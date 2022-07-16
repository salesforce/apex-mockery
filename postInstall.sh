#!/bin/bash

echo y | sfdx plugins:install @salesforce/sfdx-scanner
sfdx scanner:rule:add  --language apex --path apex-ruleset.xml