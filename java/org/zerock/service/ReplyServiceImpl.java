package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {

	private ReplyMapper mapper; // 자동주입. 생성자 의존성 주입
	private BoardMapper boardMapper; // 자동주입. 생성자 의존성 주입
	

//	@Override
//	public int register(ReplyVO vo) { // C
//		return mapper.insert(vo);
//	}
	
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		boardMapper.updateReplyCnt(vo.getBno(), 1); // 댓글 개수 1 증가
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) { // R
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) { // U
		return mapper.update(vo);
	}

//	@Override
//	public int remove(Long rno) { // D
//		return mapper.delete(rno);
//	}
	
	@Transactional
	@Override
	public int remove(Long rno) {
		ReplyVO vo = mapper.read(rno);
		boardMapper.updateReplyCnt(vo.getBno(), -1); // 댓글 개수 1 감소
		return mapper.delete(rno);
	}
	
	// 특정 게시물의 댓글 목록
	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		return mapper.getListWithPaging(cri, bno);
	}

	// 댓글의 페이지 계산과 출력 (댓글 목록)
	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(cri, bno));
	}

}
