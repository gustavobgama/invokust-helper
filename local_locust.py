#!/usr/bin/env python
# -*- coding: utf-8 -*-

import invokust
import logging
import json
logging.basicConfig(level=logging.INFO)

settings = invokust.create_settings(
    locustfile='locustfile.py',
    host='https://alice-stage-br-aws.wwbr.com.br',
    num_requests=10,
    num_clients=1,
    hatch_rate=1,
    run_time=100
    )

loadtest = invokust.LocustLoadTest(settings)
loadtest.run()

logging.info(json.dumps(loadtest.stats()))