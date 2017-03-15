/** 
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Brad Wood, Luis Majano
Date        :	07/22/2014
Description :
	A logger for outputting ANSI-formmatted text to the console
	for use with CommandBox. 
	
Properties:
- none
*/
component extends="wirebox.system.logging.AbstractAppender" {
	
	/**
	* @name.hint The unique name for this appender.
	* @properties.hint A map of configuration properties for the appender
	* @layout.hint The layout class to use in this appender for custom message rendering.
	* @levelMin.hint The default log level for this appender, by default it is 0. Optional. ex: LogBox.logLevels.WARN
	* @levelMax.hint The default log level for this appender, by default it is 5. Optional. ex: LogBox.logLevels.WARN
	*/
	ANSIConsoleAppender function init( required name, properties={}, layout, levelMin=0, leveMax=4 ) {
		// Init supertype
		super.init(argumentCollection=arguments);
		// The log levels enum as a public property
		variables.logLevels = createObject("component","wirebox.system.logging.LogLevels");
		
		return this;
	}
	
	function logMessage( required logEvent ) {

		var shell = application.wireBox.getInstance( 'shell' );
		
		var loge = arguments.logEvent;
		var entry = "";
		
		if( hasCustomLayout() ){
			entry = getCustomLayout().format( loge );
		} else {
			entry = loge.getmessage();
			if( entry == '.' ) {
				entry = '';
			}
		}
		
		// Log message
		switch( loge.getseverity() ) {
		    case logLevels.FATAL: case logLevels.ERROR:
				shell.printString( print().boldRedLine( entry ) );
		         break;
		    case logLevels.WARN:
				shell.printString( print().yellowLine( entry ) );
		         break;
		    case logLevels.INFO:
				shell.printString( print().greenLine( entry ) );
		         break;
		    default: 
				shell.printString( print().line( entry ) );
		}

		// Log Extra Info as a string
		var extraInfo = loge.getExtraInfoAsString();
		if( len( extraInfo ) ){
			shell.printString( print().line( loge.getExtraInfo().toString() ) );	
		}
	}
	
	function print() {
		if( !structKeyExists( variables, 'oPrint' ) ){
			// Appenders are created by WireBox, so we can't DI.
			variables.oPrint = application.wireBox.getInstance( 'Print' );
		} 
		return variables.oPrint;
	}
	
}