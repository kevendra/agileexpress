package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.service.ServiceRegistry;

import mx.collections.ArrayCollection;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class AccessRequestsLoadCommand extends SimpleCommand implements IResponder {
   private var _proxy : ProjectProxy;

   public function AccessRequestsLoadCommand() {
   }

   override public function execute(notification:INotification):void {
      _proxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      var id : Number = _proxy.selectedProject.id;
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.PROJECT_SERVICE);
      var call : Object = service.loadAccessRequests(id);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      _proxy.accessRequests = data.result as ArrayCollection;
   }

   public function fault(info:Object):void {
      var fault : FaultEvent = info as FaultEvent;
      trace(fault.message);
   }
}
}