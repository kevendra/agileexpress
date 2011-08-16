package com.express.view.profile
{
import com.express.ApplicationFacade;
import com.express.controller.ChangePasswordCommand;
import com.express.controller.UpdateUserCommand;
import com.express.model.ProfileProxy;
import com.express.model.ProjectProxy;
import com.express.model.SecureContextProxy;
import com.express.model.domain.User;
import com.express.model.request.ChangePasswordRequest;
import com.express.view.form.FormMediator;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.INotification;

public class ProfileMediator extends FormMediator
{
   public static const NAME : String = "com.express.view.profile.ProfileMediator";

   private var _proxy : ProfileProxy;
   private var _secureContext : SecureContextProxy;

   public function ProfileMediator(viewComp : ProfileView, mediatorName : String = NAME) {
      super(mediatorName, viewComp);
      _proxy = facade.retrieveProxy(ProfileProxy.NAME) as ProfileProxy;
      _secureContext = facade.retrieveProxy(SecureContextProxy.NAME) as SecureContextProxy;
      viewComp.resetButton.addEventListener(MouseEvent.CLICK, handleReset);
      viewComp.updateButton.addEventListener(MouseEvent.CLICK, handleUpdateUser);
      viewComp.changePwdButton.addEventListener(MouseEvent.CLICK, handlePasswordChange);
      viewComp.cancelPwdButton.addEventListener(MouseEvent.CLICK, handlePasswordChangeCancel);
      viewComp.updatePwdButton.addEventListener(MouseEvent.CLICK, handlePasswordChangeSubmit);
      viewComp.addEventListener(FlexEvent.SHOW, handleShowView);

   }

   override public function registerValidators():void {
      _validators.push(view.firstNameValidator);
      _validators.push(view.lastNameValidator);
      _validators.push(view.phone1Validator);
      _validators.push(view.phone2Validator);
   }

   override public function listNotificationInterests():Array {
      return [ChangePasswordCommand.SUCCESS,
         ChangePasswordCommand.FAILURE,
         UpdateUserCommand.SUCCESS,
         UpdateUserCommand.FAILURE];
   }

   override public function handleNotification(notification : INotification):void {
      switch (notification.getName()) {
         case ChangePasswordCommand.SUCCESS :
            sendNotification(ApplicationFacade.NOTE_SHOW_SUCCESS_MSG, "Your password has been updated.");
            view.changePasswordPanel.visible = false;
            break;
         case ChangePasswordCommand.FAILURE :
            sendNotification(ApplicationFacade.NOTE_SHOW_ERROR_MSG, String(notification.getBody()));
            view.changePasswordPanel.visible = false;
            break;
         case UpdateUserCommand.SUCCESS :
            _secureContext.currentUser = notification.getBody() as User;
            ProjectProxy(facade.retrieveProxy(ProjectProxy.NAME)).updateCurrentUser(_secureContext.currentUser);
            sendNotification(ApplicationFacade.NOTE_SHOW_SUCCESS_MSG, "Your details have been updated");
            break;
      }
   }

   private function handleShowView(event : Event) : void {
      _proxy.user = _secureContext.currentUser;
      bindForm();
      sendNotification(ApplicationFacade.NOTE_CLEAR_MSG);
      view.focusManager.setFocus(view.firstName);
   }

   private function handleReset(event : Event) : void {
      bindForm();
   }

   private function handleUpdateUser(event : Event) : void {
      if (validate(true)) {
         bindModel();
         sendNotification(ApplicationFacade.NOTE_UPDATE_USER);
      }
   }

   private function handlePasswordChange(event : Event) : void {
      view.currentPassword.text = "";
      view.password.text = "";
      view.confirmPassword.text = "";
      view.changePasswordPanel.x = event.target.mouseX;
      view.changePasswordPanel.y = event.target.mouseY;
      view.changePasswordPanel.visible = true;
      view.changePasswordPanel.focusManager.setFocus(view.currentPassword);
   }

   private function handlePasswordChangeCancel(event : Event) : void {
      view.changePasswordPanel.visible = false;
   }

   private function handlePasswordChangeSubmit(event : Event) : void {
      if (validatePasswords()) {
         var request : ChangePasswordRequest = new ChangePasswordRequest();
         request.userId = _proxy.user.id;
         request.oldPassword = view.currentPassword.text;
         request.newPassword = view.password.text;
         sendNotification(ApplicationFacade.NOTE_CHANGE_PASSWORD, request);
      }
   }

   private function validatePasswords() : Boolean {
      var result : Boolean = view.password.text == view.confirmPassword.text;
      if (!result) {
         view.password.errorString = "Your passwords do not match";
         view.confirmPassword.errorString = "Your passwords do not match";
      }
      return result;
   }

   public override function bindForm() : void {
      view.firstName.text = _proxy.user.firstName;
      view.lastName.text = _proxy.user.lastName;
      view.phone1.text = _proxy.user.phone1;
      view.phone2.text = _proxy.user.phone2;
      view.colour.selectedColor = _proxy.user.colour;
   }

   public override function bindModel() : void {
      _proxy.user.firstName = view.firstName.text;
      _proxy.user.lastName = view.lastName.text;
      _proxy.user.phone1 = view.phone1.text;
      _proxy.user.phone2 = view.phone2.text;
      _proxy.user.colour = view.colour.selectedColor;
   }

   public function get view() : ProfileView {
      return viewComponent as ProfileView;
   }

}
}