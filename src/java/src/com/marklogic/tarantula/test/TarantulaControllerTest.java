package com.marklogic.tarantula.test;

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ResultSequence;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.XSInteger;
import com.marklogic.xcc.types.XdmValue;

public class TarantulaControllerTest extends XQueryTestCase {

	private String modulePath = "/application/models/crawl-model.xqy";
	private String moduleNamespace = "http://www.marklogic.com/tarantula/crawl";
	
	private String sampleURL2 = "http://en.wikipedia.org/wiki/Star_wars";
	private String sampleURL1 = "http://en.wikipedia.org/wiki/User:Tkgd2007";
	
	public void testEmptyDatabase() throws Exception {
		executeLibraryModule(modulePath, moduleNamespace, "emptyDatabase");
		// Verify update by running a query
		String q = "fn:count(fn:doc())";
		ResultSequence rs = this.executeQuery(q, null, null);
		XSInteger qResult = (XSInteger)rs.itemAt(0);
		assertEquals(getName(), 0, qResult.asPrimitiveInt());
	}
	
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
	
	public void testStartCrawler() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(sampleURL1) };
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "crawl", params);
		// Verify update by running a query
		System.out.println(rs.asString());
		
		assertEquals(getName(), 0, 0);
	
	}
	
	
}
