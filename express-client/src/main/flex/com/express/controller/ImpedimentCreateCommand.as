package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.model.request.AddImpedimentRequest;
import com.express.service.ServiceRegistry;

import mx.rpc.Fault;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ImpedimentCreateCommand extends SimpleCommand implements IResponder {
   override public function execute(notification:INotification):void {
      var request:AddImpedimentRequest = notification.getBody() as AddImpedimentRequest;
      var registry:ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service:RemoteObject = registry.getRemoteObjectService(ApplicationFacade.BACKLOG_ITEM_SERVICE);
      var call:Object = service.addImpediment(request);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      sendNotification(ApplicationFacade.NOTE_LOAD_BACKLOG);
   }

   public function fault(info:Object):void {
      var fault:Fault = (info as FaultEvent).fault;
      trace(fault.message);
   }
}
}