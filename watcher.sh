#!/bin/bash

# Define variables
# Name of the namespace
NAMESPACE="sre"
# Name of the deployment
DEPLOYMENT_NAME="swype-app"
# Maximum number of restarts before scaling down
MAX_RESTARTS=4

# Infinite loop for monitoring
while true; do

  # Get pod restarts
  RESTARTS=$(kubectl get pods -n "$NAMESPACE" -l app="$DEPLOYMENT_NAME" -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

  CURRENT_TIME=$(date)
  echo "$CURRENT_TIME | Swype pod restarts: $RESTARTS"

  # Check restart limit
  if [[ $RESTARTS -gt $MAX_RESTARTS ]]; then
    echo "Maximum number of restart is greater than the maximum allowed, scale down the deployment"
    kubectl scale deployment -n "$NAMESPACE" "$DEPLOYMENT_NAME" --replicas=0

    break
  fi

  # Pause for 60 seconds before next check
  sleep 60

done