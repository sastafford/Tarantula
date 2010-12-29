package com.marklogic.tarantula.test;

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.XdmValue;
import com.marklogic.xcc.ResultSequence;

public class PageUtilTest extends XQueryTestCase {

	private String modulePath = "/util/url.xqy";
	private String moduleNamespace = "http://www.marklogic.com/tarantula/util";
	
	private String absURL = "http://www.example.com/a/b/c";

	public void testRelToAbs1() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("../lena.jpg")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.example.com/a/lena.jpg");					
	}
	
	public void testRelToAbs2() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("./lena.jpg")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.example.com/a/b/lena.jpg");					
	}
	
	public void testRelToAbs3() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("../../lena.jpg")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.example.com/lena.jpg");					
	}
	
	public void testRelToAbs4() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("/lena.jpg")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.example.com/lena.jpg");					
	}
	
	public void testRelToAbs5() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("../x/lena.jpg")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.example.com/a/x/lena.jpg");					
	}
	
	public void testRelToAbs6() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("../../x/y/lena.jpg")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.example.com/x/y/lena.jpg");					
	}
	
	public void testRelToAbs7() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("?w=90&h=60&f=lena.jpg")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.example.com/a/b/c?w=90&h=60&f=lena.jpg");					
	}
	
	public void testRelToAbs8() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("#lena")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.example.com/a/b/c#lena");					
	}
	
	public void testRelToAbs9() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(absURL),
				ValueFactory.newXSString("http://www.google.com")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals(s, "http://www.google.com");					
	}
	
	public void testRelToAbs10() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString("http://en.wikipedia.org/wiki/Star_Wars"),
				ValueFactory.newXSString("/wiki/File:Star_Wars_Logo.svg")};
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "rel-to-abs", params);
		String s = (String)rs.itemAt(0).asString();
		assertEquals("http://en.wikipedia.org/wiki/File:Star_Wars_Logo.svg", s);					
	}
	
	
}
