<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	//현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//oracle db 접속
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "HR";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 전체 행의 수 구하는 sql
	PreparedStatement totalRowStmt = null;
	ResultSet totalRowRs = null;
	String totalRowSql = "select count(*) from employees";
	totalRowStmt = conn.prepareStatement(totalRowSql);
	totalRowRs = totalRowStmt.executeQuery();
	// 페이지 당 행의 수
	int rowPerPage = 10;
	// 시작 행 번호
	int beginRow = (currentPage-1) * rowPerPage + 1;
	// 마지막 행 번호
	int endRow = beginRow + rowPerPage - 1;
	// 전체 행의 수
	int totalRow = 0;
	if(totalRowRs.next()) {
		totalRow = totalRowRs.getInt(1);
	}
	// 마지막 행 번호 > 전체 행의 수 -> 마지막 행 번호 = 전체 행의 수
	if(endRow > totalRow) {
		endRow = totalRow;
	}
	// 마지막 페이지 번호
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
	// sql 전송
	PreparedStatement rankStmt = null;
	ResultSet rankRs = null;
	String rankSql = "select 번호, 직원ID, 이름, 급여, 급여순위 from (select rownum 번호, 직원ID, 이름, 급여, 급여순위 from (select employee_id 직원ID, last_name 이름, salary 급여, rank() over(order by salary desc) 급여순위 from employees)) where 번호 between ? and ?";
	rankStmt = conn.prepareStatement(rankSql);
	rankStmt.setInt(1,beginRow);
	rankStmt.setInt(2,endRow);
	// 위 sql 디버깅
	System.out.println(rankStmt + " <-- rankFunctionEmpList rankStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	rankRs = rankStmt.executeQuery();
	ArrayList<HashMap<String, Object>> windowList = new ArrayList<HashMap<String, Object>>();
	while(rankRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("직원ID", rankRs.getString("직원ID")); 
		m.put("이름", rankRs.getString("이름"));
		m.put("급여", rankRs.getString("급여"));
		m.put("급여순위", rankRs.getString("급여순위"));
		windowList.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<h1>rankFunctionEmpList</h1>
	<table border="1">
		<tr>
			<td>직원ID</td>
			<td>이름</td>
			<td>급여</td>
			<td>급여순위</td>
		</tr>
		<%
			for(HashMap<String, Object> m : windowList) {
		%>
				<tr>
					<td><%=m.get("직원ID")%></td>
					<td><%=m.get("이름")%></td>
					<td><%=m.get("급여")%></td>
					<td><%=m.get("급여순위")%></td>
				</tr>
		<%	
			}
		%>
	</table>
	<%
		// 페이징 수
		int pagePerPage = 10;
		// 최소 페이지
		int minPage = (currentPage-1) / pagePerPage * pagePerPage + 1;
		// 최대 페이지
		int maxPage = minPage + pagePerPage - 1;
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		// 이전 페이지
		if(minPage>1) {
	%>
			<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
	<%			
		}
		// 최대 10개의 페이지
		for(int i = minPage; i<=maxPage; i=i+1) {
			if(i == currentPage) {
	%>	
			<%=i%>
	<%			
			}else {
	%>	
				<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>
	<%				
			}
		}
		// 다음 페이지
		if(maxPage != lastPage) {
	%>
			<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
	<%	
		}
	%>
</body>
</html>