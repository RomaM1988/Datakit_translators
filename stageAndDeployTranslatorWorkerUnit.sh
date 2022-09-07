#!/bin/bash

if [ $# -ne 4 ]
then
        echo "stageAndDeployTranslatorWorkerUnit.sh called with incorrect number of arguments."
        echo "stageAndDeployTranslatorWorkerUnit.sh <Interop_downloadPath> <StageDir> <ArtifactsDir> <DeployFlag>"
        echo "For example; stageAndDeployTranslatorWorkerUnit.sh J:\datakit_translator\Baseline_Interop10 /plm/pnnas/ppic/users/<stage_dir> <ArtifactsDir> true/false"
        exit 1
fi
declare -g Lineaa
Interop_Release=$1
STAGE_BASE_DIR=$2
ARTIFACTS_DIR=$3
EXECUTE_DEPLOY=$4

UNIT_PATH="${Interop_Release}/"
filename="${Interop_Release}/latestBaseline.txt"
echo "file at $filename"
cat $filename | while read line || [[ -n $line ]];
do
  echo "yes $line"
  Lineaa=$line
  echo ${Lineaa}
done
arrIN=(${Lineaa//,/ })
echo ${arrIN[0]}
echo "here i "
UNIT_PATH="${Interop_Release}/abc_${arrIN[0]}/${arrIN[0]}"
echo "unit path is $UNIT_PATH"

# Run customer specific stage script to stage artifacts
#chmod 0755 ${ARTIFACTS_DIR}/stage_and_deploy_artifacts.sh || { exit 1;}
#${ARTIFACTS_DIR}/stage_and_deploy_artifacts.sh ${UNIT_PATH} ${STAGE_BASE_DIR} ${ARTIFACTS_DIR} ${EXECUTE_DEPLOY} || { exit 1;}



