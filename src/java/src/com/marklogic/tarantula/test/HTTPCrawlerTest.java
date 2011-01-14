package com.marklogic.tarantula.test;

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.*;
import com.marklogic.xcc.ResultSequence;

public class HTTPCrawlerTest extends XQueryTestCase {

	private String modulePath = "/util/tarantula.xqy";
	private String modulePath2 = "util/link-queue.xqy";
	
	private String sampleURL1 = "http://en.wikipedia.org/wiki/Star_wars";
	private String sampleURL2 = "http://upload.wikimedia.org/wikipedia/commons/6/6c/Star_Wars_Logo.svg";
	private String sampleURL3 = "http://en.wikipedia.org/wiki/User:Tkgd2007";
	
	protected void setUp() throws Exception {
		super.setUp();
		executeLibraryModule("/application/models/crawl-model.xqy", 
				"http://www.marklogic.com/tarantula/crawl", 
				"init", null);
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
	
	public void testGetLinkQueue() throws Exception {
		//Initialize the variable
		XdmVariable[] variables = new XdmVariable[] { 
				ValueFactory.newVariable(new XName("url"), ValueFactory.newXSString(sampleURL3))};
		ResultSequence rs = this.executeMainModule(modulePath2, null, variables);
		String q = "fn:doc('" + sampleURL3 + "')";
		ResultSequence rs2 = executeQuery(q, null, null);
		String qStr = rs2.asString();
		System.out.println(rs.asString());
		//System.out.println(qStr);
		assertEquals("Star Wars - Wikipedia, the free encyclopedia", qStr);		
	}
	
		
}
