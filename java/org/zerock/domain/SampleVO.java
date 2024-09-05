package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor // 생성자 자동 생성
@NoArgsConstructor
public class SampleVO {

  private Integer mno;
  private String firstName;
  private String lastName;

}
