package com.express.controller.event
{
import flash.events.Event;

public class GridButtonEvent extends Event
{
   public static const CLICK:String = "GridButtonEvent.CLICK";

   public static const ACTION_EDIT:int = 0;
   public static const ACTION_VIEW:int = 1;
   public static const ACTION_REMOVE:int = 2;
   public static const ACTION_ADD_CHILD:int = 3;
   public static const ACTION_ACCEPT:int = 4;
   public static const ACTION_REJECT:int = 5;

   private var _data:Object;
   private var _action:int;

   public function GridButtonEvent(bubbles:Boolean = false, cancelable:Boolean = false, data:Object = null, action:int = GridButtonEvent.ACTION_VIEW)
   {
      super(GridButtonEvent.CLICK, bubbles, cancelable);
      this._data = data;
      this._action = action;
   }

   public function get data():Object
   {
      return this._data;
   }

   public function get action():int
   {
      return this._action;
   }

   override public function clone():Event
   {
      return new GridButtonEvent(bubbles, cancelable, data, action);
   }
}
}