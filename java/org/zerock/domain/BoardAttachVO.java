package org.zerock.domain;

import lombok.Data;

@Data
public class BoardAttachVO {
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType; // type이 boolean인 경우 getter는 getFileType()이 아니라 isFileType()으로 생성됨.

	private Long bno;
}
