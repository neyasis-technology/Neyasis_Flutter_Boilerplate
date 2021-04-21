const { exec } = require('child_process');

const IOSRunScriptHelper = {
  setInfoPListObj: (key, value) => {
    const setVersion = `/usr/libexec/PlistBuddy -c "Set ${key} ${value}" "./Runner/Info.plist"`;
    exec(setVersion,(error)=>{IOSRunScriptHelper.sendScriptErrorMessageOnXCode(error)});
  },
  sendScriptErrorMessageOnXCode: (message) => {
  if(message==null) return;
    console.log(`error: ${message}`);
  },
};

module.exports = IOSRunScriptHelper;
