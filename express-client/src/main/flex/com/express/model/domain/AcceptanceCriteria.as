package com.express.model.domain {

[RemoteClass(alias="com.express.service.dto.AcceptanceCriteriaDto")]
public class AcceptanceCriteria {

   public function AcceptanceCriteria() {
   }

   public var id : Number;

   public var version : Number;

   public var reference : String;

   public var title : String;

   public var description : String;

   public var verified : Boolean;

   public var backlogItem : BacklogItem;
}
}