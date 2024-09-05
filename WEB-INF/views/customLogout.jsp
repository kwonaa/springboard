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
		<h1>로그아웃</h1>
	
		<form method='post' action="/customLogout">
			<input type="hidden"name="${_csrf.parameterName}"value="${_csrf.token}"/>
			<div>
				<input type='submit' value="로그아웃">
			</div>
		</form>
	</body>
</html>