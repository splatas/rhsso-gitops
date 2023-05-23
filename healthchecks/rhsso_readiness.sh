#!/bin/sh
# INSTRUCTIONS TO TEST YOUR 'RH-SSO' INSTANCE RUNNING ON KUBERNETES
# -----------------------------------------------------------------
# Prerequisites:
# 1. Kubernetes Client (kubectl) installed. (Installation details: https://kubernetes.io/docs/tasks/tools/)
# 2. You should be logged in your Kubernetes Cluster.
# 3. Namespace where your RH-SSO instances is installed. 
# -----------------------------------------------------------------

# Parameters
export ITERATIONS=3000
export SECONDS_DELAY=10
export POD='null'
export RHSSO_RUNNING=false
export READINESS_COMMAND='python $JBOSS_HOME/bin/probes/runner.py -c READY --debug --logfile /tmp/readiness-log --loglevel DEBUG probe.eap.dmr.EapProbe probe.eap.dmr.HealthCheckProbe;'
export READINESS_RESPONSE='null'
export NAMESPACE='rhn-gps-splatas-dev'
export LOG_FILE='rhsso_readiness.log'

echo "=================================================================================="
echo "This script will help you to check if your RH-SSO instances is ready to work."
echo "=================================================================================="
echo "Parameters: "
echo "ITERATIONS: $ITERATIONS, SECONDS_DELAY: $SECONDS_DELAY - NAMESPACE: $NAMESPACE"
echo "READINESS_COMMAND: '$READINESS_COMMAND'"
echo "=================================================================================="

read -p "Please enter the NAMESPACE of your RH-SSO instance: " NAMESPACE
echo "NAMESPACE: $NAMESPACE"
echo "=================================================================================="

echo "--- Starting ---"
echo "	1. Checking RH-SSO running PODs:"
for (( i=1; i<=$ITERATIONS; i++ ))
do
	if [ "$RHSSO_RUNNING" == false ]; then

		# 1. IDENTIFY THE POD: GET THE NAME
		POD=$(kubectl get pods -n $NAMESPACE | grep sso | grep -v postgresql | grep -v deploy | grep Running | awk '{print $1;}')
		
		if [[ $POD != "" ]]
		then
			echo "		==>	We have a running pod! POD: '$POD'"
			echo " "
			echo "	2. Checking availability of RH-SSO:"
			# 2. RUN THE READINESS PROBE
			for (( r=1; r<=$ITERATIONS; r++ ))
			do
				if [[ $POD == "" ]]
				then
					echo "	"
					echo "		--> WARNING: previous pod seems to have been destroyed. Now is: '$POD' <-- "
					echo "	"
				fi
				
				echo "		--> Attempt number $r, pod: '$POD'"
				
				READINESS_RESPONSE=$(kubectl exec $POD -n $NAMESPACE -- /bin/bash -c "$READINESS_COMMAND")
				echo "Readiness Response: $READINESS_RESPONSE" > ./$LOG_FILE
				
				# 3. ANALIZE THE RESPONSE
				# ----------------------------------------------------------------------------
				# RESPONSE FORMAT: {
				#	    "probe.eap.dmr.EapProbe": {
				#	        "probe.eap.dmr.ServerStatusTest": "running",
				#	        "probe.eap.dmr.ServerRunningModeTest": "NORMAL",
				#	        "probe.eap.dmr.BootErrorsTest": "No boot errors",
				#	        "probe.eap.dmr.DeploymentTest": {
				#	            "keycloak-server.war": "OK"
				#	        }
				#	    },
				#	    "probe.eap.dmr.HealthCheckProbe": {
				#	        "probe.eap.dmr.HealthCheckTest": "Health Check not configured"
				#	    }
				#	}
				#
				# When deployment is not finished:	 "keycloak-server.war": "FAILED"
				# ----------------------------------------------------------------------------
				RESULT=$(cat ./$LOG_FILE | grep keycloak-server.war | grep OK)
				
				if [[ "$RESULT" == *"OK"* ]]; then
					echo " "
					echo "		==> RESULT: $RESULT ---> RH-SSO IS READY!"
					RHSSO_RUNNING=true
					break
				else 
					echo "		--> RESULT: $RESULT ---> RHSSO not ready yet. Checking continues..."
					sleep $SECONDS_DELAY
					
					# 3. VERIFY THE POD NAME: is the same?
					POD=$(kubectl get pods -n $NAMESPACE | grep sso | grep -v postgresql | grep -v deploy | grep Running | awk '{print $1;}')
				fi
			done
			
		else 
			echo "	- No RUNNING pods found! Sleeping $SECONDS_DELAY seconds..."
			sleep $SECONDS_DELAY
		fi
	
	else
		break
	fi
	
done

echo "--- Finish ---"
