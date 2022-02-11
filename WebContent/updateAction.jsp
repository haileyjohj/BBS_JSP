<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null){ //로그인 안되어 있으면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");  
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		
		int bbsID = 0;
		//존재하는 글 번호
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		//글번호 0일때
		if(bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");  
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
		Bbs bbs = new BbsDAO().getBbs(bbsID);

		//글을 작성한 사람과 로그인 한 사람이 일치하는지 확인
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글 수정 권한이 없습니다.')");  
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}else{ //수정 권한이 있으면
			if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null 
			|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("") ){ //update에서 수정된 사항들이 파라미터로 제대로 넘어오는지 확인
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('모든 정보를 입력해주세요.')");
				script.print("history.back()"); 
				script.println("</script>");
			}else{ //입력이 되었으면
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
				
				if(result == -1){ //데이터베이스 오류
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정이 실패했습니다.')");
					script.print("history.back()");
					script.println("</script>");
				}else { //정상 수정
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
		}
	
	%>
</body>
</html>