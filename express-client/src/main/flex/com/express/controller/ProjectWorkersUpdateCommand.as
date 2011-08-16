package com.express.controller {
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;

import com.express.model.request.ProjectWorkersUpdateRequest;
import com.express.service.ServiceRegistry;

import mx.rpc.IResponder;

import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ProjectWorkersUpdateCommand extends SimpleCommand implements IResponder {
   private var _proxy : ProjectProxy;

   public function ProjectWorkersUpdateCommand() {
   }

   override public function execute(notification : INotification):void {
      _proxy = ProjectProxy(facade.retrieveProxy(ProjectProxy.NAME));
      var request : ProjectWorkersUpdateRequest = new ProjectWorkersUpdateRequest();
      request.workers = _proxy.projectWorkers;
      request.projectId = _proxy.selectedProject.id;
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.PROJECT_SERVICE);
      var call : Object = service.updateProjectWorkers(request);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      sendNotification(ApplicationFacade.NOTE_LOAD_PROJECT, _proxy.selectedProject.id);
   }

   public function fault(info:Object):void {
      trace((info as FaultEvent).fault.message);
   }
}
}