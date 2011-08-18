<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author 	  : Luis Majano
Date        : 06/20/2009
Description :
 Base Test case for Handlers Standalone
---------------------------------------------------------------------->
<cfcomponent output="false" extends="mockbox.system.testing.BaseTestCase" hint="A base test for unit testing event handlers">

	<cfscript>
		this.loadColdbox = false;	
	</cfscript>

	<!--- setupTest --->
    <cffunction name="setup" output="false" access="public" returntype="void" hint="Prepare for testing">
    	<cfscript>
    		var md 			= getMetadata(this);
			var mockBox 	= getMockBox();
			var UDFLibrary  = "";
			
			// Check for handler path else throw exception
			if( NOT structKeyExists(md, "handler") ){
				$throw("handler annotation not found on component tag","Please declare a 'handler=path' annotation","BaseHandlerTest.InvalidStateException");
			}
			// Check for UDF Library File
			if( structKeyExists(md, "UDFLibraryFile") ){
				UDFLibrary = md.UDFLibraryFile;
			}
			
			// Create handler with Mocking capabilities
			variables.handler = mockBox.createMock(md.handler);
			
			// Create Mock Objects
			variables.mockController 	 = mockBox.createEmptyMock("mockbox.system.testing.mock.web.MockController");
			variables.mockRequestContext = getMockRequestContext();
			variables.mockRequestService = mockBox.createEmptyMock("mockbox.system.web.services.RequestService").$("getContext", variables.mockRequestContext);
			variables.mockLogBox	 	 = mockBox.createEmptyMock("mockbox.system.logging.LogBox");
			variables.mockLogger	 	 = mockBox.createEmptyMock("mockbox.system.logging.Logger");
			variables.mockFlash		 	 = mockBox.createMock("mockbox.system.web.flash.MockFlash").init(mockController);
			variables.mockCacheBox   	 = mockBox.createEmptyMock("mockbox.system.cache.CacheFactory");
			
			// Mock Handler Dependencies
			variables.mockController.$("getLogBox",variables.mockLogBox);
			variables.mockController.$("getCacheBox",variables.mockCacheBox);
			variables.mockController.$("getRequestService",variables.mockRequestService);
			variables.mockController.$("getSetting").$args("UDFLibraryFile").$results(UDFLibrary);
			variables.mockController.$("getSetting").$args("AppMapping").$results("/");
			variables.mockRequestService.$("getFlashScope",variables.mockFlash);
			variables.mockLogBox.$("getLogger",variables.mockLogger);
			
			// Decorate handler?
			if( NOT getUtil().isFamilyType("handler",variables.handler) ){
				getUtil().convertToColdBox( "handler", variables.handler );	
				// Check if doing cbInit()
				if( structKeyExists(variables.handler, "$cbInit") ){ variables.handler.$cbInit( mockController ); }
			}
    	</cfscript>
    </cffunction>

</cfcomponent>