## Description

With this project you can test your [locust](https://locust.io) files easily and fast. If everything is ok you can create a lambda function at AWS and scale your load tests, thanks to [invokust](https://github.com/FutureSharks/invokust).

## Installation

Before proceed you will need [docker](https://docs.docker.com/install/) installed.

    $ curl -fsSL https://get.docker.com | sh

Then you can proceed with the installation:

    $ git clone https://github.com/gustavobgama/invokust-helper.git ./InvokustHelper
    $ cd InvokustHelper && cp .env.example .env
    $ put your aws credentials and customize the other variables at .env file

## Load test workflow

First you have to know what locustfile you want to execute, the [locustfiles](https://docs.locust.io/en/stable/quickstart.html#example-locustfile-py) are located at folder `/locustfiles`. Then you have to know the `host url` you want to loadtest. With both information follow the steps:\

1. Execute the load test locally using locust.

        $ HOST=https://example.com LOCUST_FILE=example.py make local

2. If everything is ok you can proceed and create the lambda function that will allow more clients and requests to our load test.

        $ make create

3. Once the lambda is created you can execute your load test with a lot more throughput:

        $ HOST=https://example.com LOCUST_FILE=example.py RUN_TIME=200 CLIENTS=100 HATCH_RATE=5 make execute

4. If for any reason you need to check the docker container, then

        $ make run

### Customizing the execution

Both, the local test and the execute of the lambda function have the possibility of customize its parameters. The parameters are:

* HOST: host where the locust will run the load tests. (default: http://127.0.0.1)
* LOCUST_FILE: locustfile inside folder `locustfiles` which will be executed. (default: "")
* CLIENTS: quantity of clients that will be at the same time testing the host. (default: 1)
* HATCH_RATE: The rate per second in which clients are spawned. (default: 1)
* RUN_TIME: Time limit for run time (seconds) (default: 60)
* THREADS: Threads to run in parallel (default: 1, only applicable for lambda)
* RAMP_TIME: Ramp up time (seconds) (default: 0, only applicable for lambda)
* REQUESTS: quantity of locust requests. If RUN_TIME is informed it will be ignored (default: 1)

Example of customization:

    $ RUN_TIME=70 CLIENTS=1 HATCH_RATE=1 make local
