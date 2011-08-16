package com.express.model.request {

[RemoteClass(alias="com.express.service.dto.ChangePasswordRequest")]
public class ChangePasswordRequest {

   public function ChangePasswordRequest() {
   }

   public var oldPassword : String;

   public var newPassword : String;

   public var userId : Number;

}
}