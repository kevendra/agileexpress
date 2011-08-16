package com.express.service.notification;

import com.express.domain.Project;
import com.express.domain.User;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.ui.velocity.VelocityEngineUtils;
import org.springframework.util.Assert;

import java.util.HashMap;
import java.util.Map;

public class NotificationFactoryImpl implements InitializingBean, NotificationFactory {
   private VelocityEngine velocityEngine;
   private String from;
   private String mailheaderImage;
   private String registrationConfirmSubject;
   private String registrationConfirmHtmlTemplate;
   private String passwordReminderSubject;
   private String passwordReminderHtmlTemplate;
   private String projectAccessRequestHtmlTemplate;
   private String projectAccessRequestSubject;
   private String projectAccessRejectHtmlTemplate;
   private String projectAccessRejectSubject;
   private String projectAccessAcceptHtmlTemplate;
   private String projectAccessAcceptSubject;
   
   public void setVelocityEngine(VelocityEngine velocityEngine) {
      this.velocityEngine = velocityEngine;
   }

   public void setFrom(String from) {
      this.from = from;
   }

   public void setMailheaderImage(String mailheaderImage) {
      this.mailheaderImage = mailheaderImage;
   }

   public void setRegistrationConfirmSubject(String registrationConfirmSubject) {
      this.registrationConfirmSubject = registrationConfirmSubject;
   }

   public void setRegistrationConfirmHtmlTemplate(String registrationConfirmHtmlTemplate) {
      this.registrationConfirmHtmlTemplate = registrationConfirmHtmlTemplate;
   }

   public void setPasswordReminderSubject(String passwordReminderSubject) {
      this.passwordReminderSubject = passwordReminderSubject;
   }

   public void setPasswordReminderHtmlTemplate(String passwordReminderHtmlTemplate) {
      this.passwordReminderHtmlTemplate = passwordReminderHtmlTemplate;
   }

   public void setProjectAccessRequestHtmlTemplate(String projectAccessRequestHtmlTemplate) {
      this.projectAccessRequestHtmlTemplate = projectAccessRequestHtmlTemplate;
   }

   public void setProjectAccessRequestSubject(String projectAccessRequestSubject) {
      this.projectAccessRequestSubject = projectAccessRequestSubject;
   }

   public void setProjectAccessRejectHtmlTemplate(String projectAccessRejectHtmlTemplate) {
      this.projectAccessRejectHtmlTemplate = projectAccessRejectHtmlTemplate;
   }

   public void setProjectAccessRejectSubject(String projectAccessRejectSubject) {
      this.projectAccessRejectSubject = projectAccessRejectSubject;
   }

   public void setProjectAccessAcceptHtmlTemplate(String projectAccessAcceptHtmlTemplate) {
      this.projectAccessAcceptHtmlTemplate = projectAccessAcceptHtmlTemplate;
   }

   public void setProjectAccessAcceptSubject(String projectAccessAcceptSubject) {
      this.projectAccessAcceptSubject = projectAccessAcceptSubject;
   }

   public void afterPropertiesSet() throws Exception {
      Assert.notNull(velocityEngine);
   }

   public Notification createConfirmationNotification(User user, String url) {
      Map<String, String> model = createModelWithCommonItems(user.getFullName());
      model.put("emailAddress", user.getEmail());
      model.put("url", url);
      model.put("adminEmail", from);
      String message = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, registrationConfirmHtmlTemplate, model);
      
      return new Notification(from, user.getEmail(), registrationConfirmSubject, message);
   }

   public Notification createPasswordReminderNotification(User user) {
      Map<String, String> model = createModelWithCommonItems(user.getFullName());
      model.put("passwordHint", user.getPasswordHint());
      model.put("adminEmail", from);
      String message = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, passwordReminderHtmlTemplate, model);
      
      return new Notification(from, user.getEmail(), passwordReminderSubject, message);
   }

   public Notification createProjectAccessRequestNotification(User applicant, Project project, User manager) {
      Map<String, String> model = createModelWithCommonItems(manager.getFullName());
      model.put("applicantName", applicant.getFullName());
      model.put("projectName", project.getTitle());
      String message = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, projectAccessRequestHtmlTemplate, model);
      return new Notification(from,manager.getEmail(), projectAccessRequestSubject, message);
   }

   public Notification createProjectAccessRejectNotification(User applicant, Project project) {
      Map<String, String> model = createModelWithCommonItems(applicant.getFullName());
      model.put("projectName", project.getTitle());
      String message = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, projectAccessRejectHtmlTemplate, model);
      return new Notification(from, applicant.getEmail(), projectAccessRejectSubject, message);
   }

   public Notification createProjectAccessAcceptNotification(User applicant, Project project) {
      Map<String, String> model = createModelWithCommonItems(applicant.getFullName());
      model.put("projectName", project.getTitle());
      String message = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, projectAccessAcceptHtmlTemplate, model);
      return new Notification(from, applicant.getEmail(), projectAccessAcceptSubject, message);
   }

   private Map<String, String> createModelWithCommonItems(String fullName) {
      Map<String, String> model = new HashMap<String, String>();
      model.put("headerImage", mailheaderImage);
      model.put("name", fullName);
      return model;
   }
}