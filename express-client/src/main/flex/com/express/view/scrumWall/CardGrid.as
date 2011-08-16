package com.express.view.scrumWall {
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.model.SecureContextProxy;
import com.express.model.WallProxy;
import com.express.model.domain.BacklogItem;

import com.express.model.domain.User;
import com.express.view.components.AssignmentPopup;

import flash.events.Event;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.managers.DragManager;
import mx.managers.PopUpManager;

public class CardGrid extends Grid {

   private var _tasks : ArrayCollection;
   private var _facade : ApplicationFacade;
   private var _wallProxy : WallProxy;
   private var _assignmentPopup : AssignmentPopup;
   private var _secureContext : SecureContextProxy;
   private var _projectProxy : ProjectProxy;
   private var _rows : int;

   public var story : BacklogItem;

   public var gridStatus : String;

   public function CardGrid() {
      super();
      _tasks = new ArrayCollection();
      _facade = ApplicationFacade.getInstance();
      _wallProxy = WallProxy(_facade.retrieveProxy(WallProxy.NAME));
      _projectProxy = ProjectProxy(_facade.retrieveProxy(ProjectProxy.NAME));
      _secureContext = SecureContextProxy(_facade.retrieveProxy(SecureContextProxy.NAME));
      this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
      this.addEventListener(DragEvent.DRAG_ENTER, handleDragEnter);
      this.addEventListener(DragEvent.DRAG_DROP, handleDrop);
   }

   private function handleCreationComplete(event : FlexEvent) : void {
      layoutCards();
   }
   
   public function layoutCards() : void {
      if(this.getChildren().length > 0) {
         this.removeAllChildren();
      }
      var cardsPerRow : int = Math.floor(this.width / WallRow.CARD_WIDTH);
      var index : int = 0;
      _rows = 1;
      var row : GridRow = new GridRow();
      var card : TaskCard;
      for each(var task : BacklogItem in _tasks) {
         if(index != 0 && index % cardsPerRow == 0) {
            this.addChild(row);
            row = new GridRow();
            _rows++;
         }
         card = new TaskCard();
         card.task = task;
         var item : GridItem = new GridItem();
         item.addChild(card);
         row.addChild(item);
         index++;
      }
      this.addChild(row);
      WallRow(this.parent).setRowHeight((WallRow.CARD_HEIGHT + 5) * _rows);
   }

   public function getLayedOutHeight() : int {
      return (WallRow.CARD_HEIGHT + 5) * _rows;
   }

   private function handleDrop(event:DragEvent):void {
      var task : BacklogItem = TaskCard(event.dragSource.dataForFormat("taskCard")).task;
      if(!task.assignedTo && gridStatus == BacklogItem.STATUS_PROGRESS) {
         _wallProxy.inProgressItem = task;
         PopUpManager.addPopUp(getAssignmentPopUp(), this, true);
         PopUpManager.centerPopUp(_assignmentPopup);
      }
      else {
         buildAndSendUpdateNotification(task);
      }
   }

   private function buildAndSendUpdateNotification(task : BacklogItem) : void {
      task.status = gridStatus;
      if(gridStatus == BacklogItem.STATUS_DONE) {
         task.effort = 0;
      }
      _facade.sendNotification(ApplicationFacade.NOTE_UPDATE_BACKLOG_ITEM, task);
   }

   private function handleDragEnter(event:DragEvent):void {
      if(event.dragSource.hasFormat("taskCard")) {
         var taskCard : TaskCard = event.dragSource.dataForFormat("taskCard") as TaskCard;
         if(taskCard.task.parent.id == story.id && taskCard.task.status != this.gridStatus) {
            DragManager.acceptDragDrop(this);
            DragManager.showFeedback(DragManager.COPY);
         }
      }
   }

   public function set tasks(value:Array):void {
      var refresh : Boolean = value.length != _tasks.length;
      if(_tasks.length == 0) {
         _tasks.source = value;
      }
      else {
         removeItemsNotInTasks(value);
         for each(var item : BacklogItem in value) {
            var task : BacklogItem = findInTasks(item.id);
            if(task) {
               task.copyFrom(item);
            }
            else {
               _tasks.addItem(item);
            }
         }
      }
      if(refresh) {
         layoutCards();
      }
      else {
         WallRow(this.parent).setRowHeight((WallRow.CARD_HEIGHT + 5) * _rows);
      }
   }

   private function findInTasks(id : Number) : BacklogItem {
      for each(var task : BacklogItem in _tasks) {
         if(task.id == id) {
            return task;
         }
      }
      return null;
   }

   private function removeItemsNotInTasks(tasks : Array) : void {
      for(var index : int; index < _tasks.length; index++) {
         var existingTask : BacklogItem = BacklogItem(_tasks[index]);
         var found : Boolean = false;
         for each(var task : BacklogItem in tasks) {
            if(task.id == existingTask.id) {
               found = true;
               break;
            }
         }
         if(!found) {
            _tasks.removeItemAt(index--);
         }
      }
   }

   private function handleAssigned(event : Event) : void {
      var task : BacklogItem = _wallProxy.inProgressItem;
      task.assignedTo = _assignmentPopup.cboAssignedTo.selectedItem as User;
      buildAndSendUpdateNotification(task);
      PopUpManager.removePopUp(_assignmentPopup);
   }

   private function getAssignmentPopUp() : AssignmentPopup {
      if(! _assignmentPopup) {
         _assignmentPopup = new AssignmentPopup();
         _assignmentPopup.addEventListener(FlexEvent.CREATION_COMPLETE, handlePopUpCreationComplete);
      }
      else {
         _assignmentPopup.cboAssignedTo.selectedItem = getAssigneeIndex(_secureContext.currentUser.id);
      }
      return _assignmentPopup;
   }

   private function handlePopUpCreationComplete(event : Event) : void {
      _assignmentPopup.cboAssignedTo.dataProvider = _projectProxy.developers;
      _assignmentPopup.btnAssign.addEventListener(MouseEvent.CLICK, handleAssigned);
      _assignmentPopup.cboAssignedTo.selectedIndex = getAssigneeIndex(_secureContext.currentUser.id);
   }

   private function getAssigneeIndex(id :int) : int {
      for(var index : int ; index < _projectProxy.developers.length; index++) {
         if(_projectProxy.developers[index].id == id) {
            return index;
         }
      }
      return -1;
   }
}
}