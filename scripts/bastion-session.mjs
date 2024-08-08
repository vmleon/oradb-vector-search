#!/usr/bin/env zx
import Configstore from "configstore";
import clear from "clear";
import {
  createManagedSSHSessionCommand,
  getBastionSessionCommand,
  listBastionSessions,
} from "./lib/oci/bastion.mjs";
import { getOutputValues } from "./lib/terraform.mjs";
import { chalk } from "zx";

$.verbose = false;

clear();
console.log("Creating Bastion Session...");

const projectName = "vector";

const config = new Configstore(projectName, { projectName });

const regionName = config.get("regionName");
const profile = config.get("profile");
const publicKeyPath = config.get("publicKeyPath");
const privateKeyPath = config.get("privateKeyPath");

const {
  instance_id: instanceId,
  app_bastion_id: appBastionId,
  // db_bastion_id: dbBastionId,
  instance_name: instanceName,
  // db_service: dbService,
  // db_system_id: dbSystemId,
  // db_private_ip: dbPrivateIp,
} = await getOutputValues(path.join("tf", "application"));
const existingInstanceSessions = await listBastionSessions(
  {
    regionName,
    profile,
  },
  appBastionId
);
const sessionComputeList = existingInstanceSessions.filter((s) => {
  const targetResourceDetails = s["target-resource-details"];
  const targetResourceId = targetResourceDetails["target-resource-id"];
  return targetResourceId.includes("instance");
});

if (sessionComputeList.length) {
  // get session command
  const command = await getBastionSessionCommand(
    { regionName, profile },
    sessionComputeList[0].id // FIXME pick the session for the compute
  );
  const fullCommand = command.replaceAll("<privateKey>", privateKeyPath);
  console.log(chalk.yellow(fullCommand));
} else {
  const command = await createManagedSSHSessionCommand(
    {
      regionName,
      profile,
    },
    appBastionId,
    instanceName,
    instanceId,
    publicKeyPath,
    "opc"
  );
  const fullCommand = command.replaceAll("<privateKey>", privateKeyPath);
  console.log(chalk.yellow(fullCommand));
}
