#!/bin/bash

if [ $# -ne 4 ]
then
        echo "stageAndDeployTranslatorWorkerUnit.sh called with incorrect number of arguments."
        echo "stageAndDeployTranslatorWorkerUnit.sh <Interop_downloadPath> <StageDir> <ArtifactsDir> <DeployFlag>"
        echo "For example; stageAndDeployTranslatorWorkerUnit.sh J:\datakit_translator\Baseline_Interop10 /plm/pnnas/ppic/users/<stage_dir> <ArtifactsDir> true/false"
        exit 1
fi

Interop_Release=$1
STAGE_BASE_DIR=$2
ARTIFACTS_DIR=$3
EXECUTE_DEPLOY=$4

filename="${Interop_Release}/latestBaseline.txt"
line=$(head -n 1 $filename)
arrIN=(${line//,/ })
UNIT_PATH="${Interop_Release}/${arrIN[0]}/${arrIN[0]}"
echo "unit path is $UNIT_PATH"

#Run Solidworks Staging and deploy
chmod 0755 ${ARTIFACTS_DIR}/Solidworks/Solidworks_stage_and_deploy_artifacts.sh || { exit 1;}
${ARTIFACTS_DIR}/Solidworks/Solidworks_stage_and_deploy_artifacts.sh ${UNIT_PATH} ${STAGE_BASE_DIR} ${ARTIFACTS_DIR} ${EXECUTE_DEPLOY} || { exit 1;}

#Run Inventor Staging and deploy
chmod 0755 ${ARTIFACTS_DIR}/Inventor/Inventor_stage_and_deploy_artifacts.sh || { exit 1;}
${ARTIFACTS_DIR}/Inventor/Inventor_stage_and_deploy_artifacts.sh ${UNIT_PATH} ${STAGE_BASE_DIR} ${ARTIFACTS_DIR} ${EXECUTE_DEPLOY} || { exit 1;}

#Run Catiav4 Staging and deploy
chmod 0755 ${ARTIFACTS_DIR}/Catiav4/Catiav4_stage_and_deploy_artifacts.sh || { exit 1;}
${ARTIFACTS_DIR}/Catiav4/Catiav4_stage_and_deploy_artifacts.sh ${UNIT_PATH} ${STAGE_BASE_DIR} ${ARTIFACTS_DIR} ${EXECUTE_DEPLOY} || { exit 1;}
