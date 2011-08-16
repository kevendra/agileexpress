package com.express.controller {
import com.express.ApplicationFacade;
import com.express.model.SecureContextProxy;
import com.express.model.domain.User;
import com.express.model.request.ChangePasswordRequest;
import com.express.service.ServiceRegistry;

import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ChangePasswordCommand extends SimpleCommand implements IResponder{
   public static const SUCCESS : String = "ChangePasswordCommand.SUCCESS";
   public static const FAILURE : String = "ChangePasswordCommand.FAILURE";
   private var _password : String;

   public function ChangePasswordCommand() {
   }

   override public function execute(note:INotification) :void {
      var request : ChangePasswordRequest = note.getBody() as ChangePasswordRequest;
      _password = request.newPassword;
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.USER_SERVICE);
      var call : Object = service.changePassword(request);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      var secureContext : SecureContextProxy = facade.retrieveProxy(SecureContextProxy.NAME) as SecureContextProxy;
      secureContext.currentUser = data.result as User;
      sendNotification(SUCCESS);
   }

   public function fault(info:Object):void {
      var message : String = (info as FaultEvent).fault.rootCause.message;
      trace(message);
      sendNotification(FAILURE,message);
   }

}
}