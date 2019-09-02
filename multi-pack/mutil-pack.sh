#!/usr/bin/env bash

APK_PATH=$1
TEMP_PATH="../app/build/outputs/temp/"
CHANNELS_OUT_PATH="../app/build/outputs/channels"
ACCOUNT_360="360加固账号名"
PASSWORD_360="360加固账号的密码"


echo "########## jiagu start ##########"
mkdir ${TEMP_PATH}
java -jar ../multi-pack/jiagu/jiagu.jar -login ${ACCOUNT_360} ${PASSWORD_360}
java -jar ../multi-pack/jiagu/jiagu.jar -jiagu ${APK_PATH} ${TEMP_PATH}
echo "########## jiagu finish ##########"
echo "########## jiagu apk path ##########"
JIAGU_APK_NAME=$(basename $(find ${TEMP_PATH} -name "*jiagu.apk"))
JIAGU_APK_PATH=${TEMP_PATH}${JIAGU_APK_NAME}
echo ${JIAGU_APK_PATH}

echo "########## zipalign ##########"
ZIP_ALIGN_APK_PATH="${JIAGU_APK_PATH%.*}_aligned.apk"
../multi-pack/zipalign -v 4 ${JIAGU_APK_PATH} ${ZIP_ALIGN_APK_PATH}

echo "########## sign ##########"
SIGNED_APK_PATH="${ZIP_ALIGN_APK_PATH%.*}_signed.apk"
../multi-pack/apksigner sign --ks ../app/multi.jks --ks-key-alias multiKey --ks-pass pass:mxymulti --key-pass pass:mxymulti --out ${SIGNED_APK_PATH} ${ZIP_ALIGN_APK_PATH}

echo "########## channels ##########"
rm -rf ${CHANNELS_OUT_PATH}
java -jar ../multi-pack/walle-cli-all.jar batch -f ../multi-pack/channel ${SIGNED_APK_PATH} ${CHANNELS_OUT_PATH}

echo "########## clean temp ##########"
rm -rf ${TEMP_PATH}

echo "########## done ##########"
