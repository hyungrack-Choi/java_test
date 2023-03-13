package com.example.exam01;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
// @RequestMapping("/items")
public class MyController {
    	
    
    KakaoAPI kakaoApi = new KakaoAPI();
    @Autowired
	HttpSession session;
    @Autowired
    private MemberDAO mdao;
    

    // 홈페이지 인덱스 페이지
    @RequestMapping("/")
    public String doHome(HttpServletRequest req, Model model) {
    String naverid = req.getParameter("naverid");
    HttpSession s = req.getSession();// session 초기화 선언
    s.setAttribute("naverid", naverid);

    
    model.addAttribute("naverid", (String) s.getAttribute("naverid"));
    model.addAttribute("gUserid", (String) s.getAttribute("gUserid"));
    // List<Chart> images = chartRepository.findAll();
    // model.addAttribute("images", images);
    return "home";
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }
    // 로그인 페이지
    // @PostMapping("/login")
    // public String loginUser(Member member) {
    //     Member existingUser = mdao.findByUsername(member.getUserid());
    //     System.out.println(existingUser);
    //     if (existingUser != null && existingUser.getPassword().equals(member.getPassword())) {
    //         return "redirect:/home";
    //     } else {
    //         return "login";
    //     }
    // }

    // 회원가입 페이지
    @RequestMapping("/signin")
    public String doSignin() {
        return "signin";
    }

	@RequestMapping("/logincheck")
	@ResponseBody
	public String doLoginCheck(HttpServletRequest req) {
		String str = "";
		HttpSession session = req.getSession();// 초기화
		String userid = (String) session.getAttribute("gUserid");
		String naverid = (String) session.getAttribute("naverid");        
		String kakaoid = (String) session.getAttribute("kakaoId");
		System.out.println("userid==" + userid);
		System.out.println("naverid==" + naverid);
		System.out.println("kakaoid==" + kakaoid);
		if (userid != null) {
			if (userid == null || userid.equals("")) {
				str = "";
			} else {
				str = userid;
			}
		}
		if (naverid != null) {
			if (naverid == null || naverid.equals("")) {
				str = "";
			} else {
				str = naverid;
			}
		}
		if (kakaoid != null) {
			if (kakaoid == null || kakaoid.equals("")) {
				str = "";
			} else {
				str = kakaoid;
			}
		}
		System.out.println("str[" + str + "]");
		return str;
	}

    // @RequestMapping("/viewUser")
    // public String doViewUser(HttpServletRequest req) {
    //     String retval = "";
    //     try {
    //         String newId = req.getParameter("newId");
    //         String newPasscode = req.getParameter("newPasscode");
    //         String name = req.getParameter("name");
    //         String nickname = req.getParameter("nickname");
    //         String email = req.getParameter("email");
    //         String mobile = req.getParameter("mobile");

    //         mdao.insertUser(newId, newPasscode, name, nickname, email, mobile);
    //         return "signin";
    //     }
    //     catch(Exception e) {
    //         retval = "fail";
    //     }
    //     return retval;
    // }

    // "user"라는 이름으로 새로운 'Member' 객체를 생성하여 모델에 추가
    @GetMapping("/viewUser")
    public String doViewUser(Model model) {
        model.addAttribute("users", new Member());
        return "viewUser";
    }

    // 'member' 객체를 MongoDB 데이터베이스에 저장
    @PostMapping("/viewUser")
    public String newUser(Member member) {
        mdao.save(member);
        return "redirect:/login";
    }

	@RequestMapping("/checkuser")
	@ResponseBody
	public String docheckuser(HttpServletRequest req,Member member) {
		String retval = "";
		try {
            member.setPassword(req.getParameter("password"));
            Member m = mdao.findByUserid(member.getUserid());
			boolean cnt =  m.getPassword().equals(member.getPassword());
			if (cnt == true) {
				session = req.getSession();// session 초기화 선언
				session.setAttribute("gUserid", m.getUserid()); // 데이터 넣기 setAttribute
				return "ok";
			} else
				retval = "fail";
		} catch (Exception e) {
			return "fail";
		}
		return retval;
	}

    // 로그인시 등록되어있는 사용자인지 확인
    @RequestMapping("/loginOk")
    public String doLoginOk(Member member) {
        Member m = mdao.findByUserid(member.getUserid());
        if (m != null && m.getPassword().equals(member.getPassword())) {
            return "redirect:/";
        }
        else {
            return "login";
        }
    }

    @RequestMapping("/kakaologin")
	public String login(@RequestParam("code") String code, HttpSession session, Model model) {
		// 1번 인증코드 요청 전달
		String accessToken = kakaoApi.getAccessToken(code);
		// 2번 인증코드로 토큰 전달
		HashMap<String, Object> userInfo = kakaoApi.getUserInfo(accessToken);
		
		System.out.println("login info : " + userInfo.toString());
		
		if(userInfo.get("email") != null) {
			session.setAttribute("kakaoId", userInfo.get("email"));
			session.setAttribute("accessToken", accessToken);
		}
		model.addAttribute("kakaoId", userInfo.get("email"));
		return "home";
	}

	@RequestMapping("/callback")    
	public String callback() {
		return "callback";
	}

    @PostMapping("/checkId")
    @ResponseBody
    public String doCheckId(@RequestParam String userid) {
        boolean isDup = mdao.checkId(userid);
        return Boolean.toString(isDup);
    }

    @PostMapping("/checkNick")
    @ResponseBody
    public String doCheckNick(@RequestParam String nickname) {
        boolean isDup = mdao.checkNick(nickname);
        
        System.out.println(Boolean.toString(isDup));
        return Boolean.toString(isDup);
    }

    @PostMapping("/checkEmail")
    @ResponseBody
    public String doCheckEmail(@RequestParam String email) {
        boolean isDup = mdao.checkEmail(email);
        return Boolean.toString(isDup);
    }
    
	@RequestMapping("/signout")
	@ResponseBody
	public String doSignout(HttpServletRequest req) {
		String retval = "";
		try {
			HttpSession session = req.getSession();// 초기화
			session.invalidate();
			retval = "ok";
			System.out.println("signout retval=" + retval);
		} catch (Exception e) {
			retval = "fail";
		}
		return retval;
	}

}


