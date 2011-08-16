package com.express.controller
{
import mx.rpc.Fault;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ApplicationUsersLoadCommand extends SimpleCommand implements IResponder
{
   override public function execute(notification : INotification) : void {

   }

   public function result(data : Object) : void {

   }

   public function fault(info : Object) : void {
      var fault : Fault = (info as FaultEvent).fault;
   }
}
}