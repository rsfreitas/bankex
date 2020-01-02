#!/bin/bash

DB_HOST=host.docker.internal
DB_USER=postgres
DB_PASS=postgres
DB_NAME=bankex_dev

export DATABASE_URL=echo://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME
export SECRET_KEY_BASE=ooQd5xAXw+cg3Z9FTQ1tENOqKIeR4ZDUmpR/U4AjA9kU1k0NmoBs2uqGMnbp4j81

/app/bin/bankex eval Bankex.Release.migrate
/app/bin/bankex start

exit 0

