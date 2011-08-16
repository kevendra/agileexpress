package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.model.ProfileProxy;
import com.express.model.request.ProjectAccessData;
import com.express.service.ServiceRegistry;

import mx.rpc.Fault;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ProjectAccessListLoadCommand extends SimpleCommand implements IResponder
{
   public function ProjectAccessListLoadCommand() {
   }

   override public function execute(notification : INotification) : void {
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.PROJECT_SERVICE);
      var call : Object = service.findAccessRequestData();
      call.addResponder(this);
   }

   public function result(data : Object) : void {
      var proxy : ProfileProxy = facade.retrieveProxy(ProfileProxy.NAME) as ProfileProxy;
      proxy.setProjectAccessLists(data.result as ProjectAccessData);
   }

   public function fault(info : Object) : void {
      var fault : Fault = (info as FaultEvent).fault;
      trace(fault.message);
   }
}
}