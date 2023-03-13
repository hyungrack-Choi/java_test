package com.example.exam01;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Data
@Document(collection = "users") // DB안에 user_info라는 컬렉션에 저장 (table개념)
public class Member {

    // private String m_id;        // mongoDB에서 객체를 식별하기 위한 id
    @Id
    private String userid;      // 유저 id

    private String password;    // 비밀번호
    private String name;        // 유저이름
    private String nickname;    // 유저닉네임


    private String email;       // 유저 이메일

    private String phoneNumber; // 유저 핸드폰번호
    
}
