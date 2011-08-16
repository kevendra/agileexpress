package com.express.view.impedimentSummary {
import com.express.ApplicationFacade;
import com.express.controller.ImpedimentUpdateCommand;
import com.express.controller.IterationLoadCommand;
import com.express.controller.ProjectLoadCommand;
import com.express.model.ProjectProxy;
import com.express.model.domain.Issue;
import com.express.view.backlogItem.BacklogItemProxy;

import flash.events.MouseEvent;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

public class ImpedimentSummaryMediator extends Mediator {
   public static const NAME:String = "ImpedimentSummaryMediator";
   public static const SHOW_PRINT_PREVIEW:String = "Note.showPrintPreview";

   private var _proxy:ProjectProxy;
   private var _backlogItemProxy:BacklogItemProxy;

   public function ImpedimentSummaryMediator(viewComp:ImpedimentSummary, mediatorName:String = NAME) {
      super(mediatorName, viewComp);
      _proxy = ProjectProxy(facade.retrieveProxy(ProjectProxy.NAME));
      _backlogItemProxy = BacklogItemProxy(facade.retrieveProxy(BacklogItemProxy.NAME));
      view.lstImpediments.dataProvider = _proxy.impedimentList;
      viewComp.lstImpediments.addEventListener(MouseEvent.DOUBLE_CLICK, handleEditImpediment);
      viewComp.lnkClose.addEventListener(MouseEvent.CLICK, handleClose);
      viewComp.btnAddImpediment.addEventListener(MouseEvent.CLICK, handleAddImpedimentRequest);
   }

   private function handleEditImpediment(event:MouseEvent):void {
      var issue:Issue = Issue(view.lstImpediments.selectedItem);
      _backlogItemProxy.currentIssue = issue;
      sendNotification(ApplicationFacade.NOTE_EDIT_IMPEDIMENT);
   }

   private function handleAddImpedimentRequest(event:MouseEvent):void {
      _backlogItemProxy.currentIssue = new Issue();
      _backlogItemProxy.currentIssue.startDate = new Date();
      _backlogItemProxy.currentIteration = _proxy.selectedIteration;
      sendNotification(ApplicationFacade.NOTE_CREATE_IMPEDIMENT, true);
   }

   private function handleClose(event:MouseEvent):void {
      view.visible = false;
   }

   override public function listNotificationInterests():Array {
      return [IterationLoadCommand.SUCCESS,
              ApplicationFacade.NOTE_LOAD_BACKLOG_COMPLETE,
              ImpedimentUpdateCommand.SUCCESS];
   }

   override public function handleNotification(notification:INotification):void {
      switch (notification.getName()) {
         case IterationLoadCommand.SUCCESS :
            view.btnAddImpediment.enabled = true;
            _backlogItemProxy.selectedBacklog = _proxy.selectedIteration.backlog;
            break;
         case ProjectLoadCommand.SUCCESS :
            if (_proxy.selectedIteration == null) {
               view.btnAddImpediment.enabled = false;
            }
            else {
               _backlogItemProxy.selectedBacklog = _proxy.selectedIteration.backlog;
               view.btnAddImpediment.enabled = true;
            }
            break;
         case ImpedimentUpdateCommand.SUCCESS :
            view.lstImpediments.dataProvider.refresh();
            break;
      }
   }

   public function get view():ImpedimentSummary {
      return this.viewComponent as ImpedimentSummary;
   }
}
}