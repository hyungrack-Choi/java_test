
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<style>
table {
	margin: auto;
}

table .td {
	margin: auto;
}
</style>
</head>
<body>
	<table>
		<tr>
			<td>아이디 :</td>
			<td><input type=text name=userid id=userid></td>
		</tr>
		<tr>
			<td>비밀번호 :</td>
			<td><input type=password name=password id=password></td>
		</tr>
		<tr>
			<td colspan=2 style="text-align: center"><input type=button
				id=btnGo value=로그인>
				<button type=reset>취소</button></td>
		</tr>
		<tr>
			<td style="text-align: left"><a href="/">홈으로</a></td>
			<td style="text-align: right"><a href="/signin">회원가입</a></td>
		</tr>
		<tr>
			<td style="text-align: left"><a href="/callback">네이버</a>
			<td style="text-align: right"><a href="/kakaologin">카카오</a></td>
		</tr>
		<tr>
			<td style="text-align: left" onclick="naverLogout(); return false;">
				<a href="javascript:void(0)"> <span>네이버 로그아웃</span></a>
			</td>
		</tr>
	</table>
</body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
	$(document).on('click', '#btnGo', function() {
		if ($('#userid').val() == '' || $('#password').val() == '') {
			alert('로그인/비밀번호를 입력하세요');
			return false;
		}
		$.post('/checkuser', {
			userid : $('#userid').val(),
			password : $('#password').val()
		}, function(data) {
			if (data == 'ok') {
				document.location = "/";
			} else {
				alert('로긴 실패. 아이디와 비밀번호가 정확히 입력되어야 합니다.');
				$('#userid,#password').val('');
			}
		}, 'text');
		return true;
	})

	var testPopUp;
	function openPopUp() {
		testPopUp = window.open("https://nid.naver.com/nidlogin.logout",
				"_blank",
				"toolbar=yes,scrollbars=yes,resizable=yes,width=1,height=1");
	}
	function closePopUp() {
		testPopUp.close();
	}

	function naverLogout() {
		openPopUp();
		setTimeout(function() {
			closePopUp();
		}, 1000);
	}
</script>
</html>