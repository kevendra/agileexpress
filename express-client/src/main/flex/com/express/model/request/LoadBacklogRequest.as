package com.express.model.request
{

[RemoteClass(alias="com.express.service.dto.LoadBacklogRequest")]
public class LoadBacklogRequest {

   public function LoadBacklogRequest() {
   }

   public static const TYPE_ITERATION : uint = 0;
   public static const TYPE_PROJECT : uint = 1;

   public var type : uint;

   public var parentId : Number;
}
}