package com.example.exam01;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface MemberDAO extends MongoRepository<Member, String> {
    Member findByUserid(String userid);
    Member findByNickname(String nickname);
    Member findByEmail(String email);    
    // 중복확인 하는 코드
    default boolean checkId(String userid) {
        return findByUserid(userid) != null;
    }
    
    default boolean checkNick(String nickname) {
        return findByNickname(nickname) != null;
    }

    default boolean checkEmail(String email) {
        return findByEmail(email) != null;
    }


}
