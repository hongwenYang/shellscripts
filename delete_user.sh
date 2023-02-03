#!/bin/bash
for USER in user{1..10};do
    userdel $USER
done