package com.express.model
{
import flash.net.SharedObject;

public class PersistentLoginDetails
{
   public static const LOCATION:String = "com.express.model.PersistentLoginDetails";

   public static function clear():void
   {
      var localRecord:SharedObject = SharedObject.getLocal(LOCATION);
      localRecord.clear();
      localRecord.flush();
   }

   public static function store(email : String, password : String):void
   {
      var localRecord:SharedObject = SharedObject.getLocal(LOCATION);
      localRecord.data.email = email;
      localRecord.data.password = password;
      localRecord.flush();
   }

   public static function hasDetails():Boolean
   {
      var localRecord:SharedObject = SharedObject.getLocal(LOCATION);
      return (localRecord.data.email) && (localRecord.data.password) ? true : false;
   }

   public static function getEmail():String
   {
      var localRecord:SharedObject = SharedObject.getLocal(LOCATION);
      return localRecord.data.email;
   }

   public static function getPassword():String
   {
      var localRecord:SharedObject = SharedObject.getLocal(LOCATION);
      return localRecord.data.password;
   }
}
}