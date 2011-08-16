package com.express.model.domain
{
[RemoteClass(alias="com.express.service.dto.DailyIterationStatusRecordDto")]
public class DailyIterationStatusRecord {

   public function DailyIterationStatusRecord() {
   }

   public var id : Number;

   public var date : Date;

   public var taskHoursRemaining : int;

   public var totalPoints : int;

   public var completedPoints : int;
}
}