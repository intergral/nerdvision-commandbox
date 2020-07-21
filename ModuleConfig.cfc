component {

    function configure()
    {
        settings = {
            version = 'LATEST',
            apiKey = "",
            name = "",
            tags = []
        };
    }

    // Runs when module is loaded
    function onLoad()
    {
        log.info('Module loaded successfully.');
    }

    // Runs when module is unloaded
    function onUnLoad()
    {
        log.info('Module unloaded successfully.');
    }

    function preCommand( interceptData ){
        // I just intercepted ALL Commands in the CLI
        log.info('The command executed is #interceptData.CommandInfo.commandString#');
    }

    function onServerStart(required struct interceptData)
    {
        log.info('Server starting...');

        var serverInfo = arguments.interceptData.serverInfo;

        // Create a folder for the nerdvision.jar
        var nvTargetDir = serverInfo.serverHomeDirectory & '/nv/';
        directoryCreate( nvTargetDir, true, true );
        log.info('nerd.vision directory is #nvTargetDir#');

        var nvUrl = 'https://repository.sonatype.org/service/local/artifact/maven/redirect';
        cfhttp(method = "GET", getasbinary = "true", url = nvUrl, path = nvTargetDir, file = "nerdvision.jar") {
        cfhttpparam(name='r', value='central-proxy');
        cfhttpparam(name='g', value='com.nerdvision');
        cfhttpparam(name='a', value='agent');
        cfhttpparam(name='v', value='#settings.version#');
    };

        // Append the java agent to the java args
        serverInfo.JVMArgs &= ' -javaagent:#replaceNoCase(serverInfo.serverHomeDirectory, '\', '\\', 'all')#/nv/nerdvision.jar=name=#serverInfo.name#,api.key=#settings.apiKey#';
    }
}
