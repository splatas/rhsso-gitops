# keycloak-gitops

This repo is based on https://github.com/ignaciolago/keycloak-gitops
## Login: 
oc login --token=$TOKEN --server=https://api.a-snb-rosa-01.64dp.p1.openshiftapps.com:6443


## First we install the argocd operator:
```
oc apply -k bootstrap/argocd
```
## Second we install the Red Hat Single Sign Dev Environment using Red Hat Single Sign On Operator
```
oc apply -k bootstrap/deploy/application/01_rhsso-dev
```

## Install the Red Hat Single Sign TEST Environment using Red Hat Single Sign On Operator
```
oc apply -k bootstrap/deploy/application/02_rhsso-test
```

# Install Database for prod
## add values to secret for DB
```
oc apply -k bootstrap/deploy/application/04_rhsso-prod
```
