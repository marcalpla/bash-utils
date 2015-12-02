#!/bin/bash
# Launch AWS EMR Spark Application using aws cli
# Usage: ./aws_launch_spark_app.sh CLUSTER_NAME INSTANCE_TYPE INSTANCE_COUNT LOG_URI [-s step_class step_class_jar [step_class_params]...]...

CLUSTER_NAME=$1
INSTANCE_TYPE=$2
INSTANCE_COUNT=$3
LOG_URI=$4

STEPS=""

# Build steps argument text
for arg in "$@"; do
  shift
  if [ $arg = '-s' ]; then
    step_class=$1
    step_class_jar=$2
    step_class_params_array=${@:3}
    step_class_params=""

    # Build step class params argument text
    for step_class_param in $step_class_params_array; do
      if [ $step_class_param = '-s' ]; then
        break
      fi
      step_class_params+=",$step_class_param"
    done

    step="$step_class,$step_class_jar$step_class_params"
    step_name="$step_class$step_class_params"
    STEPS+="Type=Spark,Name=${step_name//,/},Args=[--deploy-mode,cluster,--master,yarn-cluster,--class,$step] "
  fi
done

aws emr create-cluster \
--name $CLUSTER_NAME \
--release-label emr-4.2.0 \
--instance-type $INSTANCE_TYPE \
--instance-count $INSTANCE_COUNT \
--ec2-attributes KeyName=emndata \
--applications Name=Spark \
--log-uri $LOG_URI \
--steps $STEPS\
--auto-terminate
