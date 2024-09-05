package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper; // 주입. setter 의존성 주입

	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper; // 주입. setter 의존성 주입
	
	@Override
	public List<BoardVO> getList() {		
		return mapper.getList(); // mapper의 getList()호출
	}

	@Transactional
	@Override
	public void register(BoardVO board) {
		// 부모글 등록
		mapper.insertSelectKey(board);
		
		// 첨부파일이 없으면 중지
		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno()); // 부모글번호 저장
			attachMapper.insert(attach); // 첨부파일 등록
		});
	}

	@Override
	public BoardVO get(Long bno) {		
		return mapper.read(bno);
	}

//	@Override
//	public boolean modify(BoardVO board) {	
////		int result=mapper.update(board);
////		if(result==1) {
////			return true;
////		}else {
////			return false;
////		}
//		return mapper.update(board)==1;//영향을 받은 행의 수가 1이면 true 리턴
//	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		// 기존 첨부파일 모두 삭제
		attachMapper.deleteAll(board.getBno()); 
		// 부모글을 먼저 수정
		boolean modifyResult = mapper.update(board) == 1;
		// 첨부파일을 하나씩 insert. 부모글이 수정되고, 첨부파일 목록이 있는 경우.
		if (modifyResult && board.getAttachList() != null) {
			if (board.getAttachList().size() > 0) {
				board.getAttachList().forEach(attach -> { // forEach문으로 하나씩 꺼내서 insert
					attach.setBno(board.getBno()); // 부모글번호 저장
					attachMapper.insert(attach);
				});
			}
		}
		return modifyResult;
	}	
	
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		mapper.deleteReply(bno);
		attachMapper.deleteAll(bno);
		return mapper.deleteBoard(bno)==1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {		
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {		
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		return attachMapper.findByBno(bno);
	}

}
