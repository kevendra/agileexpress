package com.express.service.notification;

public class Notification {
	private String to;
	private String from;
	private String message;
	private String subject;
	
	public Notification(String from, String to, String subject, String message) {
		this.from = from;
		this.to = to;
		this.subject = subject;
		this.message = message;	
	}
	
	public String getTo() {
		return this.to;
	}
	
	public void setTo(String to) {
		this.to = to;
	}
	
	public String getFrom() {
		return this.from;
	}
	
	public void setFrom(String from) {
		this.from = from;
	}
	
	public String getMessage() {
		return this.message;
	}
	
	public void setmessage(String message) {
		this.message = message;
	}
	
	public String getsubject() {
		return this.subject;
	}
	
	public void setSubject(String subject) {
		this.subject = subject;
	}
}
