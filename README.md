# [FCC Salon Appointment Scheduler](https://www.freecodecamp.org/learn/relational-database/build-a-salon-appointment-scheduler-project/build-a-salon-appointment-scheduler)

This was put together for the Relational Database (Beta) course on [FCC](https://www.freecodecamp.org/learn/relational-database/). The aim was to create an interactive Bash program that uses a PostgreSQL database. 

## Project Improvements

I have extended this project in the following ways:
* local development with Docker

## Setup

Clone the Repository

```
$ git clone git@github.com:normanrichardson/FCC-Salon-Appointment-Scheduler.git
$ cd FCC-Salon-Appointment-Scheduler
```
### Running postgres with Docker:
Using the standard postgres docker image create the container:
```
$ docker run --name=salon-proj \
-e POSTGRES_USER=freecodecamp \
-e POSTGRES_PASSWORD=1234 \
-e POSTGRES_DB=postgres \
-v "$(pwd)"/.:/home/src \
-d \
--rm \
postgres:latest
```
This will:
* launch a new container named salon-proj in the background (see `$ docker ps`). 
* remove the container after stopping it.
* map the `./` directory onto the container's directory `home/src`. 
The mapped files are accessible within the container and the host.

Launch psql in the salon-proj container and run the `createDb.sql` file
```
$ docker exec -it -w /home/src/sql salon-proj \
psql -U freecodecamp -d postgres -f createDb.sql
```
This will set up the sql database and tables, and populate it with some data.

Run the `salon.sh` bash script in the salon-proj container
```
$ docker exec -it -w /home/src/ salon-proj \
./salon.sh
```

This will launch the interactive Bash program.

Dump the file as required by the project description
```
$ docker exec -it -w /home/src/ salon-proj \
pg_dump -cC --inserts -U freecodecamp salon > salon.sql
```

If neccesary 
```
$ docker exec -it -w /home/src/sql salon-proj \
psql -U freecodecamp -d postgres -f tearDown.sql
```
can be run to drop the entire salon database. 
This can be useful for testing.

Stop the container
```
docker stop salon-proj
```
