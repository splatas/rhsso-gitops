# keycloak-gitops using HELM
## Login: 
Set the values:
```
export TOKEN="CHANGE_ME"
export OCP_CLUSTER_URL="CHANGE_ME"
export NAMESPACE="CHANGE_ME"
```
Then: 
```
$ oc login --token=${TOKEN} --server=https://${OCP_CLUSTER_URL}:6443
```

## We install the RH-SSO operator on DEV environment (rhsso-dev)
If namespace already exists we need to delete it.
```
$ oc delete project ${NAMESPACE}
$ oc new-project ${NAMESPACE}
```

## Prerequisites:
You need to have installed RH-SSO Operator. Here you have two options:
1. Use the Openshift Web Console to install it. See this link: https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html/server_installation_and_configuration_guide/operator#install_by_olm
2. Use the command-line approach: https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.4/html/server_installation_and_configuration_guide/operator#install_by_command

## Install HELM chart:
We install RHSSO Operator with a Helm Chart (Chart.yaml) named 'rhsso-operator':

### Default installation:
```
$ helm install \
--set subscription.namespace=${NAMESPACE} \
--set keycloak.namespace=${NAMESPACE} \
rhsso-operator ./rhsso-operator -n ${NAMESPACE}
```

### Parametrized installation for External Database:
First we need to define values:
```
export DB_URL="CHANGE_ME"
export DB_PORT="CHANGE_ME"
export DB_NAME="CHANGE_ME"
export DB_USER="CHANGE_ME"
export DB_PASSWORD="CHANGE_ME"

```

Then launch the installation:
```
$ helm install --set subscription.namespace=${NAMESPACE} --set keycloak.namespace=${NAMESPACE} \
--set secret.postgres_external_address=${DB_URL} \
--set secret.postgres_external_port=${DB_PORT} \
--set secret.postgres_database=${DB_NAME} \
--set secret.postgres_username=${DB_USER} \
--set secret.postgres_password=${DB_PASSWORD} \
rhsso-operator ./rhsso-operator -n ${NAMESPACE}
```
