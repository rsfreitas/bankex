# Bankex

A simple bank API to withdraw and transfer values from one user to another.

## Running

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Starting the docker container

In order to execute the docker **bankex** version a [PostgreSQL](https://www.postgresql.org)
server must be installed before.

For the sake of simplicity [don't install postgres. docker pull postgres](https://hackernoon.com/dont-install-postgres-docker-pull-postgres-bee20e200198)
and follow the steps in the link to put one up and running.

With a postgreSQL container running, create a database named **bankex\_dev**.

After that, pull the [bankex docker image](https://hub.docker.com/r/rsfreitas/bankex)
with the command:
```
docker pull rsfreitas/bankex
```

And execute it with:
```
docker run -it -dp 4000:4000 bankex-app
```

The server will be available at the port 4000 and the **client.sh** script,
located inside the _scripts_ folder can be used to access its API.

