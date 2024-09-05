package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Log4j
@RequestMapping("/sample2/*") 
@Controller
public class SampleController2 {
	// 모든 사용자 접근
	@GetMapping("/all")
	public void doAll() { // void 방식이라서 all.jsp로 감.
		log.info("모든 사용자 접근 가능");
	}
	
	// 회원 접근
	@GetMapping("/member")
	public void doMember() { // void 방식이라서 member.jsp로 감.
		log.info("member 접근 가능");
	}

	// 관리자 접근
	@GetMapping("/admin")
	public void doAdmin() { // void 방식이라서 admin.jsp로 감.
		log.info("admin 접근 가능");
	}
	
	
	
}
