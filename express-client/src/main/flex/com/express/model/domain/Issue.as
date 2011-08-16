package com.express.model.domain
{
[RemoteClass(alias="com.express.service.dto.IssueDto")]
public class Issue {

   public function Issue() {
   }

   public var id : Number;

   public var version : Number;

   public var title : String;

   public var description : String;

   public var startDate : Date;

   public var endDate : Date;

   public var backlogItem : BacklogItem;

   public var iteration : Iteration;

   public var responsible : User;

   public function get statusLabel() : String {
      if(endDate) {
         return "Closed";
      }
      return responsible ? "Assigned" : "Unassigned"
   }
}
}