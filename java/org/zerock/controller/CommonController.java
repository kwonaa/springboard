package org.zerock.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {
	// 권한 에러 페이지
	@GetMapping("/accessError") // views에 accessError.jsp 만들기
	public void accessDenied(Authentication auth, Model model) {
		log.info("권한없음 : " + auth);
		model.addAttribute("msg", "권한이 없습니다."); // ("attribute명", "값")
	}
	
	
	// 커스텀 로그인 페이지
	@GetMapping("/customLogin") // views에 customLogin.jsp 만들기
	public void loginInput(String error, String logout, Model model) {
		log.info("에러 : " + error);
		log.info("로그아웃 : " + logout);

		if (error != null) {
			model.addAttribute("error", "로그인 에러"); // ("attribute명", "값")
		}

		if (logout != null) {
			model.addAttribute("logout", "로그아웃되었습니다."); // ("attribute명", "값")
		}
	}
	
	
	// 커스텀 로그아웃 페이지
	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("custom logout");
	}

	// 커스텀 로그아웃 처리
	@PostMapping("/customLogout")
	public void logoutPost() {
		log.info("post custom logout");
	}	
	
}
