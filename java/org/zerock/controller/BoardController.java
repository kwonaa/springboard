package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
	private BoardService service; // 자동주입. 생성자의존성주입 (@AllArgsConstructor를 써줬기 때문에 어노테이션을 따로 안 써줘도 됨)
	
	// 목록
	/*
	 * @GetMapping("/list") public void list(Model model) { //
	 * request.setAttribute("list", service.getList()); 와 같은 역할 // list.jsp로 포워딩
	 * model.addAttribute("list", service.getList()); // "list"는 attribute명 }
	 * 
	 * 
	 */

	
	// 등록화면으로 이동
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()") // register 메서드가 실행되기 전에 isAuthenticated를 체크한다는 뜻 // 로그인 해야 작성 가능 (isAuthenticated가 true)
	public void register() {
		
	}
	
	// 등록 처리
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()") // 로그인 해야 작성 가능
	public String register(BoardVO board, RedirectAttributes rttr) {
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno()); // result라는 이름으로 글번호 전달
		return "redirect:/board/list"; // 주소가 변경될 때 사용 // sendRedirect() 역할
	}
	
	// 상세보기
	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		model.addAttribute("board", service.get(bno));
	}
	
	// 수정
	@PreAuthorize("principal.username == #board.writer") // 자기가 쓴 글만 수정
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify:" + board);

		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}

		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());

		return "redirect:/board/list";
	}
	
	// 삭제
	@PreAuthorize("principal.username == #writer") // 자기가 쓴 글만 삭제
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr, String writer) {
		// 첨부파일 목록
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if (service.remove(bno)) {
			// 첨부파일 삭제
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("amount", cri.getAmount());
//		rttr.addAttribute("type", cri.getType());
//		rttr.addAttribute("keyword", cri.getKeyword());

		return "redirect:/board/list" + cri.getListLink();
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		// 첨부파일이 없으면 중지
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		attachList.forEach(attach -> {
			try {
				Path file  = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\" + attach.getUuid()+"_"+ attach.getFileName());
				Files.deleteIfExists(file); // 원본파일 삭제
				// 이미지이면
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_" + attach.getUuid()+"_"+ attach.getFileName());
					Files.delete(thumbNail); // 썸네일 삭제
				}
			} catch (Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});

	}
	
	
	// 목록 with paging	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		model.addAttribute("list", service.getList(cri));
		int total = service.getTotal(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}

	// 첨부파일목록
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}


}
