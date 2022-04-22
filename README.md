# board_CRUD
<h3>CRUD게시판<h3>
  
#
<p align="center">
<img src="https://user-images.githubusercontent.com/103496262/164418272-2f3c908a-87fa-4b1d-80cd-8ad5ed86416c.gif">
</p>


<p align="center">
<img src="https://user-images.githubusercontent.com/103496262/164418280-177a6d34-3a49-4d39-ac4f-688dabdc7433.gif">
</p>


<p align="center">
<img src="https://user-images.githubusercontent.com/103496262/164418286-4c43b406-1f1c-4653-8995-c9a234bedeb6.gif">
</p>

<div align=center> 
   	<img src="https://img.shields.io/badge/java-007396?style=for-the-badge&logo=java&logoColor=white"> 
   	<img src="https://img.shields.io/badge/html5-E34F26?style=for-the-badge&logo=html5&logoColor=white"> 
	<img src="https://img.shields.io/badge/css-1572B6?style=for-the-badge&logo=css3&logoColor=white"> 
 	<img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"> 
	<img src="https://img.shields.io/badge/oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white">
	<img src="https://img.shields.io/badge/eclipse-IDE-F7DF1E?style=for-the-badge&logo=eclipse&logoColor=black">
	
</div>
<br><br>

<div align=center> 
	게시판 또한 연습용이므로, 중요도가 높은 jsp 와 db 사이의 데이터통신과 데이터처리 로직에 초점을 맞춘다.
	기본적으로 웹브라우저에서 보이는 화면, 그 화면을 제어하는 컨트롤러,<br>
	데이터베이스와 연결하는 비즈니스, 그리고 정보가 들어갈 데이터베이스가 있어야 한다.
</div>

#
**1.) 화면(View)**

	1.1)화면의 종류는 6개다.

	list.jsp       : 게시판 화면
	content.jsp    : 게시글 내용화면
	modifyForm.jsp : 글수정하기 위한 비밀번호 재확인 화면
	modifyView.jsp : 작성글 수정 화면
	deleteForm.jsp : 아이디 삭제전 비밀번호 재확인 화면  
	writeForm.jsp  : 글 작성 화면
	 

**2.) 컨트롤러(Controller)**

	2.1) 컨트롤러의 종류는 5개다.
	
	deletePro.jsp	: 글 삭제 프로세스
	modifyPro.jsp	: 글 수정 프로세스
	writePro.jsp	: 글 작성 프로세스
	

**3.) 모델(Model)**

	3.1) 모델은 DB와 소통하는 DAO, DTO다.
	(board/src/main/java/login)
	BoardDBBean.java   : DB의 트랜잭션을 실행키시는 파일[DAO]
	BoardDataBean.java : Data 이동을 위한 바구니역활[DTO]






#
**페이지 이동 흐름도** 
```

`-- JSP/board/src/main/webapp
	`-- board
	    `-- list.jsp 			 [게시판 화면]
	        |-- content.jsp			 [게시글 클릭시]
	        |   `-- action      		 [글수정버튼, 글삭제버튼, 답글버튼, 목록버튼]
	        |      |-- modifyForm.jsp	 [비밀번호확인창]
	        |      |   `-- modifyView.java	 [글수정화면]
		    	|	     |	   `-- modifyPro.java <--->  DB [수정처리]        
		      |      |-- deleteForm.jsp  [비밀번호 확인창]
			    |	     |   `-- deletePro.jsp <------> DB [삭제처리]
	        |      |-- writeForm.jsp  	 [답글작성화면]
	        |          `-- writePro.jsp  <------> DB [답글처리]
	        |              
	        |-- writeForm.jsp 		 [글작성 클릭시]
	        |   `-- writePro.jsp <----> DB 	 [글작성처리] 
	        |     
		    	| 
		    	|-- setting.jsp 	[전역변수 저장소]
	        |-- style_board.css		[view style]
	        |-- script.js			[event method]
	
```
	
# 사용 Library version
	
-   **IDE**  : Eclipse Java EE 4.22.2 (Oxygen.2 Release)
-   **JDK**: Java 1.8
-   **Tomcat**  : Tomcat 9.0.85
-   **Gradle**  : Gradle 3.1.5 (Embedded in Eclipse)
-   **DBMS**  : Oracle 5.1.35
