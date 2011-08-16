package com.express.view.themes {
import com.express.ApplicationFacade;
import com.express.controller.event.GridButtonEvent;
import com.express.model.ProjectProxy;
import com.express.model.domain.Theme;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.CloseEvent;
import mx.utils.StringUtil;

import org.puremvc.as3.patterns.mediator.Mediator;

public class ThemesMediator extends Mediator {
   public static const NAME:String = "ThemesMediator";

   private var _proxy:ProjectProxy;

   public function ThemesMediator(viewComp:ThemesForm, name:String = NAME) {
      super(name, viewComp);
      _proxy = ProjectProxy(facade.retrieveProxy(ProjectProxy.NAME));
      viewComp.grdThemes.dataProvider = _proxy.themes;
      viewComp.colId.labelFunction = formatId;
      viewComp.btnAdd.addEventListener(MouseEvent.CLICK, handleAddTheme);
      viewComp.btnSave.addEventListener(MouseEvent.CLICK, handleSaveThemes);
      viewComp.btnCancel.addEventListener(MouseEvent.CLICK, handleCancel);
      viewComp.grdThemes.addEventListener(GridButtonEvent.CLICK, handleGridButton);
   }

   private function handleAddTheme(event:Event):void {
      _proxy.themes.addItem(new Theme());
      view.grdThemes.editedItemPosition = {rowIndex: _proxy.themes.length - 1, columnIndex: 1};
   }

   private function handleSaveThemes(event:Event):void {
      if (validateThemes()) {
         sendNotification(ApplicationFacade.NOTE_UPDATE_THEMES);
         closeWindow();
      }
      else {
         sendNotification(ApplicationFacade.NOTE_SHOW_ERROR_MSG, "Invalid theme data");
      }
   }

   private function handleGridButton(event:GridButtonEvent):void {
      var index:int = view.grdThemes.selectedIndex;
      _proxy.themes.removeItemAt(index);
   }

   public function handleCancel(event:MouseEvent):void {
      _proxy.themes = _proxy.selectedProject.themes;
      closeWindow();
   }

   private function closeWindow():void {
      view.parent.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      sendNotification(ApplicationFacade.NOTE_CLEAR_MSG);
   }

   private function validateThemes():Boolean {
      for each(var theme:Theme in _proxy.themes) {
         if (theme.title == null || StringUtil.trim(theme.title) == "") {
            return false;
         }
      }
      return true;
   }

   private function formatId(row:Object, col:DataGridColumn):String {
      var theme:Theme = row as Theme;
      return theme.id ? theme.id.toString() : "-";
   }

   public function get view():ThemesForm {
      return viewComponent as ThemesForm;
   }

}
}