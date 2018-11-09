#!/usr/bin/env python
# -*- coding: utf-8 -*- 

import re, random
from locust import HttpLocust, TaskSequence, seq_task

class UserBehavior(TaskSequence):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """
        self.get_token()

    def get_token(self):
        response = self.client.get("/")
        self.csrftoken = re.search('meta name="csrf-token" content="(.+?)"', response.text).group(1)

    @seq_task(1)
    def home(self):
        self.client.get("/")

    @seq_task(2)
    def first_step(self):
        phone = random.randint(1, 1000000)
        self.client.post("/user/save", json={"user": {"firstname": "John", "lastname": "Doe", "phone": phone}, "step": 1, "_token": self.csrftoken})

    @seq_task(3)
    def second_step(self):
        self.client.post("/user/save", json={"user": {"address": "Street name", "address_number": "70", "zipcode": "11111-111", "city": "City"}, "step": 2, "_token": self.csrftoken})

    @seq_task(4)
    def third_step(self):
        self.client.post("/user/save", json={"user": {"account_owner": "John Doe", "iban": "BR0292702067000010000000001C1"}, "step": 3, "_token": self.csrftoken})

class WebsiteUser(HttpLocust):
    task_set = UserBehavior