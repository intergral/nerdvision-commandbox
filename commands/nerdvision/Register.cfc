/**
* Register an existing api key with the nerd.vision module. This api key key will be used on future server starts.
* .
* {code:bash}
* nerdvision register XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
* {code}
*/
component aliases='nv register,nv license' {
    property name='ConfigService' inject='ConfigService';

    /**
    * apiKey The api key to activate your nerd.vision agent with
     */
    function run( required string apiKey ) {
        // Get the config settings
        var configSettings = ConfigService.getconfigSettings();

        // Set the setting
        configSettings[ 'modules' ][ 'nerdvision' ][ 'apiKey' ]=arguments.apiKey;

        // Save the setting struct
        ConfigService.setConfigSettings( configSettings );

        print.greenBoldLine( 'nerd.vison api key applied.' );
    }

}
