#!/bin/sh

uci set network.globals.multipath=enable
uci set network.wan1.multipath=master
uci set network.wan2.multipath=on

