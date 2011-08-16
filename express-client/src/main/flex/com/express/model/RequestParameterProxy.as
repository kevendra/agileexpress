package com.express.model {
import flash.utils.Dictionary;

import mx.managers.IBrowserManager;

import org.puremvc.as3.patterns.proxy.Proxy;

public class RequestParameterProxy extends Proxy{
   public static const NAME : String = "RequestParameterProxy";
   public static const PROJECT_ID_PARAM : String = "projectId";
   public static const ITERATION_ID_PARAM : String = "iterationId";
   public static const BACKLOG_ITEM_ID_PARAM : String = "backlogItemId";

   private var _initialParameters : Dictionary;
   private var _urlParameters : Dictionary;
   private var _browserManager : IBrowserManager;
   private var _indexedParameterNames : Array;

   public function RequestParameterProxy(browserManager : IBrowserManager) {
      super(NAME);
      _browserManager = browserManager;
      _initialParameters = new Dictionary();
      _urlParameters = new Dictionary();
      var pairs:Array = _browserManager.fragment.split("&");
      for each(var pair : String in pairs) {
         var splitPair:Array = pair.split("=");
         _initialParameters[splitPair[0]] = splitPair[1];
      }
      _indexedParameterNames = [];
      _indexedParameterNames[0] = PROJECT_ID_PARAM;
      _indexedParameterNames[1] = ITERATION_ID_PARAM;
      _indexedParameterNames[2] = BACKLOG_ITEM_ID_PARAM;
   }

   public function hasValue(key : String) : Boolean {
      return _initialParameters[key] != null;
   }

   public function getAndRemoveValue(key : String) : String {
      var value : String = _initialParameters[key];
      delete _initialParameters[key];
      return value;
   }

   public function removeValue(key : String) : void {
      delete _urlParameters[key];
      setParametersInUrl();
   }

   public function setParameter(key : String, value : String) : void {
      _urlParameters[key] = value;
      removeRedundantParameters(key);
      setParametersInUrl();
   }

   private function setParametersInUrl() : void {
      var fragment : String = "";
      for (var key : String in _urlParameters) {
         if(fragment.length > 0) {
            fragment += "&";
         }
         fragment += key + "=" + _urlParameters[key];
      }
      _browserManager.setFragment(fragment);
   }

   private function removeRedundantParameters(key : String) : void {
      for(var index : int = _indexedParameterNames.indexOf(key) + 1; index < _indexedParameterNames.length; index++) {
         delete _urlParameters[_indexedParameterNames[index]];
      }
   }
}
}