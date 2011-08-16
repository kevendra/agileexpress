package com.express.controller {
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.model.RequestParameterProxy;
import com.express.service.ServiceRegistry;
import com.express.view.projectSummary.ProjectSummaryMediator;

import mx.collections.ArrayCollection;
import mx.rpc.Fault;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ProjectListLoadCommand extends SimpleCommand implements IResponder {
   private var _projectProxy:ProjectProxy;
   private var _parameterProxy:RequestParameterProxy;
   private var _mediator:ProjectSummaryMediator;

   override public function execute(notification:INotification):void {
      var registry:ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service:RemoteObject = registry.getRemoteObjectService(ApplicationFacade.PROJECT_SERVICE);
      var call:Object = service.findAllProjects();
      call.addResponder(this);
   }

   public function result(data:Object):void {
      _projectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      _parameterProxy = RequestParameterProxy(facade.retrieveProxy(RequestParameterProxy.NAME));
      _mediator = facade.retrieveMediator(ProjectSummaryMediator.NAME) as ProjectSummaryMediator;

      _projectProxy.projectList = data.result as ArrayCollection;
      if (_projectProxy.selectedProject != null) {
         _mediator.view.cboProjects.selectedIndex = getIndex(_projectProxy.projectList, _projectProxy.selectedProject.id);
      }
      else if (!loadFromPermalink() && _projectProxy.projectList.length == 1) {
         _mediator.view.cboProjects.selectedIndex = 0;
         _mediator.handleProjectSelected(null);
      }
   }

   private function loadFromPermalink():Boolean {
      if (_parameterProxy.hasValue('projectId')) {
         _mediator.view.cboProjects.selectedIndex =
               getIndex(_projectProxy.projectList, new Number(_parameterProxy.getAndRemoveValue('projectId')));
         _mediator.handleProjectSelected(null);
         return true;
      }
      return false;
   }

   private function getIndex(list:ArrayCollection, id:Number):int {
      var index:int = 0;
      for each(var object:Object in list) {
         if (object.id == id) {
            return index;
         }
         index++;
      }
      return -1;
   }

   public function fault(info:Object):void {
      var fault:Fault = (info as FaultEvent).fault;
      trace(fault.message);
   }
}
}