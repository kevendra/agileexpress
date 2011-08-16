package com.express.view.backlogItem
{
import com.express.model.domain.BacklogItem;
import com.express.model.domain.Issue;
import com.express.model.domain.Iteration;
import com.express.model.domain.User;
import com.express.model.request.CreateBacklogItemRequest;

import mx.collections.ArrayCollection;

import org.puremvc.as3.patterns.proxy.Proxy;

public class BacklogItemProxy extends Proxy
{
   public static const NAME : String = "BacklogItemProxy";

   public static const ACTION_ITEM_CREATE : int = 1;
   public static const ACTION_ITEM_EDIT : int = 2;
   public static const ACTION_ITEM_CHILD_CREATE : int = 3;
   public static const ACTION_ITEM_CHILD_EDIT : int = 4;

   public var createBacklogItemRequest : CreateBacklogItemRequest;
   public var currentIssue : Issue;
   public var currentBacklogItem : BacklogItem;
   public var currentIteration : Iteration;
   public var viewAction :int = 0;

   private var _assignToList : ArrayCollection;
   private var _statusList : ArrayCollection;
   private var _selectedBacklog : ArrayCollection;
   private var _selectedBacklogTasks : ArrayCollection;


   public function BacklogItemProxy(proxyName:String = NAME, data:Object = null) {
      super(proxyName, data);
      _assignToList = new ArrayCollection();
      _selectedBacklog = new ArrayCollection();
      _selectedBacklogTasks = new ArrayCollection();
      _statusList = new ArrayCollection();
      _statusList.addItem(BacklogItem.STATUS_OPEN);
      _statusList.addItem(BacklogItem.STATUS_PROGRESS);
      _statusList.addItem(BacklogItem.STATUS_TEST);
      _statusList.addItem(BacklogItem.STATUS_DONE);
   }

   public function get assignToList() : ArrayCollection {
      return _assignToList;
   }

   public function get statusList() : ArrayCollection {
      return _statusList;
   }

   public function get selectedBacklog():ArrayCollection {
      return _selectedBacklog;
   }

   public function set selectedBacklog(value:ArrayCollection):void {
      _selectedBacklog = value;
      _selectedBacklogTasks.source = [];
      for each(var item : BacklogItem in value) {
         for each(var task : BacklogItem in item.tasks) {
            _selectedBacklogTasks.addItem(task);
         }
      }
   }

   public function get selectedBacklogTasks():ArrayCollection {
      return _selectedBacklogTasks;
   }

   public function set selectedBacklogTasks(value:ArrayCollection):void {
      _selectedBacklogTasks = value;
   }

   public function set assignToList(assignToList : ArrayCollection) : void {
      _assignToList.source = [];
      for each(var user : User in assignToList) {
         _assignToList.addItem(user);
      }
   }

}
}