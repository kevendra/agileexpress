package com.express.model.domain {

[RemoteClass(alias="com.express.service.dto.AccessRequestDto")]
public class AccessRequest {

   public static const UNRESOLVED : uint = 0;
   public static const APPROVED : uint = 1;
   public static const REJECTED : uint = 2;

   public function AccessRequest() {
   }

   public var id : Number;

   public var version : Number;

   public var requestor : User;

   public var requestDate : Date;

   public var resolvedDate : Date;

   public var status : int;

   public var reason : String;

   public var project : Project;
}
}