const Environment = require('../../.env.json');
const { sendScriptErrorMessageOnXCode, setInfoPListObj } = require('./helper');
const { exec } = require('child_process');
const AppMode = {
  development: 1,
  production: 2,
  uat: 3,
  test: 4
};
let bundleId = '';
let versionCode = 1;
let versionName = '';
let appName = Environment.applicationName;
let googleServicesInfoPListName="";
if (Environment.environmentMode === AppMode.development) {
  bundleId = Environment.bundleId.development.ios;
  versionCode = Environment.versionCode.development.ios;
  versionName = Environment.versionName.development.ios;
  appName += '-DEV';
  googleServicesInfoPListName=Environment.googleApi.servicesFileNames.ios.development;
} else if (Environment.environmentMode === AppMode.production) {
  bundleId = Environment.bundleId.production.ios;
  versionCode = Environment.versionCode.production.ios;
  versionName = Environment.versionName.production.ios;
  googleServicesInfoPListName=Environment.googleApi.servicesFileNames.ios.production;
} else if (Environment.environmentMode === AppMode.test) {
  bundleId = Environment.bundleId.test.ios;
  versionCode = Environment.versionCode.test.ios;
  versionName = Environment.versionName.test.ios;
  appName += '-TEST';
  googleServicesInfoPListName=Environment.googleApi.servicesFileNames.ios.test;
} else if (Environment.environmentMode === AppMode.uat) {
  bundleId = Environment.bundleId.uat.ios;
  versionCode = Environment.versionCode.uat.ios;
  versionName = Environment.versionName.uat.ios;
  appName += '-UAT';
  googleServicesInfoPListName=Environment.googleApi.servicesFileNames.ios.uat;
} else {
  sendScriptErrorMessageOnXCode('Please set your environment app mode in .env.json');
}
const createGoogleServicesInfo=`cp ./Runner/${googleServicesInfoPListName} ./Runner/GoogleService-Info.plist`;
exec(createGoogleServicesInfo,(error)=>{sendScriptErrorMessageOnXCode(error)});

setInfoPListObj('CFBundleShortVersionString', versionName);
setInfoPListObj('CFBundleVersion', versionCode);
setInfoPListObj('CFBundleDisplayName', appName);
setInfoPListObj('CFBundleIdentifier', bundleId);
//setInfoPListObj('PRODUCT_BUNDLE_IDENTIFIER', bundleId);

// sendScriptErrorMessageOnXCode('İşlem bitti');
