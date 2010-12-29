package com.marklogic.tarantula.test;

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.*;
import com.marklogic.xcc.ResultSequence;

public class HTTPCrawlerTest extends XQueryTestCase {

	private String modulePath = "/util/tarantula.xqy";
	
	private String sampleURL = "http://en.wikipedia.org/wiki/Star_wars";
	//private String sampleURL = "http://upload.wikimedia.org/wikipedia/commons/6/6c/Star_Wars_Logo.svg";
	
	protected void setUp() throws Exception {
		super.setUp();
		executeLibraryModule("/application/models/http-crawler.xqy", 
				"http://www.marklogic.com/tarantula/crawler", 
				"init", null);
		executeLibraryModule("/application/models/http-crawler.xqy", 
							"http://www.marklogic.com/tarantula/crawler", 
							"emptyQueue", null);
	}
	
	public void testHTTPGet() throws Exception {
		//Initialize the variable
		XdmVariable[] variables = new XdmVariable[] { 
				ValueFactory.newVariable(new XName("url"), ValueFactory.newXSString(sampleURL))};
		ResultSequence rs = this.executeMainModule(modulePath, null, variables);
		XSBoolean ok  = (XSBoolean)rs.itemAt(0);
		assertTrue(ok.asBoolean());					
	}
	
		
}
