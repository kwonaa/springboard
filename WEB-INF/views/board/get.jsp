<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@ include file="../includes/header.jsp" %>

            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board</h1>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Read
                        </div>
                        
                        <div class="panel-body">                           
                           	<div class="form-group">
                           		<label>Bno</label>
                           		<input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly>
                           	</div>
                           	<div class="form-group">
                           		<label>Title</label>
                           		<input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly>
                           	</div>
                           	<div class="form-group">
                           		<label>Content</label>
                           		<textarea class="form-control" rows="3" name="content" readonly><c:out value="${board.content}"/></textarea>
                           	</div>
                           	<div class="form-group">
                           		<label>Writer</label>
                           		<input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly>	
                           	</div>	
                           	
                      <%--   	<button class="btn btn-default">
                        		<a href="/board/modify?bno=<c:out value='${board.bno}'/>">Modify</a>
                        	</button>
                        	<button type="reset" class="btn btn-default">
                        		<a href="/board/list">List</a>
                        	</button>    --%>  	  
                        	
                        	
				            <!-- 첨부파일 ------------------------------------------------------------------->
				            <div class='bigPictureWrapper'>
							  <div class='bigPicture'>
							  </div>
							</div>
                        	
	                        <div class = pull-right>
	                        
								<%-- <button data-oper='modify' class="btn btn-default">
									<a href="/board/modify?bno=<c:out value='${board.bno}'/>">수정/삭제</a>
								</button> --%>
								
								<!-- principal을 pinfo 변수에 저장 -->
						        <sec:authentication property="principal" var="pinfo"/>
						        <!-- 로그인을 했으면 -->
						        <sec:authorize access="isAuthenticated()"> 
						        <!-- 아이디가 작성자와 같으면 -->
						        <c:if test="${pinfo.username eq board.writer}"> 
						        
						        <button data-oper='modify' class="btn btn-default">
						        	<a href="/board/modify?bno=<c:out value='${board.bno}'/>">수정/삭제</a>
					        	</button>
						        
						        </c:if>
						        </sec:authorize>								
								
								
								<button data-oper='list' class="btn btn-default">
									<a href="/board/list">목록</a>
								</button>               	
	                        </div>
                        </div>
                    </div>
                </div>
            </div>

			
			<style>
			.uploadResult {
			  width:100%;
			  background-color: gray;
			  overflow:auto;	
			}
			.uploadResult ul{
			  display:flex;
			  flex-flow: row;
			  justify-content: center;
			  align-items: center;
			}
			.uploadResult ul li {
			  list-style: none;
			  padding: 10px;
			  align-content: center;
			  text-align: center;
			}
			.uploadResult ul li img{
			  width: 100px;
			}
			.uploadResult ul li span {
			  color:white;
			}
			.bigPictureWrapper {
			  position: fixed;
			  display: none;
			  justify-content: center;
			  align-items: center;
			  top:0 !important;
			  left:0 !important;
			  width:100%;
			  height:100%;
			  z-index: 1000 !important;
			  background:rgba(0,0,0,0.7);  	  
			}
			.bigPicture {
			  position: relative;
			  display:flex;
			  justify-content: center;
			  align-items: center;		
			}
			
			.bigPicture img {
			  width:600px;
			}
			
			</style>
			
			
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
			
						<div class="panel-heading">Files</div>
						<!-- /.panel-heading -->
						<div class="panel-body">
			
							<div class='uploadResult'>
								<ul>
								</ul>
							</div>
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
					<div class="panel panel-default">
						
						<!-- 로그인 한 경우만 댓글 등록 버튼 출력 -->
						<div class="panel-heading">
							<i class="fa fa-comments fa-fw"></i> 댓글
							<sec:authorize access="isAuthenticated()">
							<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>댓글작성</button>
							</sec:authorize>
						</div>
						
						<div class="panel-body">
							<!-- 댓글목록 출력 ul태그 -->
							<ul class="chat">
							</ul>
						</div>
			
						<div class="panel-footer"></div>
			
			
					</div>
				</div>
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
								<label>내용</label> <input class="form-control" name='reply'>
							</div>
							<div class="form-group">
								<label>작성자</label> <input class="form-control" name='replyer' readonly>
							</div>
							<div class="form-group">
								<label>작성일</label> <input class="form-control" name='replyDate' value='2018-01-01 13:13'>
							</div>
						</div>
						
						<div class="modal-footer">
							<!-- principal을 pinfo 변수에 저장 -->
					        <sec:authentication property="principal" var="pinfo"/>
					        <!-- 로그인을 했으면 -->
					        <sec:authorize access="isAuthenticated()"> 
					        <!-- 아이디가 작성자와 같으면 -->
					        <c:if test="${pinfo.username eq vo.replyer}"> 						
								<button id='modalModBtn' type="button" class="btn btn-warning">수정</button>
								<button id='modalRemoveBtn' type="button" class="btn btn-danger">삭제</button>
							</c:if>
							</sec:authorize>
							<button id='modalRegisterBtn' type="button" class="btn btn-primary">작성</button>
							<button id='modalCloseBtn' type="button" class="btn btn-default">닫기</button>
						</div>
						
					</div>
				</div>
			</div>
            
            
            <!-- 히든태그에 값을 넣어서 전송하기위한 폼 ----------------------------------------> 
            <form id="operForm" action="/board/modify" method="get">
            	<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'>
            	<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
            	<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
            	<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
            	<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
            </form>            
            <!-- 히든태그에 값을 넣어서 전송하기위한 폼.end -->
            
<script>
	/* csrf 토큰 처리 *******************************************************************************/
	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";
/* 	$(document).ajaxSend(function(e, xhr, options) { 
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
	});  */
	
	/* 댓글작성자 *****************************************************************************/
	<sec:authorize access="isAuthenticated()">		    
	replyer = '<sec:authentication property="principal.username"/>';   		    
	</sec:authorize>
</script>         
         
<script src="/resources/js/reply3.js?bno=<c:out value='${board.bno}'/>"></script>            
<%@ include file="../includes/footer.jsp" %>            