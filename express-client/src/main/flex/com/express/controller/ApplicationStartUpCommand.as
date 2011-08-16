package com.express.controller
{
import com.express.ApplicationFacade;
import com.express.model.ProfileProxy;
import com.express.model.ProjectProxy;
import com.express.model.SecureContextProxy;
import com.express.model.RequestParameterProxy;
import com.express.service.ServiceRegistry;
import com.express.view.ApplicationMediator;
import com.express.view.backlogItem.BacklogItemProxy;

import mx.managers.BrowserManager;
import mx.managers.IBrowserManager;
import mx.messaging.Channel;
import mx.messaging.config.ServerConfig;

import org.puremvc.as3.interfaces.*;
import org.puremvc.as3.patterns.command.*;

public class ApplicationStartUpCommand extends SimpleCommand {
   private var _requestParameterProxy:RequestParameterProxy;

   override public function execute(note:INotification):void {
      var registry:ServiceRegistry = createServiceRegistry();
      var browserManager:IBrowserManager = BrowserManager.getInstance();
      browserManager.init();
      browserManager.setTitle("Express | Agile Project Management");
      _requestParameterProxy = new RequestParameterProxy(browserManager);
      registerProxies(registry);
      var app:Express = note.getBody() as Express;
      var appMediator:ApplicationMediator = new ApplicationMediator(app);
      facade.registerMediator(appMediator);
      checkRegistrationConfirmation();
   }

   protected function registerProxies(registry:ServiceRegistry):void {
      facade.registerProxy(new ProjectProxy());
      facade.registerProxy(new SecureContextProxy());
      facade.registerProxy(new ProfileProxy());
      facade.registerProxy(new BacklogItemProxy());
      facade.registerProxy(registry);
      facade.registerProxy(_requestParameterProxy);
   }

   protected function createServiceRegistry():ServiceRegistry {
      var channel:Channel = ServerConfig.getChannel("my-amf");
      var registry:ServiceRegistry = new ServiceRegistry(channel);

      registry.registerRemoteObjectService(ApplicationFacade.USER_SERVICE, ApplicationFacade.USER_SERVICE);
      registry.registerRemoteObjectService(ApplicationFacade.PROJECT_SERVICE, ApplicationFacade.PROJECT_SERVICE);
      registry.registerRemoteObjectService(ApplicationFacade.ITERATION_SERVICE, ApplicationFacade.ITERATION_SERVICE);
      registry.registerRemoteObjectService(ApplicationFacade.BACKLOG_ITEM_SERVICE, ApplicationFacade.BACKLOG_ITEM_SERVICE);

      return registry;
   }

   private function checkRegistrationConfirmation():void {
      if (_requestParameterProxy.hasValue("registerId")) {
         var userId:Number = new Number(_requestParameterProxy.getAndRemoveValue("registerId"));
         sendNotification(ApplicationFacade.NOTE_REGISTER_CONFIRM, userId);
      }
   }

}
}
