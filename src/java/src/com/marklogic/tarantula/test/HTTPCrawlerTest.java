package com.marklogic.tarantula.test;

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.*;
import com.marklogic.xcc.ResultSequence;

public class HTTPCrawlerTest extends XQueryTestCase {

	private String modulePath = "/util/tarantula.xqy";
	
	private String sampleURL1 = "http://en.wikipedia.org/wiki/Star_wars";
	private String sampleURL2 = "http://upload.wikimedia.org/wikipedia/commons/6/6c/Star_Wars_Logo.svg";
	
	protected void setUp() throws Exception {
		super.setUp();
		executeLibraryModule("/application/models/http-crawler.xqy", 
				"http://www.marklogic.com/tarantula/crawler", 
				"init", null);
		executeLibraryModule("/application/models/http-crawler.xqy", 
							"http://www.marklogic.com/tarantula/crawler", 
							"emptyQueue", null);
	}
	
	public void testHTTPGetHTMLContent() throws Exception {
		//Initialize the variable
		XdmVariable[] variables = new XdmVariable[] { 
				ValueFactory.newVariable(new XName("url"), ValueFactory.newXSString(sampleURL1))};
		ResultSequence rs = this.executeMainModule(modulePath, null, variables);
		String q = "fn:doc('" + sampleURL1 + "')//*:title/text()";
		ResultSequence rs2 = executeQuery(q, null, null);
		String qStr = rs2.asString();
		System.out.println(rs.asString());
		System.out.println(qStr);
		assertEquals("Star Wars - Wikipedia, the free encyclopedia", qStr);		
	}
	
		
}
