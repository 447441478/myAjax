<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>演示隐藏帧技术</title>
		<style type="text/css">
			td:first-child {
				width:80px;
				padding-right:10px;
				text-align: right;
			}
		</style>
		
		<script type="text/javascript">
			//通过正则表达式reg，检查value是否符合要求，并且在span显示检查结果
			function check(reg,value,tipSpan,okMsg,errorMsg) {
				var bFlag = reg.test(value);
				if( bFlag ){
					tipSpan.innerHTML=okMsg;
				}else{
					tipSpan.innerHTML=errorMsg;
				}
				return bFlag;
			}
			
			
			function checkPwd() {
				var oPwd = document.getElementsByName("pwd")[0];
				var value = oPwd.value;
				var reg = /^\w{3,10}$/;
				var okMsg="√".fontcolor("#0f0");
				var errorMsg="密码由3~10个的字母、数字或_ 组成。".fontcolor("#f00");
				return check(reg,value,pwdSpan,okMsg,errorMsg);
			}
			function checkPwd2() {
				var check = checkPwd();
				if( check ){
					var oPwd = document.getElementsByName("pwd")[0];
					var oPwd2 = document.getElementsByName("pwd2")[0];
					if(oPwd.value != oPwd2.value){
						pwd2Span.innerHTML="两次密码不一致!".fontcolor("#f00");
						return false;
					}else{
						pwd2Span.innerHTML="√".fontcolor("#0f0");
						return true;
					}
				}
				return false;
			}
			
			function mySubmit() {
				if( 0 == isNameError && checkPwd2() ){
					regForm.submit();
				}
			}
			var isNameError = 1;
			function checkName() {
				isNameError = 1;
				var oName = document.getElementsByName("name")[0];
				var value = oName.value;
				var reg = /^\w{3,10}$/;
				var okMsg="";
				var errorMsg="用户名由3~10个的字母、数字或_ 组成。".fontcolor("#f00");
				var boo = check(reg,value,nameSpan,okMsg,errorMsg);
				if( boo ){
					//*
					///////////隐藏帧技术--基础版////////////
					//开始进行点通讯
					//1.把oName.value赋给 '隐藏表单' 中的 input
					document.getElementsByName("regName")[0].value=value;
					//2.提交'隐藏表单'
					hiddenForm.submit();
					///////////隐藏帧技术--基础版///////////
					//*/
					/*
					//下面采用我自己做的ajax
					myAjax({
						"url":"checkNameServlet",
						"data":{
							"regName":value
							},
						"success":function(data){
							callBack(data);
						}
					});
					*/
				}else{
					return false;
				}
			}
			
			//该函数是回调函数，在jsps/checkResult.jsp中调用
			function callBack(res) {
				isNameError = res;
				if ( isNameError == 0 ) {
					nameSpan.innerHTML="恭喜，用户名可以使用。".fontcolor("#0f0");
				} else {
					nameSpan.innerHTML="用户名已存在,请换一个试一试。".fontcolor("#f00");
				}
			}
			
			//////////////我的ajax/////////////////
			//需要传入一个JSON对象参数
			function myAjax(json) {
				//先获取辅助用的 '隐藏的iframe'
				oIframe = document.getElementsByName("myAjax_hiddenIframe")[0];
				//如果没有就产生一个iframe
				if( !oIframe ){
					//创建<iframe>元素
					oIframe = document.createElement("iframe");
					//设置 name 属性，以便与下面的<form>元素的target属性关联起来
					oIframe.name="myAjax_hiddenIframe";
					//设置<iframe>元素不显示
					oIframe.style.display="none";
					//绑定<iframe>接收到服务器响应后的响应事件
					oIframe.onload = function(){
						myAjaxIframeOnload(this,json["success"]);
					};
					//把<iframe>元素添加到document树上
					document.body.appendChild(oIframe);
				}
				//先获取辅助用的 <form>元素
				oForm = document.getElementById("myAjax_hiddenForm");
				//判断是否为存在，不存在就生成一个<form>元素
				if( !oForm ){
					oForm = document.createElement("form");
					oForm.id = "myAjax_hiddenForm"
					oForm.method="post";
					//下面这一句将form提交后响应目标窗口绑定到上面的iframe元素
					oForm.target=oIframe.name;
					//设置提交的url
					oForm.action=json["url"];
				}
				//先清空oForm中的所有内容
				oForm.innerHTML="";
				//获取需要向后台提交的数据
				var data = json["data"];
				//遍历data-->json对象
				for( var x in data){
					oForm.innerHTML += "<input type='hidden' name='"+x+"' value='"+data[x]+"' />"
				}
				//把<form>元素添加到document树上
				document.body.appendChild(oForm);
				//提交表单
				oForm.submit();
				
			}
			function myAjaxIframeOnload(oIframe, method ){
				var iframeDom = oIframe.contentWindow.document;
				//alert(iframeDom.body.innerHTML);
				//通过alert可以测试不同浏览器的弹框内容,根据具体内容做浏览器兼容
				var iPre = iframeDom.getElementsByTagName("pre")[0];
				if(iPre){//chrome 和  Firefox
					method( iPre.innerHTML );
				}else{//IE
					method( iframeDom.body.innerHTML );
				}
				
			}
			//////////////我的ajax/////////////////
			
			
			/////隐藏帧技术--基础版  -> myAjax 过渡 /////
			//获取iframe中的元素文本内容
			function iframeOnload() {
				//获取隐藏的iframe元素
				var iframe = document.getElementsByName("hiddenIframe")[0];
				//通过iframe.contentWindow.document获取到子页的文档对象
				var iframeDom = iframe.contentWindow.document;
				//这里是模拟ajax,具体分析服务器响应数据格式待完善
				//因为通过chrome和Firefox测试该项目的响应数据可知，数据是<pre>元素的文本内容
				//但是IE却无法响应onload方法，也就调不这个函数，适应性没有ajax强
				//就自己玩玩
				var iPre = iframeDom.getElementsByTagName("pre")[0];
				//alert(iPre.innerHTML);
				if( iPre){
					callBack( iPre.innerHTML );
				}
			}
			/////隐藏帧技术--基础版  -> myAjax 过渡 /////
		</script>
		
	</head>
	<body>
		<h1>通过隐藏帧技术实现点通讯</h1>
		<form id="regForm" action="regServlet" method="post">
		<table>
			<tr>
				<td>用&ensp;户&ensp;名:</td>
				<td><input type="text" name="name" onblur="checkName();"/></td>
				<td><span id="nameSpan"></span></td>
			</tr>
			<tr>
				<td>密&emsp;&emsp;码:</td>
				<td><input type="password" name="pwd" onblur="checkPwd();" /></td>
				<td><span id="pwdSpan"></span></td>
			</tr>
			<tr>
				<td>确认密码:</td>
				<td><input type="password" name="pwd2" onblur="checkPwd2();" /></td>
				<td><span id="pwd2Span"></span></td>
			</tr>
			<tr>
				<td></td>
				<td><input type="button" value="注册" onclick="mySubmit();"/></td>
			</tr>
		</table>
		</form>
		
		<!-- 以下是隐藏帧技术需要的辅助元素 form和iframe 外加 一个/jsps/checkResult.jsp-->
		<form id="hiddenForm" target="hiddenIframe" action="checkNameServlet" method="post">
			<input type="hidden" name="regName" />
		</form>
		<!-- 隐藏帧技术--基础版 -->
		<iframe name="hiddenIframe" style="display: none;" >
		</iframe>
		
		<%-- 
		<!-- 隐藏帧技术--基础版  -> myAjax 过渡 -->
		<!-- 注意 IE 是不支持onload事件 -->
		<iframe name="hiddenIframe" style="display: none;" onload="iframeOnload();">
		</iframe>
		--%>
	</body>
</html>