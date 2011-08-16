package com.express.view.projectSummary {

import com.express.ApplicationFacade;
import com.express.controller.ProjectLoadCommand;
import com.express.model.ProjectProxy;
import com.express.model.SecureContextProxy;
import com.express.model.domain.Project;
import com.express.navigation.MenuItem;
import com.express.view.ApplicationMediator;
import com.express.view.projectDetails.ProjectDetailsMediator;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileReference;
import flash.net.URLRequest;

import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.events.ListEvent;
import mx.messaging.config.ServerConfig;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

public class ProjectSummaryMediator extends Mediator{
   public static const NAME : String = "ProjectSummaryMediator";

   private var _proxy : ProjectProxy;
   private var _secureContext : SecureContextProxy;
   private var _fileRef : FileReference;

   public function ProjectSummaryMediator(viewComp : ProjectSummary, mediatorName : String = NAME) {
      super(mediatorName, viewComp);
      _proxy = ProjectProxy(facade.retrieveProxy(ProjectProxy.NAME));
      _secureContext = SecureContextProxy(facade.retrieveProxy(SecureContextProxy.NAME));
      bindDisplay();
      viewComp.cboProjects.dataProvider = _proxy.projectList;
      viewComp.cboProjects.addEventListener(Event.CHANGE, handleProjectSelected);
      viewComp.lnkProjectAccess.addEventListener(MouseEvent.CLICK, handleNavigateRequest);
      viewComp.lnkProjectAccess.data = new MenuItem(viewComp.lnkProjectAccess.label,ApplicationMediator.ACCESS_VIEW, null);
      viewComp.auth.userRoles = _secureContext.availableRoles;
      viewComp.managePopUp.addEventListener(ListEvent.ITEM_CLICK, handleManageMenuSelection);
      viewComp.btnEdit.addEventListener(MouseEvent.CLICK, handleEditProject);
      viewComp.lnkVelocity.addEventListener(MouseEvent.CLICK, handleDisplayVelocityChart);
      viewComp.lnkBurnUp.addEventListener(MouseEvent.CLICK, handleDisplayBurnUpChart);
      viewComp.lnkRefresh.addEventListener(MouseEvent.CLICK, handleRefreshProjectRequest);

      viewComp.lnkExport.addEventListener(MouseEvent.CLICK, handleProductBacklogExport);
      viewComp.lnkClose.addEventListener(MouseEvent.CLICK, handleClose);
      _fileRef = new FileReference();
      _fileRef.addEventListener(Event.CANCEL, handleDownload);
      _fileRef.addEventListener(Event.COMPLETE, handleDownload);
      _fileRef.addEventListener(Event.OPEN, handleDownload);
      _fileRef.addEventListener(Event.SELECT, handleDownload);
      _fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleDownload);
      _fileRef.addEventListener(IOErrorEvent.IO_ERROR, handleDownload);
      _fileRef.addEventListener(ProgressEvent.PROGRESS, handleDownload);
      _fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleDownload);
   }

   private function handleDisplayBurnUpChart(event:MouseEvent):void {
      sendNotification(ApplicationFacade.NOTE_DISPLAY_BURNUP, _proxy.selectedProject);
   }

   private function handleDownload(evt:Event):void {
      /* Create shortcut to the FileReference object. */
//      var fr:FileReference = evt.currentTarget as FileReference;
   }

   private function handleClose(event:MouseEvent):void {
      view.visible = false;
   }

   private function handleProductBacklogExport(event : Event) : void {
      var url : String = ServerConfig.getChannel("my-amf").endpoint;
      url = url.substr(0,url.length - 18);
      url += "/project/" + _proxy.selectedProject.id + "/backlog";
      var request : URLRequest = new URLRequest(url);
      _fileRef.download(request, _proxy.selectedProject.title + "_backlog.csv");
   }

   public function handleProjectSelected(event : Event) : void {
      var project : Project = view.cboProjects.selectedItem as Project;
      _proxy.selectedIteration = null;
      if (project != null) {
         _proxy.selectedProject = project;
         sendNotification(ApplicationFacade.NOTE_LOAD_PROJECT, project.id);
      }
   }

   private function handleRefreshProjectRequest(event : Event) : void {
      if (_proxy.selectedProject != null) {
         sendNotification(ApplicationFacade.NOTE_LOAD_PROJECT, _proxy.selectedProject.id);
      }
   }

   public function handleNavigateRequest(event : MouseEvent) : void {
      facade.sendNotification(ApplicationFacade.NOTE_NAVIGATE,
            new MenuItem(ApplicationMediator.ACCESS_HEAD, ApplicationMediator.ACCESS_VIEW, null));
   }

   

   private function handleManageMenuSelection(event : ListEvent) : void {
      switch(event.rowIndex) {
         case 0 :
            event.stopImmediatePropagation();
            sendNotification(ApplicationFacade.NOTE_PROJECT_ACCESS_MANAGE);
            break;
         case 1 :
            event.stopImmediatePropagation();
            sendNotification(ApplicationFacade.NOTE_THEMES_MANAGE);
            break;
      }
   }

   override public function listNotificationInterests():Array {
      return [ProjectLoadCommand.SUCCESS];
   }

   override public function handleNotification(notification : INotification):void {
      switch(notification.getName()) {
         case ProjectLoadCommand.SUCCESS :
            view.cboProjects.dataProvider.refresh();
            bindDisplay();
            break;
      }
   }

   private function handleEditProject(event : Event) : void {
      sendNotification(ProjectDetailsMediator.EDIT);
   }

   private function handleDisplayVelocityChart(event : Event) : void {
      sendNotification(ApplicationFacade.NOTE_DISPLAY_VELOCITY, _proxy.selectedProject.iterations);
   }

   public function get view() : ProjectSummary {
      return viewComponent as ProjectSummary;
   }

   private function bindDisplay() : void {
      if(_proxy.selectedProject) {
         view.reference.text = _proxy.selectedProject.reference;
         view.methodology.text = _proxy.selectedProject.methodology;
         view.effortUnit.text = _proxy.selectedProject.effortUnit;
         view.startDate.text = DateField.dateToString(_proxy.selectedProject.startDate, "DD/MM/YYYY");
         view.description.text = _proxy.selectedProject.description;
         view.rptAdmins.dataProvider = _proxy.selectedProject.admins;
         view.lnkVelocity.visible = true;
         view.lnkBurnUp.visible = true;
         view.btnEdit.enabled = true;
         view.managePopUp.enabled = true;
         view.lnkExport.enabled = true;
      }
   }
}
}