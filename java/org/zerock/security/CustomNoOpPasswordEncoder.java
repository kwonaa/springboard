package org.zerock.security;

import org.springframework.security.crypto.password.PasswordEncoder;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder {

	public String encode(CharSequence rawPassword) {
		// 여기에 비밀번호 암호화 코드 작성
		
		// 더미데이터에 비밀번호가 암호화되어 있지 않으므로 여기서는 암호화 하지 않고 리턴
		return rawPassword.toString();
	}

	//로그인 이후 회원정보를 변경할 때 필요
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		//비밀번호 일치여부 확인
		//사용자가 입력한 비밀번호를 암호화 해서 테이블에 암호화된 비밀번호와 비교

		// 더미데이터에 비밀번호가 암호화되어 있지 않으므로 여기서는 그냥 같은지 비교
		return rawPassword.toString().equals(encodedPassword);
	}

}
