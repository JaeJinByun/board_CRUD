<%@page import="board.BoardDBBean"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="setting.jsp" %>
<script src="<%=project%>/script.js"></script>

<h2><%=page_write %></h2>

<%
	request.setCharacterEncoding("utf-8");
%>
<%//------------------DTO 데이터 세팅 --------------------------------------------------%>
<jsp:useBean id="dto" class="board.BoardDataBean"/>
	<jsp:setProperty name="dto" property="*"/>
	<!-- post 값으로 넘어온 데이터들 : writer email subject content passwd 가 입력한값으로 넘어온다 -->
	<!-- hidden 으로 넘어온 데이터들 : num ref re_step re_level  -->
	
<%	//<reg_date 와 ip 는 메소드로 처리>
	dto.setReg_date(new Timestamp(System.currentTimeMillis()));
	dto.setIp( request.getRemoteAddr() );
//------------------------------------------------------------------------------------
%>


<%	//DAO를 통해 함수처리및 결과값 받기--------------------------------------------------------
	BoardDBBean dao = BoardDBBean.getInstance();
	int result = dao.insertArticle(dto);
	if( result == 0 ){
		%>	
		<script type="text/javascript">
		<!--
			erroralert(inserterror);
		//-->
		</script>
		<%
	}else{
		response.sendRedirect("list.jsp");
	}
	//---------------------------------------------------------------------------------
%>

























