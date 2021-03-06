component {

    function configure() {
        settings = {
            enable = true,
            version = 'LATEST',
            apikey = "",
            name = "",
            tags = ""
        };
    }

    function onServerStart(required struct interceptData) {
        jobEnabled = wirebox.getBinder().mappingExists( 'interactiveJob' );
        consoleLogger = wirebox.getInstance( dsl='logbox:logger:console' );

        var serverInfo = arguments.interceptData.serverInfo;

        var serverService = wirebox.getInstance( 'ServerService' );
        var configService = wirebox.getInstance( 'ConfigService' );
        var systemSettings = wirebox.getInstance( 'SystemSettings' );

        // read server.json
        var serverJSON = serverService.readServerJSON( serverInfo.serverConfigFile ?: '' );

        // Get defaults
        var defaults = configService.getSetting( 'server.defaults', {} );
        systemSettings.expandDeepSystemSettings( serverJSON );
        systemSettings.expandDeepSystemSettings( defaults );

        var nvEnable = serverJSON.nerdvision.enable ?: defaults.nerdvision.enable ?: settings.enable;
        var version =  serverJSON.nerdvision.version ?: defaults.nerdvision.version ?: settings.version;
        var apikey =  serverJSON.nerdvision.apikey ?: defaults.nerdvision.apikey ?: settings.apikey;
        var name =  serverJSON.nerdvision.name ?: defaults.nerdvision.name ?: settings.name;
        var tags =  serverJSON.nerdvision.tags ?: defaults.nerdvision.tags ?: settings.tags;

        if (isBoolean(nvEnable) && !nvEnable) {
            logDebug('NerdVision is disabled');
            return;
        }

        if ("#apikey#" == "") {
            logError('NerdVision apikey not set.');
            return;
        }

        logDebug( '******************************************' );
        logDebug( '* CommandBox NerdVision Module Loaded *' );
        logDebug( '******************************************' );

        // Create a folder for the nerdvision.jar
        var nvTargetDir = serverInfo.serverHomeDirectory & '/nv';
        directoryCreate(nvTargetDir, true, true);

        var download = true;
        var versionsXML = "";
        var latestAvail = "";
        var jarExists = fileExists('#nvTargetDir#/nerdvision.jar');
        var versionExists = fileExists("#nvTargetDir#/nv_version");
        try {
            versionsXML = xmlParse("https://repo1.maven.org/maven2/com/nerdvision/agent/maven-metadata.xml");
            latestAvail = versionsXML.metadata.versioning.latest.XMLText;

            if (versionExists) {
                var nvVersion = fileRead("#nvTargetDir#/nv_version");
                if ("#nvVersion#" == "#version#" and jarExists) {
                    download = false;
                    logDebug("Found existing nerdvision.jar (#nvVersion#) expecting (#version#) file in #nvTargetDir#");
                } else {
                    if ("#version#" == "LATEST") {
                        download = "#latestAvail#" != "#nvVersion#";
                        if (download) {
                            logDebug("Found existing nerdvision.jar (#nvVersion#) updating to new version (#latestAvail#)");
                        } else {
                            logDebug("nerdvision.jar (#nvVersion#) already at latest version (#latestAvail#)");
                        }
                    } else {
                        logDebug("Found existing nerdvision.jar (#nvVersion#) updating to set version (#version#)");
                    }
                }
            }
        } catch (any e) {
            download = false;
            if (jarExists and versionExists) {
                var nvVersion = fileRead("#nvTargetDir#/nv_version");
                logError("Could not download nerdvision version list. Using existing version (#nvVersion#)");
            } else {
                logError("Could not download nerdvision and no jar installed. Disabling plugin.");
                return;
            }
        }

        if (download) {
            var nvUrl = 'https://repository.sonatype.org/service/local/artifact/maven/redirect';
            logDebug('Downloading nerd.vision #version# from https://repository.sonatype.org to directory #nvTargetDir#...');
            cfhttp(method = "GET", getasbinary = "true", url = nvUrl, path = nvTargetDir, file = "nerdvision.jar", timeout = "10") {
                cfhttpparam(name = 'r', value = 'central-proxy');
                cfhttpparam(name = 'g', value = 'com.nerdvision');
                cfhttpparam(name = 'a', value = 'agent');
                cfhttpparam(name = 'v', value = '#version#');
            };
            var versionInstalled = '';
            if ("#version#" == "LATEST") {
                versionInstalled = latestAvail;
            } else {
                versionInstalled = version;
            }
            fileWrite("#nvTargetDir#/nv_version", "#versionInstalled#");
        }

        // if we have an apikey set the agent args
        if ("#apikey#" != "") {
            var nvJVMArgs = ' "-javaagent:#replaceNoCase(serverInfo.serverHomeDirectory, '\', '\\', 'all')#/nv/nerdvision.jar=api.key=#trim(apikey)#';

            if ("#name#" != "") {
                nvJVMArgs &= ",name=#trim(reReplace(name, '\s', '', 'ALL'))#";
            }
            if ("#tags#" != "") {
                nvJVMArgs &= ",tags=#trim(reReplace(tags, '\s', '', 'ALL'))#";
            }
            nvJVMArgs &= '"';
            serverInfo.JVMArgs &= nvJVMArgs;

            logDebug('Using nerd.vision JVM args #serverInfo.JVMArgs#');
        } else {
            logDebug("To use nerd.vision set an apikey by executing 'box set config modules.nerdvision.apikey=<your apikey>'");
        }
    }

    private function logError( message ) {
        if( jobEnabled ) {
            if( message == '.' ) { return; }
            var job = wirebox.getInstance( 'interactiveJob' );
            job.addErrorLog( message );
        } else {
            consoleLogger.error( message );
        }
    }

    private function logWarn( message ) {
        if( jobEnabled ) {
            if( message == '.' ) { return; }
            var job = wirebox.getInstance( 'interactiveJob' );
            job.addWarnLog( message );
        } else {
            consoleLogger.warn( message );
        }
    }

    private function logDebug( message ) {
        if( jobEnabled ) {
            if( message == '.' ) { return; }
            var job = wirebox.getInstance( 'interactiveJob' );
            job.addLog( message );
        } else {
            consoleLogger.debug( message );
        }
    }
}
