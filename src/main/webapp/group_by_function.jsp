<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%

	/*
	SELECT 
		null 부서ID, job_id 직무 ID,
		COUNT(*) FROM employees
		GROUP BY job_id
		UNION ALL
		SELECT department_id, null, COUNT(*)
		FROM employees
		GROUP BY department_id;
	*/
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	PreparedStatement groupingSetStmt = null;
	ResultSet groupingSetRs = null;
	String groupingSetSql  = "SELECT department_id, job_id, COUNT(*) FROM employees GROUP BY department_id, job_id";
	groupingSetStmt = conn.prepareStatement(groupingSetSql);
	System.out.println(groupingSetStmt + "group_by_function stmt");
	groupingSetRs = groupingSetStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> groupingSetList = new ArrayList<HashMap<String, Object>>();
		while(groupingSetRs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("부서ID",groupingSetRs.getInt("department_id"));
			m.put("직원ID",groupingSetRs.getString("job_id"));
			m.put("인원수",groupingSetRs.getInt("count(*)"));
			groupingSetList.add(m);
		}
		
	PreparedStatement rollupStmt = null;
	ResultSet rollupRs = null;
	String rollupSql = "SELECT department_id, job_id, count(*) FROM employees GROUP BY ROLLUP(department_id, job_id)";
	rollupStmt = conn.prepareStatement(rollupSql);
	System.out.println(rollupStmt + "<-- group_by_function rollupStmt");
	rollupRs = rollupStmt.executeQuery();
	ArrayList<HashMap<String, Object>> rollupList1 = new ArrayList<HashMap<String, Object>>();
		while(rollupRs.next()){
			HashMap<String, Object> r = new HashMap<String, Object>();
			r.put("부서ID",rollupRs.getInt("department_id"));
			r.put("직원ID",rollupRs.getString("job_id"));
			r.put("인원수",rollupRs.getInt("count(*)"));
			rollupList1.add(r);
		}
		
		PreparedStatement cubeStmt = null;
		ResultSet cubeSetRs = null;
		String cubeSql = "SELECT department_id, job_id, COUNT(*) FROM employees GROUP BY CUBE(department_id, job_id)";
		cubeStmt = conn.prepareStatement(cubeSql);
		cubeSetRs = cubeStmt.executeQuery();
		
		ArrayList<HashMap<String, Object>> cubeList2 = new ArrayList<HashMap<String, Object>>();
		while(cubeSetRs.next()){
			HashMap<String, Object> c = new HashMap<String, Object>();
			c.put("부서ID",cubeSetRs.getInt("department_id"));
			c.put("직원ID",cubeSetRs.getString("job_id"));
			c.put("인원수",cubeSetRs.getInt("count(*)"));
			cubeList2.add(c);
		}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>groupingSetList</h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>직원ID</td>
			<td>부서인원</td>
		</tr>
		<%
			for(HashMap<String, Object> m : groupingSetList) {
		%>
			<tr>
				<td><%=(Integer)(m.get("부서ID")) %></td>
				<td><%=(String)(m.get("직원ID")) %></td>
				<td><%=(Integer)(m.get("인원수")) %></td>

			</tr>
		<%
			}
		%>
	</table>
	<h1>rollupList</h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>직원ID</td>
			<td>부서인원</td>
		</tr>
		<%
			for(HashMap<String, Object> r : rollupList1) {
		%>
			<tr>
				<td><%=(Integer)(r.get("부서ID")) %></td>
				<td><%=(String)(r.get("직원ID")) %></td>
				<td><%=(Integer)(r.get("인원수")) %></td>

			</tr>
		<%
			}
		%>
	</table>
	<h1>cubeList</h1>
	<table border="1">
		<tr>
			<td>부서ID</td>
			<td>직원ID</td>
			<td>부서인원</td>
		</tr>
		<%
			for(HashMap<String, Object> c : cubeList2) {
		%>
			<tr>
				<td><%=(Integer)(c.get("부서ID")) %></td>
				<td><%=(String)(c.get("직원ID")) %></td>
				<td><%=(Integer)(c.get("인원수")) %></td>

			</tr>
		<%
			}
		%>
	</table>
</body>
</html>