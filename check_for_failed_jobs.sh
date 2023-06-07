#!/bin/bash

### Promt for project name
echo "Enter project name:"
read project
oc project $project

### Show if there are failed jobs in this project
JOB=$(oc get jobs --field-selector=status.successful!=1)
if [ -z "$JOB" ]; then
	echo "There are no failed jobs for this project"
	exit 0
fi
JOB=$(oc get jobs --field-selector=status.successful!=1 )
echo "There is a failed job: $JOB"

### Ask if the user wants to delete the job
oc get job -A --
echo "Do you want to delete the faild job? (y/n)"
read -r confirmation
if [ "$confirmation" != "y" ]; then
  echo "Aborted."
  exit 1
fi

### Put a step for job deletion here
oc delete job -n $project $JOB

### to return only the name of the failed pod
oc get jobs --field-selector=status.successful!=1 --no-headers -o custom-columns=':metadata.name'
