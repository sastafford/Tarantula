package com.marklogic.tarantula.test;

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.*;
import com.marklogic.xcc.ResultSequence;

public class HTTPCrawlerTest extends XQueryTestCase {

	private String modulePath = "/util/tarantula.xqy";
	private String moduleNamespace = "http://www.marklogic.com/tarantula";
	
	private String sampleURL = "http://en.wikipedia.org/wiki/Star_wars";

	public void testHTTPGet() throws Exception {
		//Initialize the variable
		XdmValue[] params = new XdmValue[] { ValueFactory.newXSString(sampleURL)};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "get-page", params);
		XSBoolean ok  = (XSBoolean)rs.itemAt(0);
		assertTrue(ok.asBoolean());					
	}
	
	public void testexternalVariableTest() throws Exception {
		//Initialize the variable
		XdmValue[] params = new XdmValue[] { ValueFactory.newXSString(sampleURL)};
		ResultSequence rs = executeLibraryModule("/application/models/http-crawler.xqy", "http://www.marklogic.com/tarantula/crawler", "tester", null);
		assertTrue(true);					
	}
	
	
	
}
