package com.express.model.request
{
[RemoteClass(alias="com.express.service.dto.LoginRequest")]
public class LoginRequest {
   public function LoginRequest() {
   }

   public var username : String;
   public var password : String;
   public var passwordReminderRequest : Boolean;

}
}