#!/bin/bash
faas-cli build -f floatoperation.yml
faas-cli build -f matmul.yml
faas-cli build -f linpack.yml
faas-cli build -f imageprocessing.yml
faas-cli build -f videoprocessing.yml
faas-cli build -f featuregeneration.yml
faas-cli build -f modeltraining.yml
faas-cli build -f cnnimageclassification.yml
faas-cli build -f rnngeneratecharacter.yml
faas-cli build -f dd.yml
faas-cli build -f iperf3.yml
faas-cli build -f jsondumpsloads.yml
