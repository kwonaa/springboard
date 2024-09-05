package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	private int startPage; // 1...10 구간의 시작페이지
	private int endPage; // 1...10 구간의 마지막페이지
	private boolean prev,next; // 이전,다음구간 존재유무
	private int total; //전체글수
	private Criteria cri; // Criteria 객체 필요
	
	public PageDTO(Criteria cri,int total) {
		this.cri=cri;
		this.total=total;
		this.endPage=(int)(Math.ceil(cri.getPageNum()/10.0))*10;
		this.startPage=this.endPage-9;
		int realEnd=(int)(Math.ceil((total*1.0) / cri.getAmount()));
		if(realEnd<=this.endPage) {
			this.endPage=realEnd;
		}
		this.prev=this.startPage>1; // startPage가 1보다 크면 true
		this.next=this.endPage<realEnd; // realEnd가 endPage보다 크면 true
	}
	
}
