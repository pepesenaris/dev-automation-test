# AlayaCare Automation Skill Test

Welcome to AlayaCare's automation skill test.
You have shown interest in CI/CD, automation, scripts and cloud technologies ; now it's time to put
your skills to work.
Given a highly simplified setup resembling ours, you will learn to get familiar with Jenkins, Docker
and a typical deployment flow.
Different aspects make up for the test:

- research
- documentation
- setup
- scripting

Each task adds a building block to the setup, you will want to work on them sequentially.
If you face a blocker, you should be able to move on to the next task, although you might not be
able to test your work.
Feel free to work around the instructions in that case, and document what you did.
For example if you cannot load the `database.sql` script through Jenkins, you can always do it
manually and move on.

**N.B.** remember to document everything you do !!

**Bonus:** throughout the test, please feel free to increment all the scripts with better logging,
error handling and other improvements. Each task contains a goal and some guidelines, you're
welcome to adapt them and develop them in your own way.

----------

## Assignment

### How to submit your work ?

**/!\ You need to fork this repository.**

1. Fork this repository
2. Clone your fork locally
3. Work
4. Once you're done, submit a pull request to the remote repository
5. Review your changes and validate

### Delivery

We are expecting the following files:

- `README.md`, all the documentation you wrote
- `Dockerfile`, for the custom Jenkins image
- `init_database.groovy`, Groovy script to import the trunk file
- `init_database.xml`, config file for the eponymous Jenkins job
- `run_migrations.groovy`, Groovy script to run DB migrations
- `run_migrations.xml`, config file for the eponymous Jenkins job
- `deploy.py`, Python script with all the logic
- `migration_summary`, from task 10
- `requirements.txt` if needed
- `docker-compose.yml` in case you have changed the original one

### Overview

- *a database,* contains fake tenant data
- *a Jenkins server,* with some pipelines to run dummy DB migrations
- *a Python CLI tool,* with logic to verify and validate tenant migrations

----------

## Tasks

### I. Up & Running

Let's get our Jenkins server and database up and running on your local.
Everything must be dockerized.

#### task 1

Set up Jenkins & MySQL on your local ; you must use docker containers.
A `docker-compose.yml` has been provided, feel free to use it / increment it.

**N.B.** docker compose already creates a network with all services involved.
That allows us to access mysql under `db` from the `jenkins` container.
If you're running logic outside the docker-compose setup that requires communicating
with one of its containers, you either need to retrieve the container's IP address
or expose its port.

#### task 2

Install `mysql-client` and `python3` on your Jenkins server.
Let's be classy about it : create a new docker image based on `jenkins/jenkins:lts` and install
the packages in your derived image's `Dockerfile`.

#### task 3

Find a clean way to get files to your Jenkins server.
Ideas: `docker cp`, shared mount point, git clone etc.
You will start by sending over `database.sql`, but later on you will be uploading groovy scripts
& python files.

#### task 4

Find a way to export Jenkins job configs.
For each job you set up, a config file is generated on the Jenkins server.
To evaluate your jobs, we need the groovy script + the job config associated.
Out of all the files and directories created by Jenkins for a single job, we are interested in
the one containing the parameter information etc.


### II. Groovy Baby!

Time get our hands dirty with some groovy!
Each groovy script you write is a file, and has a corresponding Jenkins job associated that calls
the file.

#### task 5

Create `init_database.groovy` which will load all of `database.sql` into our DB.
The script must be in Groovy, and will be set up in a Jenkins job called `init_database` (no parameters).
Essentially, the script runs a `mysql` command to source the trunk file, and Groovy is simply
the glue between that command and Jenkins.

**Action:** Run the job to populate the database with initial data.

#### task 6

Create `run_migrations.groovy` which will run a given migration sequentially for specified tenants.
A migration is simply an entry in the table `migrations` with a given name and tenant ID.
The job `run_migrations` takes 2 parameters:

- `TENANT_NAMES`, a CSV of tenant names (e.g. `tenant1` or `tenant1,tenant2`) ; it also accepts
`ALL`, the equivalent of passing all tenant names
- `MIGRATION_NAME`, a blank field accepting a string like `migr6`

The job will run a dummy DB migration for the given tenants, one at a time, by doing something like:

```sql
INSERT INTO migrations(tenant_id, name) VALUES (1, 'migr6');
```

**N.B.** This task can either be done in Groovy (over a `mysql` shell command) or in Python.
If you choose to move the migration logic to Python, you still need a Groovy script to call
the Python logic from a Jenkins job.

**Action:** Run the job a couple times to add more content to the database - worry not, the next
tasks will help us validate each tenant's migration state.


#### task 7

Increment `run_migration` by adding a drop-down column `RUN_TYPE` with 2 choices: `sequential` and
`parallel`.
Instead of running all migrations sequentially, we now wish to run them in parallel - Jenkins
easily supports this.
However, Jenkins' builtin `parallel` tool doesn't allow you to limit the number of sub-processes.
You will therefor need to change `run_migrations.groovy` to run the DB migrations for 5 tenants
at a time when chosing the `parallel` option.


### III. Python

You have full freedom in your choice of Python tools, packages, logging etc.
Ideally, please use `python3`.
All your logic must be accessible in CLI, and should fit in a single file.

#### task 8

Write Python logic that checks DB migrations for all tenants. e.g.

```bash
$ python deploy.py check-migration 'migr2'
tenant1: OK
tenant2: OK
tenant3: missing
...
```

#### task 9

Write Python logic that counts DB migrations for all tenants. e.g.

```bash
$ python deploy.py count-migrations
tenant1: 5
tenant2: 5
tenant3: 4
...
```

#### task 10

Thanks to the Python logic you just wrote, create a little report showing the current state of
tenant migrations.
Point out the tenant with mismatching numbers.
The report can be a markdown document with console outputs of your scripts and / or screenshots.
Jot down your findings, explaining why some tenants have migrations that others don't.

----------

## Resources

- [jenkins docker image](https://github.com/jenkinsci/docker/blob/master/README.md)
- [mysql docker image](https://hub.docker.com/_/mysql)
- [docker compose documentation](https://docs.docker.com/compose/)

