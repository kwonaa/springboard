package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
public class Criteria {

	private int pageNum; // 페이지 번호
	private int amount; // 페이지 당 글의 수
	
	// 검색항목(type)과 검색 키워드(keyword)추가 
	private String type;
	private String keyword;

	public Criteria() {
		this(1, 10); // 기본값(1페이지, 10씩)
	}

	public Criteria(int pageNum, int amount) { // 생성자 오버로딩
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	// 롬복이 getTypeArr와 짝이 되는  typeArr 필드를 자동 생성
	public String[] getTypeArr() {
		return type == null? new String[] {}: type.split(""); 
		// type이 없으면 빈 문자열 배열을 리턴. 그렇지 않으면 list.jsp에 있는 검색폼의 type을 한글자씩 분리해서 배열에 넣어서 리턴
	}
	
	// url parameter 생성
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		return builder.toUriString();
	}
}
