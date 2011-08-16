package com.express.view.projectAccess
{
import com.express.ApplicationFacade;
import com.express.controller.ProjectAccessRequestCommand;
import com.express.model.ProfileProxy;
import com.express.model.SecureContextProxy;
import com.express.model.domain.Project;
import com.express.model.request.ProjectAccessRequest;
import com.express.view.form.FormUtility;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

public class ProjectAccessMediator extends Mediator
{
   public static const NAME : String = "ProjectAccessMediator";

   private var _profileProxy : ProfileProxy;
   private var _validators : Array;

   public function ProjectAccessMediator(viewComp : ProjectAccessForm) {
      super(NAME, viewComp);
      _profileProxy = facade.retrieveProxy(ProfileProxy.NAME) as ProfileProxy;
      viewComp.addEventListener(FlexEvent.SHOW, handleShowView);
      handleShowView(null);
      viewComp.projectList.dataProvider = _profileProxy.availableProjectList;
      viewComp.grantedList.dataProvider = _profileProxy.existingProjectList;
      viewComp.pendingList.dataProvider = _profileProxy.pendingProjectList;
      viewComp.requestAccessButton.addEventListener(MouseEvent.CLICK, handleRequestAccessExistingProject);
      viewComp.newProjectButton.addEventListener(MouseEvent.CLICK, handleSelectNewProject);
      viewComp.existingProjectButton.addEventListener(MouseEvent.CLICK, handleSelectExistingProject);

      viewComp.newProjectForm.effortUnit.dataProvider = Project.EFFORT_UNITS;
      viewComp.newProjectForm.methodology.dataProvider = Project.METHODOLOGIES;
      viewComp.newProjectForm.btnSave.label = "Create";
      viewComp.newProjectForm.btnSave.addEventListener(MouseEvent.CLICK, handleRequestNewProject);
      viewComp.newProjectForm.btnCancel.addEventListener(MouseEvent.CLICK, handleCancelButton);

      _validators = [];
      _validators.push(viewComp.newProjectForm.titleValidator);
      _validators.push(viewComp.newProjectForm.referenceValidator);
      _validators.push(viewComp.newProjectForm.dateValidator);
   }

   public override function listNotificationInterests():Array {
      return [ProjectAccessRequestCommand.ACCESS_REQUEST_SUCCESS,
         ProjectAccessRequestCommand.ACCESS_REQUEST_FAILURE];
   }

   public override function handleNotification(notification:INotification):void {
      switch (notification.getName()) {
         case ProjectAccessRequestCommand.ACCESS_REQUEST_SUCCESS :
            requestSuccess();
            break;
         case ProjectAccessRequestCommand.ACCESS_REQUEST_FAILURE :
            requestFailure();
            break;
      }
   }

   public function handleShowView(event : FlexEvent) : void {
      sendNotification(ApplicationFacade.NOTE_LOAD_PROJECT_ACCESS_LIST);
      _profileProxy.projectAccessRequest = new ProjectAccessRequest();
      _profileProxy.user = (facade.retrieveProxy(SecureContextProxy.NAME) as SecureContextProxy).currentUser;
      if (view.newProjectButton.selected) {
         _profileProxy.projectAccessRequest.newProject = new Project();
      }
      bindProjectForm();
      sendNotification(ApplicationFacade.NOTE_CLEAR_MSG);
   }

   public function handleSelectNewProject(event : MouseEvent) : void {
      _profileProxy.projectAccessRequest = new ProjectAccessRequest();
      _profileProxy.projectAccessRequest.newProject = new Project();
      bindProjectForm();
   }

   public function handleSelectExistingProject(event : MouseEvent) : void {
      _profileProxy.projectAccessRequest = new ProjectAccessRequest();
   }

   public function handleRequestAccessExistingProject(event : MouseEvent) : void {
      _profileProxy.projectAccessRequest.existingProjects = view.projectList.selectedItems as Array;
      sendNotification(ApplicationFacade.NOTE_REQUEST_PROJECT_ACCESS, _profileProxy.projectAccessRequest);
   }
   private function handleCancelButton(event : MouseEvent) : void {
      bindProjectForm();
   }

   public function handleRequestNewProject(event : Event) : void {
      if (FormUtility.validateAll(_validators, true)) {
         bindFormToRequest();
         sendNotification(ApplicationFacade.NOTE_REQUEST_PROJECT_ACCESS,
               _profileProxy.projectAccessRequest);
         bindProjectForm();
      }
   }

   public function requestSuccess() : void {
      var message : String;
      if (_profileProxy.projectAccessRequest.newProject == null) {
         message = "Your request has been processed, you will recieve" +
                   " an email as soon as the project administrator has approved or rejected your " +
                   "application";
      }
      else {
         message = "Your new project has been approved.";
      }
      sendNotification(ApplicationFacade.NOTE_SHOW_SUCCESS_MSG, message);
      _profileProxy.projectAccessRequest = new ProjectAccessRequest();
      if(view.newProjectButton.selected) {
         _profileProxy.projectAccessRequest.newProject = new Project();
      }
   }

   public function requestFailure() : void {
      sendNotification(ApplicationFacade.NOTE_SHOW_ERROR_MSG, "An error has occurred processing your request");
   }

   protected function bindFormToRequest() : void {
      _profileProxy.projectAccessRequest.newProject.title = view.newProjectForm.title.text;
      _profileProxy.projectAccessRequest.newProject.reference = view.newProjectForm.reference.text;
      _profileProxy.projectAccessRequest.newProject.description = view.newProjectForm.description.text;
      _profileProxy.projectAccessRequest.newProject.effortUnit = view.newProjectForm.effortUnit.text;
      _profileProxy.projectAccessRequest.newProject.methodology = view.newProjectForm.methodology.selectedItem as String;
      _profileProxy.projectAccessRequest.newProject.startDate = view.newProjectForm.startDate.selectedDate;
   }

   protected function bindProjectForm() : void {
      view.newProjectForm.focusManager.setFocus(view.newProjectForm.title);
      view.newProjectForm.title.text = "";
      view.newProjectForm.reference.text = "";
      view.newProjectForm.description.text = "";
      view.newProjectForm.startDate.selectedDate = null;
   }

   public function get view() : ProjectAccessForm {
      return viewComponent as ProjectAccessForm;
   }

}
}