#!/usr/bin/env zx
import Configstore from "configstore";
import inquirer from "inquirer";
import clear from "clear";
import {
  createManagedSSHSessionCommand,
  getBastionSessionCommand,
  listBastionSessions,
} from "./lib/oci/bastion.mjs";
import { getOutputValues } from "./lib/terraform.mjs";

$.verbose = false;

clear();
console.log("Create Bastion Session...");

const projectName = "vector";

const config = new Configstore(projectName, { projectName });

const regionName = config.get("regionName");
const profile = config.get("profile");
const publicKeyPath = config.get("publicKeyPath");
const privateKeyPath = config.get("privateKeyPath");

const {
  instance_id: instanceId,
  bastion_id: bastionId,
  instance_name: instanceName,
} = await getOutputValues(path.join("tf", "application"));

const sessionList = await listBastionSessions(
  { regionName, profile },
  bastionId
);

if (sessionList.length) {
  // get session command
  const command = await getBastionSessionCommand(
    { regionName, profile },
    sessionList[0].id // FIXME pick the session for the compute
  );
  const fullCommand = command.replaceAll("<privateKey>", privateKeyPath);
  console.log(chalk.yellow(fullCommand));
} else {
  const command = await createManagedSSHSessionCommand(
    {
      regionName,
      profile,
    },
    bastionId,
    instanceName,
    instanceId,
    publicKeyPath,
    "opc"
  );
  const fullCommand = command.replaceAll("<privateKey>", privateKeyPath);
  console.log(chalk.yellow(fullCommand));
}
