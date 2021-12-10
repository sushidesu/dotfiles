#!/bin/bash

for package in $(brew list); do
  echo -n $package: $(brew uses --installed $package | wc -l) | grep " 0"
done

