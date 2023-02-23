# keycloak-gitops

This repo is based on https://github.com/ignaciolago/keycloak-gitops

## First we install the argocd operator:
```
oc apply -k bootstrap/argocd
```
## Second we install the Red Hat Single Sign Dev Environment using Red Hat Single Sign On Operator

            ### SANDBOX is just for TESTING
            ```
            oc apply -k bootstrap/deploy/application/00_rhsso-sandbox
            ```


```
oc apply -k bootstrap/deploy/application/01_rhsso-dev
```

# Install Database for prod
## add values to secret for DB
```
oc apply -k bootstrap/deploy/application/03_rhsso-prod
```
