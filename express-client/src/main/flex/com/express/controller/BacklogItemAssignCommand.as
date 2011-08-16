package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.model.request.BacklogItemAssignRequest;
import com.express.service.ServiceRegistry;

import mx.rpc.Fault;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class BacklogItemAssignCommand extends SimpleCommand implements IResponder
{
   override public function execute(notification:INotification):void {
      var request : BacklogItemAssignRequest = notification.getBody() as BacklogItemAssignRequest;
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.BACKLOG_ITEM_SERVICE);
      var call : Object = service.backlogItemAssignmentRequest(request);
      call.addResponder(this);
   }

   public function result(data : Object) : void {
      var proxy : ProjectProxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      sendNotification(ApplicationFacade.NOTE_LOAD_PROJECT, proxy.selectedProject.id);
      sendNotification(ApplicationFacade.NOTE_LOAD_ITERATION, proxy.selectedIteration.id);
   }

   public function fault(info : Object) : void {
      var fault : Fault = (info as FaultEvent).fault;
      trace(fault.message);
   }
}
}