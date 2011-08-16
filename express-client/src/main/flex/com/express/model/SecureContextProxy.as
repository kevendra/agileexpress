package com.express.model
{
import com.express.model.domain.Project;
import com.express.model.domain.User;
import com.express.navigation.MenuItem;
import com.express.view.ApplicationMediator;

import mx.collections.ArrayCollection;

import org.puremvc.as3.patterns.proxy.Proxy;

public class SecureContextProxy extends Proxy
{
   public static const NAME:String = "SecureContextProxy";
   public static const ROLE_PROJECT_ADMIN :String = "role.projectAdmin";
   public static const ROLE_ITERATION_ADMIN :String = "role.iterationAdmin";

   private var _currentUser : User;
   private var _availableRoles: ArrayCollection;
   private var _menu : ArrayCollection;

   public function SecureContextProxy() {
      super(NAME, null);
      _availableRoles = new ArrayCollection();
      _menu = new ArrayCollection();
   }

   public function logout() : void {
      _currentUser = null;
   }

   public function get menu() : ArrayCollection {
      return _menu;
   }

   public function set currentUser(user : User) : void {
      _currentUser = user;
      if(user != null) {
         loadMenu();
      }
   }

   public function get currentUser() : User {
      return _currentUser;
   }

   public function get availableRoles():ArrayCollection {
      return _availableRoles;
   }

   public function setAvailableRoles(project : Project):void {
      _availableRoles.source = [];
      if (project.isIterationAdmin(_currentUser)) {
         _availableRoles.addItem(ROLE_ITERATION_ADMIN);
      }
      if (project.isProjectAdmin(_currentUser)) {
         _availableRoles.addItem(ROLE_PROJECT_ADMIN);
      }
   }

   private function loadMenu() : void {
      var menuItems : Array = [];
      var menuItem : MenuItem = new MenuItem("Backlog", ApplicationMediator.BACKLOG_VIEW, null);
      menuItems.push(menuItem);
      menuItem = new MenuItem("Wall", ApplicationMediator.WALL_VIEW ,  null);
      menuItems.push(menuItem);
      menuItem = new MenuItem(ApplicationMediator.PROFILE_HEAD, ApplicationMediator.PROFILE_VIEW, null);
      menuItems.push(menuItem);

      _menu.source = menuItems;
   }

   public function hasRole(role : String) : Boolean {
      for each(var existingRole : String in _availableRoles) {
         if(existingRole == role) {
            return true;
         }
      }
      return false;
   }
}
}