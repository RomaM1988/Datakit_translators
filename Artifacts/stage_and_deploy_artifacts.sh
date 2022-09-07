#!/bin/bash

if [ $# -ne 4 ]
then
        echo "stage_and_deploy_artifacts.sh called with incorrect number of arguments."
        echo "stage_and_deploy_artifacts.sh <unitPaht> <StageBaseDir> <CustomerArtifactDir> <DeployFlag>"
        echo "For example; stage_and_deploy_artifacts.sh /plm/pnnas/ppic/users/<unit_name> /plm/pnnas/ppic/users/<stage_dir> <Artifacts> true/false"
        exit 1
fi

echo "Executing stage_and_deploy_artifacts.sh..."

UNIT_PATH=$1
STAGE_BASE_DIR=$2
CUSTOMER_ARTIFACTS_DIR=$3
EXECUTE_DEPLOY=$4

STAGE_DIR=${STAGE_BASE_DIR}/Solidworks/lnx64/TranslatorBinaries/
SOURCE_PATH=${UNIT_PATH}/lnx64/kits/jt_sw
SOLIDWORKS_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Solidworks/lnx64
SOLIDWORKS_STAGE_DIR=${STAGE_DIR}jt_sw

if [ ! -d ${STAGE_DIR} ]
then
	echo "Creating staging directory ${STAGE_DIR}"
	mkdir -p ${STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${SOLIDWORKS_STAGE_DIR} ]
then
	echo "Creating staging directory ${SOLIDWORKS_STAGE_DIR}"
	mkdir -p ${SOLIDWORKS_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${SOLIDWORKS_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${SOURCE_PATH}/*   ${SOLIDWORKS_STAGE_DIR} || { exit 1;}

RUN_SWTOJT=${STAGE_DIR}/run_swtojt
RUN_SWTOJT_MULTICAD=${STAGE_DIR}/run_swtojt_multicad

cp -f ${SOLIDWORKS_ARTIFACTS_DIR}/run_swtojt ${RUN_SWTOJT} || { exit 1;}
cp -f ${SOLIDWORKS_ARTIFACTS_DIR}/run_swtojt_multicad ${RUN_SWTOJT_MULTICAD} || { exit 1;}
cp -f ${SOLIDWORKS_ARTIFACTS_DIR}/SWJT_Translator_README.txt ${STAGE_BASE_DIR}/Solidworks/lnx64/ || { exit 1;}

chmod 0755 ${RUN_SWTOJT} || { exit 1;}
chmod 0755 ${RUN_SWTOJT_MULTICAD} || { exit 1;}

if [ ${EXECUTE_DEPLOY} == "true" ]
then
	echo "Deploy flag is set to true. Executing deploy step for solidworks Linux build..."
	releaseName="SWJT_LINUX"
	cd ${STAGE_BASE_DIR}/Solidworks/lnx64 || { exit 1;}
	tar -czf $releaseName.tar.gz TranslatorBinaries/ || { exit 1;}
	# echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/NXtoJT/$releaseName/ || { exit 1;}"

	# echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/NXtoJT/$releaseName/ || { exit 1;}"

	cd -
	echo "Deploy flag is set to true. deploy step..."
else
	echo "Deploy flag is set to false. Skipping deploy step..."
fi
