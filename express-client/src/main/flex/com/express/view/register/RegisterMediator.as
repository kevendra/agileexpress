package com.express.view.register {
import com.express.navigation.MenuItem;
import com.express.view.*;
import com.express.ApplicationFacade;
import com.express.controller.RegisterCommand;
import com.express.model.ProfileProxy;
import com.express.model.domain.User;
import com.express.view.form.FormMediator;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.controls.TextInput;
import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.INotification;

public class RegisterMediator extends FormMediator{
   public static const NAME : String = "com.express.view.register.RegisterMediator";

   private var _registrationProxy : ProfileProxy;

   public function RegisterMediator(viewComp : RegisterView) {
      super(NAME, viewComp);
      _registrationProxy = facade.retrieveProxy(ProfileProxy.NAME) as ProfileProxy;
      _registrationProxy.user = new User();
      viewComp.btnCancel.addEventListener(MouseEvent.CLICK, handleCancelButton);
      viewComp.btnSave.addEventListener(MouseEvent.CLICK, handleRegisterButton);
      viewComp.confirmPassword.addEventListener(Event.CHANGE, handleConfirmPassword);
      viewComp.confirmPassword.addEventListener(FocusEvent.FOCUS_OUT, handleConfirmPassword);
      viewComp.password.addEventListener(FocusEvent.FOCUS_OUT, handleConfirmPassword);
      viewComp.addEventListener(FlexEvent.SHOW, handleShowView);
   }

   override public function listNotificationInterests():Array {
      return [RegisterCommand.SUCCESS, RegisterCommand.FAILURE];
   }

   override public function handleNotification(notification : INotification):void {
      switch(notification.getName()) {
         case RegisterCommand.SUCCESS :
            clear();
            sendNotification(ApplicationFacade.NOTE_SHOW_SUCCESS_MSG,"You have successfully " +
                             "registered. An email has been sent to the address provided. Please " +
                             "use the link to confirm your registration.");
            break;
         case RegisterCommand.FAILURE :
            sendNotification(ApplicationFacade.NOTE_SHOW_ERROR_MSG, notification.getBody() as String);
            break;
      }
   }

   private function handleShowView(event : Event) : void {
      clear();
      view.focusManager.setFocus(view.email);
      sendNotification(ApplicationFacade.NOTE_CLEAR_MSG);
   }

   private function handleCancelButton(event : MouseEvent) : void {
      clear();
      sendNotification(ApplicationFacade.NOTE_NAVIGATE,
            new MenuItem(ApplicationMediator.LOGIN_HEAD, ApplicationMediator.LOGIN_VIEW, null));
   }

   private function handleRegisterButton(event : MouseEvent) : void {
      if (validate(true)) {
         bindModel();
         sendNotification(ApplicationFacade.NOTE_REGISTER);
      }
   }

   private function handleConfirmPassword(event : Event) : void {
      var password : TextInput = view.password;
      var confirmPassword : TextInput = view.confirmPassword;
      if (password.text != confirmPassword.text) {
         confirmPassword.errorString = "The confirm password is not the same as the password.";
      }
      else {
         confirmPassword.errorString = "";
      }
   }

   override public function registerValidators():void {
      _validators.push(view.firstNameValidator);
      _validators.push(view.lastNameValidator);
      _validators.push(view.emailValidator);
      _validators.push(view.passwordValidator);
      _validators.push(view.confirmPasswordValidator);
      _validators.push(view.passwordHintValidator);
      _validators.push(view.phone1Validator);
      _validators.push(view.phone2Validator);
   }

   override public function bindForm():void {
      view.firstName.text = _registrationProxy.user.firstName;
      view.lastName.text = _registrationProxy.user.lastName;
      view.email.text = _registrationProxy.user.email;
      view.password.text = _registrationProxy.user.password;
      view.confirmPassword.text = _registrationProxy.user.password;
      view.hint.text = _registrationProxy.user.passwordHint;
      view.phone1.text = _registrationProxy.user.phone1;
      view.phone2.text = _registrationProxy.user.phone2;
   }

   override public function bindModel():void {
      _registrationProxy.user.firstName = view.firstName.text;
      _registrationProxy.user.lastName = view.lastName.text;
      _registrationProxy.user.email = view.email.text;
      _registrationProxy.user.password = view.password.text;
      _registrationProxy.user.passwordHint = view.hint.text;
      _registrationProxy.user.phone1 = view.phone1.text;
      _registrationProxy.user.phone2 = view.phone2.text;
      _registrationProxy.user.colour = view.colour.selectedColor;
   }

   private function clear() : void {
      _registrationProxy.user = new User();
      bindForm();
      resetValidation();
   }

   public function get view() : RegisterView {
      return viewComponent as RegisterView;
   }
}
}