package com.express.view.renderer {
import com.express.model.domain.Permissions;

import flash.events.Event;

import flash.events.MouseEvent;

import mx.controls.CheckBox;

public class ProjectAdminCheckBoxRenderer extends CheckBox{
   private var permissions : Permissions;

   public function ProjectAdminCheckBoxRenderer() {
      this.addEventListener(MouseEvent.CLICK, handleClick);
   }

   override public function set data(data : Object) : void {
      permissions = data.permissions as Permissions;
      this.selected = permissions.projectAdmin;
   }

   override public function get data() : Object {
      return this.selected;
   }

   private function handleClick(event : Event) : void {
      permissions.projectAdmin = this.selected;
   }
}
}