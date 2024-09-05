package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;
import org.zerock.security.domain.CustomUser;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	@Setter(onMethod_ = { @Autowired })
	private MemberMapper memberMapper; // 주입

	// 회원 아이디로 회원 정보 조회
	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		// 여기에서 userName은 userid를 의미함
		MemberVO vo = memberMapper.read(userName);
		return vo == null ? null : new CustomUser(vo); // CustomUser 만들기 전까지 에러남
	} 

}
