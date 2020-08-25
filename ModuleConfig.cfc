component {

    function configure() {
        settings = {
            version = 'LATEST',
            apikey = "",
            name = "",
            tags = ""
        };
    }

    function onServerStart(required struct interceptData) {
        var serverInfo = arguments.interceptData.serverInfo;

        // Create a folder for the nerdvision.jar
        var nvTargetDir = serverInfo.serverHomeDirectory & '/nv/';
        directoryCreate( nvTargetDir, true, true );

        // download the JAR from maven if not done before
        if (!fileExists(nvTargetDir & 'nerdvision.jar')) {
            var nvUrl = 'https://repository.sonatype.org/service/local/artifact/maven/redirect';
            log.info('Downloading nerd.vision #settings.version# from https://repository.sonatype.org to directory #nvTargetDir#...');
            cfhttp(method = "GET", getasbinary = "true", url = nvUrl, path = nvTargetDir, file = "nerdvision.jar", timeout = "10") {
                cfhttpparam(name = 'r', value = 'central-proxy');
                cfhttpparam(name = 'g', value = 'com.nerdvision');
                cfhttpparam(name = 'a', value = 'agent');
                cfhttpparam(name = 'v', value = '#settings.version#');
            };
        } else {
            log.info("Found existing nerdvision.jar file in #nvTargetDir#");
        }

        // if we have an apikey set the agent args
        if( "#settings.apikey#" != "" ) {
            var nvJVMArgs = "-javaagent:#replaceNoCase(serverInfo.serverHomeDirectory, '\', '\\', 'all')#/nv/nerdvision.jar=api.key=#trim(settings.apikey)#";

            if( "#settings.name#" != "" ) {
                nvJVMArgs &= ",name=#trim(reReplace(settings.name, '\s', '', 'ALL'))#";
            }
            if( "#settings.tags#" != "" ) {
                nvJVMArgs &= ",tags=#trim(reReplace(settings.tags, '\s', '', 'ALL'))#";
            }
            serverInfo.JVMArgs &= nvJVMArgs;

            log.info('Using nerd.vision JVM args #serverInfo.JVMArgs#');
        } else {
            log.info("To use nerd.vision set an apikey by executing 'box set config modules.nerdvision.apikey=<your apikey>'");
        }
    }
}
