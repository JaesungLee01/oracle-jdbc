<%@page import="javax.naming.spi.DirStateFactory.Result"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	//oracle db 접속
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	// sql 전송
	PreparedStatement nvlStmt = null;
	ResultSet nvlRs = null;
	String nvlSql = "SELECT name, nvl(one,0) one FROM null_function";
	nvlStmt = conn.prepareStatement(nvlSql);
	// sql 디버깅
	System.out.println(nvlStmt + "<-- null_function nvlStmt");
	
	nvlRs = nvlStmt.executeQuery();
	ArrayList<HashMap<String, Object>> nvlList = new ArrayList<HashMap<String, Object>>();
		while(nvlRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("이름",nvlRs.getString("name"));
			m.put("일분기", nvlRs.getInt("one"));
			nvlList.add(m);
		}
		
	// 2번째 sql
	PreparedStatement nvl2Stmt = null;
	ResultSet nvl2Rs = null;
	String nvl2Sql = "SELECT name, nvl2(one, 'success', 'fail') one from null_function";
	nvl2Stmt = conn.prepareStatement(nvl2Sql);
	
	System.out.println(nvl2Stmt + "<-- null_function nvl2Stmt");
	
	nvl2Rs = nvl2Stmt.executeQuery();
	ArrayList<HashMap<String, Object>> nvlList2 = new ArrayList<HashMap<String, Object>>();
		while(nvl2Rs.next()) {
			HashMap<String, Object> n = new HashMap<String, Object>();
			n.put("이름",nvl2Rs.getString("name"));
			n.put("일분기",nvl2Rs.getString("one"));
			nvlList2.add(n);
		}
		
	// 3번쨰 sql
	PreparedStatement nullifStmt = null;
	ResultSet  nullifRs = null;
	String nullifSql = "select name, nullif(four, 100) four FROM null_function";
	nullifStmt = conn.prepareStatement(nullifSql);
	// sql 디버깅
	System.out.println(nullifStmt + "<-- null_fuction nullifStmt");
	nullifRs = nullifStmt.executeQuery();
	ArrayList<HashMap<String, Object>> nullifList = new ArrayList<HashMap<String, Object>>();
	while(nullifRs.next()) {
		HashMap<String, Object> f = new HashMap<String, Object>();
		f.put("이름",nullifRs.getString("name"));
		f.put("사분기",nullifRs.getInt("four"));
		nullifList.add(f);
	}
	
	// 4번쨰 sql
	PreparedStatement coalesceStmt = null;
	ResultSet  coalesceRs = null;
	String coalesceSql = "select name, coalesce(one, two, three, four) four FROM null_function";
	coalesceStmt = conn.prepareStatement(coalesceSql);
	// sql 디버깅
	System.out.println(nullifStmt + "<-- null_fuction nullifStmt");
	coalesceRs = coalesceStmt.executeQuery();
	ArrayList<HashMap<String, Object>> coalesceList = new ArrayList<HashMap<String, Object>>();
	while(coalesceRs.next()) {
		HashMap<String, Object> c = new HashMap<String, Object>();
		c.put("이름",coalesceRs.getString("name"));
		c.put("첫실적",coalesceRs.getInt("four"));
		coalesceList.add(c);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>nvl</h1>
	<table>
		<tr>
			<th>이름</th>
			<th>일분기</th>
		</tr>
		<%
			for(HashMap<String, Object> m : nvlList){
		%>
				<tr>
					<td><%=m.get("이름") %></td>
					<td><%=m.get("일분기") %></td>
				</tr>
		<%
			}
		%>
	</table>
	<h1>nvl2</h1>
	<table>
		<tr>
			<th>이름</th>
			<th>일분기</th>
		</tr>
		<%
			for(HashMap<String, Object> n : nvlList2){
		%>
				<tr>
					<td><%=n.get("이름") %></td>
					<td><%=n.get("일분기") %></td>
				</tr>
		<%
			}
		%>
	</table>
	<h1>nullif</h1>
	<table>
		<tr>
			<th>이름</th>
			<th>사분기</th>
		</tr>
		<%
			for(HashMap<String, Object> f : nullifList){
		%>
				<tr>
					<td><%=f.get("이름") %></td>
					<td><%=f.get("사분기") %></td>
				</tr>
		<%
			}
		%>
	</table>
	<h1>coalesce</h1>
	<table>
		<tr>
			<th>이름</th>
			<th>첫실적</th>
		</tr>
		<%
			for(HashMap<String, Object> c : coalesceList){
		%>
				<tr>
					<td><%=c.get("이름") %></td>
					<td><%=c.get("첫실적") %></td>
				</tr>
		<%
			}
		%>
	</table>
</body>
</html>