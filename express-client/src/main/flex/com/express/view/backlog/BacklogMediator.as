package com.express.view.backlog
{
import com.express.ApplicationFacade;
import com.express.controller.IterationCreateCommand;
import com.express.controller.IterationLoadCommand;
import com.express.controller.IterationUpdateCommand;
import com.express.controller.ProjectLoadCommand;
import com.express.controller.event.GridButtonEvent;
import com.express.model.ProjectProxy;
import com.express.model.SecureContextProxy;
import com.express.model.domain.BacklogFilter;
import com.express.model.domain.BacklogItem;
import com.express.model.domain.Theme;
import com.express.model.request.BacklogItemAssignRequest;
import com.express.view.backlogItem.BacklogItemMediator;

import flash.events.MouseEvent;

import mx.collections.IHierarchicalCollectionView;
import mx.controls.AdvancedDataGrid;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.managers.DragManager;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

public class BacklogMediator extends Mediator {
   public static const NAME:String = "BacklogViewMediator";

   private var _proxy:ProjectProxy;
   private var _secureContext:SecureContextProxy;

   public function BacklogMediator(viewComp:BacklogView) {
      super(NAME, viewComp);
      _proxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      _secureContext = facade.retrieveProxy(SecureContextProxy.NAME) as SecureContextProxy;

      viewComp.grdIterationBacklog.dataProvider = _proxy.selectedBacklog;
      viewComp.grdProductBacklog.dataProvider = _proxy.productBacklog;
      viewComp.grdIterationBacklog.dataTipFunction = buildToolTip;
      viewComp.grdProductBacklog.dataTipFunction = buildToolTip;

      viewComp.grdIterationBacklog.addEventListener(GridButtonEvent.CLICK, handleGridButton);
      viewComp.grdProductBacklog.addEventListener(GridButtonEvent.CLICK, handleGridButton);
      viewComp.grdIterationBacklog.addEventListener(MouseEvent.DOUBLE_CLICK, handleGridDoubleClick);
      viewComp.grdProductBacklog.addEventListener(MouseEvent.DOUBLE_CLICK, handleGridDoubleClick);
      viewComp.btnCreateItem.addEventListener(MouseEvent.CLICK, handleCreateBacklogItem);
      viewComp.btnProductCreateItem.addEventListener(MouseEvent.CLICK, handleCreateProductBacklogItem);
      viewComp.grdIterationBacklog.addEventListener(DragEvent.DRAG_DROP, dropInIteration);
      viewComp.grdProductBacklog.addEventListener(DragEvent.DRAG_DROP, dropInProductBacklog);

      viewComp.grdProductBacklog.addEventListener(DragEvent.DRAG_ENTER, handleDragEnter);
      viewComp.grdIterationBacklog.addEventListener(DragEvent.DRAG_ENTER, handleDragEnter);

      viewComp.lnkProductBacklogFilter.addEventListener(MouseEvent.CLICK, handleShowProductBacklogFilterPanel);
      viewComp.lnkRemoveProductBacklogFilter.addEventListener(MouseEvent.CLICK, handleRemoveProductBacklogFilter);
      viewComp.lnkIterationBacklogFilter.addEventListener(MouseEvent.CLICK, handleShowIterationBacklogFilterPanel);
      viewComp.lnkRemoveIterationBacklogFilter.addEventListener(MouseEvent.CLICK, handleRemoveIterationBacklogFilter);

      if (_proxy.selectedProject != null) {
         projectLoaded();
      }
   }

   private function handleRemoveProductBacklogFilter(event:MouseEvent):void {
      removeGridFilter(view.grdProductBacklog);
      view.lnkRemoveProductBacklogFilter.enabled = false;
   }

   private function handleRemoveIterationBacklogFilter(event:MouseEvent):void {
      removeGridFilter(view.grdIterationBacklog);
      view.lnkRemoveIterationBacklogFilter.enabled = false;
   }

   private function handleShowProductBacklogFilterPanel(event:MouseEvent):void {
      sendNotification(ApplicationFacade.NOTE_SHOW_FILTER_DIALOG, event, ApplicationFacade.NOTE_APPLY_PRODUCT_BACKLOG_FILTER);
   }

   private function handleShowIterationBacklogFilterPanel(event:MouseEvent):void {
      sendNotification(ApplicationFacade.NOTE_SHOW_FILTER_DIALOG, event, ApplicationFacade.NOTE_APPLY_ITERATION_BACKLOG_FILTER);
   }

   /**
    * Disallow dragging of tasks
    */
   private function handleDragEnter(event:DragEvent):void {
      var items:Array = event.dragSource.dataForFormat('treeDataGridItems') as Array;
      for each(var item:BacklogItem in items) {
         if (item.parent) {
            event.preventDefault();
            DragManager.showFeedback(DragManager.NONE);
            return;
         }
      }
   }

   private function dropInIteration(event:DragEvent):void {

      var assignmentRequest:BacklogItemAssignRequest = createAssignmentrequest(event.dragSource.dataForFormat('treeDataGridItems') as Array);
      assignmentRequest.iterationToId = _proxy.selectedIteration.id;
      assignmentRequest.iterationFromId = 0;
      sendNotification(ApplicationFacade.NOTE_ASSIGN_BACKLOG_ITEM, assignmentRequest);
   }

   private function dropInProductBacklog(event:DragEvent):void {
      var assignmentRequest:BacklogItemAssignRequest = createAssignmentrequest(event.dragSource.dataForFormat('treeDataGridItems') as Array);
      assignmentRequest.iterationToId = 0;
      assignmentRequest.iterationFromId = _proxy.selectedIteration.id;
      sendNotification(ApplicationFacade.NOTE_ASSIGN_BACKLOG_ITEM, assignmentRequest);
   }

   private function createAssignmentrequest(items:Array):BacklogItemAssignRequest {
      var assignmentRequest:BacklogItemAssignRequest = new BacklogItemAssignRequest();
      assignmentRequest.projectId = _proxy.selectedProject.id;
      var length:int = items.length;
      for (var index:int; index < length; index++) {
         assignmentRequest.itemIds.push(items[index].id);
      }
      return assignmentRequest;
   }

   override public function listNotificationInterests():Array {
      return [ProjectLoadCommand.SUCCESS,
         IterationCreateCommand.SUCCESS,
         IterationUpdateCommand.SUCCESS,
         IterationLoadCommand.SUCCESS,
         ApplicationFacade.NOTE_APPLY_PRODUCT_BACKLOG_FILTER,
         ApplicationFacade.NOTE_APPLY_ITERATION_BACKLOG_FILTER];
   }

   override public function handleNotification(notification:INotification):void {
      switch (notification.getName()) {
         case ProjectLoadCommand.SUCCESS :
            projectLoaded();
            break;
         case IterationCreateCommand.SUCCESS :
            view.btnCreateItem.enabled = true;
            view.lblIterationTitle.text = _proxy.selectedIteration.title + " Backlog";
            break;
         case IterationLoadCommand.SUCCESS :
            removeGridFilter(view.grdIterationBacklog);
            view.lnkRemoveIterationBacklogFilter.enabled = false;
            // Fall through
         case IterationUpdateCommand.SUCCESS :
            view.btnCreateItem.enabled = true;
            view.lblIterationTitle.text = _proxy.selectedIteration.title + " Backlog";
            break;
         case ApplicationFacade.NOTE_APPLY_PRODUCT_BACKLOG_FILTER :
            filterGrid(BacklogFilter(notification.getBody()), view.grdProductBacklog);
            view.lnkRemoveProductBacklogFilter.enabled = true;
            break;
         case ApplicationFacade.NOTE_APPLY_ITERATION_BACKLOG_FILTER :
            filterGrid(BacklogFilter(notification.getBody()), view.grdIterationBacklog);
            view.lnkRemoveIterationBacklogFilter.enabled = true;
            break;
      }
   }

   private function handleGridButton(event:GridButtonEvent):void {
      switch (event.action) {
         case GridButtonEvent.ACTION_ADD_CHILD :
            var task:BacklogItem = new BacklogItem();
            var parent:BacklogItem = event.data as BacklogItem;
            task.parent = parent;
            sendNotification(BacklogItemMediator.CREATE, task);
            break;
         case GridButtonEvent.ACTION_REMOVE :
            _proxy.selectedBacklogItem = event.data as BacklogItem;
            Alert.show("Are you sure you want to delete this item?", "Confirm Removal", Alert.YES | Alert.NO, null, removeConfirmed, null, Alert.YES);
            break;
      }
   }

   private function handleGridDoubleClick(event:MouseEvent):void {
      var item:BacklogItem = event.currentTarget.selectedItem as BacklogItem;
      if (item) {
         sendNotification(BacklogItemMediator.EDIT, item);
      }
   }

   private function removeConfirmed(event:CloseEvent):void {
      if (event.detail == Alert.YES) {
         if (_proxy.selectedBacklogItem.inProductBacklog()) {
            _proxy.productBacklogRequest = true;
         }
         sendNotification(ApplicationFacade.NOTE_REMOVE_BACKLOG_ITEM, _proxy.selectedBacklogItem);
      }
   }

   private function handleCreateBacklogItem(event:MouseEvent):void {
      var story:BacklogItem = new BacklogItem();
      story.iteration = _proxy.selectedIteration;
      _proxy.productBacklogRequest = false;
      sendNotification(BacklogItemMediator.CREATE, story);
   }

   private function handleCreateProductBacklogItem(event:MouseEvent):void {
      var story:BacklogItem = new BacklogItem();
      story.project = _proxy.selectedProject;
      _proxy.productBacklogRequest = true;
      sendNotification(BacklogItemMediator.CREATE, story);
   }

   private function filterGrid(filter:BacklogFilter, grid:AdvancedDataGrid):void {
      var data:IHierarchicalCollectionView = IHierarchicalCollectionView(grid.dataProvider);
      data.filterFunction = function(object:Object):Boolean {
         var item:BacklogItem = BacklogItem(object);
         for each(var theme:Theme in filter.themes) {
            if (item.hasTheme(theme)) {
               return true;
            }
         }
         return false;
      };
      data.refresh();
   }

   private function removeGridFilter(grid : AdvancedDataGrid) : void {
      var data:IHierarchicalCollectionView = IHierarchicalCollectionView(grid.dataProvider);
      if(data) {
         data.filterFunction = null;
         data.refresh();
      }
   }

   private function projectLoaded():void {
      if (!_proxy.selectedIteration && ! _proxy.selectedProject.currentIteration) {
         view.btnCreateItem.enabled = false;
      }
      else {
         if (_proxy.selectedIteration) {
            view.btnCreateItem.enabled = true;
         }
         else {
            sendNotification(ApplicationFacade.NOTE_LOAD_ITERATION, _proxy.selectedProject.currentIteration.id);
         }
      }
      view.btnProductCreateItem.enabled = _proxy.selectedProject != null;
      view.lnkProductBacklogFilter.enabled = _proxy.selectedProject != null;
      view.lnkRemoveProductBacklogFilter.enabled = false;
      removeGridFilter(view.grdProductBacklog);
      removeGridFilter(view.grdIterationBacklog);
   }

   private function buildToolTip(row:Object):String {
      var item:BacklogItem = row as BacklogItem;
      return item ? item.summary : "";
   }

   public function get view():BacklogView {
      return viewComponent as BacklogView;
   }

}
}