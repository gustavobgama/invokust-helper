#!/usr/bin/env python
# -*- coding: utf-8 -*-

from locust import HttpLocust, TaskSequence, seq_task

class UserBehavior(TaskSequence):

    @seq_task(1)
    def home(self):
        self.client.get("/")

class WebsiteUser(HttpLocust):
    task_set = UserBehavior