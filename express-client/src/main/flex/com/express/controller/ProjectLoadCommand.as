package com.express.controller {
import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.model.RequestParameterProxy;
import com.express.model.domain.Project;
import com.express.service.ServiceRegistry;
import com.express.view.backlogItem.BacklogItemProxy;
import com.express.view.iterationSummary.IterationSummaryMediator;

import mx.collections.ArrayCollection;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ProjectLoadCommand extends SimpleCommand implements IResponder {
   public static const SUCCESS:String = "ProjectLoadCommand.SUCCESS";
   private var _proxy:ProjectProxy;
   private var _parameterProxy:RequestParameterProxy;

   public function ProjectLoadCommand() {
   }

   override public function execute(notification:INotification):void {
      var id:Number = notification.getBody() as Number;
      var registry:ServiceRegistry = facade.retrieveProxy(ServiceRegistry.NAME) as ServiceRegistry;
      var service:RemoteObject = registry.getRemoteObjectService(ApplicationFacade.PROJECT_SERVICE);
      var call:Object = service.findProject(id);
      call.addResponder(this);
   }

   public function result(data:Object):void {
      _parameterProxy = RequestParameterProxy(facade.retrieveProxy(RequestParameterProxy.NAME));
      _proxy = facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
      _proxy.selectedProject = data.result as Project;
      _proxy.setProjectHistory(_proxy.selectedProject);
      var backlogItemProxy:BacklogItemProxy = BacklogItemProxy(facade.retrieveProxy(BacklogItemProxy.NAME));
      backlogItemProxy.assignToList = _proxy.developers;
      loadFromPermalink();
      _parameterProxy.setParameter(RequestParameterProxy.PROJECT_ID_PARAM, _proxy.selectedProject.id.toString());
      sendNotification(SUCCESS);
   }

   public function fault(info:Object):void {
      var fault:FaultEvent = info as FaultEvent;
      trace(fault.message);
   }

   private function loadFromPermalink():void {
      if (_parameterProxy.hasValue(RequestParameterProxy.ITERATION_ID_PARAM)) {
         var iterationMediator:IterationSummaryMediator = IterationSummaryMediator(facade.retrieveMediator(IterationSummaryMediator.NAME));
         iterationMediator.view.cboIterations.selectedIndex = getIndex(_proxy.iterationList, new Number(_parameterProxy.getAndRemoveValue(RequestParameterProxy.ITERATION_ID_PARAM)));
         iterationMediator.handleIterationSelected(null);
      }
   }

   private function getIndex(list:ArrayCollection, id:Number):int {
      var index:int = 0;
      for each(var object:Object in list) {
         if (object.id == id) {
            return index;
         }
         index++;
      }
      return -1;
   }
}
}