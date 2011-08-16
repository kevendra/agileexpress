package com.express.view.backlogItem {
import com.express.ApplicationFacade;
import com.express.controller.event.GridButtonEvent;
import com.express.model.ProjectProxy;
import com.express.model.RequestParameterProxy;
import com.express.model.domain.AcceptanceCriteria;
import com.express.model.domain.BacklogItem;
import com.express.model.domain.Project;
import com.express.model.domain.Theme;
import com.express.model.domain.User;
import com.express.model.request.CreateBacklogItemRequest;
import com.express.view.form.FormMediator;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.utils.StringUtil;

import org.puremvc.as3.interfaces.INotification;

public class BacklogItemMediator extends FormMediator {
   public static const NAME:String = "BacklogItemMediator";
   public static const EDIT:String = "Note.start.EditBacklogItem";
   public static const CREATE:String = "Note.start.CreateBacklogItem";

   private var _proxy:BacklogItemProxy;
   private var _projectProxy:ProjectProxy;
   private var _parameterProxy:RequestParameterProxy;

   public function BacklogItemMediator(viewComp:BacklogItemView, mediatorName:String = NAME) {
      super(mediatorName, viewComp);
      _proxy = facade.retrieveProxy(BacklogItemProxy.NAME) as BacklogItemProxy;
      _projectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      _parameterProxy = facade.retrieveProxy(RequestParameterProxy.NAME) as RequestParameterProxy;
      viewComp.backlogItemForm.itemStatus.dataProvider = _proxy.statusList;
      viewComp.backlogItemForm.lstTheme.dataProvider = _projectProxy.themes;

      viewComp.acceptanceCriteriaView.grdCriteria.addEventListener(GridButtonEvent.CLICK, handleGridButton);
      viewComp.btnSave.addEventListener(MouseEvent.CLICK, handleItemSave);
      viewComp.btnCancel.addEventListener(MouseEvent.CLICK, handleCancel);
      viewComp.backlogItemForm.defaultButton = viewComp.btnSave;

      viewComp.acceptanceCriteriaView.btnAdd.addEventListener(MouseEvent.CLICK, handleAddCriteria);
      viewComp.backlogItemForm.lnkAddTheme.addEventListener(MouseEvent.CLICK, handleAddTheme);
      viewComp.backlogItemForm.btnSaveTheme.addEventListener(MouseEvent.CLICK, handleSaveTheme);
      viewComp.backlogItemForm.lnkCancel.addEventListener(MouseEvent.CLICK, handleCancelAddTheme);
   }

   private function handleAddTheme(event:MouseEvent):void {
      view.backlogItemForm.themeItem.visible = false;
      view.backlogItemForm.newThemeItem.visible = true;
   }

   private function handleSaveTheme(event:MouseEvent):void {
      var title:String = view.backlogItemForm.newThemeTitle.text;
      if (title != null && StringUtil.trim(title) != "") {
         var theme:Theme = new Theme();
         theme.title = title;
         _projectProxy.themes.addItem(theme);
         sendNotification(ApplicationFacade.NOTE_UPDATE_THEMES);
         clearAndHideThemeTitle();
      }
      else {
         sendNotification(ApplicationFacade.NOTE_SHOW_ERROR_MSG, "No title entered for theme");
      }
   }

   private function handleCancelAddTheme(event:MouseEvent):void {
      clearAndHideThemeTitle();
   }

   private function clearAndHideThemeTitle():void {
      view.backlogItemForm.newThemeTitle.text = "";
      view.backlogItemForm.newThemeItem.visible = false;
      view.backlogItemForm.themeItem.visible = true;
      sendNotification(ApplicationFacade.NOTE_CLEAR_MSG);
   }


   override public function registerValidators():void {
      view.backlogItemForm.summaryValidator.trigger = view.btnSave;
      view.backlogItemForm.summaryValidator.triggerEvent = MouseEvent.CLICK;
      _validators.push(view.backlogItemForm.summaryValidator);
      view.backlogItemForm.asAValidator.trigger = view.btnSave;
      view.backlogItemForm.asAValidator.triggerEvent = MouseEvent.CLICK;
      _validators.push(view.backlogItemForm.asAValidator);
      view.backlogItemForm.iWantValidator.trigger = view.btnSave;
      view.backlogItemForm.iWantValidator.triggerEvent = MouseEvent.CLICK;
      _validators.push(view.backlogItemForm.iWantValidator);
      view.backlogItemForm.soThatValidator.trigger = view.btnSave;
      view.backlogItemForm.soThatValidator.triggerEvent = MouseEvent.CLICK;
      _validators.push(view.backlogItemForm.soThatValidator);
      view.backlogItemForm.effortValidator.trigger = view.btnSave;
      view.backlogItemForm.effortValidator.triggerEvent = MouseEvent.CLICK;
      _validators.push(view.backlogItemForm.effortValidator);
      view.backlogItemForm.valueValidator.trigger = view.btnSave;
      view.backlogItemForm.valueValidator.triggerEvent = MouseEvent.CLICK;
      _validators.push(view.backlogItemForm.valueValidator);
   }

   private function handleAddCriteria(event:Event):void {
      var criteria:AcceptanceCriteria = new AcceptanceCriteria();
      criteria.backlogItem = _proxy.currentBacklogItem;
      _proxy.currentBacklogItem.acceptanceCriteria.addItem(criteria);
      view.acceptanceCriteriaView.grdCriteria.editedItemPosition = {rowIndex: _proxy.currentBacklogItem.acceptanceCriteria.length - 1, columnIndex: 0};
   }

   private function handleGridButton(event:GridButtonEvent):void {
      var index:int = view.acceptanceCriteriaView.grdCriteria.selectedIndex;
      _proxy.currentBacklogItem.acceptanceCriteria.removeItemAt(index);
   }

   private function handleItemSave(event:MouseEvent):void {
      if (validate(true)) {
         bindModel();
         if (_proxy.viewAction == BacklogItemProxy.ACTION_ITEM_CHILD_EDIT || _proxy.viewAction == BacklogItemProxy.ACTION_ITEM_EDIT) {
            _projectProxy.productBacklogRequest = _proxy.currentBacklogItem.inProductBacklog();
            sendNotification(ApplicationFacade.NOTE_UPDATE_BACKLOG_ITEM, _proxy.currentBacklogItem);
         }
         else {
            var request:CreateBacklogItemRequest = new CreateBacklogItemRequest();
            request.backlogItem = _proxy.currentBacklogItem;
            if (request.backlogItem.project != null) {
               request.type = CreateBacklogItemRequest.UNCOMMITED_STORY;
               request.parentId = request.backlogItem.project.id;
            }
            else {
               if (request.backlogItem.iteration != null) {
                  request.type = CreateBacklogItemRequest.STORY;
                  request.parentId = request.backlogItem.iteration.id;
               }
               else {
                  request.type = CreateBacklogItemRequest.TASK;
                  request.parentId = request.backlogItem.parent.id;
               }
            }
            _projectProxy.productBacklogRequest = request.backlogItem.inProductBacklog();
            sendNotification(ApplicationFacade.NOTE_CREATE_BACKLOG_ITEM, request);
         }
         closeWindow();
      }
      else {
         event.stopImmediatePropagation();
      }
   }

   public function handleCancel(event:MouseEvent):void {
      removeUnsavedAcceptanceCriteria();
      closeWindow();
   }

   private function closeWindow():void {
      clearAndHideThemeTitle();
      TitleWindow(view.parent).removeEventListener(CloseEvent.CLOSE, handleWindowClose);
      view.parent.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      _parameterProxy.removeValue(RequestParameterProxy.BACKLOG_ITEM_ID_PARAM);
   }

   public override function bindModel():void {
      setTypeSpecificFields();
      _proxy.currentBacklogItem.title = view.backlogItemForm.title.text;
      _proxy.currentBacklogItem.effort = int(view.backlogItemForm.effort.text);
      _proxy.currentBacklogItem.businessValue = int(view.backlogItemForm.businessValue.text);
      _proxy.currentBacklogItem.status = view.backlogItemForm.itemStatus.selectedLabel;
      _proxy.currentBacklogItem.assignedTo = view.backlogItemForm.cboAssignedTo.selectedItem as User;
      _proxy.currentBacklogItem.detailedDescription = view.backlogItemForm.descriptionEditor.htmlText;
   }

   private function setTypeSpecificFields():void {
      if (_proxy.viewAction == BacklogItemProxy.ACTION_ITEM_CHILD_CREATE || _proxy.viewAction == BacklogItemProxy.ACTION_ITEM_CHILD_EDIT) {
         _proxy.currentBacklogItem.summary = view.backlogItemForm.summary.text;
      }
      else {
         _proxy.currentBacklogItem.themes.source = view.backlogItemForm.lstTheme.selectedItems;
         _proxy.currentBacklogItem.asA = view.backlogItemForm.asA.text;
         _proxy.currentBacklogItem.want = view.backlogItemForm.iWant.text;
         _proxy.currentBacklogItem.soThat = view.backlogItemForm.soThat.text;
         _proxy.currentBacklogItem.summary = "As " + view.backlogItemForm.asA.text + " I want " + view.backlogItemForm.iWant.text + " so that " + view.backlogItemForm.soThat.text;
      }
   }

   public override function bindForm():void {
      view.backlogItemForm.asA.dataProvider = _projectProxy.selectedProject.actors;
      view.acceptanceCriteriaView.grdCriteria.dataProvider = _proxy.currentBacklogItem.acceptanceCriteria;
      view.backlogItemForm.title.text = _proxy.currentBacklogItem.title;
      view.backlogItemForm.itemStatus.selectedItem = _proxy.currentBacklogItem.status;
      view.backlogItemForm.effort.text = _proxy.currentBacklogItem.effort.toString();
      view.backlogItemForm.businessValue.text = _proxy.currentBacklogItem.businessValue.toString();
      view.backlogItemForm.cboAssignedTo.dataProvider = _projectProxy.developers;
      view.backlogItemForm.cboAssignedTo.selectedIndex = _projectProxy.getDeveloperIndex(_proxy.currentBacklogItem.assignedTo);
      view.backlogItemForm.descriptionEditor.textArea.htmlText = _proxy.currentBacklogItem.detailedDescription;
      if (_proxy.viewAction == BacklogItemProxy.ACTION_ITEM_CHILD_CREATE || _proxy.viewAction == BacklogItemProxy.ACTION_ITEM_CHILD_EDIT) {
         view.backlogItemForm.summary.text = _proxy.currentBacklogItem.summary;
         view.backlogItemForm.focusManager.setFocus(view.backlogItemForm.summary);
      }
      else {
         view.backlogItemForm.asA.text = _proxy.currentBacklogItem.asA;
         view.backlogItemForm.iWant.text = _proxy.currentBacklogItem.want;
         view.backlogItemForm.soThat.text = _proxy.currentBacklogItem.soThat;
         view.backlogItemForm.lstTheme.selectedIndices = getSelectedThemeIndices(_proxy.currentBacklogItem.themes.source);
         view.backlogItemForm.focusManager.setFocus(view.backlogItemForm.asA);
      }
      resetValidation();
      view.tbViews.selectedIndex = 0;
   }

   private function handleWindowClose(event:Event):void {
      removeUnsavedAcceptanceCriteria();
      _parameterProxy.removeValue(RequestParameterProxy.BACKLOG_ITEM_ID_PARAM);
   }

   private function removeUnsavedAcceptanceCriteria():void {
      var copy:Array = _proxy.currentBacklogItem.acceptanceCriteria.source.concat();
      _proxy.currentBacklogItem.acceptanceCriteria.source = [];
      for each(var criteria:AcceptanceCriteria in copy) {
         if (criteria.id > 0) {
            _proxy.currentBacklogItem.acceptanceCriteria.addItem(criteria);
         }
      }
   }

   private function getSelectedThemeIndices(themes:Array):Array {
      var indices:Array = [];
      var projectThemes:ArrayCollection = _projectProxy.themes;
      for each(var theme:Theme in themes) {
         for (var index:int = 0; index < projectThemes.length; index++) {
            if (theme.id == projectThemes[index].id) {
               indices.push(index);
               break;
            }
         }
      }
      return indices;
   }

   public override function listNotificationInterests():Array {
      return [EDIT, CREATE];
   }

   public override function handleNotification(notification:INotification):void {
      TitleWindow(view.parent).addEventListener(CloseEvent.CLOSE, handleWindowClose);
      _proxy.currentBacklogItem = BacklogItem(notification.getBody());
      switch (notification.getName()) {
         case CREATE :
            if (_proxy.currentBacklogItem.parent == null) {
               _proxy.viewAction = BacklogItemProxy.ACTION_ITEM_CREATE;
               TitleWindow(view.parent).title = "New Story";
               setStoryView();
            }
            else {
               _proxy.viewAction = BacklogItemProxy.ACTION_ITEM_CHILD_CREATE;
               TitleWindow(view.parent).title = "Add Task for " + _proxy.currentBacklogItem.parent.reference;
               setTaskView();
            }
            break;
         case EDIT :
            if (_proxy.currentBacklogItem.parent == null) {
               _proxy.viewAction = BacklogItemProxy.ACTION_ITEM_EDIT;
               TitleWindow(view.parent).title = "Editing Story " + _proxy.currentBacklogItem.reference;
               setStoryView();
            }
            else {
               _proxy.viewAction = BacklogItemProxy.ACTION_ITEM_CHILD_EDIT;
               TitleWindow(view.parent).title = "Editing Task " + _proxy.currentBacklogItem.reference;
               setTaskView();
            }
            break;
      }
      bindForm();
   }

   private function setTaskView():void {
      view.backlogItemForm.businessValueItem.visible = false;
      view.backlogItemForm.businessValueItem.includeInLayout = false;
      view.backlogItemForm.effortUnitLabel.text = Project.EFFORT_HOURS;
      view.backlogItemForm.asItem.visible = false;
      view.backlogItemForm.asItem.includeInLayout = false;
      view.backlogItemForm.iWantItem.visible = false;
      view.backlogItemForm.iWantItem.includeInLayout = false;
      view.backlogItemForm.soThatItem.visible = false;
      view.backlogItemForm.soThatItem.includeInLayout = false;
      view.backlogItemForm.themeItem.visible = false;
      view.backlogItemForm.themeItem.includeInLayout = false;
      view.backlogItemForm.summaryItem.visible = true;
      view.backlogItemForm.summaryItem.includeInLayout = true;
   }

   private function setStoryView():void {
      view.backlogItemForm.businessValueItem.visible = true;
      view.backlogItemForm.businessValueItem.includeInLayout = true;
      view.backlogItemForm.effortUnitLabel.text = _proxy.currentBacklogItem.getProject().effortUnit;
      view.backlogItemForm.asItem.visible = true;
      view.backlogItemForm.asItem.includeInLayout = true;
      view.backlogItemForm.iWantItem.visible = true;
      view.backlogItemForm.iWantItem.includeInLayout = true;
      view.backlogItemForm.soThatItem.visible = true;
      view.backlogItemForm.soThatItem.includeInLayout = true;
      view.backlogItemForm.themeItem.visible = true;
      view.backlogItemForm.themeItem.includeInLayout = true;
      view.backlogItemForm.summaryItem.visible = false;
      view.backlogItemForm.summaryItem.includeInLayout = false;
   }

   public function get view():BacklogItemView {
      return viewComponent as BacklogItemView;
   }
}
}