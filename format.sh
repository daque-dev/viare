#!/bin/bash 

find . -name "*.d" -exec dfmt -i '{}' --indent_style space --max_line_length 80 --soft_max_line_length 80 ';'
