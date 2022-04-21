//글 작성
var writerstr = "작성자를 입력하세요.";
var subjectstr = "글제목을 입력하세요.";
var contentstr = "글내용을 입력하세요.";
var passwdstr = "비밀번호를 입력하세요.";

var passwderror = "입력한 비밀번호가 다릅니다.\n다시확인하세요.";
var deleteerror = "글삭제에 실패했습니다.\n잠시후 다시시도하세요.";
var modifyerror = "글 수정에 실패했습니다.\n잠시후 다시 시도해주세요.";

function erroralert(msg){
	alert(msg);
	history.back(); //이전으로 돌려보내기
}


function modifycheck(){
	if( !modifyform.subject.value ) {
		alert(subjectstr);
		return false
	}else if( !modifyform.content.value ) {
		alert(contentstr);
		return false
	}else if( !modifyform.passwd.value ) {
		alert(passwdstr);
		return false
	}
	
}


//글작성화면에서 작성버튼 눌렀을때 null 값 유효성검사
function writecheck(){
	if(!writeForm.writer.value){
		alert(writerstr);
		writeForm.writer.focus();
		return false;
	}else if(!writeForm.subject.value){
		alert(subjectstr);
		writeForm.subject.focus();
		return false;
	}else if(!writeForm.content.value){
		alert(contentstr);
		writeForm.content.focus();
		return false;
	}else if(!writeForm.passwd.value){
		alert(passwdstr);
		writeForm.passwd.focus();
		return false;
	}else{
		
	}	
}