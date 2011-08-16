package com.express.model.domain
{
import mx.collections.ArrayCollection;

[RemoteClass(alias="com.express.service.dto.IterationDto")]
public class Iteration {
   public static const MILLIS_IN_A_DAY:int = 86400000;

   public function Iteration(id:Number = 0, title:String = null) {
      backlog = new ArrayCollection();
      history = new ArrayCollection();
      impediments = new ArrayCollection();
      this.id = id;
      this.title = title;
   }

   [Bindable]
   public var id:Number;

   public var version:Number;

   public var title:String;

   public var goal:String;

   [Bindable]
   public var startDate:Date;

   [Bindable]
   public var endDate:Date;

   public var finalVelocity:Number;

   public var project:Project;

   public var backlog:ArrayCollection;

   public var history:ArrayCollection;

   public var impediments:ArrayCollection;

   public function getPoints():int {
      var total:Number = 0;
      for each(var item:BacklogItem in backlog) {
         total += item.effort;
      }
      return total;
   }

   public function getDaysRemaining():int {
      var today:Date = new Date();
      if (today.getTime() >= endDate.getTime()) {
         return 0;
      }
      var millis:Number = today.getTime() < startDate.getTime() ? startDate.getTime() : today.getTime();
      millis = endDate.getTime() - millis;
      var result:Number = millis / MILLIS_IN_A_DAY;
      if (Math.floor(result) < result) {
         result ++;
      }
      return result;
   }

   public function isOpen():Boolean {
      var temp:Date = new Date();
      var today:Date = new Date(temp.fullYear, temp.month, temp.date);
      var start:Date = new Date(startDate.fullYear, startDate.month, startDate.date);
      var end:Date = new Date(endDate.fullYear, endDate.month, endDate.date);
      return today.getTime() <= end.getTime() && today.getTime() >= start.getTime();
   }

   public function getTaskHoursRemaining():int {
      var total:Number = 0;
      for each(var item:BacklogItem in backlog) {
         for each (var task:BacklogItem in item.tasks) {
            total += task.effort;
         }
      }
      return total;
   }

   public function setBacklog(backlogItems:ArrayCollection):void {
      backlog.source = backlogItems.source;
      impediments.source = [];
      for each(var item:BacklogItem in backlog) {
         if (item.impediment) {
            impediments.addItem(item.impediment);
         }
         for each(var task:BacklogItem in item.tasks) {
            if (task.impediment) {
               impediments.addItem(task.impediment);
            }
         }
      }
   }

   public function getBacklogItemById(id : Number) : BacklogItem {
      for each(var item : BacklogItem in backlog) {
         if(item.id == id) {
            return item;
         }
      }
      return null;
   }

   public function copyFrom(iteration:Iteration):void {
      id = iteration.id;
      version = iteration.version;
      title = iteration.title;
      startDate = iteration.startDate;
      endDate = iteration.endDate;
      project = iteration.project;
      goal = iteration.goal;
      history = iteration.history;
      backlog = iteration.backlog;
      finalVelocity = iteration.finalVelocity;
      impediments = iteration.impediments;
   }
}
}