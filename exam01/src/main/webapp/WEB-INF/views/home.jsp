<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>홈</title>
</head>
<body>
    <h1>홈페이지</h1>
    <div id=dvHead style='width:100%'></div>
    <a href="/users">회원목록 이동</a>
    
</body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
$(document)
.ready(function() {
    $.post('/logincheck',{},function(data){
      console.log("data="+data);
      if(data == ''){
        str="<div class='login'><a href='login'>로그인</a>&emsp;&emsp;<a href='signin'>회원가입</a></div><br><br>";
      }else {
        str="<div class='login'>"+data+"&emsp;&emsp;<input type=button id=lblSignout value='로그아웃'></div><br><br>";
      }
      $('#dvHead').html(str);
      // if(data!=''){
      //   $('body').append('<input type=button id=btnWrite value="글작성">');
      // }
    },'text');
    // Last.fm API 키
    var apiKey = '7c299ab01d7a9433efb0c6bba589ca36';
    
    // 음원차트 요청
    $.ajax({
      url: 'https://ws.audioscrobbler.com/2.0/',
      data: {
        method: 'chart.gettoptracks',
        api_key: apiKey,
        format: 'json',
        limit: 10
      },
      dataType: 'json',
      success: function(response) {
          console.log(response)
        // 트랙 목록
        var tracks = response.tracks.track;
        
        // 각 트랙에 대한 처리
        $.each(tracks, function(index, track) {
          // 앨범 정보 요청
          $.ajax({
            url: 'https://ws.audioscrobbler.com/2.0/',
            data: {
              method: 'track.getInfo',
              api_key: apiKey,
              artist: track.artist.name,
              track: track.name,
              format: 'json'
            },
            dataType: 'json',
            success: function(response) {
              // HTML 페이지에 트랙 정보 추가
              if(typeof(response.track.album) == "undefined"){
                  var html = '<span class="track">';
                  html += '<span class="rank">' + (index + 1) + '</span>';
                  html += '<img src="img/default.png" alt="Album Image">';
                  html += '<span class="title">' + track.name + '</span>';
                  html += '<span class="artist">' + track.artist.name + '</span>'; 
                  html += '</div>' + '<br>';
                  $('#chart').append(html);
              } else{
                  // 앨범 정보에서 이미지 URL 추출
                  var image = response.track.album.image[1]['#text'];
                  var html = '<span class="track">';
                  html += '<span class="rank">' + (index + 1) + '</span>';
                  html += '<img src="' + image +'" alt="Album Image">';
                  html += '<span class="title">' + track.name + '</span>';
                  html += '<span class="artist">' + track.artist.name + '</span>'; 
                  html += '</div>' + '<br>';
                  $('#chart').append(html);
              }
              
            }
          });
        });
      }
    })
  })
  .on('click', '#lblSignout', function(){
    $.post('/signout', {}, function(data){
      if(data=="ok"){
        document.location="/";
      } else {
        alert('로그아웃 실패. 다시 시도하십시오.');
      }
    }, 'text');
  });
</script>
</html>
