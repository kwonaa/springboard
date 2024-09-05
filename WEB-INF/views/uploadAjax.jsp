<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>uploadAjax</title>
	<!-- jQuery CDN -->
	<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
	<script>
		/* 원본 이미지 출력 **************************************************************************/
		function showImage(fileCallPath){
			$(".bigPictureWrapper").css("display","flex").show(); // 보이게
			$(".bigPicture").html("<img src='/display?fileName="+ encodeURI(fileCallPath)+"'>")
							.animate({width:'100%', height:'100%'}, 1000); // 1초동안
		}
		
		/* 첨부파일 목록 출력 *********************************************************************/
		function showUploadedFile(uploadResultArr) {
			var str = "";
			$(uploadResultArr).each(function(i, obj) {
				if(!obj.image) { // 이미지가 아닌 경우
					var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName); // 한글 파일명 깨짐 방지
					
			          str += "<li><a href='/download?fileName="+fileCallPath+"'>"
			        		  +"<img src='/resources/img/attach.png'>"+obj.fileName+"</a>"
			        		  +"<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>" // x버튼 추가
			        		  +"</li>";
				} else { // 이미지인 경우
					var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName); // 썸네일 경로
					// 역슬래시 '\\'를 슬래시 '/'로 바꿈
					var originPath = obj.uploadPath+ "\\"+obj.uuid +"_"+obj.fileName; // 원본 파일 경로
					originPath = originPath.replace(new RegExp(/\\/g),"/"); 
					// 이미지를 클릭하면 showImage 함수 호출
					str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">"
							+"<img src='display?fileName="+fileCallPath+"'></a>"
							+"<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>"
							+"<li>";
				}
			});
			var uploadResult = $(".uploadResult ul");
			uploadResult.append(str);
		}
		
		$(document).ready(function(){
			/* 파일 확장자. 파일 크기 체크 *************************************************************/
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz|js|jar)$"); // 업로드 금지 확장자
			var maxSize = 5242880; //5MB (5*1024*1024)
			function checkExtension(fileName, fileSize) {
				if(fileSize >= maxSize) {
					alert("파일 사이즈 초과");
					return false;
				}
				if(regex.test(fileName)) {
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				return true;
			}

			/* 업로드 버튼 이벤트 처리 *********************************************************************/
			var cloneObj = $(".uploadDiv").clone(); // 복제
			$("#uploadBtn").on("click", function(e) {
				// Form 태그 역할을 하는 FormData 객체 생성
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']"); // input 태그에서 name이 uploadFile인 것을 찾음 (검색해서 찾은 태그는 배열로 리턴되기 때문에 [] 사용)
				console.log(inputFile);
				// 업로드 파일 목록
				var files = inputFile[0].files;
				console.log(files);
				// forData에 파일 목록 추가
				for(var i = 0; i < files.length; i++) {
					// 파일 확장자. 파일 크기 체크
					if(!checkExtension(files[i].name, files[i].size)){
						return false;
					}
					formData.append("uploadFile", files[i]);
				}
				// Ajax 처리
				$.ajax({
					url : "/uploadAjaxAction", // 서버주소
					processData : false, // 파일 업로드 시 설정 (true가 기본값)
					contentType : false, // 파일 업로드 시 설정 (true가 기본값)
					data : formData, // 서버로 전송되는 데이터
					type : "post", // 전송방식
					success : function(result) { // 성공했을 때 호출되는 함수
						showUploadedFile(result);
						$(".uploadDiv").html(cloneObj.html()); // uploadDiv 초기화
					}
				});
			});
			
			/* 원본 이미지 클릭 이벤트 처리 ***************************************************/
			$(".bigPictureWrapper").on("click", function(e){
				// $(선택자).animate(객체, milliseconds, callback); callback 함수는 animation 종료 후 호출됨
				$(".bigPicture").animate({width:'0%', height: '0%'}, 1000, function(){
					$(".bigPictureWrapper").hide();
				});
			});
			
			
			/* x버튼 클릭 이벤트 처리. 파일 삭제 *********************************************/
			$(".uploadResult").on("click", "span", function(e) {
				var targetFile = $(this).data("file");
				var type = $(this).data("type"); // file or image
				console.log(targetFile);

				$.ajax({
					url: '/deleteFile', // 서버 주소
				    data: {fileName:targetFile, type:type}, // 서버로 전송되는 데이터
				    dataType:'text', // 서버에서 넘어오는 데이터의 형식
				    type: 'POST', // 전송 방식
					success: function(result){ // 성공했을 대 호출하는 함수. 서버에서 넘어오는 데이터는 result에 저장됨
				    	alert(result);
					}
				});

			});

		});
	</script>
	
	<style>
		.uploadResult {
			width: 100%;
			background-color: gray;
		}

		.uploadResult ul {
			display: flex;
			flex-flow: row;
			justify-content: center;
			align-items: center;
		}

		.uploadResult ul li {
			list-style: none; /* 기호 없애기 */
			padding: 10px;
		}

		.uploadResult ul li img {
			width: 100px;
		}
		
		.uploadResult ul li span {
			color: white;
			cursor: pointer;
		}
		
		.bigPictureWrapper {
			position: absolute;
			display: none; /* 숨기기 */
			justify-content: center;
			align-items: center;
			top:0%;
			width:100%;
			height:100%;
			background-color: gray; 
			z-index: 100; /* 가장 앞으로 */
		}
		
		.bigPicture {
			position: relative;
			display:flex;
			justify-content: center;
			align-items: center;
		}
	</style>
	
	</head>
	<body>
		<div class='bigPictureWrapper'>
			<div class='bigPicture'>
			</div>
		</div>
		
		<div class = "uploadDiv">
			<input type = 'file' name = 'uploadFile' multiple>
		</div>
		
		<div class='uploadResult'>
			<ul>
			
			</ul>
		</div>		
		
		<button id = 'uploadBtn'>Upload</button>
	</body>
</html>