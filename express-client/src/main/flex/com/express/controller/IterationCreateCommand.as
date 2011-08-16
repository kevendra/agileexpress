package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.model.domain.Iteration;
import com.express.service.ServiceRegistry;

import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class IterationCreateCommand extends SimpleCommand implements IResponder {
   public static const SUCCESS : String = "IterationCreateCommand.SUCCESS";
   public static const FAILURE : String = "IterationCreateCommand.FAIURE";
   private var _proxy : ProjectProxy;

   public function IterationCreateCommand() {
   }

   override public function execute(notification:INotification):void {
      _proxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      var registry : ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service : RemoteObject = registry.getRemoteObjectService(ApplicationFacade.ITERATION_SERVICE);
      var call : Object;
      call = service.createIteration(_proxy.newIteration);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      _proxy.selectedIteration = data.result as Iteration;
      _proxy.selectedProject.iterations.removeItemAt(_proxy.selectedProject.iterations.length - 1);
      _proxy.selectedProject.iterations.addItem(data.result as Iteration);
      _proxy.newIteration = null;
      _proxy.updateIterationList();
      sendNotification(SUCCESS, data.result);
   }

   public function fault(info:Object):void {
      trace((info as FaultEvent).fault.message);
   }

}
}