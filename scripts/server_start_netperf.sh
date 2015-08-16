#!/bin/sh
serverIP=$1

ssh root@$serverIP netserver || true
