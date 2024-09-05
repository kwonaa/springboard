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
		<h1>Access Denied</h1>
		
		<!-- 컨트롤러에서 attribute명을 msg로 설정했기 때문에 jsp에서 msg로 받는 것임 -->
		<h2><c:out value="${msg}"/></h2> 
	</body>
</html>