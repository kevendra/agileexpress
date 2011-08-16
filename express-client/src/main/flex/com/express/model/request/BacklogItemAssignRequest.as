package com.express.model.request
{
[RemoteClass(alias="com.express.service.dto.BacklogItemAssignRequest")]
public class BacklogItemAssignRequest
{
   public function BacklogItemAssignRequest() {
      itemIds = [];
   }
   public var projectId : Number;

   public var iterationFromId : Number;

   public var iterationToId : Number;

   public var itemIds : Array;

}
}