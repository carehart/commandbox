/**
* I represent an invocation of a command.  I can be run asyncronously and will pass back status via reference since I can by run async.
* I require the CommandCFC reference to run, the struct of parameters, and a pipedInputStream that will receive the output of the command.
* This command should not output anything directly to the console (unless it requires interactivity) but flush it all via the input stream.
*/
component accessors=true {
	property name="wirebox" inject="wirebox";
	property name="shell" inject="shell";
	property name="errored" default=false;
	property name="exception";
	property name="threadName";
	property name="pipedInputStream";
	property name="pipedOutputStream";
	
	any function init() {
		setPipedOutputStream( createObject( 'java', 'java.io.PipedOutputStream' ).init() );
		setPipedInputStream( createObject( 'java', 'java.io.PipedInputStream' ).init( getPipedOutputStream() ) );
		setThreadName( createUUID() );
		return this;
	}
	
	function run( commandCFC, parameters ) {
		thread name=getThreadName() commandCFC=commandCFC parameters=parameters {
			try {
				thread.pipedOutputStream = getPipedOutputStream();
				var result = commandCFC.run( argumentCollection = parameters );	
				//	systemOutput( 'command done', true );
				// Backwards compat-- any text returned from the method is flushed to output buffer.
				if( !isNull( result ) ) {
					commandCFC.getPrint().text( result );
				}
				//	setErrored( commandCFC.hasError() );
			} catch( any e ){
				//	systemOutput( 'catch block entered', true );
				//	systemOutput( 'error! #e.message#', true );
				setErrored( true );
				setException( e );
			
				//shell.printError( e );
			} finally {
				//systemOutput( 'finally block entered', true );
				// Close the piped output stream which signifies to its listener that it's finished.
				getPipedOutputStream().close();
			}
		}
		
		// This will return immediately even if the command thread above is still running
		return getPipedInputStream();
	}
}