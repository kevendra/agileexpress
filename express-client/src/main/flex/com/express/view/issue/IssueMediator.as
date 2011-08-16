package com.express.view.issue {

import com.express.ApplicationFacade;
import com.express.model.domain.BacklogItem;
import com.express.model.domain.Issue;
import com.express.model.domain.User;
import com.express.model.request.AddImpedimentRequest;
import com.express.view.backlogItem.BacklogItemProxy;
import com.express.view.form.FormMediator;
import com.express.view.form.FormUtility;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;

import org.puremvc.as3.interfaces.INotification;

public class IssueMediator extends FormMediator {
   public static const NAME:String = "IssueMediator";
   public static const CREATE:String = "IssueMediator.CREATE";
   public static const EDIT:String = "IssueMediator.EDIT";

   private var _proxy:BacklogItemProxy;

   public function IssueMediator(viewComp:IssueForm) {
      super(NAME, viewComp);
      _proxy = BacklogItemProxy(facade.retrieveProxy(BacklogItemProxy.NAME));
      viewComp.cboStories.dataProvider = _proxy.selectedBacklog;
      viewComp.cboTasks.dataProvider = _proxy.selectedBacklogTasks;
      viewComp.cboStories.addEventListener(Event.CHANGE, handleStorySelected);
      viewComp.cboTasks.addEventListener(Event.CHANGE, handleTaskSelected);
      viewComp.lstResponsible.dataProvider = _proxy.assignToList;
      viewComp.btnCancel.addEventListener(MouseEvent.CLICK, handleCancel);
      viewComp.btnSave.addEventListener(MouseEvent.CLICK, handleImpedimentSave);
   }

   private function handleTaskSelected(event:Event):void {
      view.cboStories.selectedIndex = -1
   }

   private function handleStorySelected(event:Event):void {
      view.cboTasks.selectedIndex = -1;
   }

   override public function registerValidators():void {
      _validators.push(view.titleValidator);
      _validators.push(view.descriptionValidator);
   }


   override public function listNotificationInterests():Array {
      return [ApplicationFacade.NOTE_EDIT_IMPEDIMENT,
         ApplicationFacade.NOTE_CREATE_IMPEDIMENT];
   }

   override public function handleNotification(notification:INotification):void {
      bindForm();
      view.focusManager.setFocus(view.issueTitle);
      switch (notification.getName()) {
         case ApplicationFacade.NOTE_CREATE_IMPEDIMENT :
            _proxy.viewAction = BacklogItemProxy.ACTION_ITEM_CREATE;
            view.btnSave.label = "Save";
            view.cboStories.enabled = notification.getBody() as Boolean;
            view.cboTasks.enabled = notification.getBody() as Boolean;
            break;
         case ApplicationFacade.NOTE_EDIT_IMPEDIMENT :
            _proxy.viewAction = BacklogItemProxy.ACTION_ITEM_EDIT;
            view.btnSave.label = "Update";
            view.cboStories.enabled = notification.getBody() as Boolean;
            view.cboTasks.enabled = notification.getBody() as Boolean;
            checkIssueClosed();
            break;
      }
   }

   override public function bindForm():void {
      var issue : Issue = _proxy.currentIssue;
      view.issueTitle.text = issue.title;
      view.description.text = issue.description;
      view.cboStories.selectedIndex = getSelectionIndex(getSelectedStoryId(issue.backlogItem), ArrayCollection(view.cboStories.dataProvider));
      view.cboTasks.selectedIndex = getSelectionIndex(getSelectedTaskId(issue.backlogItem), ArrayCollection(view.cboTasks.dataProvider));
      issue.responsible ? view.lstResponsible.selectedIndex = getSelectionIndex(issue.responsible.id, ArrayCollection(view.lstResponsible.dataProvider)) : -1;
      FormUtility.clearValidationErrors(_validators);
   }

   private function checkIssueClosed() : void {
      if(_proxy.currentIssue.statusLabel == "Closed") {
         view.btnSave.enabled = false;
         view.btnCancel.label = "Close";
      }
      else {
         view.btnSave.enabled = true;
         view.btnCancel.label = "Cancel";
      }
   }

   private function getSelectedStoryId(item : BacklogItem) : int {
      if(!item) {
         return -1;
      }
      return item.isStory() ? item.id : item.parent.id;
   }

   private function getSelectedTaskId(item : BacklogItem) : int {
      return !item || item.isStory() ? -1 : item.id;
   }

   private function getSelectionIndex(id:Number, collection:ArrayCollection):int {
      for (var index:int = 0; index < collection.length; index++) {
         if (collection.getItemAt(index).id == id) {
            return index;
         }
      }
      return -1;
   }

   override public function bindModel():void {
      _proxy.currentIssue.title = view.issueTitle.text;
      _proxy.currentIssue.description = view.description.text;
      _proxy.currentIssue.responsible = view.lstResponsible.selectedItem as User;
   }

   private function handleImpedimentSave(event:MouseEvent):void {
      var selectedItem : BacklogItem = getSelectedBacklogItem();
      if (validate(true) && selectedItem) {
         bindModel();
         if (_proxy.viewAction == BacklogItemProxy.ACTION_ITEM_CREATE) {
            var request:AddImpedimentRequest = new AddImpedimentRequest();
            request.impediment = _proxy.currentIssue;
            request.iterationId = _proxy.currentIteration.id;
            request.backlogItemId = selectedItem.id;
            sendNotification(ApplicationFacade.NOTE_ADD_IMPEDIMENT, request);
         }
         else {
            sendNotification(ApplicationFacade.NOTE_UPDATE_IMPEDIMENT, _proxy.currentIssue);
         }
         closeWindow();
      }
      else {
         event.stopImmediatePropagation();
      }
   }

   private function handleCancel(event:MouseEvent):void {
      closeWindow();
   }

   private function closeWindow():void {
      view.parent.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
   }

   protected function get view():IssueForm {
      return viewComponent as IssueForm;
   }

   private function getSelectedBacklogItem():BacklogItem {
      return view.cboTasks.selectedItem ? view.cboTasks.selectedItem as BacklogItem :
                                          view.cboStories.selectedItem as BacklogItem;
   }

}
}