local building = false;
local compile = false;

function initBuild()
    if(building) then
        iprint('Already building...');
        return;
    end
    building = true;
    iprint('Starting build...');

    local metaFileXML = xmlLoadFile('meta.xml', true);
    local metaFileNodes = xmlNodeGetChildren(metaFileXML);

    local buildFilesExec = '';

    for i, v in ipairs(metaFileNodes) do
        local ignore = xmlNodeGetAttribute(v, 'build_ignore');
        if(ignore ~= "true") then
            local filePath = xmlNodeGetAttribute(v, 'src');

            local fileHandler = fileOpen(filePath, true);
            local fileHandlerContent = fileRead(fileHandler, fileGetSize(fileHandler));
            fileClose(fileHandler);

            fileExec = 'loadstring([[\n' .. fileHandlerContent .. '\n]])()';
            buildFilesExec = buildFilesExec ~= '' and (buildFilesExec .. '\n' .. fileExec) or fileExec;

            iprint('builded:', filePath);
        end
    end

    xmlUnloadFile(metaFileXML);

    local templateMain = fileOpen('src/build/template/main.lua', true);
    local templateMainContent = fileRead(templateMain, fileGetSize(templateMain));
    fileClose(templateMain);

    local templateMeta = fileOpen('src/build/template/meta.xml', true);
    local templateMetaContent = fileRead(templateMeta, fileGetSize(templateMeta));
    fileClose(templateMeta);

    local function onBuilded(exec_data)
        local distExecFile = fileCreate(':SDX/exec.luac');
        fileWrite(distExecFile, exec_data);
        fileClose(distExecFile);
        iprint('created: exec.luac');

        local distMainFile = fileCreate(':SDX/main.lua');
        fileWrite(distMainFile, templateMainContent);
        fileClose(distMainFile);
        iprint('created: main.lua');

        local distMetaFile = fileCreate(':SDX/meta.xml');
        fileWrite(distMetaFile, templateMetaContent);
        fileClose(distMetaFile);
        iprint('created: meta.xml');

        building = false;
        iprint('Ended build!');
    end

    if(compile) then
        fetchRemote('https://luac.mtasa.com/?compile=1&debug=0&obfuscate=3', onBuilded, buildFilesExec, true);
    else
        onBuilded(buildFilesExec);
    end
end

addCommandHandler('sdx_build', initBuild);
