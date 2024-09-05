<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<a href="/board/list">목록</a>
				<a href="/board/register" class="btn btn-primary btn-xs pull-right">글쓰기</a>
			</div>
			<!-- /.panel-heading -->
			
			<div class="panel-body">
				<table width="100%"
					class="table table-striped table-bordered table-hover">
					<!-- <table width="100%" class="table table-striped table-bordered table-hover"  id="dataTables-example"> -->
					<thead>
						<tr>
							<th>#번호</th>
							<th width="50%">제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>수정일</th>
						</tr>
					</thead>

					<c:forEach items="${list}" var="board">
						<tr>
							<td>
								<c:out value="${board.bno}" />
							</td>
							<%-- <td><a href='/board/get?bno=<c:out value="${board.bno}"/>'><c:out value="${board.title}"/></a></td> --%>

							<%-- <td>
								<a class='move' href='<c:out value="${board.bno}"/>'>
									<c:out value="${board.title}" /> <b>[  <c:out value="${board.replyCnt}" />  ]</b>
								</a>
							</td> --%>
							<td>
								<a class='move' href='<c:out value="${board.bno}"/>'>
									<c:out value="${board.title}" /> 
									<c:if test="${board.replyCnt != 0}"> <!-- 댓글 개수가 0이 아닐 경우에만 댓글 수 출력 -->
										<b>[ <c:out value="${board.replyCnt}" /> ]</b>
									</c:if>
								</a>
							</td>
							<td>
								<c:out value="${board.writer}" />
							</td>
							<td>
								<fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}" />
							</td>
							<td>
								<fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}" />
							</td>
						</tr>
					</c:forEach>
				</table>
				<!-- /.table-responsive -->

                <!-- 검색폼 ----------------------------------------------------------->
                <form id="searchForm" action="/board/list" method="get" class="input-group mb-3" style="display: flex">
                	<select name="type" class="form-control" style="width: 15%;">
                		<option value="" <c:out value="${pageMaker.cri.type==null?'selected':''}"/>>--</option>
                     		<option value="T" <c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
                     		<option value="C" <c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
                     		<option value="W" <c:out value="${pageMaker.cri.type eq 'W'?'selected':''}"/>>작성자</option>
                     		<option value="TC" <c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목 or 내용</option>
                   	</select>
                	<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword }"/>' class="form-control" style="width: 50%;">
                	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                	<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                	<button class="btn btn-primary btn-md">검색</button>
                </form>
                <!-- 검색폼.end -->



                  <!-- page번호 출력 ------------------------------------------------------>
                  <div class="pull-right">
                  	<ul class="pagination">
                  		<c:if test="${pageMaker.prev}">
                  		<li class="paginate_button previous">
                  			<a href="${pageMaker.startPage-1}">Previous</a>
                  		</li>
                  		</c:if>
                  		
                  		<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                  		<li class="paginate_button ${pageMaker.cri.pageNum==num? 'active' : ''  }">
                  			<a href="${num}">${num}</a>
                  		</li>                            		
                  		</c:forEach>         
                  		
                  		<c:if test="${pageMaker.next}">
                  		<li class="paginate_button next">
                  			<a href="${pageMaker.endPage+1}">Next</a>
                  		</li>
                  		</c:if>
                  	</ul>
                  </div>
                  <!-- page번호출력.end -->
        
                  <!-- page번호 이벤트 처리시 필요한 form -------------------------------------------->
                  <form id="actionForm" action="/board/list" method="get">
                  	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                  	<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                  	<input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/>'>
                  	<input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
                  </form>
                  <!-- page번호 이벤트 처리시 필요한 form.end -->



			<!-- 모달 --------------------------------------------------------------------------------->
			<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
							<h4 class="modal-title" id="myModalLabel">알림</h4>
						</div>
						<div class="modal-body">처리가 완료되었습니다.</div>
						<div class="modal-footer">
							<button type="button" class="btn btn btn-primary" data-dismiss="modal">닫기</button>
						</div>
					</div>
					<!-- /.modal-content -->
				</div>
				<!-- /.modal-dialog -->
			</div>
			<!-- 모달 end -->

		</div>
		<!-- /.panel-body -->
	</div>
	<!-- /.panel -->
</div>
<!-- /.col-lg-12 -->


<script>
	$(document).ready(function() {
		/* 등록된 글번호 *********************/
		var result = '<c:out value="${result}"/>';
		checkModal(result);
		
		/* 모달창 띄우기 *********************/
		function checkModal(result) {
			if (result === '') {
				return;
			}
			if (parseInt(result) > 0) {
				$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
			}
			$("#myModal").modal("show");
		}
		
		/* 페이지 번호 이벤트 처리 *********************/
		var actionForm = $("#actionForm"); // id "actionForm"을 미리 찾아놓음
		$(".paginate_button a").on("click", function(e) {
			e.preventDefault(); // 링크를 클릭했을 때 다음 주소로 넘어가는 것을 방지
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.attr("action","/board/list"); // 목록으로 전송
			actionForm.submit(); // Form 전송
		});
		
        /* 제목 클릭 시 이벤트처리 **********************************/
        $(".move").on("click",function(e){
           e.preventDefault(); //기본이벤트방지.다른페이지로 넘어가는 것 방지
           
           // if문으로 제어해서 bno가 한번만 append되도록 변경
            if(!actionForm.find("input[name='bno']").val()) {               
				actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
				actionForm.attr("action","/board/get"); //상세보기로 변경                                    
            } else {
            	actionForm.find("input[name='bno']").val($(this).attr("href"));
            }
            actionForm.attr("action","/board/get");
			actionForm.submit();//폼전송
        });


		
			
/* 		$(".move").on("click",function(e) {
			e.preventDefault(); // 기본이벤트 방지. 다른 페이지로 넘어가는 것 방지.
			$("#actionForm").append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>")
			.attr("action", "/board/get") // 상세보기로 변경
			.submit(); // 폼전송
		}); */
		
		
		/* 검색 버튼 이벤트 처리 ************************/
		var searchForm = $("#searchForm");
		$("#searchForm button").on("click",function(e) {
			e.preventDefault(); // 폼 전송 방지
			if (!searchForm.find("option:selected").val()) {
				alert("검색종류를 선택하세요");
				return false;
			}

			if (!searchForm.find("input[name='keyword']").val()) {
				alert("키워드를 입력하세요");
				return false;
			}

			searchForm.find("input[name='pageNum']").val("1");
			searchForm.submit();
		});
		
	});
</script>

<%@include file="../includes/footer.jsp"%>