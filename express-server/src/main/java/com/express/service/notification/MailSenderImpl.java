package com.express.service.notification;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service("mailSender")
public class MailSenderImpl implements MailSender{
   private static final Log LOG = LogFactory.getLog(MailSenderImpl.class);
   private final JavaMailSender mailer;
   
   @Autowired
   public MailSenderImpl(@Qualifier("mailer")JavaMailSender mailer) {
      this.mailer = mailer;
   }


   public void sendMail(final Notification notification) {
      try {
         MimeMessage mimeMsg = mailer.createMimeMessage();
         MimeMessageHelper helper = new MimeMessageHelper(mimeMsg);
         helper.setTo(notification.getTo());
         helper.setFrom(notification.getFrom());
         helper.setSubject(notification.getsubject());
         helper.setText(notification.getMessage(), true); //text included is html
         
         mailer.send(mimeMsg);   
      }
      catch (MessagingException e) {
         LOG.error("Unable to send mail [" + notification.getsubject() + "]", e);
      }
   }
}
