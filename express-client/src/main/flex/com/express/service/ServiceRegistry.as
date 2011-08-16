package com.express.service
{
import flash.utils.Dictionary;

import mx.messaging.Channel;
import mx.messaging.ChannelSet;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.patterns.proxy.Proxy;

/**
    * The ServiceRegistry allows the registration of RemoteObject and HTTPService objects. It provides
    * central management of credentials for remote calls.
    */
public class ServiceRegistry extends Proxy {
   public static const NAME : String = "ServiceRegistry";

   protected var _services:Dictionary;
   private var _channelSet : ChannelSet;

   public function ServiceRegistry(channel : Channel) {
      super(NAME, null);
      _services = new Dictionary();
      _channelSet = new ChannelSet();
      _channelSet.addChannel(channel);
   }

   public function unregister(id:String):void {
      _services[id] = null;
   }

   public function registerRemoteObjectService(id:String, destination:String,
                                               showBusyCursor:Boolean = true):void {
      var service:RemoteObject = new RemoteObject(destination);
      service.showBusyCursor = showBusyCursor;
      service.channelSet = _channelSet;
      _services[id] = service;
   }

   public function getService(id:String):Object {
      return _services[id];
   }

   public function getRemoteObjectService(id:String):RemoteObject {
      return _services[id] as RemoteObject;
   }

   public function setCredentials(username:String, password:String, charset:String = null):void {
      _channelSet.login(username, password, charset);
   }

   public function logout():void {
      _channelSet.logout();
   }
}
}