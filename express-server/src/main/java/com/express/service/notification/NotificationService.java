package com.express.service.notification;

import com.express.domain.User;
import com.express.domain.AccessRequest;

public interface NotificationService {
   
   void sendConfirmationNotification(User user);
   
   void sendPasswordReminderNotification(User user);

   void sendProjectAccessRequestNotification(AccessRequest request, User manager);

   void sendProjectAccessAccept(AccessRequest request);

   void sendProjectAccessReject(AccessRequest request);

}
