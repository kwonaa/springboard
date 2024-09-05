package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {

	public int insert(ReplyVO vo); // 등록

	public ReplyVO read(Long rno); // 조회

	public int delete(Long rno); // 삭제

	public int update(ReplyVO reply); // 수정

	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno); // 댓글목록 with paging // MyBatis에서 parameter가 두 개 이상일 땐 @Param을 적어줘야 함.

	public int getCountByBno(Long bno); // 댓글 수
}
