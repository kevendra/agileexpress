package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.model.request.ProjectAccessRequest;
import com.express.service.ServiceRegistry;

import mx.rpc.Fault;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ProjectAccessRequestCommand extends SimpleCommand implements IResponder
{
   public static const ACCESS_REQUEST_SUCCESS : String = "ProjectAccessSuccess";
   public static const ACCESS_REQUEST_FAILURE : String = "ProjectAccessFailure";

   override public function execute(notification : INotification) : void {
      var request : ProjectAccessRequest = notification.getBody() as ProjectAccessRequest;
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.PROJECT_SERVICE);
      var call : Object = service.projectAccessRequest(request);
      call.addResponder(this);
   }

   public function result(data : Object) : void {
      sendNotification(ApplicationFacade.NOTE_LOAD_PROJECT_LIST);
      sendNotification(ApplicationFacade.NOTE_LOAD_PROJECT_ACCESS_LIST);
      sendNotification(ACCESS_REQUEST_SUCCESS);
   }

   public function fault(info : Object) : void {
      var fault : Fault = (info as FaultEvent).fault;
      trace(fault.message);
      sendNotification(ACCESS_REQUEST_FAILURE);
   }
}
}