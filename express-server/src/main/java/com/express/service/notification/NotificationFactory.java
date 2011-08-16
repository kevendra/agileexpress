package com.express.service.notification;

import com.express.domain.User;
import com.express.domain.Project;

/**
 * The Notification factory is responsible for building notifications which can then be sent as
 * emails or using any other type of transport available. Each specific type of notication needs
 * a create method in this factory.
 */
public interface NotificationFactory {

   Notification createConfirmationNotification(User user, String url);

   Notification createPasswordReminderNotification(User user);

   Notification createProjectAccessRequestNotification(User applicant, Project project, User manager);

   Notification createProjectAccessRejectNotification(User applicant, Project project);

   Notification createProjectAccessAcceptNotification(User applicant, Project project);

}