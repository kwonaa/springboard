package org.zerock.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		// 역할 이름 목록
		List<String> roleNames = new ArrayList<>();
		auth.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});
		
		// admin 권한이 있으면
		if (roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/sample2/admin"); // 관리자 페이지로 이동
			return;
		}
		
		// member 권한이 있으면
		if (roleNames.contains("ROLE_MEMBER")) {
			response.sendRedirect("/sample2/member"); // member 페이지로 이동
			return;
		}
		
		// 일반회원은 root로 이동 (따로 코딩을 안 해놨기 때문에 index.jsp로 이동)
		response.sendRedirect("/");	
	}

}
