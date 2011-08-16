package com.express.model
{
import com.express.model.domain.BacklogItem;

import com.express.model.domain.Iteration;

import mx.collections.ArrayCollection;

import org.puremvc.as3.patterns.proxy.Proxy;

public class WallProxy extends Proxy
{
   public static const NAME : String = "WallProxy";

   public var inProgressItem : BacklogItem;
   public var currentIteration : Iteration;
   private var _currentBacklog : ArrayCollection;

   public function WallProxy() {
      super(NAME, null);
      _currentBacklog = new ArrayCollection();
   }

   public function get currentBacklog() : ArrayCollection {
      return _currentBacklog;
   }

   public function set currentBacklog(backlog : ArrayCollection) : void {
      _currentBacklog.source = backlog.source.concat();
   }

   public function refreshCurrentBacklog(backlog : ArrayCollection) : void {
      for each(var item : BacklogItem in backlog) {
         var oldItem : BacklogItem = findInBacklog(item.id);
         if(oldItem) {
            oldItem.copyFrom(item);
         }
         else{
            backlog.addItem(item);
         }
      }
   }

   public function removeBacklogItem(item : BacklogItem) : void {
      if(item.parent == null) {
         removeItemFromCollection(item.id, _currentBacklog);
      }
//      else {
//         removeItemFromCollection(item.id, _taskCollections[item.status]);
//      }
   }




   private function findInBacklog(id : Number) : BacklogItem {
      for each( var item : BacklogItem in _currentBacklog) {
         if(item.id == id) {
            return item;
         }
      }
      return null;
   }

   private function removeItemFromCollection(id : Number, collection : ArrayCollection) : void {
      var index : int = 0;
      for each(var item : BacklogItem in collection) {
         if(id == item.id) {
            collection.removeItemAt(index);
            return;
         }
         index++;
      }
   }

}
}