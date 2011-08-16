package com.express.model
{
public class NavigationItem
{
   private var _index : uint;

   private var _heading : String;

   public function NavigationItem(index:uint, heading:String) {
      _index = index;
      _heading = heading;
   }

   public function get index() : uint {
      return _index;
   }

   public function get heading() : String {
      return _heading;
   }

}
}