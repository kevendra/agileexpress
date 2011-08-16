package com.express.view.projectDetails {
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.model.domain.Project;
import com.express.view.form.FormMediator;

import flash.events.MouseEvent;

import mx.events.CloseEvent;

import org.puremvc.as3.interfaces.INotification;

public class ProjectDetailsMediator extends FormMediator{
   public static const NAME : String = "com.express.view.projectDetails.ProjectDetailsMediator";
   public static const EDIT : String = "ProjectDetailsMediator.EDIT";
   public static const CANCEL_EDIT : String = "ProjectDetailsMediator.CANCEL_EDIT";

   private var _proxy : ProjectProxy;

   public function ProjectDetailsMediator(viewComp : ProjectDetailsForm, mediatorName : String = NAME) {
      super(mediatorName, viewComp);
      _proxy = ProjectProxy(facade.retrieveProxy(ProjectProxy.NAME));
      viewComp.effortUnit.dataProvider =  Project.EFFORT_UNITS;
      viewComp.methodology.dataProvider = Project.METHODOLOGIES;
      viewComp.btnSave.label = "Update";
      viewComp.btnSave.addEventListener(MouseEvent.CLICK, handleUpdateButton);
      viewComp.btnCancel.addEventListener(MouseEvent.CLICK, handleCancelButton);
   }

   override public function registerValidators():void {
      _validators.push(view.titleValidator);
      _validators.push(view.referenceValidator);
      _validators.push(view.dateValidator);
   }

   override public function bindForm():void {
      view.title.text = _proxy.selectedProject.title;
      view.reference.text = _proxy.selectedProject.reference;
      view.description.text = _proxy.selectedProject.description;
      view.effortUnit.selectedItem = _proxy.selectedProject.effortUnit;
      view.methodology.selectedItem = _proxy.selectedProject.methodology;
      view.startDate.selectedDate = _proxy.selectedProject.startDate;
      view.focusManager.setFocus(view.title);
   }

   override public function bindModel():void {
      _proxy.selectedProject.title = view.title.text;
      _proxy.selectedProject.reference = view.reference.text;
      _proxy.selectedProject.effortUnit = view.effortUnit.text;
      trace(view.methodology.selectedItem.toString());
      _proxy.selectedProject.methodology = view.methodology.selectedItem.toString();
      _proxy.selectedProject.description = view.description.text;
      _proxy.selectedProject.startDate = view.startDate.selectedDate;
   }

   override public function listNotificationInterests():Array {
      return [EDIT];
   }

   override public function handleNotification(notification : INotification):void {
      bindForm();
   }

   private function handleUpdateButton(event : MouseEvent) : void {
      if(validate(true)) {
         bindModel();
         sendNotification(ApplicationFacade.NOTE_UPDATE_PROJECT);
         view.parent.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      }
   }

   private function handleCancelButton(event : MouseEvent) : void {
      view.parent.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      sendNotification(CANCEL_EDIT);
   }

   public function get view() : ProjectDetailsForm {
      return ProjectDetailsForm(viewComponent);
   }
}
}