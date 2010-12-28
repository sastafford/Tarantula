package com.marklogic.tarantula.test;

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.*;
import com.marklogic.xcc.ResultSequence;

public class HTTPCrawlerTest extends XQueryTestCase {

	private String modulePath = "/util/tarantula.xqy";
	
	private String sampleURL = "http://en.wikipedia.org/wiki/Star_wars";

	public void testHTTPGet() throws Exception {
		//Initialize the variable
		XdmVariable[] variables = new XdmVariable[] { 
				ValueFactory.newVariable(new XName("url"), ValueFactory.newXSString(sampleURL))};
		ResultSequence rs = this.executeMainModule(modulePath, null, variables);
		XSBoolean ok  = (XSBoolean)rs.itemAt(0);
		assertTrue(ok.asBoolean());					
	}
	
		
}
