#!/bin/bash 

find . -name "*.d" -exec dfmt -i '{}' ';'
