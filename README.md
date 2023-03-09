# keycloak-gitops

This repo is based on https://github.com/ignaciolago/keycloak-gitops

## First we install the argocd operator:
```
oc apply -k bootstrap/argocd
```
## Second we install the Red Hat Single Sign Dev Environment using Red Hat Single Sign On Operator

### SANDBOX (just for TESTING)
```
oc apply -k bootstrap/deploy/application/00_rhsso-sandbox
```

### DEVELOPMENT
```
oc apply -k bootstrap/deploy/application/01_rhsso-dev
```

# Install Database for prod
## add values to secret for DB
```
oc apply -k bootstrap/deploy/application/03_rhsso-prod
```



# Create secret using personal Tokens:
We need to create a Secret with our personal Github token to access to 'customer' repo (below defined as 'url')
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
