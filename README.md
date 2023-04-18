# keycloak-gitops

This repo is based on https://github.com/ignaciolago/keycloak-gitops


## Login: 
oc login --token=$TOKEN --server=https://api.XXXXX.openshiftapps.com:6443


.
# Kustomize approach
## First we install the argocd operator:
```
oc apply -k bootstrap/argocd
```
## Second we install the Red Hat Si	ngle Sign Dev Environment using Red Hat Single Sign On Operator

### SANDBOX (just for TESTING)
```
oc apply -k bootstrap/deploy/application/00_rhsso-sandbox
```

### DEVELOPMENT
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


================
# Create secret using personal Tokens:
We can create a Secret with our personal Github token to access to 'customer' repo (below defined as 'url')
```
$ cat <<EOF | oc apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: private-il-repo
  namespace: openshift-gitops
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  url: https://github.com/ignaciolago/keycloak-gitops.git
  password: ${GITHUB_TOKEN}
  username: not-used
EOF
```

To get my GITHUB_TOKEN go to: https://github.com/settings/tokens => 'Generate new Token'



# HELM approach
See [Helm Chart installation](./rhsso-operator/README.md)

# Testing Keycloack/RH-SSO
## Postman
We can perform some requests to Keycloack REST API using Postman collections.
To do that we just need:
1. Open a local installation of Postman (it doesn't work from web because refers to local RHSSO instance)
2. Import collections from [Postman Collections](./testing_rhsso/postman/01.LOCAL-SSO.postman_collection.json)
3. Run requests defined there

## Python KCAPI
To perform some tests of a RH-SSO instance we can run tests described on: [Testing Keycloak](./testing_rhsso/README.md)

There we have defined the following tests:

- Check if exists clients in an specific RH-SSO REALM
- Check if exists roles in an specific RH-SSO REALM

# Securing applications with Keycloack
To secure applications with Keycloack please see [Securing applications with Keycloak](./secured-apps/README.md)