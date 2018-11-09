## Description

Helper to make easier to run you [locustfile](https://docs.locust.io/en/stable/writing-a-locustfile.html) using [locust](https://locust.io) and [invokust](https://github.com/FutureSharks/invokust) at AWS lambda.

## How to install

Before proceed you will need [docker](https://docs.docker.com/install/) installed. Then you need to clone the repository:

    $ git clone git@github.com:gustavobgama/invokust-helper.git ./InvokustHelper

## How to configure

    $ cd InvokustHelper && cp .env.example .env

Then put your aws credentials and customize the other variables at .env file. Next you will **replace the locustfile.py** in the root folder by your real locustfile. The file that comes with this project is just an example.

## How to execute

The repository has a makefile that allow you the following:

1. Run the container

        $ make run

2. Local test the locustfile (using only locust):

        $ make local

3. Local test the locustfile (using invokust and locust):

        $ make local-invokust

4. Create or update the lambda function:

        $ make create

5. Execute the load test using the lambda function:

        $ make execute

### Customizing the execution

Both, the local test and the execute of the lambda function have the possibility of customize its parameters. The parameters are:

* HOST: host where the locust will run the load tests. (default: http://127.0.0.1)
* CLIENTS: quantity of clients that will be at the same time testing the host. (default: 1)
* HATCH_RATE: The rate per second in which clients are spawned. (default: 1)
* RUN_TIME: Time limit for run time (seconds) (default: 60)
* THREADS: Threads to run in parallel (default: 1, only applicable for lambda)
* RAMP_TIME: Ramp up time (seconds) (default: 0, only applicable for lambda)
* REQUESTS: quantity of locust requests. If RUN_TIME is informed it will be ignored (default: 1)

Example of customization:

    $ RUN_TIME=70 CLIENTS=1 HATCH_RATE=1 make local
