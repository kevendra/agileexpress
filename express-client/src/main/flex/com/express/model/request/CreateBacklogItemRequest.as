package com.express.model.request
{
import com.express.model.domain.BacklogItem;

[RemoteClass(alias="com.express.service.dto.CreateBacklogItemRequest")]
public class CreateBacklogItemRequest {
   public static const UNCOMMITED_STORY : uint = 0;
   public static const STORY : uint = 1;
   public static const TASK : uint = 2;

   public function CreateBacklogItemRequest() {
   }

   public var backlogItem : BacklogItem;

   public var type : uint;

   public var parentId : Number;

   /* public function CreateBacklogItemRequest(backlogItem : BacklogItem) {
    this.backlogItem = backlogItem;
    } */


}
}