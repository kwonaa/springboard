package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	// 테스트용 업로드폼
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	// 파일 업로드 처리
//	@PostMapping("/uploadFormAction")
//	public void uploadFormPost(MultipartFile[] uploadFile, Model mode) {
//		// 다중 파일 처리
//		for(MultipartFile multipartFile : uploadFile) {
//			log.info("------------------------------------");
//			log.info("Upload File Name: " +multipartFile.getOriginalFilename());
//			log.info("Upload File Size: " +multipartFile.getSize());
//		}
//	}
	
	
	// 파일 저장
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		// 업로드 폴더
		String uploadFolder = "C:\\upload";
		// 다중 파일 처리
		for (MultipartFile multipartFile : uploadFile) {
			log.info("-------------------------------------");
			log.info("Upload File Name: " + multipartFile.getOriginalFilename());
			log.info("Upload File Size: " + multipartFile.getSize());
			// 파일 객체 생성
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			try {
				multipartFile.transferTo(saveFile); // 업로드 파일 저장
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}	
	
	// Ajax 파일 업로드 테스트 화면
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	// 중복된 이름의 파일 처리
	// 오늘 날짜 년월일 형식(2024\08\14)을 구하는 함수. 이 함수는 Service에 작성하거나 common 패키지에 클래스를 만들어서 사용 권장 
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator); // 윈도우즈는 File.seperator가 '\(역슬래시)'이다.
	}
	
	// 첨부파일이 이미지인지 체크
	// 이런 메서드를 service에 따로 코딩하는 것이 더 좋음. 컨트롤러에 메서드를 코딩하는 것은 좋지 않음. 
	private boolean checkImageType(File file) { 
		try {
			String contentType = Files.probeContentType(file.toPath());
			System.out.println("contentType : "+contentType);
			return contentType.startsWith("image"); // image로 시작하면 true 리턴
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false; // image가 아니면 false 리턴
	}	

	// Ajax 파일 업로드 처리
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		List<AttachFileDTO> list = new ArrayList<>();
		// 업로드폴더
		String uploadFolder="c:\\upload";
		
		// 오늘 날짜 경로
		String uploadFolderPath = getFolder();
		// 오늘 날짜 폴더 생성
//		File uploadPath = new File(uploadFolder, getFolder());
		File uploadPath = new File(uploadFolder, uploadFolderPath); // 매개변수 변경
		if(uploadPath.exists() == false) { // 폴더가 존재하지 않으면 // exists의 리턴값은 boolean임. // if(!uploadPath.exists())라고 해주는 게 좋음.
			uploadPath.mkdirs(); // 2024\08\14 계층형으로 폴더가 연속 생성됨. // 꼭 복수형인 mkdirs로 써주기!
		}			
		
		// 다중 파일 처리
		for(MultipartFile multipartFile : uploadFile) {
			log.info("----------------------------------------");
			log.info("Upload File Name : "+multipartFile.getOriginalFilename());
			log.info("Upload File Size: "+multipartFile.getSize());
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			attachDTO.setFileName(uploadFileName);
			
			// UUID 생성
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName; // 업로드 파일명			
			
			// 파일 객체 생성
			try {
				File saveFile=new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);// 업로드 파일 저장

				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				 // 첨부 파일이 이미지면 썸네일 생성
				 if (checkImageType(saveFile)) {	
					 attachDTO.setImage(true);
					 FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					 Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100); // createThumbnail(InputStream, OutputStream, width, height) // 원본 비율에 맞게 생성됨
					 thumbnail.close();
				 }
				 // list에 추가
				 list.add(attachDTO);
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	// 이미지 출력
	@GetMapping("/display")	
	@ResponseBody // 얘를 붙이면 리턴값이 json or xml or text 등등일 때 view(display.jsp)로 forwarding 되지 않음
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info("fileName: " + fileName);
		File file = new File("c:\\upload\\" + fileName);
		log.info("file: " + file);
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();

			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	// 일반 파일 다운로드
	// 브라우저가 이미지, pdf를 다운로드하면 viewer로 동작함. 이 작업이 일어나지 않게 아래처럼 코딩함. 
	// MediaType.APPLICATION_OCTET_STREAM_VALUE는 첨부파일이 image이거나 pdf여도 무조건 다운로드 되도록 처리
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {
		log.info("User-Agent : " + userAgent);
		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
		if (resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND); // not found
		}
		
		String resourceName = resource.getFilename();
		// 파일명만 추출
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		// Header 생성
		HttpHeaders headers = new HttpHeaders();
		try {
			String downloadName = null;
			downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1"); // 한글 파일명 깨짐 방지
			log.info("downloadName: " + downloadName);
			headers.add("Content-Disposition", "attachment; filename=" + downloadName); // 다운로드 파일명 변경
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	
	// 파일 삭제
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		log.info("deleteFile: " + fileName);
		File file;
		try {
			// 썸네일 or 일반파일 지우기
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			file.delete();

			if (type.equals("image")) { // 원본 이미지 파일 지우기
				String largeFileName = file.getAbsolutePath().replace("s_", ""); // "s_" 지우기
				log.info("largeFileName: " + largeFileName);
				file = new File(largeFileName);
				file.delete();
			}
		} catch(Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // 내부 서버 에러
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}

}
