<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="setting.jsp" %>
<link href="<%=project%>/style_board.css" rel="stylesheet" type="text/css">
<script src="<%=project%>/script.js"></script>

<!-- 글쓰기 페이지 -->
<h2><%=page_write%></h2>

<% 
	//제목글인 경우 (일반글)
	int num = 0;		//제목글 / 답변글
	int ref = 1;		//그룹화 아이디
	int re_step = 0;	//글순서
	int re_level = 0;	//글레벨
	
	//답변글인 경우
	if(request.getParameter("num") != null){
		num = Integer.parseInt(request.getParameter("num"));
		ref = Integer.parseInt(request.getParameter("ref"));
		re_step = Integer.parseInt(request.getParameter("re_step"));
		re_level = Integer.parseInt(request.getParameter("re_level"));
	}
	
%>
<form name="writeForm" method="post" action="writePro.jsp" onsubmit="return writecheck()">
	<input type="hidden" name="num" value="<%=num %>">
	<input type="hidden" name="ref" value="<%=ref %>">
	<input type="hidden" name="re_step" value="<%=re_step %>">
	<input type="hidden" name="re_level" value="<%=re_level %>">
	<table>
		<tr>
			<th colspan="2" style="text-align:right">
				<a href="list.jsp"><%=str_list %>&nbsp;&nbsp;&nbsp;</a> <!-- 글목록 -->
			</th>
		</tr>
		<tr>
			<th><%=str_writer %></th>
			<td><input class="input" type="text" name="writer" maxlength="30" autofocus></td>
		</tr>
		<tr>
			<th><%=str_email %> </th>
			<td><input class="input" type="text" name="email" maxlength="40"></td>
		</tr>
		<tr>
			<th><%=str_subject %></th>
			<td><input class="input" type="text" name="subject" maxlength="100"></td>
		</tr>
		<tr>
			<th><%=str_content %></th>
			<td><textarea name="content" rows="10" cols="40"></textarea></td>
		</tr>
		<tr>
			<th><%=str_passwd %></th>
			<td><input class="input" type="password" name="passwd" maxlength="20"></td>
		</tr>
		<tr>
			<th colspan="2">
				<input class="inputbutton" type="submit" value="<%=btn_write %>"> <!-- 글작성 버튼 -->
				<input class="inputbutton" type="reset" value="<%=btn_cancel %>"> <!-- 취소버튼 -->
				<input class="inputbutton" type="button" value="<%=btn_list %>" onclick="location='list.jsp'">  <!-- 메인메뉴로 돌아가기 버튼 -->
			</th>
		</tr>
	</table>
</form>



















