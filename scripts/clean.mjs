#!/usr/bin/env zx
import Configstore from "configstore";
import clear from "clear";

$.verbose = false;

clear();
console.log("Clean up config files, certs, ssh keys...");

const projectName = "vector";

const config = new Configstore(projectName, { projectName });

// await $`rm -rf ./.artifacts`;
// console.log(`${chalk.green("Artifacts")} deleted`);
// await $`rm -rf ./.certs`;
// console.log(`${chalk.green("Certs")} deleted`);

const sshPathParam = path.join(os.homedir(), ".ssh", projectName);
await $`rm -f ${sshPathParam}*`;
console.log(`${chalk.green("SSH keys")} deleted`);

const generatedTf = path.join("tf", "application", "generated");
await $`rm -rf ${generatedTf}`;
console.log(`${chalk.green(generatedTf)} folder deleted`);

const tfvars = path.join("tf", "application", "terraform.tfvars");
await $`rm -f ${tfvars}`;
console.log(`${chalk.green(tfvars)} file deleted`);

config.clear();
console.log(`${chalk.green("Config file")} deleted`);
