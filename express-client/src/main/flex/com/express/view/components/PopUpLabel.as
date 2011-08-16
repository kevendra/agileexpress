package com.express.view.components {
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Image;
import mx.controls.Label;
import mx.controls.List;
import mx.core.Application;
import mx.events.CollectionEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;

public class PopUpLabel extends HBox {

   public var _dataProvider:ICollectionView;

   private var _labelText:String;

   [Bindable]
   [Embed(source="/images/icons/down.png")]
   public var popUpIcon:Class;

   [Bindable]
   [Embed(source="/images/icons/down-over.png")]
   public var popUpIconOver:Class;

   [Bindable]
   [Embed(source="/images/icons/down-disabled.png")]
   public var popUpIconDisabled:Class;

   [Bindable]
   public var labelStyleName:String;

   [Bindable]
   public var labelFunction:Function;

   [Bindable]
   public var selectedIndex:int;

   [Bindable]
   public var leftIcon:Class;

   private var _popup:VBox;
   private var _rowHeight:int = 23;
   private var _img:Image;
   private var _label:Label;
   private var _list:List;
   private var _leftImg:Image;

   public function PopUpLabel() {
      this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
   }

   private function handleCreationComplete(event:Event):void {
      if (leftIcon) {
         _leftImg = new Image();
         _leftImg.source = leftIcon;
         this.addChild(_leftImg);
      }
      if (_labelText) {
         _label = new Label();
         _label.text = _labelText;
         _label.styleName = labelStyleName;
         this.addChild(_label);
      }
      _img = new Image();
      _img.source = popUpIcon;
      _img.addEventListener(MouseEvent.MOUSE_OVER, handleIconOver);
      _img.addEventListener(MouseEvent.MOUSE_OUT, handleIconOff);
      _img.addEventListener(MouseEvent.CLICK, popup);
      _img.buttonMode = true;
      _img.useHandCursor = true;

      this.addChild(_img);
   }

   private function createPopUp():void {
      _popup = new VBox();
      _popup.verticalScrollPolicy = "off";
      _popup.horizontalScrollPolicy = "off";
      _list = new List();
      _list.dataProvider = _dataProvider;
      if (labelFunction != null) {
         _list.labelFunction = labelFunction;
      }
      _list.styleName = "popupList";
      _list.addEventListener(ListEvent.ITEM_CLICK, handleEventListItemClick);
      _list.height = (_dataProvider.length + 1) * _rowHeight;
      _list.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleListSizeChange);
      selectedIndex = -1;
      _popup.addChild(_list);
   }

   private function handleListSizeChange(event:CollectionEvent):void {
      _list.height = (_dataProvider.length + 1) * _rowHeight;
   }

   private function handleIconOver(event:Event):void {
      _img.source = popUpIconOver;
   }

   private function handleIconOff(event:Event):void {
      _img.source = popUpIcon;
   }

   private function handleEventListItemClick(event:ListEvent):void {
      selectedIndex = event.rowIndex;
      this.dispatchEvent(event);
   }

   private function popup(event:MouseEvent):void {
      if (!_popup) {
         createPopUp();
      }
      PopUpManager.addPopUp(_popup, Application.application as Express);
      var newX:int = event.stageX;
      if (newX + _popup.width > Application.application.width) {
         newX = newX - _popup.width;
      }
      _popup.x = newX;
      _popup.y = event.stageY;
      _list.selectedIndex = -1;
      event.stopImmediatePropagation();
      Application.application.stage.addEventListener(MouseEvent.CLICK, handleMouseClick);
   }

   private function handleMouseClick(event:MouseEvent):void {
      PopUpManager.removePopUp(_popup);
      Application.application.stage.removeEventListener(MouseEvent.CLICK, handleMouseClick);
   }

   public function set dataProvider(value:Object):void {
      if (value is Array) {
         _dataProvider = new ArrayCollection(value as Array);
      } else if (value is ICollectionView) {
         _dataProvider = ICollectionView(value);
      } else if (value is IList) {
         _dataProvider = new ListCollectionView(IList(value));
      } else if (value is XMLList) {
         _dataProvider = new XMLListCollection(value as XMLList);
      }
      else {
         // convert it to an array containing this one item
         var tmp:Array = [value];
         _dataProvider = new ArrayCollection(tmp);
      }
   }

   [Bindable]
   public function get labelText():String {
      return _labelText;
   }

   public function set labelText(value:String):void {
      _labelText = value;
      if (_label) {
         _label.text = _labelText;
      }
   }
}
}