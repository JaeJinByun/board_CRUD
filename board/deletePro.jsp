<%@page import="board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="setting.jsp" %>
<script src="<%=project%>/script.js"></script>
<h2><%=page_delete %></h2>

<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	String passwd = request.getParameter("passwd");
	
%>

<%
	BoardDBBean dao = BoardDBBean.getInstance();
	int result = dao.check(num, passwd);
	if(result == 0){
		//비밀번호가 다르다
		%>
		<script type="text/javascript">
		<!--
			erroralert(passwderror);
		//-->
		</script>	
		<%
	}else{
		//비밀번호가 같다.
		result = dao.deleteArticle( num );
		if( result == 0 ){
			%>
			<script type="text/javascript">
				<!--
					alert(delteerror);
				//-->
			</script>	
			<meta http-equiv="refresh" content="0;	url=lust.jsp?pageNum=<%=pageNum%>">
			<%
		}else{
			response.sendRedirect("list.jsp?pageNum="+pageNum);			
		}
		
		
	 
	}	
%>









