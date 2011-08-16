package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.model.domain.Issue;
import com.express.service.ServiceRegistry;

import mx.rpc.Fault;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ImpedimentUpdateCommand extends SimpleCommand implements IResponder
{
   public static const SUCCESS : String = "ImpedimentUpdateCommand.success";

   override public function execute(notification:INotification):void {
      var issue : Issue = notification.getBody() as Issue;
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.PROJECT_SERVICE);
      var call : Object = service.updateImpediment(issue);
      call.addResponder(this);
   }

   public function result(data : Object) : void {
      sendNotification(SUCCESS);
   }

   public function fault(info : Object) : void {
      var fault : Fault = (info as FaultEvent).fault;
      trace(fault.message);
   }
}
}