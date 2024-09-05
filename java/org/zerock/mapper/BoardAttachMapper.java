package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardAttachVO;

public interface BoardAttachMapper {
	// 등록
	public void insert(BoardAttachVO vo);
	// 목록 (목록이라서 List)
	public List<BoardAttachVO> findByBno(Long bno);
	// 첨부파일 목록 모두 삭제
	public void deleteAll(Long bno);
	// 어제 날짜 첨부파일 목록
	public List<BoardAttachVO> getOldFiles();
	
	public void delete(String uuid);
	

}