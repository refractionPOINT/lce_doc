# Jobs

## Overview
The Job system allows for the automation of complex tasks. Often comprised of expert-driven algorithm, jobs are discrete units of work.

## Using
Each Job type has a particular specialization and is accesible through the main menu of the web application.

## REST API
Jobs can be interacted with using the REST API's `/job/{oid}/{jid}` endpoint. This endpoint is generic for all Jobs, the actual underlying request
structure is per-Replicant as described below.

