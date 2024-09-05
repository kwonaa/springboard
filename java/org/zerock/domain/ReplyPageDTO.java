package org.zerock.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor // 모든 필드를 parameter로 갖는 생성자를 구현해줌
@Getter
public class ReplyPageDTO {
	private int replyCnt; // 댓글 수
	private List<ReplyVO> list; // 댓글 목록
	
//	@AllArgsConstructor에 의해 구현되는 생성자 예시
//	public ReplyPageDTO(int replyCnt, List<ReplyVO> list) {
//		super();
//		this.replyCnt = replyCnt;
//		this.list = list;
//	}
	
}
