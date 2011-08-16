package com.express.view.components
{
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.controls.List;
import mx.controls.TextInput;
import mx.core.Application;
import mx.events.ListEvent;
import mx.managers.PopUpManager;

public class AutoCompleteTextInput extends TextInput
{
   private static const ROW_COUNT : uint = 6;
   public static const NOTE_ITEM_SELECTED : String = "note.itemSelected";
   private var _dropDown : List;
   private var _selectedItem:Object;
   private var _settingFromSelection : Boolean;
   private var _dataProvider : ArrayCollection;
   public var labelField : String;

   public function AutoCompleteTextInput() {
      addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
      addEventListener(Event.CHANGE, handleTextChange);
      addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
   }

   private function createDropDown() : void {
      _dropDown = new List();
      _dropDown.labelField = labelField;
      _dropDown.rowCount = ROW_COUNT;
      _dropDown.focusEnabled = false;
      _dropDown.dataProvider = dataProvider;
      _dropDown.addEventListener(ListEvent.ITEM_CLICK, handleItemClick);
      Application.application.stage.addEventListener(MouseEvent.CLICK, handleMouseClick);
   }

   private function handleKeyDown(event : KeyboardEvent) : void {
      if (isDropDownVisible()) {
         if (event.keyCode == Keyboard.ENTER) {
            _settingFromSelection = true;
            this.selectedItem = _dropDown.selectedItem;
            event.stopImmediatePropagation();
         }
         else if (event.keyCode == Keyboard.DOWN) {
            _dropDown.selectedIndex ++;
            _dropDown.scrollToIndex(_dropDown.selectedIndex);
         }
         else if (event.keyCode == Keyboard.UP) {
            if (_dropDown.selectedIndex > 0) {
               _dropDown.selectedIndex --;
               _dropDown.scrollToIndex(_dropDown.selectedIndex);
            }
            setSelection(text.length, _dropDown.selectedItem.toString().length);
         }
         else if (event.keyCode == Keyboard.ESCAPE || event.keyCode == Keyboard.TAB) {
            hideDropDown();
         }
      }
   }

   public function set selectedItem(value : Object) : void {
      _selectedItem = value;
      if (isDropDownVisible()) {
         hideDropDown();
      }
      callLater(setTextValue);
      dispatchEvent(new Event(NOTE_ITEM_SELECTED));
   }

   private function setTextValue() : void {
      if (_selectedItem) {
         text = (labelField) ? _selectedItem[labelField] : _selectedItem.toString();
         setSelection(text.length, text.length);
      }
      else {
         text = null;
      }
   }

   [Bindable]
   public function get selectedItem() : Object {
      return _selectedItem;
   }

   private function handleItemClick(event : ListEvent) : void {
      selectedItem = _dropDown.selectedItem;
   }

   [Bindable]
   public function get dataProvider() : ArrayCollection {
      return _dataProvider;
   }

   public function set dataProvider(list : ArrayCollection) : void {
      _dataProvider = list;
      if (_dropDown) {
         _dropDown.dataProvider = dataProvider;
      }
   }

   /**
    * If the list is visible and we click somewhere else
    * we're going to close it
    */
   private function handleMouseClick(event : MouseEvent) : void {
      if (!isDropDownVisible()) {
         return;
      }
      if (!_dropDown.hitTestPoint(event.stageX, event.stageY)) {
         hideDropDown();
      }
   }

   public function handleTextChange(event : Event) : void {
      if(_settingFromSelection) {
         _settingFromSelection = false;
         return;
      }
      filterData();
      if (dataProvider.length == 0) {
         hideDropDown();
         return;
      }
      if (isDropDownVisible()) {
         if (text.length == 0) {
            hideDropDown();
         }
      }
      else {
         if (text.length > 0) {
            showDropDown();
         }
      }

      if (isDropDownVisible()) {
         callLater(positionDropDown);
         callLater(highlightFirstItem);
         _dropDown.rowCount = (dataProvider.length < ROW_COUNT ? dataProvider.length : ROW_COUNT);
      }
   }

   private function highlightFirstItem() : void {
      _dropDown.selectedIndex = 0;
   }

   private function filterData() : void {
      dataProvider.filterFunction = defaultFilterFunction;
      dataProvider.refresh();
   }

   private function defaultFilterFunction(item : Object) : Boolean {
      if(!item) {
         return false;
      }
      var itemString : String = (labelField) ? item[labelField] : item.toString();
      return beginsWith(itemString, text);
   }

   private function showDropDown() : void {
      if (!_dropDown) {
         createDropDown();
      }
      _dropDown.width = width;
      PopUpManager.addPopUp(_dropDown, this);
   }

   private function positionDropDown() : void {
      var localPoint : Point = new Point(0, height);
      var globalPoint : Point = localToGlobal(localPoint);
      _dropDown.x = globalPoint.x;
      // check if it will fit below the textInput
      if (Application.application.height - globalPoint.y > _dropDown.height) {
         _dropDown.y = globalPoint.y;
      }
      else {
         _dropDown.y = globalPoint.y - height - _dropDown.height;
      }
   }

   private function handleFocusOut(event : FocusEvent) : void {
      hideDropDown();
   }

   private function hideDropDown() : void {
      if(isDropDownVisible()) {
         PopUpManager.removePopUp(_dropDown);
      }
   }

   public function isDropDownVisible() : Boolean {
      return _dropDown && _dropDown.parent;
   }

   public function beginsWith(string : String, pattern : String) : Boolean {
      if (!string) {
         return false;
      }
      string = string.toLowerCase();
      pattern = pattern.toLowerCase();
      return pattern == string.substr(0, pattern.length);
   }

}
}