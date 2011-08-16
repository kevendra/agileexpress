package com.express.view.scrumWall {
import com.express.ApplicationFacade;
import com.express.model.SecureContextProxy;
import com.express.model.domain.BacklogItem;
import com.express.model.domain.Project;
import com.express.model.domain.User;

import mx.binding.utils.BindingUtils;
import mx.collections.ArrayCollection;
import mx.events.ListEvent;

public class QuickMenu {

   public static const NOTE_ADD_TASK:String = "Note.AddTAsk";
   public static const NOTE_MARK_DONE:String = "Note.MarkDone";
   public static const NOTE_IMPEDED:String = "Note.Impeded";
   public static const NOTE_UNIMPEDED:String = "Note.Unimpeded";
   public static const NOTE_VIEW_IMPEDIMENT:String = "Note.ViewImpdeiment";
   public static const NOTE_TAKE : String = "Note.Take";
   public static const NOTE_UNASSIGN:String = "Note.UnassignTask";

   private static const _ADD_TASK:String = "Add Task";
   private static const _MARK_DONE:String = "Mark as Done";
   private static const _IMPEDED:String = "Impeded";
   private static const _UNIMPEDED:String = "Unimpeded";
   private static const _VIEW_IMPEDIMENT:String = "View Impediment";
   private static const _TAKE:String = "Assign to me";
   private static const _UNASSIGN:String = "Unassign";

   private var _quickMenu : ArrayCollection;
   private var _facade:ApplicationFacade;
   private var _item : BacklogItem;

   public function QuickMenu() {
      _facade = ApplicationFacade.getInstance();
      _quickMenu = new ArrayCollection()
   }

   public function get quickMenu():ArrayCollection {
      return _quickMenu;
   }

   public function set item(value:BacklogItem):void {
      _item = value;
      buildMenu();
      BindingUtils.bindSetter(buildMenu, value, "impediment");
      BindingUtils.bindSetter(buildMenu, value, "assignedToLabel");
   }

   private function buildMenu(obj:Object = null):void {
      _quickMenu.source = [];
      if (_item.canAddTask) {
         _quickMenu.addItem(_ADD_TASK);
         _quickMenu.addItem(_MARK_DONE);
      }
      if (_item.impediment) {
         _quickMenu.addItem(_VIEW_IMPEDIMENT);
         _quickMenu.addItem(_UNIMPEDED);
      }
      else {
         _quickMenu.addItem(_IMPEDED);
      }
      if (_item.assignedTo) {
         _quickMenu.addItem(_UNASSIGN);
      }
      var currentUser:User = SecureContextProxy(_facade.retrieveProxy(SecureContextProxy.NAME)).currentUser;
      if (!(_item.assignedTo) || _item.assignedTo.id != currentUser.id) {
         _quickMenu.addItem(_TAKE);
      }
   }

   public function handleQuickMenuSelection(event:ListEvent):void {
      switch (_quickMenu[event.rowIndex]) {
         case _ADD_TASK :
            _facade.sendNotification(NOTE_ADD_TASK, _item);
            break;
         case _MARK_DONE :
            _facade.sendNotification(NOTE_MARK_DONE, _item);
            break;
         case _IMPEDED :
            _facade.sendNotification(NOTE_IMPEDED, _item);
            break;
         case _UNIMPEDED :
            _facade.sendNotification(NOTE_UNIMPEDED, _item);
            break;
         case _VIEW_IMPEDIMENT :
            _facade.sendNotification(NOTE_VIEW_IMPEDIMENT, _item);
            break;
         case _TAKE :
            _facade.sendNotification(NOTE_TAKE, _item);
            break;
         case _UNASSIGN :
            _facade.sendNotification(NOTE_UNASSIGN, _item);
            break;
      }
   }
}
}