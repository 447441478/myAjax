package cn.hncu.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/checkNameServlet")
public class CheckNameServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String regName = request.getParameter("regName");
		//按理这里应该进行dao层查询，这里就模拟了
		//假设hncu开头的才可以注册，其他的都不行
		//响应 "0" 表示可以注册，响应 "1" 表示不可以注册
		
		//*
		/////////////隐藏帧技术--基础版///////////////
		if( regName != null && regName.startsWith("hncu") ) {
			request.setAttribute("error", 0); //隐藏帧技术--基础版
		}else {
			request.setAttribute("error", 1); //隐藏帧技术--基础版
		}
		//隐藏帧技术--基础版
		request.getRequestDispatcher("/jsps/checkResult.jsp").forward(request, response);
		/////////////隐藏帧技术--基础版///////////////
		//*/
		
		/*
		//////////myAjax版/////////////
		if( regName != null && regName.startsWith("hncu") ) {
			response.getWriter().println("0"); //myAjax版
		} else {
			response.getWriter().println("1"); //myAjax版
		}
		//////////myAjax版/////////////
		*/
		
	}

}
