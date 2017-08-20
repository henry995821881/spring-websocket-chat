package com.joniluo.websocket.handler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

import com.alibaba.fastjson.JSON;
import com.joniluo.websocket.message.MessageBody;

public class SystemWebSocketHandler implements WebSocketHandler {  
    
    private Logger log = LoggerFactory.getLogger(SystemWebSocketHandler.class);  
      
    private static final ConcurrentHashMap<String,WebSocketSession> usersSession = new ConcurrentHashMap<String,WebSocketSession>();
    
    private static final ConcurrentHashMap<String,String> usersSessionId = new ConcurrentHashMap<String,String>();
    
    private static final ConcurrentHashMap<String,String> sessionIdUsers = new ConcurrentHashMap<String,String>();;  
   
    @Override  
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {  
        System.out.println("ConnectionEstablished");  
        log.debug("ConnectionEstablished");  
        usersSession.put(session.getId(), session);
       // session.sendMessage(new TextMessage("connect"));  
        //session.sendMessage(new TextMessage("new_msg"));  
          
    }  
   
    @Override  
    public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {  
        System.out.println("handleMessage" + message.toString());  
        log.debug("handleMessage" + message.toString());  
        String messageStr=message.getPayload().toString();
        if(messageStr.indexOf("java.nio.HeapByteBuffer")>-1){
        	return;
        }
        MessageBody messageBody = JSON.parseObject(messageStr, MessageBody.class);  
        if(messageBody!=null){
        	if(messageBody.getType().equals("0")){
        		usersSessionId.put(messageBody.getFrom(), session.getId());
        		sessionIdUsers.put(session.getId(), messageBody.getFrom());
        	}
        	if(messageBody.getType().equals("1")){
        		//MessageBody toMessageBody=new MessageBody();
        		//toMessageBody.setFrom(messageBody.getFrom());
        		messageBody.setContent(java.net.URLDecoder.decode(messageBody.getContent(),"UTF-8"));
        		String fromUser=sessionIdUsers.get(session.getId());
        		messageBody.setFrom(fromUser);
        		String toUser=messageBody.getTo();
        		String toSessionId= usersSessionId.get(toUser);
        		if(null!=toSessionId){
        		WebSocketSession toSession= usersSession.get(toSessionId);
	        		if(null!=toSession){
	        			toSession.sendMessage(new TextMessage(messageBody.toString())); 
	        		}else{
	        			
	        		}
        		}
        	}
        }
        //sendMessageToUsers();  
      //  session.sendMessage(new TextMessage(new Date() + ""));  
    }  
   
    @Override  
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {  
        if(session.isOpen()){  
            session.close();  
        }  
        String user=sessionIdUsers.get(session.getId());
        usersSessionId.remove(user);
        sessionIdUsers.remove(session.getId());
       // users.remove(session);  
        usersSession.remove(session.getId());   
        log.debug("handleTransportError" + exception.getMessage());  
    }  
   
    @Override  
    public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {  
       // users.remove(session);  
    	String user=sessionIdUsers.get(session.getId());
        usersSessionId.remove(user);
        sessionIdUsers.remove(session.getId());
    	 usersSession.remove(session.getId());
        log.debug("afterConnectionClosed" + closeStatus.getReason());  
          
    }  
   
    @Override  
    public boolean supportsPartialMessages() {  
        return false;  
    }  
   
    /** 
     * 给所有在线用户发送消息 
     * 
     * @param message 
     */  
    public void sendMessageToUsers(TextMessage message) {  
    	 for(String key : usersSession.keySet()) {  
    		 try {
				usersSession.get(key).sendMessage(message);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }  

//        for (WebSocketSession user : users) {  
//            try {  
//                if (user.isOpen()) {  
//                    user.sendMessage(message);  
//                }  
//            } catch (IOException e) {  
//                e.printStackTrace();  
//            }  
//        }  
    }  
   
}  
