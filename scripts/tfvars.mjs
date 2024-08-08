#!/usr/bin/env zx
import Mustache from "mustache";
import Configstore from "configstore";
import clear from "clear";
$.verbose = false;

clear();
console.log("Create terraform.tfvars...");

const projectName = "vector";

const config = new Configstore(projectName, { projectName });

await generateTFVars();

async function generateTFVars() {
  const tenancyId = config.get("tenancyId");
  const regionName = config.get("regionName");
  const profile = config.get("profile");
  const compartmentId = config.get("compartmentId");
  const compartmentName = config.get("compartmentName");
  const publicKeyContent = config.get("publicKeyContent");
  const sshPrivateKeyPath = config.get("privateKeyPath");
  const dbShape = config.get("base_db_shape");
  const instanceShape = config.get("instanceShape");
  // const exadataShape = config.get("autonomous_exadata_shape");
  // const exadataVersion = config.get("autonomous_exadata_version");
  // const datascienceShape = config.get("dsShape");
  // const dsNotebookOCPU = config.get("dsNotebookOCPU");
  // const dsNotebookMemory = config.get("dsNotebookMemory");

  const tfFolder = path.join("tf", "application");
  const tfVarsPath = path.join(tfFolder, "terraform.tfvars");

  const tfvarsTemplate = await fs.readFile(`${tfVarsPath}.mustache`, "utf-8");

  const output = Mustache.render(tfvarsTemplate, {
    tenancy_id: tenancyId,
    region_name: regionName,
    compartment_id: compartmentId,
    ssh_public_key: publicKeyContent,
    ssh_private_key_path: sshPrivateKeyPath,
    config_file_profile: profile,
    project_name: projectName,
    instance_shape: instanceShape,
    base_db_shape: dbShape,
    // autonomous_container_database_version: exadataVersion,
    // autonomous_exadata_shape: exadataShape,
    // datascience_shape: datascienceShape,
    // notebook_ocpus: dsNotebookOCPU,
    // notebook_memory_in_gbs: dsNotebookMemory,
  });

  console.log(
    `Terraform will deploy resources in ${chalk.green(
      regionName
    )} in compartment ${
      compartmentName ? chalk.green(compartmentName) : chalk.green("root")
    }`
  );

  await fs.writeFile(tfVarsPath, output);

  console.log(`File ${chalk.green(tfVarsPath)} created`);

  console.log(`1. ${chalk.yellow("cd " + tfFolder)}`);
  console.log(`2. ${chalk.yellow("terraform init")}`);
  console.log(`3. ${chalk.yellow("terraform apply -auto-approve")}`);
}
