package com.express.controller {
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.model.RequestParameterProxy;
import com.express.model.domain.BacklogItem;
import com.express.model.domain.Iteration;
import com.express.service.ServiceRegistry;
import com.express.view.backlogItem.BacklogItemMediator;

import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class IterationLoadCommand extends SimpleCommand implements IResponder {
   public static const SUCCESS:String = "IterationLoadCommand.SUCCESS";
   private var _proxy:ProjectProxy;
   private var _parameterProxy:RequestParameterProxy;

   public function IterationLoadCommand() {
   }

   override public function execute(notification:INotification):void {
      var id:Number = notification.getBody() as Number;
      var registry:ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service:RemoteObject = registry.getRemoteObjectService(ApplicationFacade.ITERATION_SERVICE);
      var call:Object = service.findIteration(id);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      _parameterProxy = RequestParameterProxy(facade.retrieveProxy(RequestParameterProxy.NAME));
      _proxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      var iteration:Iteration = data.result as Iteration;
      _proxy.selectedIteration = iteration;
      loadFromPermalink();
      _parameterProxy.setParameter(RequestParameterProxy.ITERATION_ID_PARAM, iteration.id.toString());
      sendNotification(SUCCESS, iteration);
   }

   public function fault(info:Object):void {
      var fault:FaultEvent = info as FaultEvent;
      trace(fault.message);
   }

   private function loadFromPermalink():void {
      if (_parameterProxy.hasValue(RequestParameterProxy.BACKLOG_ITEM_ID_PARAM)) {
         var item:BacklogItem = _proxy.selectedIteration.getBacklogItemById(
                  new Number(_parameterProxy.getAndRemoveValue(RequestParameterProxy.BACKLOG_ITEM_ID_PARAM)));
         if (item) {
            sendNotification(BacklogItemMediator.EDIT, item);
         }
      }
   }

}
}