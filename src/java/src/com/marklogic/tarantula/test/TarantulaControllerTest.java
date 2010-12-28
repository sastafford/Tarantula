package com.marklogic.tarantula.test;

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ResultSequence;

public class TarantulaControllerTest extends XQueryTestCase {

	private String modulePath = "/application/models/http-crawler.xqy";
	private String moduleNamespace = "http://www.marklogic.com/tarantula/crawler";
	
	public void testInit() throws Exception {
		executeLibraryModule(modulePath, moduleNamespace, "init");
		// Verify update by running a query
		String q = "fn:doc('/config/tarantula.xml')" + "//tara:switch/text()";
		ResultSequence rs = this.executeQuery(q, null, null);
		String qStr = rs.asString();
		assertEquals("on", qStr);
	
	}
	
	public void testTurnOff() throws Exception {
		executeLibraryModule(modulePath, moduleNamespace, "turnOff");
		// Verify update by running a query
		String q = "fn:doc('/config/tarantula.xml')" + "//tara:switch/text()";
		ResultSequence rs = this.executeQuery(q, null, null);
		String qStr = rs.asString();
		assertEquals("off", qStr);
	
	}
	
	public void testTurnOn() throws Exception {
		executeLibraryModule(modulePath, moduleNamespace, "turnOn");
		// Verify update by running a query
		String q = "fn:doc('/config/tarantula.xml')" + "//tara:switch/text()";
		ResultSequence rs = this.executeQuery(q, null, null);
		String qStr = rs.asString();
		assertEquals("on", qStr);
	
	}
	
	
	
}
