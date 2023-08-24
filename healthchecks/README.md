# RHSSO Readiness test
The  this script 

## Description: 
The goal of this script is to provide a mechanism to determine if an RH-SSO instance is available to start working.
To do this, the READINESS Probe provided by the RH-SSO base image is executed externally. 
Once this script is launched, it will run until the result of the readiness-probe is Ok: that is, the instance is ready to operate.

## Prerequisites
1. An instance of RH-SSO installed and running on Kubernetes/Openshift cluster. 
2. Kubernetes Client (kubectl) installed. (Installation details: https://kubernetes.io/docs/tasks/tools/)
3. You should be logged in your Kubernetes Cluster.
4. Namespace where your RH-SSO instances is installed.

## Execution