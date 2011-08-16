package com.express.view.scrumWall {
import com.express.ApplicationFacade;
import com.express.model.domain.BacklogItem;
import com.express.view.backlogItem.BacklogItemMediator;
import com.express.view.components.PopUpLabel;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import mx.binding.utils.BindingUtils;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Label;
import mx.controls.Text;
import mx.events.ListEvent;

public class StoryCard extends VBox {

   private var _facade:ApplicationFacade;
   

   //Child visual components
   private var _refHeading:Label;
   private var _statusHeading:Label;
   private var _text:Text;
   private var _actionPopUp:PopUpLabel;

   [Bindable]
   public var _story:BacklogItem;

   private var _quickMenu : QuickMenu;

   public function StoryCard() {
      super();
      var headerBox:HBox = new HBox();
      headerBox.styleName = "storyCardHeaderBox";
      headerBox.percentWidth = 100;
      _refHeading = new Label();
      _refHeading.styleName = "h3";
      _refHeading.width = 75;
      headerBox.addChild(_refHeading);
      _statusHeading = new Label();
      _statusHeading.percentWidth = 100;
      headerBox.addChild(_statusHeading);
      _quickMenu = new QuickMenu();
      _actionPopUp = new PopUpLabel();
      _actionPopUp.dataProvider = _quickMenu.quickMenu;
      _actionPopUp.styleName = "storyQuickMenu";
      _actionPopUp.addEventListener(ListEvent.ITEM_CLICK, _quickMenu.handleQuickMenuSelection);
      headerBox.addChild(_actionPopUp);

      _text = new Text();
      _text.width = 205;
      _text.height = 80;
      _text.styleName = "storyText";

      this.addChild(headerBox);
      this.addChild(_text);
      this.width = 220;
      _facade = ApplicationFacade.getInstance();
      this.doubleClickEnabled = true;
      this.addEventListener(MouseEvent.DOUBLE_CLICK, handleDoubleClick);
      addDropShadow();
   }

   private function handleDoubleClick(event:MouseEvent):void {
      _facade.sendNotification(BacklogItemMediator.EDIT, _story);
   }


   private function addDropShadow() : void {
      var newFilters : Array = [];
      var shadowFilter : DropShadowFilter = new DropShadowFilter();
      shadowFilter.angle = 45;
      shadowFilter.hideObject = false;
      shadowFilter.alpha = 0.4;
      newFilters.push(shadowFilter);
      this.filters = newFilters;
   }

   public function set story(value:BacklogItem):void {
      if(_story && _story.id == value.id) {
         _story.copyFrom(value);
      }
      else {
         _quickMenu.item = _story = value;
         BindingUtils.bindProperty(_refHeading, "text", _story, "reference");
         BindingUtils.bindProperty(_statusHeading, "text", _story, "status");
         BindingUtils.bindProperty(_text, "text", _story, "summary");
         BindingUtils.bindProperty(_text, "toolTip", _story, "summary");
         BindingUtils.bindSetter(setCardStyle, _story, "impediment");
      }
      setCardStyle();
   }

   private function setCardStyle(value : Object = null) : void {
      this.styleName = _story.impediment ? "storyImpeded" : "";
   }
}
}