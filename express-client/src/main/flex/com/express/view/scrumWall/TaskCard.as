package com.express.view.scrumWall {
import com.express.ApplicationFacade;
import com.express.model.domain.BacklogItem;
import com.express.view.backlogItem.BacklogItemMediator;
import com.express.view.components.PopUpLabel;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import mx.binding.utils.BindingUtils;
import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Label;
import mx.controls.Text;
import mx.core.DragSource;
import mx.events.ListEvent;
import mx.managers.DragManager;

public class TaskCard extends VBox {

   private static const _EFFORT_PREFIX : String = "Remaining hrs:";

   private var _facade:ApplicationFacade;
   private var _quickMenu : QuickMenu;
   private var _task:BacklogItem;
   private var _colour : int;

   //Child visual components
   private var _refHeading : Label;
   private var _actionPopUp:PopUpLabel;
   private var _text:Text;
   private var _dot : Box;
   private var _assignedToLabel : Label;
   private var _effortLabel : Label;

   public function TaskCard() {
      super()
      _facade = ApplicationFacade.getInstance();
      var headerBox:HBox = new HBox();
      headerBox.styleName = "storyCardHeaderBox";
      headerBox.percentWidth = 100;
      _refHeading = new Label();
      _refHeading.styleName = "cardHeading";
      _refHeading.width = 95;
      _quickMenu = new QuickMenu();
      _actionPopUp = new PopUpLabel();
      _actionPopUp.dataProvider = _quickMenu.quickMenu;
      _actionPopUp.styleName = "storyQuickMenu";
      _actionPopUp.addEventListener(ListEvent.ITEM_CLICK, _quickMenu.handleQuickMenuSelection);
      headerBox.addChild(_refHeading);
      headerBox.addChild(_actionPopUp);

      _text = new Text();
      _text.percentWidth = 100;
      _text.height = 48;
      _text.styleName = "cardSummaryText";

      var assignedBox : HBox = new HBox();
      assignedBox.percentWidth = 100;
      assignedBox.setStyle("horizontalGap",0);
      _dot = new Box();
      _dot.height = 13;
      _dot.width = 13;
      _dot.styleName = "cardColourDot";
      assignedBox.addChild(_dot);
      _assignedToLabel = new Label();
      _assignedToLabel.styleName = "cardText";
      assignedBox.addChild(_assignedToLabel);

      _effortLabel = new Label();
      _effortLabel.styleName = "cardText";

      this.addChild(headerBox);
      this.addChild(_text);
      this.addChild(assignedBox);
      this.addChild(_effortLabel);
      this.width = WallRow.CARD_WIDTH;
      this.height = WallRow.CARD_HEIGHT;
      this.horizontalScrollPolicy = "off";
      this.verticalScrollPolicy = "off";
      addDropShadow();
      this.addEventListener(MouseEvent.MOUSE_MOVE, handleDragStart);
      this.doubleClickEnabled = true;
      this.addEventListener(MouseEvent.DOUBLE_CLICK, handleDoubleClick);
   }

   private function handleDragStart(event:MouseEvent):void {
      var source : DragSource = new DragSource();
      source.addData(this, "taskCard");
      DragManager.doDrag(this,source,event);
   }

   private function handleDoubleClick(event:MouseEvent):void {
      _facade.sendNotification(BacklogItemMediator.EDIT, _task);
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

   public function get task() : BacklogItem {
      return _task;
   }

   public function set task(value:BacklogItem):void {
      _quickMenu.item = _task = value;
      BindingUtils.bindProperty(_refHeading, "text", _task, "reference");
      BindingUtils.bindProperty(_text, "text", _task, "summary");
      BindingUtils.bindProperty(_text, "toolTip", _task, "summary");
      BindingUtils.bindProperty(_assignedToLabel, "text", _task, "assignedToLabel");
      BindingUtils.bindSetter(setColour, _task, "colour");
      BindingUtils.bindSetter(setCardStyle, _task, "impediment");
      _dot.setStyle("borderColor", _colour);
      _dot.setStyle("backgroundColor", _colour);
      _effortLabel.text = _EFFORT_PREFIX + " " + _task.effort;
      setCardStyle();
   }

   private function setCardStyle(value : Object = null) : void {
      this.styleName = _task.impediment ? "taskImpeded" : "";
   }

   private function setColour(value : Object = null) : void {
      _colour = _task.colour;
      _dot.setStyle("borderColor", _colour);
      _dot.setStyle("backgroundColor", _colour);
   }
}
}