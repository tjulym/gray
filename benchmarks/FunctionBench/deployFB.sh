#!/bin/bash
faas-cli deploy -f floatoperation.yml
faas-cli deploy -f matmul.yml
faas-cli deploy -f linpack.yml
faas-cli deploy -f imageprocessing.yml
faas-cli deploy -f videoprocessing.yml
faas-cli deploy -f featuregeneration.yml
faas-cli deploy -f modeltraining.yml
faas-cli deploy -f cnnimageclassification.yml
faas-cli deploy -f rnngeneratecharacter.yml
faas-cli deploy -f dd.yml
faas-cli deploy -f iperf3.yml
faas-cli deploy -f jsondumpsloads.yml
