<%@ page contentType="text/html;charset=utf-8" language="java"
	pageEncoding="UTF-8" import="java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
<head>  
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
<title>WebSocket/SockJS Echo Sample (Adapted from Tomcat's echo sample)</title>  
   <style type="text/css">  
       #connect-container {  
           float: left;  
           width: 400px  
       }  
 
       #connect-container div {  
           padding: 5px;  
       }  
 
       #console-container {  
           float: left;  
           margin-left: 15px;  
           width: 400px;  
       }  
 
       #console {  
           border: 1px solid #CCCCCC;  
           border-right-color: #999999;  
           border-bottom-color: #999999;  
           height: 170px;  
           overflow-y: scroll;  
           padding: 5px;  
           width: 100%;  
       }  
 
       #console p {  
           padding: 0;  
           margin: 0;  
       }  
   </style>  
 
   <script src="http://cdn.sockjs.org/sockjs-0.3.min.js"></script>  
 
   <script type="text/javascript">  
       var ws = null;  
       var url = null;  
       var transports = [];  
 
       function setConnected(connected) {  
           document.getElementById('connect').disabled = connected;  
           document.getElementById('disconnect').disabled = !connected;  
           document.getElementById('echo').disabled = !connected;  
           var userName = document.getElementById('userName').value;  
            
           var message="{\"from\":\""+userName +"\",\"type\":\"0\"}";
          // log('Sent: ' + message);
           ws.send(message);  
       }  
 	   function sendMessageTo(userName,msg){
 		  var message="{\"to\":\""+userName +"\",\"type\":\"1\",\"content\":\""+encodeURIComponent(msg) +"\"}";
          //log('Sent: ' + message);
          ws.send(message);  
 	   }
       function connect() {  
          // if (!url) {  
            // /  alert('Select whether to use W3C WebSocket or SockJS');  
             //  return;  
          // }  
             
             
           ws = new WebSocket('ws://127.0.0.1:8090/spring-websocket-chat/webSocketServer');/* (url.indexOf('sockjs') != -1) ?   
               //new SockJS(url, undefined, {protocols_whitelist: transports}) :  */  
            // ws = new SockJS("http://127.0.0.1:8088/websocket/sockjs");  
               //console.log("http://192.168.10.107:8080/mspjapi/webSocketServer/sockjs");  
                 
           ws.onopen = function () {  
               setConnected(true);  
               log('Info: connection opened.');  
           };  
             
           ws.onmessage = function (event) {  
               log('Received: ' + event.data);  
           };  
             
           ws.onclose = function (event) {  
               setConnected(false);  
               log('Info: connection closed.');  
               log(event);  
           };  
       }  
 
       function disconnect() {  
           if (ws != null) {  
               ws.close();  
               ws = null;  
           }  
           setConnected(false);  
       }  
 
       function echo() {  
           if (ws != null) {  
        	   var touserName = document.getElementById('touserName').value; 
        	   if(touserName==''){
        		   alert('输入发送对象');
        		   return;
        	   }
               var message = document.getElementById('message').value;  
               //log('Sent: ' + message);  
               sendMessageTo(touserName,message);
               //ws.send(message);  
           } else {  
               alert('connection not established, please connect.');  
           }  
       }  
 
       function updateUrl(urlPath) {  
           if (urlPath.indexOf('sockjs') != -1) {  
               url = urlPath;  
                document.getElementById('sockJsTransportSelect').style.visibility = 'visible';  
            }  
            else {  
              if (window.location.protocol == 'http:') {  
                  url = 'ws://' + window.location.host + urlPath;  
              } else {  
                  url = 'wss://' + window.location.host + urlPath;  
              }  
              document.getElementById('sockJsTransportSelect').style.visibility = 'hidden';  
            }  
           alert(url);
        }  
  
        function updateTransport(transport) {  
          transports = (transport == 'all') ?  [] : [transport];  
        }  
          
        function log(message) {  
            var console = document.getElementById('console');  
            var p = document.createElement('p');  
            p.style.wordWrap = 'break-word';  
            p.appendChild(document.createTextNode(message));  
            console.appendChild(p);  
            while (console.childNodes.length > 25) {  
                console.removeChild(console.firstChild);  
            }  
            console.scrollTop = console.scrollHeight;  
        }  
    </script>  
</head>  
<body>  
<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websockets   
    rely on Javascript being enabled. Please enable  
    Javascript and reload this page!</h2></noscript>  
<div>  
    <div id="connect-container"> 
    <label>用户名:</label>  
      <input id="userName"  name="userName"  value="test">   
        <br>       
        <div>  
            <button id="connect" onclick="connect();">Connect</button>  
            <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>  
        </div>  
        <div>  
            <label>发送给:</label>  
      	  <input id="touserName"  name="touserName"  value="test1">   
            <textarea id="message" style="width: 350px">发送给test1的消息</textarea>  
        </div>  
        <div>  
            <button id="echo" onclick="echo();" disabled="disabled">send message</button>  
        </div>  
    </div>  
    <div id="console-container">  
        <div id="console"></div>  
    </div>  
</div>  
  
<a href="echoendpoint.jsp">echoendpoint test</a>  
<a href="websocket2.jsp">echoendpoint test</a>  
  
</body>  
</html>
