<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title></title>
	</head>
	<body>
		<h1>admin</h1>
		
<!-- 		<p>principal : <sec:authentication property="principal"/></p>
		<p>MemberVO : <sec:authentication property="principal.member"/></p>
		<p>사용자이름 : <sec:authentication property="principal.member.userName"/></p>
		<p>사용자아이디 : <sec:authentication property="principal.username"/></p> 시큐리티에서 사용하는 username임
		<p>사용자 권한 리스트  : <sec:authentication property="principal.member.authList"/></p> -->
		
		<a href="/customLogout">로그아웃</a>
		<a href="/board/list">게시판</a>
	</body>
</html>