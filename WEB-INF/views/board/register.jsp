<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


<%@include file="../includes/header.jsp"%>

<style>
	.uploadResult {
		width: 100%;
		height: 150px; /* height 설정해서 처음부터 보이게 함 */
		background-color: gray;
		overflow: auto;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li img {
		width: 100px;
	}
	
	.bigPictureWrapper {
	  position: absolute;
	  display: none;
	  justify-content: center;
	  align-items: center;
	  top:0%;
	  width:100%;
	  height:100%;
	  background-color: gray; 
	  z-index: 100;
	}
	
	.bigPicture {
	  position: relative;
	  display:flex;
	  justify-content: center;
	  align-items: center;
	}
</style>


<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board</h1>
	</div>
</div>


<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">등록</div>
			<div class="panel-body">

				<form role="form" action="/board/register" method="post" onsubmit="return validateForm(this);">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

					<div class="form-group">
						<label>제목</label> <input class="form-control" name="title">
					</div>

					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" rows="3" name="content"></textarea>
					</div>

					<div class="form-group">
						<label>작성자</label> <input class="form-control" name="writer" value='<sec:authentication property="principal.username"/>' readonly="readonly">
					</div>
					
					<!-- 첨부파일 ------------------------------------------------------------>
					<div class="row">
						<div class="col-lg-12">
							<div class="panel panel-default">
								<div class="panel-heading">첨부파일</div>
								<div class="panel-body">
									<div class="form-group uploadDiv">
										<input type="file" name="uploadFile" multiple>
									</div>
					
									<div class="uploadResult">
										파일을 여기에 끌어다 놓거나 파일 선택 버튼을 클릭하여 업로드하세요.
										<ul>
					
										</ul>
									</div>
									
								</div>
							</div>
						</div>
					</div>
					<div class = "pull-right">
						<button type="submit" class="btn btn-primary">등록</button>
						<button type="reset" class="btn btn-default">취소</button>
						<button type="button" onclick="location.href='/board/list';" class="btn btn-default">목록</button>
					</div>
				</form>


			</div>
		</div>
	</div>
</div>




<script>
	/* 필수 항목 입력 확인 ********************/
	function validateForm(form) {
		if(form.title.value == ""){
			alert("제목을 입력하세요.");
			form.title.focus();
			return false;
		}
		if(form.content.value == ""){
			alert("내용을 입력하세요.");
			form.content.focus();
			return false;
		}
		if(form.writer.value == ""){
			alert("작성자를 입력하세요.");
			form.writer.focus();
			return false;
		}
	}


	/* 파일 크기. 파일 확장자 체크 (함수는 document.ready 밖에 만들기) *******************************************/
	function checkExtension(fileName, fileSize){
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; //5MB
		
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
	  
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}
	/* 파일 크기. 파일 확장자 체크. end */
	
	/* 첨부파일 목록 미리보기 ************************************************************/
	function showUploadResult(uploadResultArr){
		// 첨부파일 목록이 없으면 중지
		if(!uploadResultArr || uploadResultArr.length == 0){
			return;
		}
		// 출력할 ul 태그 미리 찾아놓기
		var uploadUL = $(".uploadResult ul");
		
		var str ="";
		
		// 첨부파일 목록에서 하나씩 처리
		$(uploadResultArr).each(function(i, obj){	
			if(obj.image){ // 이미지 파일일 때
				// 썸네일 경로
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				str += "<li data-path='"+obj.uploadPath+"'";
				str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>"
				str += "	<div>";
				str += "		<span>"+ obj.fileName+"</span>";
				str += "		<button type='button' data-file='"+fileCallPath+"' ";
				str += " 			data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "		<img src='/display?fileName="+fileCallPath+"'>";
				str += "	</div>";
				str += "</li>";
			} else { // 일반 파일일 때
				// 파일 경로
				var fileCallPath =  encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);			      
			    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/"); // '\\'를 '/'로 변경
			      
			    str += "<li data-path='"+obj.uploadPath+"'";
				str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>"
				str += "	<div>";
				str += "		<span>"+ obj.fileName+"</span>";
				str += "		<button type='button' data-file='"+fileCallPath+"' ";
				str += " 			data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "		<img src='/resources/img/attach.png'></a>";
				str += "	</div>";
				str += "</li>";
			}
		});
		uploadUL.append(str); // ul 태그에 추가
	}
	/* 첨부파일 목록 미리보기 end */
	

	/* csrf토큰 처리 *****************************************************************/
	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";

	
	$(document).ready(function(e){
		
		/* 첨부파일을 선택했을 때 이벤트 처리 ***************************************/
		$("input[type='file']").change(function(e){
			// form 태그 역할을 하는 객체
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']"); // input type="file" 미리 찾아놓기
			var files = inputFile[0].files; // 첨부파일 목록
			
			for(var i = 0; i < files.length; i++){
				// 파일 확장자, 파일 사이즈가 안 맞으면 중지
				if(!checkExtension(files[i].name, files[i].size) ){
					return false;
				}
				// formData에 파일 추가
				formData.append("uploadFile", files[i]);
			}
   
			$.ajax({
				url: '/uploadAjaxAction', // 서버 주소
				processData: false, // 파일 업로드 시 설정 필요
				contentType: false, // 파일 업로드 시 설정 필요
			    beforeSend: function(xhr) {
			        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			    },				
				data: formData, // 서버로 전송되는 데이터
				type: 'post', // 전송방식
				dataType:'json', // 서버에서 넘어오는 데이터의 형식
				success: function(result){ // 성공하면 호출되는 함수. result에 서버에서 넘어온 데이터가 저장됨.
					console.log(result); 
					showUploadResult(result); // 첨부파일 목록 미리보기 출력
				}
			});
		}); 
		
		
		/* x버튼 클릭 이벤트 처리. 파일 삭제 **********************************************/
		// 부모인 .uploadResult에 click이벤트를 위임
		$(".uploadResult").on("click", "button", function(e){
			console.log("delete file");
			      
			var targetFile = $(this).data("file"); // data-file 속성값 읽어오기
			var type = $(this).data("type"); // data-type 속성값 읽어오기
			var targetLi = $(this).closest("li"); // 가장 가까운 부모태그 li 찾아오기
			    
			$.ajax({
				url: '/deleteFile', // 서버주소
				data: {fileName: targetFile, type:type}, // 서버로 전송되는 데이터
			    beforeSend: function(xhr) {
			        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			    },				
				dataType:'text', // 서버에서 넘어오는 데이터 형식
				type: 'POST', // 전송방식
				success: function(result){ // 성공했을 때 호출되는 함수. 서버에서 넘어온 데이터는 result에 저장됨
					alert(result);
					targetLi.remove(); // li 태그 삭제. 첨부파일 목록 삭제
				}
			});
		});		
			
		
	    /* 등록버튼 이벤트 처리 *******************************************************/
		var formObj = $("form[role='form']"); // form 태그 찾아놓기
		$("button[type='submit']").on("click", function(e){
			e.preventDefault(); // 전송 방지
			var str = "";
			// 첨부파일 목록에서 하나씩 처리
			$(".uploadResult ul li").each(function(i, obj){ // li 태그가 매개변수 obj로 들어감
				var jobj = $(obj);
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
			});
			// formObj(form태그)에 hidden 태그 추가. 전송
			console.log(str);
			formObj.append(str).submit();
		});
	    
		/* 파일 드래그 시 새창으로 열리는 것 방지 ******************************************/
		$(".uploadResult").on("dragenter dragover",function(event){ // 이벤트를 두개 써도 됨.(dragenter, dragover)
			// 기본 이벤트 취소. 새창이 열리는 것 방지
			event.preventDefault();
		});
		
		/* 파일 드롭 시 새창으로 열리는 것 방지. 파일 업로드 **********************************/
	    $(".uploadResult").on("drop",function(e){
			// 기본 이벤트 취소.새창이 열리는 것 방지
			event.preventDefault();
			
			//form태그 역할하는 객체
			var formData=new FormData();
			// drop했을 때 파일 목록 구하기
			var files=e.originalEvent.dataTransfer.files;

			for(var i=0;i<files.length;i++){
				//파일확장자,파일사이즈가 안맞으면 중지
				if(!checkExtension(files[i].name,files[i].size)){
					return false;
				}
				//formData에 파일추가
				formData.append("uploadFile",files[i]);
			}
			$.ajax({
				url:'/uploadAjaxAction', //서버주소
				processData: false, // 파일업로드시 설정필요
				contentType: false, // 파일업로드시 설정필요
			    beforeSend: function(xhr) {
			        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			    },				
				data:formData, // 서버로 전송되는 데이터
				type: "post",  //전송방식
				dataType: 'json', //서버에서 넘어오는 데이터의 형식
				success:function(result){ //성공하면 호출되는 함수. result에 서버에서 넘어온 데이터가 저장됨.
					showUploadResult(result); //첨부파일목록 미리보기 출력
				}
			});
	    });
	    	
	});
</script>

<%@include file="../includes/footer.jsp"%>