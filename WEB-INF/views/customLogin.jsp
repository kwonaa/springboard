<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title></title>
	</head>
	<body>
		<h1>로그인</h1>
		<h2><c:out value="${error}"/></h2>
		<h2><c:out value="${logout}"/></h2>
	
		<form method='post' action="/login">
			<!-- username -->
			<div>
				<input type='text' name='username' placeholder="id"> 
			</div>
			
			<!-- password -->
			<div>
				<input type='password' name='password' placeholder="pw">
			</div>
			
			<!-- 자동로그인 -->
			<div>
				<input type='checkbox' name='remember-me'> 자동로그인
			</div>

			<div>
				<input type='submit' value="로그인">
			</div>
			
			<!-- hidden 태그 -->
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		</form>
		<a href="/board/list">게시판</a>
</body>
</html>