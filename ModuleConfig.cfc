component {

    function configure() {
        settings = {
            apiKey = "",
            name = "",
            tags = []
        }   
    }

    function onServerStart( required struct interceptData ) {

        var serverInfo = arguments.interceptData.serverInfo;
        
	// Create nv folder for server
	directoryCreate( serverInfo.serverHomeDirectory & 'nv/', true, true );

        url = "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.nerdvision&a=agent&v=LATEST"
        // download the latest version of nv : https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.nerdvision&a=agent&v=LATEST
        cfhttp( method='GET', getasbinary='true', url='#url#', path=serverInfo.serverHomeDirectory & 'nv/', file='nerdvision.jar')

        // Append the java agent to the java args
	serverInfo.JVMArgs &= ' "-javaagent:#replaceNoCase( serverInfo.serverHomeDirectory, '\', '\\', 'all' )#nerdvision.jar=name=#serverInfo.name#,api_key=#serverInfo.api_key#';
    }
}
