// 즉시실행함수 
// var replyService=(function(){return {add:100};)();는
// var replyService={add:100}; 과 결과적으로 같다.

var replyService = (function() {

	// js에서 함수의 이름은 reference임
	// callback, error parameter에는 함수를 가리키는 reference나 함수의 이름이 전달됨
	
	// 댓글 등록
	function add(reply, callback, error) {
		$.ajax({
			type : 'post', // 전송방식
			url : '/replies/new', // 서버 주소
			data : JSON.stringify(reply), // 서버로 전달되는 데이터
			contentType : "application/json; charset=utf-8", // 서버로 전달되는 데이터 형식
			success : function(result, status, xhr) {
				if (callback) {
					callback(result); // success일 때 사용하는 함수 호출
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er); // error일 때 사용하는 함수 호출. 책에서 실제로는 사용 안 함.
				}
			}
		})
	}
	
	
	// 댓글의 페이지 계산과 출력 (댓글 목록)
	function getList(param, callback, error) {
		var bno = param.bno; // 부모글번호
	    var page = param.page || 1; // 페이지번호. 페이지번호가 넘어오면 page변수에 저장. 페이지번호가 넘어오지 않으면 page는 1.
	    
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json", function(data) {
			if (callback) { // success일 때 함수 호출
				//callback(data); // 댓글 목록만 가져오는 경우 
	            callback(data.replyCnt, data.list); // 댓글 숫자와 목록을 가져오는 경우 
			}
		}).fail(function(xhr, status, err) { // 에러가 났을 때
			if (error) {
				error();
			}
		});
	}
	
	
	// 댓글 삭제
	function remove(rno, callback, error) {
		$.ajax({
			type : "delete", // 전송방식
			url : "/replies/" + rno, // 서버주소
			success : function(deleteResult, status, xhr) { // 성공했을 때 호출하는 함수
				if (callback) {
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er) { // 실패 시 호출하는 함수
				if (error) {
					error(er);
				}
			}
		});
	}


	// 댓글 수정
	function update(reply, callback, error) {

		console.log("RNO: " + reply.rno);

		$.ajax({
			type : "put", // update 시에는 put or patch 타입으로 전송
			url : "/replies/" + reply.rno, // 서버주소
			data : JSON.stringify(reply), // 서버로 전송되는 데이터
			contentType : "application/json; charset=utf-8", // 서버로 전송되는 데이터의 형식
			success : function(result, status, xhr) { // 성공 시 호출하는 함수
				if (callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) { // 실패 시 호출하는 함수
				if (error) {
					error(er);
				}
			}
		});
	}
	
	
	// 댓글 조회
	function get(rno, callback, error) {
		// get 방식 전용(post 방식으로는 사용 불가)
		$.get("/replies/" + rno + ".json", function(result) {
			if (callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}
	
	
	// 댓글 작성일
	function displayTime(timeValue) {
		var today = new Date(); // 현재 날짜 시간
		var gap = today.getTime() - timeValue; // 댓글 등록 이후 지난 시간
		var dateObj = new Date(timeValue); // 댓글작성시간을 Date 타입으로 변환
		var str = "";
		
		// 댓글을 작성한 지 24시간이 안 됐으면 시:분:초만 출력
		if (gap < (1000 * 60 * 60 * 24)) { // 24시간, 60분, 60초, 1초는 1000ms
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss ].join(''); // join은 배열의 요소를 연결해주기 위해 사용. 연결자를 ''로 둬서 값을 주지 않음. // 배열 중간의 ':'들을 지우고 join('/')라고 해도 됨.
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1; // getMonth() is zero-based // 1월이 0이라서 1 더해줌
			var dd = dateObj.getDate();
			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd ].join('');
		}
	}
	;
	
	
	return {
		add:add, 
		get:get,
		getList : getList,
		remove : remove,
		update : update,
		displayTime : displayTime
	};

})();
