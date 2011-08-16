package com.express.security {
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.core.UIComponent;
import mx.events.CollectionEvent;
import mx.events.FlexEvent;

public class Authorize extends EventDispatcher{

   public static const HAS_ANY : String = "hasAny";
   public static const HAS_ALL : String = "hasAll";
   public static const HAS_NONE : String = "hasNone";

   public static const DISABLE : String = "disable";
   public static const VANISH : String = "vanish";
   public static const COLLAPSE : String = "collapse";

   /**
    * Roles which will be evaluated against the type rules and user's roles.
    */
   private var _roles : ICollectionView;

   /**
    * Roles which the current user has. These will be evauated aginst the type rules and roles.
    */
   private var _userRoles : ICollectionView;

   /**
    * Components which will have behaviour applied to them based on the evaluation outcome.
    */
   private var _components : ICollectionView;

   /**
    * Specifies the type of evaluation which will be applied to the roles
    */
   [Inspectable(enumeration="hasAny,hasAll,hasNone")]
   public var type : String;

   /**
    * Specifies the type of evaluation which will be applied to the roles
    */
   [Inspectable(enumeration="disable,vanish,collapse")]
   public var behaviour : String;

   public function Authorize() {
      super();
      addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
   }

   private function handleCreationComplete(event : FlexEvent) : void {
      evaluate();
   }

   public function evaluate() : void {
      var result : Boolean = false;
      if (_roles != null && _userRoles != null && type != null) {
         if (type == HAS_ANY) {
            result = evaluateAny();
         }
         else if (type == HAS_ALL) {
            result = evaluateAll();
         }
         else if (type == HAS_NONE) {
            result = evaluateNone();
         }
      }
      applyResult(result);
   }

   protected function evaluateAny() : Boolean {
      for each(var userRole : String in _userRoles) {
         if (containsRole(_roles, userRole)) {
            return true;
         }
      }
      return false;
   }

   protected function evaluateAll() : Boolean {
      for each(var userRole : String in _userRoles) {
         if (!containsRole(_roles, userRole)) {
            return false;
         }
      }
      return true;
   }

   protected function evaluateNone() : Boolean {
      for each(var userRole : String in _userRoles) {
         if (containsRole(_roles, userRole)) {
            return false;
         }
      }
      return true;
   }

   protected function containsRole(roles : ICollectionView, role : String) : Boolean {
      for each(var userRole : String in roles) {
         if (role == userRole) {
            return true;
         }
      }
      return false;
   }

   protected function applyResult(result : Boolean) : void {
      for each(var comp : UIComponent in _components) {
         switch(behaviour) {
            case DISABLE :
               comp.enabled = result;
               break;
            case VANISH :
               comp.visible = result;
               break;
            case COLLAPSE :
               comp.visible = result;
               comp.includeInLayout = result;
         }
      }
   }

   public function get roles():Object {
      return _roles;
   }

   public function set roles(val:Object):void {
      _roles = convertToCollection(val);
      evaluate();
   }

   public function get userRoles():Object {
      return _userRoles;
   }

   public function set userRoles(val:Object):void {
      _userRoles = convertToCollection(val);
      _userRoles.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChange, false, 0, true);
      evaluate();
   }

   public function get components():Object {
      return _components;
   }

   public function set components(val:Object):void {
      _components = convertToCollection(val);
      _components.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChange, false, 0, true);
      evaluate();
   }

   private function handleCollectionChange(event : Event) : void {
      evaluate();
   }

   public function convertToCollection(value : Object) : ICollectionView {
      if (value is Array) {
         return new ArrayCollection(value as Array);
      }
      else if (value is ICollectionView) {
         return ICollectionView(value);
      }
      else if (value is IList) {
         return new ListCollectionView(IList(value));
      }
      else if (value is XMLList) {
         return new XMLListCollection(value as XMLList);
      }
      else {
         // convert it to an array containing this one item
         var tmp:Array = [value];
         return new ArrayCollection(tmp);
      }
   }
}
}