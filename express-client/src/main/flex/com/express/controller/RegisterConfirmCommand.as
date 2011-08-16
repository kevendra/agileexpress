package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.service.ServiceRegistry;

import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class RegisterConfirmCommand extends SimpleCommand implements IResponder {
   public static const SUCCESS : String = "RegisterConfirmCommand.SUCCESS";
   public static const FAILURE : String = "RegisterConfirmCommand.FAILURE";

   override public function execute(notification:INotification):void {
      var userId : Number = notification.getBody() as Number;
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.USER_SERVICE);
      var call : Object = service.confirmRegistration(userId);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      sendNotification(SUCCESS);
   }

   public function fault(info:Object):void {
      trace((info as FaultEvent).fault.message);
      sendNotification(FAILURE);
   }
}
}