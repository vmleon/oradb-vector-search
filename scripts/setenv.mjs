#!/usr/bin/env zx
import { spinner } from "zx";
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
  listAvailabilityDomains,
} from "./lib/oci.mjs";
import { createSSHKeyPair } from "./lib/crypto.mjs";
import {
  listDataScienceSessionShapes,
  listDataScienceSessionShapesFamilies,
} from "./lib/oci/datascience.mjs";
import {
  listADBExaShapeFamilies,
  listADBExaVersions,
  listDBShapes,
} from "./lib/oci/db.mjs";

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

// await selectADBExaVersions();
// await selectADBExaShapeFamilies();

await selectBaseDbShape();

await selectComputeShape();
// await selectDataScienceShape();
// await selectNotebookSize();

await createSSHKeys(projectName);

await downloadDataset();

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
        { profile, region: regionName },
        compartmentName || "root"
      );
      config.set("compartmentName", compartmentName);
      config.set("compartmentId", compartmentId);
    });
}

async function selectADBExaVersions() {
  const versions = await listADBExaVersions(
    { region: regionName, profile },
    compartmentId
  );
  await inquirer
    .prompt([
      {
        type: "list",
        name: "autonomous_exadata_version",
        message: "Select Autonomous Exadata Version",
        choices: versions.reverse(),
      },
    ])
    .then((answers) => {
      config.set(
        "autonomous_exadata_version",
        answers.autonomous_exadata_version
      );
    });
}

async function selectADBExaShapeFamilies() {
  const ads = await listAvailabilityDomains(
    { region: regionName, profile },
    compartmentId
  );
  const listAutonomousExadataShapes = await listADBExaShapeFamilies(
    { profile, region: regionName },
    compartmentId,
    ads[0].name
  );

  await inquirer
    .prompt([
      {
        type: "list",
        name: "autonomous_exadata_shape",
        message: "Select Autonomous Exadata Shape",
        choices: listAutonomousExadataShapes,
      },
    ])
    .then((answers) => {
      config.set("autonomous_exadata_shape", answers.autonomous_exadata_shape);
    });
}

async function selectBaseDbShape() {
  const listShapes = await listDBShapes(
    { profile, region: regionName },
    compartmentId,
    "VIRTUALMACHINE"
  );

  let choices;
  const intelShapes = listShapes
    .filter((s) => s["shape-type"].includes("INTEL"))
    .map((s) => `${s.shape} (${s["shape-type"]})`)
    .sort();
  const amdShapes = listShapes
    .filter((s) => s["shape-type"].includes("AMD"))
    .map((s) => `${s.shape} (${s["shape-type"]})`)
    .sort();
  const ampereShapes = listShapes
    .filter((s) => s["shape-type"].includes("AMPERE"))
    .map((s) => `${s.shape} (${s["shape-type"]})`)
    .sort();
  choices = [...intelShapes, ...amdShapes, ...ampereShapes];

  await inquirer
    .prompt([
      {
        type: "list",
        name: "base_db_shape",
        message: "Select Base DB Shape",
        choices: choices,
        filter(val) {
          return listShapes.find((r) => val.includes(r.shape)).shape;
        },
      },
    ])
    .then((answers) => {
      config.set("base_db_shape", answers.base_db_shape);
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

async function downloadDataset() {
  const outputFilePath = "dataset/hotels.zip";
  const exists = await fs.pathExists(outputFilePath);
  if (exists) {
    console.log(`Dataset already downloaded ${chalk.yellow(outputFilePath)}`);
  } else {
    const datasetUrl =
      "https://objectstorage.us-sanjose-1.oraclecloud.com/p/3wQ38o8tIN5wDKDgfs0FyvhEL6MN02-U0ZhiALaOgRqE9495PpTJjBTqPhWSSDJm/n/axwytvijqqld/b/public-content/o/hotels.zip";
    await spinner(
      "Downloading dataset",
      () => $`wget -O ${outputFilePath} ${datasetUrl}`
    );
    console.log(`Dataset downloaded: ${chalk.green(outputFilePath)}`);
  }
}
