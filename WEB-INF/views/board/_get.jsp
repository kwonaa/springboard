<!-- 백업본 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>


<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">상세보기</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">조회</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<div class="form-group">
					<label>글번호</label> 
					<input class="form-control" name='bno' value='<c:out value="${board.bno }"/>' readonly>
				</div>

				<div class="form-group">
					<label>제목</label> 
					<input class="form-control" name='title' value='<c:out value="${board.title }"/>' readonly>
				</div>

				<div class="form-group">
					<label>내용</label>
					<textarea class="form-control" rows="3" name='content' readonly><c:out value="${board.content}" /></textarea>
				</div>

				<div class="form-group">
					<label>작성자</label> 
					<input class="form-control" name='writer' value='<c:out value="${board.writer }"/>' readonly>
				</div>

				<button data-oper='modify' class="btn btn-default">
					<a href="/board/modify?bno=<c:out value='${board.bno}'/>">수정/삭제</a>
				</button>
				<button data-oper='list' class="btn btn-info">
					<a href="/board/list">목록</a>
				</button>



				<!-- 히든 태그에 값을 넣어서 전송하기 위한 폼 -->
				<form id='operForm' action="/boad/modify" method="get">
					<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
					<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
					<input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
					<input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>  
				</form>

			</div>
			<!--  end panel-body -->

		</div>
		<!--  end panel-body -->
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->

<!-- 댓글 목록 ----------------------------------------------------------->
<div class='row'>
	<div class="col-lg-12">
		<!-- /.panel -->
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> 댓글
				<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>댓글작성</button>
			</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<!-- 댓글목록 출력 ul태그 -->
				<ul class="chat">
				</ul>
				<!-- ./ end ul -->
			</div>
			<!-- /.panel .chat-panel -->

			<div class="panel-footer"></div>


		</div>
	</div>
	<!-- ./ end row -->
</div>




<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">댓글 작성</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>내용</label> <input class="form-control" name='reply' value='New Reply!!!!'>
				</div>
				<div class="form-group">
					<label>작성자</label> <input class="form-control" name='replyer' value='replyer'>
				</div>
				<div class="form-group">
					<label>댓글 작성일</label> <input class="form-control" name='replyDate' value='2018-01-01 13:13'>
				</div>

			</div>
			<div class="modal-footer">
				<button id='modalModBtn' type="button" class="btn btn-warning">수정</button>
				<button id='modalRemoveBtn' type="button" class="btn btn-danger">삭제</button>
				<button id='modalRegisterBtn' type="button" class="btn btn-primary">작성</button>
				<button id='modalCloseBtn' type="button" class="btn btn-default">닫기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->





<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
	$(document).ready(function() {
		/* 전역변수 & 미리 태그 찾아놓기 ****************************************************************************************/
	    var bnoValue = '<c:out value="${board.bno}"/>'; // 부모글번호
		var replyUL = $(".chat"); // 댓글 목록이 출력되는 ul 태그 찾아놓기
		var operForm = $("#operForm"); // 게시글 수정/삭제버튼
		var modal = $(".modal"); // 모달창
		var modalInputReply = modal.find("input[name='reply']"); // 댓글내용
		var modalInputReplyer = modal.find("input[name='replyer']"); // 댓글작성자
		var modalInputReplyDate = modal.find("input[name='replyDate']"); // 댓글작성일
		var modalModBtn = $("#modalModBtn"); // 댓글수정버튼
		var modalRemoveBtn = $("#modalRemoveBtn"); // 댓글삭제버튼
		var modalRegisterBtn = $("#modalRegisterBtn"); // 댓글등록버튼
		
		
	    /* 댓글 목록 *******************************************************************************************************/
	    showList(1); // 첫페이지 출력
	   
	    function showList(page){
	    	// replyService.getList(데이터, success 시 호출 함수);
			replyService.getList({bno:bnoValue, page:page||1 }, function(replyCnt, list) {
		        // 댓글 등록 시 마지막 페이지로 이동. -1(eof를 의미)은 마지막 페이지로 가기 위한 약속
		        if(page == -1){
			        pageNum = Math.ceil(replyCnt/10.0); // 전체 페이지 수 == 마지막 페이지
			        showList(pageNum); // 재귀호출
			        return;
	        	}
		        
	         	var str="";
	         	
	         	// 댓글이 없으면 종료
	         	if(list == null || list.length == 0){
	         		replyUL.empty(); // 댓글 목록 초기화
	         		replyPageFooter.empty(); // 댓글 페이징 초기화
	            	return;
	         	}
	         
				for (var i = 0, len = list.length || 0; i < len; i++) {
					str +="<li class='left clearfix' data-rno='"+list[i].rno+"' style='cursor:pointer;'>";
					str +="  <div>"; 
					str +="		<div class='header'>"; 
					/* str +="			<strong class='primary-font'>["+list[i].rno+"] "+list[i].replyer+"</strong>";  */
					str +="			<strong class='primary-font'>"+list[i].replyer+"</strong>"; 
					str +="			<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small>";
					str +="		</div>";
					str +="		<p>"+list[i].reply+"</p>";
					str +="  </div>";
					str +="</li>";
				}
				
				replyUL.html(str); // ul 태그에 li 태그 출력
				
				showReplyPage(replyCnt); // 페이지번호 출력
			});//end function
		}//end showList
	     
	    
	    /* 댓글 페이징 처리 ***************************************************************************************************/
		var pageNum = 1; // 기본 1페이지
	    var replyPageFooter = $(".panel-footer"); // 페이지 번호가 출력될 태그
	    
	    function showReplyPage(replyCnt){
			var endNum = Math.ceil(pageNum / 10.0) * 10; // 계산으로 구한 현재 구간의 마지막 페이지
			var startNum = endNum - 9; // 첫번재 페이지
      		var prev = startNum != 1; // prev 존재 유무. startNum가 1이 아니면 true
			var next = false; // next 존재 유무. false가 기본값
			
			// 실제 마지막 페이지가 계산으로 구한 마지막페이지보다 작으면 마지막 페이지 변경
			if(endNum * 10 >= replyCnt){
				endNum = Math.ceil(replyCnt/10.0);
			}
	      	
			// 실제 마지막 페이지가 계산으로 구한 마지막 페이지보다 크면 next가 true
			if(endNum * 10 < replyCnt){
				next = true;
			}

			// ul태그
			var str = "<ul class='pagination pull-right'>";

			// li 태그
			if(prev){
				str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
			}

			for(var i = startNum ; i <= endNum; i++){
				var active = pageNum == i? "active":""; // 현재 페이지와 페이지번호가 같으면 active 적용 
				str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}

			if(next){
				str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
			}

			str += "</ul></div>";
			replyPageFooter.html(str); // 페이지 번호 출력
		}	     
	    
	    
	    /* 댓글 페이지 번호 이벤트 처리 *****************************************************************************************/
	    // delegate 위임. 중요★
	    // 부모인 replPageFooter에게 이벤트를 위임
	    replyPageFooter.on("click","li a", function(e){
			e.preventDefault(); // 링크를 클릭했을 때 다음 페이지로 넘어가는 것 방지
			console.log("page click");
	        var targetPageNum = $(this).attr("href"); // 이벤트가 발생한 a태그의 href 속성값 구하기
	        pageNum = targetPageNum;
	        showList(pageNum); // 해당 페이지 댓글목록 출력
	      });       

		
		/* 수정, 삭제 버튼 이벤트 처리 *****************************************************************************************/
		/* var operForm = $("#operForm"); // 게시글 수정/삭제버튼 */
		$("button[data-oper='modify']").on("click", function(e) {
			operForm.attr("action", "/board/modify").submit(); // 수정화면으로 전송
		});

		$("button[data-oper='list']").on("click", function(e) {
			operForm.find("#bno").remove(); //hidden 태그 bno 삭제. 목록에서는 bno가 필요없음
			operForm.attr("action", "/board/list").submit(); // 목록화면으로 전송
		});
		
		
		
		/* 댓글 등록 *****************************************************************************************************/
	    /* var modal = $(".modal"); // 모달창
	    var modalInputReply = modal.find("input[name='reply']"); // 댓글내용
	    var modalInputReplyer = modal.find("input[name='replyer']"); // 댓글작성자
	    var modalInputReplyDate = modal.find("input[name='replyDate']"); // 댓글작성일
	    var modalModBtn = $("#modalModBtn"); // 댓글수정버튼
	    var modalRemoveBtn = $("#modalRemoveBtn"); // 댓글삭제버튼
	    var modalRegisterBtn = $("#modalRegisterBtn"); // 댓글등록버튼 */
	    
	    
	    
	    // 모달 떴을 때 '닫기' 버튼 누르면 모달 숨기기
		$("#modalCloseBtn").on("click", function(e){
			modal.modal('hide');
	    });
	    
	    // '댓글작성' 버튼 클릭 시 모달창 띄우기
		$("#addReplyBtn").on("click", function(e){
			modal.find("input").val(""); // input 태그 값 초기화
			modalInputReplyer.removeAttr("readonly"); // 댓글작성자 readonly 제거
			modalInputReplyDate.closest("div").hide(); // 댓글 등록일 안 보이게
			modal.find("button[id !='modalCloseBtn']").hide(); // 모달창 '닫기'버튼을 제외한 나머지 버튼 모두 안 보이게
			modalRegisterBtn.show(); // 모달창 '작성' 버튼 다시 보이게
			$(".modal").modal("show"); // 모달창 보이게 
		});
	    
	    // 댓글등록
		modalRegisterBtn.on("click",function(e){
			var reply = {
				reply: modalInputReply.val(),
				replyer:modalInputReplyer.val(),
				bno:bnoValue
			};
	        replyService.add(reply, function(result){
				alert(result);
				modal.find("input").val("");
				modal.modal("hide");
				
				showList(-1); // page 번호 -1은 마지막 페이지로 이동하기 위해 사용.
			});
		});
	    
	    
		/* 댓글 상세보기 모달창. 수정/삭제  *******************************************************************************************************/
		// 부모인 ".chat"을 찾아서 이벤트 처리를 위임(delegate)
		$(".chat").on("click", "li", function(e){
			var rno = $(this).data("rno"); // 클릭이벤트가 발생한 li태그를 $(this)로 찾아서 date-rno 속성값 읽기
			replyService.get(rno, function(reply){
		        modalInputReply.val(reply.reply); // 댓글
		        modalInputReplyer.val(reply.replyer).attr("readonly","readonly"); // 댓글작성자
		        modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly"); // 댓글 작성일
		        modal.data("rno", reply.rno); // 댓글번호
		        
		        modal.find("button[id !='modalCloseBtn']").hide(); // close 버튼 이외의 버튼은 안 보이게
		        modalModBtn.show(); // 수정 버튼 보이게
		        modalRemoveBtn.show(); // 삭제 버튼 보이게
		        
		        $(".modal").modal("show");
			});
		});
		

		// 모달창 수정 버튼 이벤트 처리
	    modalModBtn.on("click", function(e){
			var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
			replyService.update(reply, function(result){
				alert(result); // 알림창 띄우기
				modal.modal("hide"); // 모달창 닫기
				showList(pageNum); // 목록 갱신
			}); 
	   	});

		// 모달창 삭제 버튼 이벤트 처리
		modalRemoveBtn.on("click", function (e){
			var rno = modal.data("rno"); // 댓글번호
			replyService.remove(rno, function(result){
				alert(result); // 알림창 띄우기
				modal.modal("hide"); // 모달창 닫기
				showList(pageNum); // 목록갱신
			});  
     	});
	    
	});
</script>

<%@include file="../includes/footer.jsp"%>
