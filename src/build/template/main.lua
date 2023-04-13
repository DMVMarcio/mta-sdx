local execFile = fileOpen('exec.luac');
local execFileContent = fileRead(execFile, fileGetSize(execFile));
fileClose(execFile);

function load()
    return execFileContent;
end
