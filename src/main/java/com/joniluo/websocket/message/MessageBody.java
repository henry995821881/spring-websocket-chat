package com.joniluo.websocket.message;

import com.alibaba.fastjson.JSON;

public class MessageBody {

	private String from;
	private String to;
	private String type;
	private String content;
	public String getFrom() {
		return from;
	}
	public void setFrom(String from) {
		this.from = from;
	}
	public String getTo() {
		return to;
	}
	public void setTo(String to) {
		this.to = to;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
	 @Override
	 public String toString() {
		String jsonString = JSON.toJSONString(this);  
		return jsonString;
		 
	 }
	
	
}
