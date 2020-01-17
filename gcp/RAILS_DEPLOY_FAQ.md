# Rails deployment Common errors 

## Load both webserver & Sidekiq

It's required to use foreman as the staring point of the application and having a Procfile with web and sidekiq starting commands. More instructions [here](https://cloud.google.com/community/tutorials/appengine-ruby-rails-activejob-sidekiq#deploying_to_app_engine_flexible_environment)

Procfile example 
```
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 5 -v -q mailers
```

## Set current project

Use this command to change current project `gcloud config set project my-project-id`

## Generate Credentials

If required to generate new `config/master.key` and `config/credentials.yml.enc`, do the following:

```bash
rm config/credentials.yml.enc
rm config/master.key
EDITOR=vim rails credentials:edit 
```

Copy the secret key base into environment variable `SECRET_KEY_BASE` and content from master.key file into `RAILS_MASTER_KEY`

```yaml
#Example
SECRET_KEY_BASE: a041a62984beec5caca6d8807072ead894d9693058333bce7aedca0edaexample101761b40d80e464ff87606eccce4dbc5b0f70c4d34aaa2ff868def09aad42
RAILS_MASTER_KEY: ec17b39b3be4example7f7038413ddc4
```

Also add the key into `config/secrets.yml`

```yaml
production:
  secret_key_base: <%= ENV['SECRET_KEY_BASE'] %>
```

## App Engine deployment config example

Must be located in the root path of your project. To deploy use `gcloud app deploy app.yaml`
## app.yaml 
```yaml
runtime: ruby
env: flex # REQUIRED to launch sidekiq & to be able to use private ip for sql

entrypoint: bundle exec foreman start # Must add foreman gem to project

env_variables:
  DB_HOST_PRODUCTION: 10.48.1.2 # Use private ip obtained from cloud console -> Cloud SQL
  DB_PORT_PRODUCTION: 5432
  DB_NAME_PRODUCTION: wbooks_api_development
  DB_USERNAME_PRODUCTION: wbooks-api
  DB_PASSWORD_PRODUCTION: wbooks-api
  REDIS_URL: redis://10.123.234.123:6379/0/cache # Get this ip from cloud console -> Memorystore
  SECRET_KEY_BASE: examplesecret_key_base
  RAILS_MASTER_KEY: example12345
  RAILS_ENV: production

skip_files: .env #Be careful with deploying .env file, it could override variables set up here.

beta_settings:
  cloud_sql_instances: test-gae-sql4-b22aea35:us-east1:db-test-gae-sql4-b22aea35-6269194a # Use from cloud console -> Cloud SQL -> Instance connection name

vpc_access_connector:
  name: "projects/PROJECT_ID/locations/REGION/connectors/CONNECTOR_NAME" # Get the connector name from cloud console -> VPC Network -> Serveless VPC access. Default: my-connector
```

An alternative way to avoid having sensitive data on the app.yaml file is to extract environment variables into another file like this:

```yaml
runtime: ruby
env: flex 
entrypoint: bundle exec foreman start 

includes:
  - env_variables.yaml

skip_files: .env

beta_settings:
  cloud_sql_instances: test-gae-sql4-b22aea35:us-east1:db-test-gae-sql4-b22aea35-6269194a 

vpc_access_connector:
  name: "projects/PROJECT_ID/locations/REGION/connectors/CONNECTOR_NAME" 
```

And set the `env_variables` there:
 
```yaml
env_variables:
  DB_HOST_PRODUCTION: 10.48.1.2 # Use private ip obtained from cloud console -> Cloud SQL
  DB_PORT_PRODUCTION: 5432
  DB_NAME_PRODUCTION: wbooks_api_development
  DB_USERNAME_PRODUCTION: wbooks-api
  DB_PASSWORD_PRODUCTION: wbooks-api
```

## Redis extra configuration

Redis instances in GCP blocks CLIENT command generating an error on Sidekiq, to avoid this it's required to set `id: nil` on Sidekiq initialization as showed [here](https://github.com/mperham/sidekiq/wiki/Using-Redis#disabled-client-command)

## Migrate DB

Migration is a bit tricky. There are different approches, but not a perfect one.

1. Run this command to execute db:migrate on appengine instance. Gem `appengine` is required to be installed.

    `GAE_EXEC_STRATEGY=deployment bundle exec rake appengine:exec -- bundle exec rake db:migrate`

    This command deploys a temporal new version of your app (copied from the last version uploaded), and executes the command there. Since we are using flex environment this will take a lot of time. We cannot use default strategy because it uses cloud build to create the instance, and that will not be connected to the private network, thus not being able to connect to the db.

2. Run it locally
   To do this, we need to connect a proxy to cloud sql. Follow instructions [here](https://cloud.google.com/sql/docs/postgres/quickstart-proxy-test). This will open a port to connect to the cloud sql instance (Use `localhost` as url). Once connected remember to set all production environment variables, and run `RAILS_ENV=production bundle exec rake db:migrate`. 

3. EXPERIMENTAL
   You can add the command to be run on the procfile. However, this could lead to a race condition since appengine always creates 2 minimum instances on deploy.

## Regions & zones 

App Engine must be on the same region as Cloud SQL, Private VPC Connector and the private network itself while using private ip. More [here](https://cloud.google.com/appengine/docs/standard/python3/connecting-vpc)

**Redis zones are not the same as the rest** of the services zones, be careful with that if Redis instance cannot be created.