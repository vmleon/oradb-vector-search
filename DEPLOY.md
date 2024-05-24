# Deploy

## Clone Repository

Go to OCI Cloud Shell and clone the repository.

```bash
https://github.com/vmleon/oradb-vector-search.git
```

Go to the new folder `oradb-vector-search`

```bash
cd oradb-vector-search
```

## Setup environment

Install the dependencies for the scripts in [Google ZX](https://google.github.io/zx/).

```bash
cd scripts/ && npm install && cd ..
```

Answer all the questions from `setenv.mjs` script:

```bash
npx zx scripts/setenv.mjs
```

## Deploy with Terraform

Generate the `terraform.tfvars` file:

```bash
npx zx scripts/tfvars.mjs
```

Run the commands that `tfvars.mjs` output in yellow one by one.

Come back to the root folder:

```bash
cd ../..
```

## Connect to Database

Create the bastion host session

```bash
npx zx scripts/bastion-session.mjs
```

Paste the yellow command to connect with SSH into the compute instance.

To connect, asnwer `yes` to add the fingerprint to the know hosts.

When you are in the compute instance, create the connection `basedb` with `connection.sql` script.

```bash
echo exit | sql /nolog @/home/opc/connection.sql
```

Connect with the ADB high service.

```bash
sql -name basedb
```

Run a query to test the connection.

```sql
SELECT sysdate, 'Oracle Database' FROM DUAL;
```

To exit **SQLcl**:

```sql
quit
```

To exit the SSH connection with the compute intance:

```bash
exit
```

## Clean up

Go to the folder `tf/application`.

```bash
cd tf/application
```

Run the Terraform destroy:

```bash
terraform destroy -auto-approve
```

Come back to the root compartment:

```bash
cd ../..
```

Clean all auxiliary files:

```bash
npx zx scripts/clean.mjs
```
