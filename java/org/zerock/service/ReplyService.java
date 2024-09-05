package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;

public interface ReplyService {

	public int register(ReplyVO vo); // C

	public ReplyVO get(Long rno); // R

	public int modify(ReplyVO vo); // U

	public int remove(Long rno); // D
	
	public List<ReplyVO> getList(Criteria cri, Long bno); // 특정 게시물의 댓글 목록
	
	public ReplyPageDTO getListPage(Criteria cri, Long bno); // 댓글의 페이지 계산과 출력 (댓글 목록)
}
