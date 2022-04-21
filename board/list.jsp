<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.BoardDataBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="setting.jsp" %>
<link href="<%=project%>/style_board.css" rel="stylesheet" type="text/css">
<script src="<%=project%>/script.js"></script>

<!-- 메인 게시판 화면 -->
<%
	int count = 0; 
	int size = 5;	//한 페이지에 size개씩
	int start = 0;
	int end = 0;
	String pageNum = null;	//페이지넘버
	int currentPage = 1;	//현재 페이지
	int pageSize = 5;		// [1] [2] [3] [4] [5]
%>
<%
	BoardDBBean dao = BoardDBBean.getInstance();
	count = dao.getCount();
%>
<%
	pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	currentPage = Integer.parseInt( pageNum );
	start = (currentPage - 1) * size + 1;		// ex) 4번 페이지는 31~40의 번호를 가진 게시글이 나와야함
	end = start + size -1;						// 
	
	if( end > count ) end = count;
	int number = count - (currentPage-1)*size; 	// ex) 50 - (5-1)*10  = 나온값부터 보겠다.  
	
	int startPage = (currentPage/pageSize)*pageSize  + 1; //ex 2 페이지 보겠다  
	if(startPage%pageSize == 0) startPage -= pageSize;
	
	int endPage = startPage + pageSize -1;
	int pageCount = ( count/size ) + (count % size > 0 ? 1 : 0);
	if(endPage > pageCount) endPage = pageCount;
%>

<!-- 	페이지 이름		 	글 목록	    	전체글개수 	-->
<h2><%=page_list%> (<%=str_count%> : <%=count %>)</h2>
  
<table>
	<tr>
		<td colspan="6" align="right">
			<a href="writeForm.jsp">글쓰기&nbsp;&nbsp;&nbsp;</a>
		</td>
	</tr>
	<tr>
		<th style="width:7%;"> 글번호 </th>
		<th style="width:40%;"> 제목 </th>
		<th style="width:15%;"> 작성자 </th>
		<th style="width:15%;"> 작성일 </th>
		<th style="width:8%;"> 조회수 </th>
		<th>  IP </th>
	</tr>
	<%	//글이 없는경우
		if(count == 0){
			%>
			<tr>
				<td colspan="6" align="center">
					<%=msg_list_x %>
				</td>
			</tr>
			<%
		}else{
		//글이 있는경우
		
			ArrayList<BoardDataBean> dtos = dao.getArticles(start,end);
			for(BoardDataBean dto : dtos){
				%>
				<tr>
					<td align="center">	<!-- 글번호 -->
						<%=number--%>
					</td>	
					<td>
						<%
							int level = dto.getRe_level(); //답글인지 확인
							int wid = (level - 1)*10;
							if(level > 1){	//재답글인경우 재답글의 개수만큼 이미지를 넓혀서 출력 => 들여쓰기 효과
								%>
								<img src="/JSP/images/level.gif" border="0" width="<%=wid%>"> 
								<%
							}
							if(level > 0){
								%>
								<img src="/JSP/images/re.gif" border="0" width="20">
								<%
							}
						%>
						<%
							if(dto.getReadcount() == -1){
								//삭제된 경우
								%>
								<%=dto.getSubject() %>
								<%
							}else {
								%>
								<a href="content.jsp?num=<%=dto.getNum()%>&pageNum=<%=pageNum%>&number=<%=number+1%>">
									<%=dto.getSubject() %>
								</a>
								<%
							}
						
						%>
							
					</td>
					<td align="center">
						<%=dto.getWriter() %>
					</td>
					<td>
						<%
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm"); //작성시간 
						%>
						<%=sdf.format(dto.getReg_date()) %>
					</td>
					<td align="center">
						<%
						if(dto.getReadcount() == -1){
							%>
							0
							<%
						}else {
							%>
							<%=dto.getReadcount() %>
							<%
						}
						
						
						%>
					</td>
					<td align="center">
						<%=dto.getIp() %>
					</td>
				</tr>
				
				<%
			}
		}
	
	  
	%> 


</table>
<%
	if(count > 0){
		if(startPage > pageSize){
			%>
			<a href="list.jsp?PageNum=<%=startPage-pageSize%>">[◀]</a>
			<%			
		}
		for(int i=startPage; i<=endPage; i++){
			if( i == currentPage){
				%>
				<b>[<%=i%>]</b>
				<%				
			}else {
				%>
				<a href="list.jsp?pageNum=<%=i%>">[<%=i%>]</a>
				<%
			}
		}
		if(endPage < pageCount){
			%>
			<a href="list.jsp?pageNum=<%=startPage+pageSize%>">[▶]
			</a>
			<%			
		}
	}
%>

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    