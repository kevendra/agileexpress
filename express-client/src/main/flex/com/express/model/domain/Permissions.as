package com.express.model.domain {

[RemoteClass(alias="com.express.service.dto.PermissionsDto")]
public class Permissions {

   public function Permissions() {
   }

   public var id : Number;

   public var version : Number;

   [Bindable]
   public var iterationAdmin : Boolean;

   [Bindable]
   public var projectAdmin : Boolean;
   
}
}