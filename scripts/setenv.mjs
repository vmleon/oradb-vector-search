#!/usr/bin/env zx
import Configstore from "configstore";
import inquirer from "inquirer";
import clear from "clear";
import { readFile } from "node:fs/promises";
import { parse as iniParse } from "ini";
import {
  getNamespace,
  getRegions,
  searchCompartmentIdByName,
  getEFlexShapes,
} from "./lib/oci.mjs";
import { createSSHKeyPair } from "./lib/crypto.mjs";
import {
  listDataScienceSessionShapes,
  listDataScienceSessionShapesFamilies,
} from "./lib/oci/datascience.mjs";

$.verbose = false;

clear();
console.log("Set up environment...");

const projectName = "vector";

const config = new Configstore(projectName, { projectName });

await selectProfile();
const profile = config.get("profile");
const tenancyId = config.get("tenancyId");

await selectRegion();
const regionName = config.get("regionName");

await setNamespaceEnv();

await setCompartmentEnv();
const compartmentId = config.get("compartmentId");

await selectComputeShape();
await selectDataScienceShape();
await selectNotebookSize();

await createSSHKeys(projectName);

console.log(`\nConfiguration file saved in: ${chalk.green(config.path)}`);

async function selectProfile() {
  let ociConfigFile = await readFile(`${os.homedir()}/.oci/config`, {
    encoding: "utf-8",
  });

  const ociConfig = iniParse(ociConfigFile);
  const profileList = Object.keys(ociConfig);

  await inquirer
    .prompt([
      {
        type: "list",
        name: "profile",
        message: "Select the OCI Config Profile",
        choices: profileList,
      },
    ])
    .then((answers) => {
      config.set("profile", answers.profile);
      config.set("tenancyId", ociConfig[answers.profile].tenancy);
    });
}

async function selectRegion() {
  const listSubscribedRegions = (await getRegions(profile, tenancyId)).sort(
    (r1, r2) => r1.isHomeRegion > r2.isHomeRegion
  );

  await inquirer
    .prompt([
      {
        type: "list",
        name: "region",
        message: "Select the region",
        choices: listSubscribedRegions.map((r) => r.name),
        filter(val) {
          return listSubscribedRegions.find((r) => r.name === val);
        },
      },
    ])
    .then((answers) => {
      config.set("regionName", answers.region.name);
      config.set("regionKey", answers.region.key);
    });
}

async function setNamespaceEnv() {
  const namespace = await getNamespace(profile);
  config.set("namespace", namespace);
}

async function setCompartmentEnv() {
  await inquirer
    .prompt([
      {
        type: "input",
        name: "compartmentName",
        message: "Compartment Name",
        default() {
          return "root";
        },
      },
    ])
    .then(async (answers) => {
      const compartmentName = answers.compartmentName;
      const compartmentId = await searchCompartmentIdByName(
        compartmentName || "root"
      );
      config.set("compartmentName", compartmentName);
      config.set("compartmentId", compartmentId);
    });
}

async function selectComputeShape() {
  const listComputeShapes = await getEFlexShapes(
    profile,
    regionName,
    compartmentId
  );

  await inquirer
    .prompt([
      {
        type: "list",
        name: "instance_shape",
        message: "Select the Compute Shape",
        choices: listComputeShapes.sort().reverse(),
      },
    ])
    .then((answers) => {
      config.set("instanceShape", answers.instance_shape);
    });
}

async function selectDataScienceShape() {
  const dsShapeFamilies = await listDataScienceSessionShapesFamilies(
    { profile, region: regionName },
    compartmentId
  );

  await inquirer
    .prompt([
      {
        type: "list",
        name: "ds_shape_family",
        message: "Select the Data Science Shape Family",
        choices: dsShapeFamilies.sort(),
      },
    ])
    .then(async (answers) => {
      config.set("dsShapeFamily", answers.ds_shape_family);
      const dsShapes = await listDataScienceSessionShapes(
        { profile, region: regionName },
        compartmentId,
        answers.ds_shape_family
      );

      await inquirer
        .prompt([
          {
            type: "list",
            name: "ds_shape",
            message: "Select the Data Science Shape",
            choices: dsShapes
              .map((s) => s.name)
              .sort()
              .reverse(),
          },
        ])
        .then((answers) => {
          config.set("dsShape", answers.ds_shape);
        });
    });
}

async function selectNotebookSize() {
  await inquirer
    .prompt([
      {
        type: "number",
        name: "notebook_ocpu",
        message: "Data Science Notebook OCPUs",
        default: 1,
      },
      {
        type: "number",
        name: "notebook_memory",
        message: "Data Science Notebook Memory (Gb)",
        default: 16,
      },
    ])
    .then((answers) => {
      config.set("dsNotebookOCPU", answers.notebook_ocpu);
      config.set("dsNotebookMemory", answers.notebook_memory);
    });
}

async function createSSHKeys(name) {
  const sshPathParam = path.join(os.homedir(), ".ssh", name);
  const publicKeyContent = await createSSHKeyPair(sshPathParam);
  config.set("privateKeyPath", sshPathParam);
  config.set("publicKeyContent", publicKeyContent);
  config.set("publicKeyPath", `${sshPathParam}.pub`);
  console.log(`SSH key pair created: ${chalk.green(sshPathParam)}`);
}
