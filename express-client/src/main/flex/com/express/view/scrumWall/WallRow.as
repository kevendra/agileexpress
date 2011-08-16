package com.express.view.scrumWall {
import com.express.model.domain.BacklogItem;

import mx.containers.HBox;
import mx.controls.Spacer;
import mx.core.Container;
import mx.events.DividerEvent;
import mx.events.FlexEvent;

public class WallRow extends HBox {

   public static const CARD_WIDTH :int = 125;
   public static const CARD_HEIGHT :int = 110;

   public var header : Container;

   private var _story : BacklogItem;

   private var _storyCard : StoryCard;
   private var _openGrid : CardGrid;
   private var _progressGrid : CardGrid;
   private var _testGrid : CardGrid;
   private var _doneGrid : CardGrid;
   private var _allGrids : Array;
   private var _resizeIndex : int;

   public function WallRow() {
      super();
      _storyCard = new StoryCard();
      this.addChild(_storyCard);
      var spacer : Spacer = new Spacer();
      spacer.width = 5;
      this.addChild(spacer);
      _openGrid = new CardGrid();
      _openGrid.gridStatus = BacklogItem.STATUS_OPEN;
      _openGrid.percentHeight = 100;
      _openGrid.percentWidth = 100;
      _openGrid.setStyle("backgroundColor", "#ffffff");
      this.addChild(_openGrid);

      spacer = new Spacer();
      spacer.width = 10;
      this.addChild(spacer);

      _progressGrid = new CardGrid();
      _progressGrid.gridStatus = BacklogItem.STATUS_PROGRESS;
      _progressGrid.percentHeight = 100;
      _progressGrid.percentWidth = 100;
      _progressGrid.setStyle("backgroundColor", "#ffffff");
      this.addChild(_progressGrid);

      spacer = new Spacer();
      spacer.width = 10;
      this.addChild(spacer);

      _testGrid = new CardGrid();
      _testGrid.gridStatus = BacklogItem.STATUS_TEST;
      _testGrid.percentHeight = 100;
      _testGrid.percentWidth = 100;
      _testGrid.setStyle("backgroundColor", "#ffffff");
      this.addChild(_testGrid);

      spacer = new Spacer();
      spacer.width = 10;
      this.addChild(spacer);

      _doneGrid = new CardGrid();
      _doneGrid.gridStatus = BacklogItem.STATUS_DONE;
      _doneGrid.percentHeight = 100;
      _doneGrid.percentWidth = 100;
      _doneGrid.setStyle("backgroundColor", "#ffffff");
      this.addChild(_doneGrid);
      _allGrids = [_openGrid, _progressGrid, _testGrid, _doneGrid];

      this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
      this.minHeight = 100;
   }

   /**
    * It is more efficient to only resize the grids that are effected by the divider being moved
    * @param event
    */
   private function handleResizeIndexes(event:DividerEvent):void {
      _resizeIndex = event.dividerIndex;
   }

   /**
    * When the header is resized all CardGrids need to lay themselves out again. We first set
    * the row height back to the minimum. It will then end up the height of the tallest CardGrid.
    * @param event
    */
   private function handleHeaderResize(event : FlexEvent):void {
      this.height = CARD_HEIGHT + 3;
      for(var index : int = 0; index < _allGrids.length; index++) {
         if(index == _resizeIndex || index == (_resizeIndex + 1)) {
            _allGrids[index].layoutCards();
         }
         else {
            setRowHeight(_allGrids[index].getLayedOutHeight());
         }
      }
   }

   private function handleCreationComplete(event : FlexEvent) : void {
      header.parent.addEventListener(FlexEvent.UPDATE_COMPLETE, handleHeaderResize);
      header.parent.addEventListener(DividerEvent.DIVIDER_RELEASE, handleResizeIndexes);
   }

   public function setRowHeight(newHeight : int) : void {
      if(newHeight > this.height) {
         this.height = newHeight + 3;
      }
   }

   public function get story():BacklogItem {
      return _story;
   }

   public function set story(value:BacklogItem):void {
      _story = value;
      _storyCard.story = _story;
      _openGrid.story = _story;
      _progressGrid.story = _story;
      _testGrid.story = _story;
      _doneGrid.story = _story;
      sortTasks();
   }

   public function layoutCards() : void {
      this.height = WallRow.CARD_HEIGHT + 8;
      sortTasks();
   }

   private function sortTasks() : void {
      var tasks : Array = [];
      tasks[BacklogItem.STATUS_OPEN] = [];
      tasks[BacklogItem.STATUS_PROGRESS] = [];
      tasks[BacklogItem.STATUS_TEST] = [];
      tasks[BacklogItem.STATUS_DONE] = [];
      for each (var task : BacklogItem in _story.tasks) {
         tasks[task.status].push(task);
      }
      _openGrid.tasks = tasks[BacklogItem.STATUS_OPEN];
      _progressGrid.tasks = tasks[BacklogItem.STATUS_PROGRESS];
      _testGrid.tasks = tasks[BacklogItem.STATUS_TEST];
      _doneGrid.tasks = tasks[BacklogItem.STATUS_DONE];
   }

   public function set openWidth(value:int):void {
      _openGrid.width = value;
   }

   public function set progressWidth(value:int):void {
      _progressGrid.width = value;
   }

   public function set testWidth(value:int):void {
      _testGrid.width = value;
   }

   public function set doneWidth(value:int):void {
      _doneGrid.width = value;
   }
}
}