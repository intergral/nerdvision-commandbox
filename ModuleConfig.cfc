component {

    function configure()
    {
        settings = {
            apiKey = "",
            name = "nerd.vision",
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

        // Create nv folder for server
        directoryCreate(serverInfo.serverHomeDirectory & 'nv/', true, true);

        var url = "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.nerdvision&a=agent&v=LATEST";
        // download the latest version of nv : https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.nerdvision&a=agent&v=LATEST
        cfhttp(method = 'GET', getasbinary = 'true', url = '#url#', path = serverInfo.serverHomeDirectory & 'nv/', file = 'nerdvision.jar');

        // Append the java agent to the java args
        serverInfo.JVMArgs &= ' "-javaagent:#replaceNoCase(serverInfo.serverHomeDirectory, '\', '\\', 'all')#nerdvision.jar=name=#serverInfo.name#,api.key=#serverInfo.apiKey#';
    }
}
