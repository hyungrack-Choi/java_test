<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 페이지</title>
</head>
<body>
<h1>회원가입 페이지</h1>
<form method="POST" action="/viewUser" id=frmSignIn>
    <table>
    <tr>
        <td>로그인아이디</td><td><input type=text name=userid id=newId>
        <input type="button" value='중복확인' id="btnIdCheck">
        <input type=hidden id=I_Duplicate>
    </tr>
    <tr>
        <td>비밀번호</td><td><input type=password name=password id=newPasscode>
    </tr>
    <tr>
        <td>비밀번호확인</td><td><input type=password name=newPasscode_ id=newPasscode_>
    </tr>
    <tr>
        <td>이름</td><td><input type=text name=name id=name>
    </tr>
    <tr>
        <td>닉네임</td><td><input type=text name=nickname id=nickname>
        <input type="button" value='중복확인' id="btnNickCheck">
        <input type=hidden id=N_Duplicate>
    </tr>
    <tr>
        <td>이메일</td><td><input type=email name=email id=email>
		<input type="button" value='중복확인' id="btnEmailCheck">
		<input type=hidden id=E_Duplicate>
    </tr>
    <tr>
        <td>핸드폰번호</td><td><input type=text name=phoneNumber id=mobile>
    </tr>
    <tr>
        <td colspan=2 align=center>
            <input type=submit value='회원가입' id=btnSignIn>
        </td>
    </tr>
    </table>
    </form>
    <a href='/'>홈으로</a>
    &nbsp;&nbsp;
    <a href='/login'>로그인하기</a>
</body>
<script src='https://code.jquery.com/jquery-3.4.1.js'></script>
<script>
$(document)
// .on('click', '#btnSignIn', function(){
//     if($('#newId').val()=='' || $('#name').val()=='' || $('#mobile').val()=='') {
//         alert("빈칸을 확인해주세요.");
//         return false;
//     }
//     if($('#newPasscode').val()==$('#newPasscode_').val()){
//         $('frmSignin').submit();
//         alert("회원가입이 성공하셨습니다.");
//     }
//     else {
//         alert("비밀번호가 일치하지 않습니다.");
//         return false;
//     }
// })
.on('click', '#btnIdCheck', function(){
	if($('#newId').val()=='') {
        alert("아이디를 입력해주세요.");
		return false;
    }
	else {
        $.post('/checkId', {userid:$('#newId').val()}, function(data){
		if(data=='true') {
			alert("이미 사용중인 아이디입니다.");
		}
		else {
			alert("사용가능한 아이디입니다.");
			$('#I_Duplicate').val('ok');
		}
	}, 'text');
	return false;
    }
})

.on('click', '#btnNickCheck', function(){
	if($('#nickname').val()=='') {
        alert("사용할 닉네임을 입력해주세요.");
		return false;
    }
	else {
        $.post('/checkNick', {nickname:$('#nickname').val()}, function(data){
		if(data=='true') {
			alert("이미 사용중인 닉네임입니다.");
		}
		else {
			alert("사용가능한 닉네임입니다.");
			$('#N_Duplicate').val('ok');
		}
	}, 'text');
	return false;
    }
})

.on('click', '#btnEmailCheck', function(){
	if($('#email').val()=='') {
        alert("이메일을 입력해주세요.");
		return false;
    }
	else {
        $.post('/checkEmail', {email:$('#email').val()}, function(data){
		if(data=='true') {
			alert("이미 사용중인 이메일입니다.");
		}
		else {
			alert("사용가능한 이메일입니다.");
			$('#E_Duplicate').val('ok');
		}
	}, 'text');
	return false;
    }
})

.on('click', '#btnSignIn', function(){
	if($('#newId').val()=='' || $('#name').val()=='' || $('#mobile').val()=='') {
		alert("빈칸을 확인해주세요.");
		return false;
	}
	if($('#I_Duplicate').val()!="ok") {
		alert("중복확인 하십시오.");
		return false;
	}
	if($('#newPasscode').val()!=$('#newPasscode_').val()){
		alert("비밀번호가 일치하지 않습니다.");
		return false;
	}
    if($('#N_Duplicate').val()!="ok") {
		alert("중복확인 하십시오.");
		return false;
	if($('#E_Duplicate').val() != "ok") {
		alert("중복확인 하십시오.");
		return false;
	}	
	}
	$.post('/viewUser', {userid:$('#newId').val(), password:$('#newPasscode').val(),
		name:$('#name').val(), email:$('#email'), phoneNumber:$('#mobile').val()}, function(data){
			if(data=='ok') {
				alert("회원가입되었습니다.");
				document.location = '/login';
			}
			else {
				alert("회원가입 실패!!");
				$('#newId', '#newPasscode', '#newPasscode_', '#name',
						'#mobile', '#IDuplicate').val('');
			}
		}, 'text');
})
// .on('click', '#btnIdCheck', function(){
//     let id = $("#newId").val();
//     $.get("/checkId", function(exists){
//         if (exists) {
//             alert("중복된 ID입니다.");
//         }
//         else {
//         // 중복되지 않은 ID 처리
//         alert("사용가능한 ID입니다.");
//         }
//     })
// })

</script>
</html>