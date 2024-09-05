package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardMapper {
	//목록
	public List<BoardVO> getList();
	//등록
	public void insert(BoardVO board);
	//등록 with select key
	public void insertSelectKey(BoardVO board);
	//상세보기
	public BoardVO read(Long bno);
	//수정처리
	public int update(BoardVO board);
	//삭제
	public void deleteReply(Long bno);
	public int deleteBoard(Long bno);
	//목록 with paging
	public List<BoardVO> getListWithPaging(Criteria cri);
	//전체글수
	public int getTotalCount(Criteria cri);
	// 댓글 트랜잭션 처리
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}