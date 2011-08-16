package com.express.view.projectWorkers {
import com.express.ApplicationFacade;
import com.express.controller.event.GridButtonEvent;
import com.express.model.ProjectProxy;
import com.express.model.domain.AccessRequest;
import com.express.model.domain.ProjectWorker;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.CloseEvent;

import org.puremvc.as3.patterns.mediator.Mediator;

public class ProjectAdminMediator extends Mediator{
   public static const NAME : String = "ProjectAdminMediator";

   private var _proxy : ProjectProxy;

   public function ProjectAdminMediator(viewComp : ProjectAdmin, name : String = NAME) {
      super(name, viewComp);
      _proxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      viewComp.grdRequests.addEventListener(GridButtonEvent.CLICK, handleGridButtonClick);
      viewComp.grdRequests.dataProvider = _proxy.accessRequests;

      viewComp.grdWorkers.addEventListener(GridButtonEvent.CLICK, handleGridButtonClick);
      viewComp.grdWorkers.dataProvider = _proxy.projectWorkers;

      viewComp.btnUpdate.addEventListener(MouseEvent.CLICK, handleUpdateProjectWorkers);
   }

   private function handleUpdateProjectWorkers(event : MouseEvent):void {
      sendNotification(ApplicationFacade.NOTE_UPDATE_PROJECT_WORKERS);
   }

   private function handleGridButtonClick(event : GridButtonEvent) : void {
      switch(event.action) {
         case GridButtonEvent.ACTION_ACCEPT :
            _proxy.selectedAccessRequest = view.grdRequests.selectedItem as AccessRequest;
            Alert.show("Please click yes if you want to accept", "Confirm Accept",
                       Alert.YES | Alert.NO, null, handleAcceptConfirm, null, Alert.YES);
            break;
         case GridButtonEvent.ACTION_REJECT :
            Alert.show("Please click yes if you want to reject", "Confirm Reject",
                       Alert.YES | Alert.NO, null, handleRejectConfirm, null, Alert.YES);
            break;
         case GridButtonEvent.ACTION_REMOVE :
            var worker : ProjectWorker = view.grdWorkers.selectedItem as ProjectWorker;
               _proxy.removeProjectWorker(worker);
            //showConfirm("Confirm Removal", "Are you sure you want to remove this Worker");
            break;
      }
   }

   private function handleAcceptConfirm(event : CloseEvent) : void {
      if (event.detail == Alert.YES) {
         _proxy.selectedAccessRequest.status = AccessRequest.APPROVED;
         sendNotification(ApplicationFacade.NOTE_PROJECT_ACCESS_RESPONSE, true);
      }
   }

   private function handleRejectConfirm(event : CloseEvent) : void {
      if (event.detail == Alert.YES) {
         _proxy.selectedAccessRequest.status = AccessRequest.REJECTED;
         sendNotification(ApplicationFacade.NOTE_PROJECT_ACCESS_RESPONSE, false);
      }
   }

   public function get view() : ProjectAdmin {
      return viewComponent as ProjectAdmin;
   }

}
}