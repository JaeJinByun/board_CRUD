<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.BoardDataBean"%>
<%@page import="board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="setting.jsp" %>
<link href="<%=project%>/style_board.css" rel="stylesheet" type="text/css">
<script src="<%=project%>/script.js"></script>
    
    
<h2><%=page_content%></h2>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum =  request.getParameter("pageNum");
	int number = Integer.parseInt(request.getParameter("number"));
%>
<%
	BoardDBBean dao = BoardDBBean.getInstance();
	BoardDataBean dto = dao.getArticle(num);
	if(!request.getRemoteAddr().equals(dto.getIp())){ // 다른사람이 읽었을때만 
		dao.addCount(num); //어떤 글의 조회수를 처리할꺼냐 
	}
%>

<table>
	<tr>
		<th>작성자 <%=str_num%></th>
		<td align="center"><%=number%></td>
		<th><%=str_readcount%></th>
		<td align="center"><%=dto.getReadcount() %></td>
	</tr>
	<tr>
		<th><%=str_writer %></th>
		<td align="center"><%=dto.getWriter() %></td>
		<th><%=str_reg_date %></th>
		<td align="center">
			<%
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			%>
			<%=sdf.format(dto.getReg_date())%>
		</td>
	</tr>
	<tr>
		<th><%=str_subject %></th>
		<td colspan="3"><%=dto.getSubject() %></td>
	</tr>
	<tr>
		<th><%=str_content %></th>
		<td colspan="3"><pre><%=dto.getContent() %></pre></td>
	</tr>
	<tr>
		<th colspan="4">
			<input class="inputbutton" type="button" value="<%=btn_modify %>" onclick="location='modifyForm.jsp?num=<%=dto.getNum()%>&pageNum=<%=pageNum%>'">
			<input class="inputbutton" type="button" value="<%=btn_delete %>" onclick="location='deleteForm.jsp?num=<%=dto.getNum()%>&pageNum=<%=pageNum%>'">
			<input class="inputbutton" type="button" value="<%=btn_reply %>" 
			onclick="location='writeForm.jsp?num=<%=dto.getNum()%>&ref=<%=dto.getRef()%>&re_step=<%=dto.getRe_step()%>&re_level=<%=dto.getRe_level()%>'">
			<input class="inputbutton" type="button" value="<%=btn_list %>" onclick="location='list.jsp?pageNum=<%=pageNum%>'">
		</th>
	</tr>
</table>


















