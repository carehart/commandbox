/**
*********************************************************************************
* Copyright Since 2014 CommandBox by Ortus Solutions, Corp
* www.coldbox.org | www.ortussolutions.com
********************************************************************************
* @author Brad Wood, Luis Majano, Denny Valliant
*
* I am a helper object that wraps the print helper.  Instead of returning
* text, I accumulate it in a variable that can be retreived at the end.
*
*/
component accessors="true" extends="Print"{

	// DI
	property name="shell" inject="shell";

	/**
	* Result buffer
	*/
	property name="pipedOutputStream";
	property name="outputStreamWriter";

	function init(){
		// I accept raw bytes in
		pipedOutputStream = createObject( 'java', 'java.io.PipedOutputStream' ).init();
		// I accept character strings and feed their raw bytes to the pipedOutputStream
		outputStreamWriter = createObject( 'java', 'java.io.OutputStreamWriter' ).init( pipedOutputStream );
		
		return this;
	}

	// Force a flush
	function toConsole(){
		//variables.shell.printString( getResult() );
		//clear();
	}

	// Reset the result
	function clear(){
		init();
		//variables.result = '';
	}

	// Proxy through any methods to the actual print helper
	function onMissingMethod( missingMethodName, missingMethodArguments ){
		var result = super.onMissingMethod( arguments.missingMethodName, arguments.missingMethodArguments );
		outputStreamWriter.write( result, 0, result.len() );
		outputStreamWriter.flush();
		return this;
	}

}
