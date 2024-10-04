#!/bin/bash

echo y | sf plugins install @salesforce/sfdx-scanner
sf scanner rule add  --language apex --path apex-ruleset.xml