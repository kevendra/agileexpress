package com.express.navigation
{
import mx.collections.ArrayCollection;

/**
 * Data structure for building a MenuBar navigation model.
 */
public class MenuItem {

   public var label : String;

   public var icon : String;

   public var index : int;

   public var children : ArrayCollection;

   public function MenuItem(label : String, index : int, icon : String) {
      this.label = label;
      this.icon = icon;
      this.index = index;
   }

}
}