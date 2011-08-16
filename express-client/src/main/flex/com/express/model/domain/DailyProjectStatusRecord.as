package com.express.model.domain
{
[RemoteClass(alias="com.express.service.dto.DailyProjectStatusRecordDto")]
public class DailyProjectStatusRecord {

   public function DailyProjectStatusRecord() {
   }

   public var id : Number;

   public var date : Date;

   public var totalPoints : int;

   public var completedPoints : int;
}
}