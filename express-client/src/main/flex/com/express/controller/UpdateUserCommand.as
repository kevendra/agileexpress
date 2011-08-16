package com.express.controller {
import com.express.ApplicationFacade;
import com.express.model.ProfileProxy;
import com.express.service.ServiceRegistry;

import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class UpdateUserCommand extends SimpleCommand implements IResponder{
   public static const SUCCESS : String = "UpdateUserCommand.SUCCESS";
   public static const FAILURE : String = "UpdateUserCommand.FAILURE";

   override public function execute(notification : INotification):void {
      var proxy : ProfileProxy = ProfileProxy(facade.retrieveProxy(ProfileProxy.NAME));
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.USER_SERVICE);
      var call : Object = service.updateUserDetails(proxy.user);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      sendNotification(SUCCESS, data.result);
   }

   public function fault(info:Object):void {
      sendNotification(FAILURE, FaultEvent(info).fault.rootCause.message);
   }
}
}