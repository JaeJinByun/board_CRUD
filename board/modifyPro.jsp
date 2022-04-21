<%@page import="board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="setting.jsp" %>
<script src="<%=project%>/script.js"></script>    
<%
	request.setCharacterEncoding("utf-8");
%>
<h2><%=page_modify %></h2>

 <jsp:useBean id="dto" class="board.BoardDataBean"/>
 	<jsp:setProperty name="dto" property="*"/>

<!-- 넘어오는 데이터 num email, subject, content, passwd -->
<%
	String pageNum = request.getParameter("pageNum");
%>
<%
	BoardDBBean dao = BoardDBBean.getInstance();
	int result = dao.modifyArticle(dto);
	
	if(result == 0){
		%>
		<script type="text/javascript">
			<!--
				erroralert(modifyerror);			
			//-->
		</script>
		<%
	}else{
		response.sendRedirect("list.jsp?pageNum="+pageNum);
		
	}
%>


