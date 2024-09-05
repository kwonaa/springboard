package org.zerock.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.SampleVO;
import org.zerock.domain.Ticket;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/sample")
@Log4j
public class SampleController {
	
	// JSON/XML 테스트
	@GetMapping(value = "/getSample", produces = { MediaType.APPLICATION_JSON_UTF8_VALUE, MediaType.APPLICATION_XML_VALUE })
	public SampleVO getSample() {
		return new SampleVO(112, "길동", "홍");
	}
	
	// Collection 타입의 객체 반환 - List
	@GetMapping(value = "/getList")
	public List<SampleVO> getList() {
		// 전통 방식(for문 사용)
//		List<SampleVO> list = new ArrayList<>();
//		for(int i=1; i<10; i++) {
//			list.add(new SampleVO(i, i + "First", i + " Last"));
//		}
//		return list;
		
		// 최근 방식(람다식 사용)
		return IntStream.range(1, 10)
						.mapToObj(i -> new SampleVO(i, i + "First", i + " Last"))
						.collect(Collectors.toList());
//		IntStream.range(1, 10): 1부터 9까지의 정수를 생성하는 스트림을 만듭니다. range(1, 10)은 시작 값(1)부터 끝 값(10) 전까지의 값을 생성합니다.
//		.mapToObj(i -> new SampleVO(i, i + " First", i + " Last")): 각 정수 i에 대해 SampleVO 객체를 생성합니다. i는 SampleVO의 첫 번째 필드로, i + " First"는 두 번째 필드로, i + " Last"는 세 번째 필드로 사용됩니다.
//		.collect(Collectors.toList()): 생성된 SampleVO 객체들을 리스트로 수집합니다.
	}
	
	
	// Collection 타입의 객체 반환 - Map
	@GetMapping(value = "/getMap")
	public Map<String, SampleVO> getMap() {
		log.warn("테스트============");
		Map<String, SampleVO> map = new HashMap<>();
		map.put("First", new SampleVO(111, "그루트", "주니어")); // SampleVO.java에서 @AllArgsConstructor로 생성자 자동 생성

		return map;

	}
	
	// ResponseEnitity 타입
	@GetMapping(value = "/check", params = { "height", "weight" })
	public ResponseEntity<SampleVO> check(Double height, Double weight) {
		SampleVO vo = new SampleVO(0, "" + height, "" + weight); // 실수를 문자열로 바꿀려고 빈문자열을 앞에 붙임
		ResponseEntity<SampleVO> result = null;
		if (height < 150) {
			result = ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo); // BAD_GATEWAY는 502번 에러
		} else {
			result = ResponseEntity.status(HttpStatus.OK).body(vo); // OK는 200번 에러 (요청이 성공적으로 처리되었음을 나타냄)
		}
		return result;
	}
	
	
	// @RestController의 파라미터 中 @PathVariable
	@GetMapping("/product/{cat}/{pid}")
	public String[] getPath(@PathVariable("cat") String cat, @PathVariable("pid") Integer pid) {
		return new String[] { "category: " + cat, "productid: " + pid }; // cat은 카테고리
	}
	
	

	// @RequestBody
	@PostMapping("/ticket")
	public Ticket convert(@RequestBody Ticket ticket) {
		log.info("convert.......ticket" + ticket);
		return ticket;
	}	

}
