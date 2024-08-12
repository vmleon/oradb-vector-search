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

> Download pre-packaged model from Oracle
>
> [Now Available! Pre-built Embedding Generation model for Oracle Database 23ai](https://blogs.oracle.com/machinelearning/post/use-our-prebuilt-onnx-model-now-available-for-embedding-generation-in-oracle-database-23ai)
>
> `wget https://adwc4pm.objectstorage.us-ashburn-1.oci.customer-oci.com/p/VBRD9P8ZFWkKvnfhrWxkpPe8K03-JIoM5h_8EJyJcpE80c108fuUjg7R5L5O7mMZ/n/adwc4pm/b/OML-Resources/o/all_MiniLM_L12_v2_augmented.zip`
>
> `unzip all_MiniLM_L12_v2_augmented.zip -d all_MiniLM_L12_v2_augmented`

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

> NOTE The installation of `DBMS_CLOUD` is done automatically based on this MOS [Doc ID 2748362.1](https://support.oracle.com/rs?type=doc&id=2748362.1)

Run a simple SELECT command to check everything is working fine.

```bash
echo "select * from hotels; exit;" | sql -name hotel
```

Run a simple Vector Search command:

```bash
sql -name hotel @queries/query.sql "I want a hotel near the airport" 2
```

To exit the SSH connection with the compute instance:

```bash
exit
```

## Data Science

Open Terminal within OCI Data Science

```bash
python -m pip install oracledb --upgrade --user
```

> Oracle Instant Client is installed by default on Data Science.
>
> One example would be:
> `/usr/lib/oracle/19.17/client64/lib/`

Create a Jupyter notebook.

To connect with the Oracle Database you will use [OracleDB](https://python-oracledb.readthedocs.io/en/latest/) python library with the `thick` mode.

```python
import os
import oracledb

oracledb.init_oracle_client()
```

```python
db_url = os.environ["DB_URL"]
db_password = os.environ["DB_PASSWORD"]
```

```python
with oracledb.connect(user="system", password=db_password, dsn=db_url) as connection:
    with connection.cursor() as cursor:
        sql = """select sysdate from dual"""
        for r in cursor.execute(sql):
            print(r)
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
