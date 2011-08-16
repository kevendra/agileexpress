package com.express.view.xpWall {
import com.express.model.domain.BacklogItem;
import com.express.view.scrumWall.*;

import flash.utils.Dictionary;

import mx.containers.HBox;
import mx.controls.Spacer;
import mx.core.Container;

public class WallRow extends HBox {

   public static const CARD_WIDTH :int = 125;
   public static const CARD_HEIGHT :int = 110;

   public var header : Container;

   private var _story : BacklogItem;

   private var _storyCard : StoryCard;
   private var _openLane : CardBox;
   private var _progressLane : CardBox;
   private var _testLane : CardBox;
   private var _doneLane : CardBox;
   private var _laneMap : Dictionary;

   public function WallRow() {
      super();
      _laneMap = new Dictionary();
      //Sotry card needs to go in the appropriate lane
      _storyCard = new StoryCard();

      _openLane = new CardBox();
      _laneMap[BacklogItem.STATUS_OPEN] = _openLane;
      var spacer : Spacer = new Spacer();
      _openLane.gridStatus = BacklogItem.STATUS_OPEN;
      _openLane.percentHeight = 100;
      _openLane.percentWidth = 100;
      _openLane.setStyle("backgroundColor", "#ffffff");
      this.addChild(_openLane);

      spacer = new Spacer();
      spacer.width = 10;
      this.addChild(spacer);

      _progressLane = new CardBox();
      _laneMap[BacklogItem.STATUS_PROGRESS] = _progressLane;
      _progressLane.gridStatus = BacklogItem.STATUS_PROGRESS;
      _progressLane.percentHeight = 100;
      _progressLane.percentWidth = 100;
      _progressLane.setStyle("backgroundColor", "#ffffff");
      this.addChild(_progressLane);

      spacer = new Spacer();
      spacer.width = 10;
      this.addChild(spacer);

      _testLane = new CardBox();
      _laneMap[BacklogItem.STATUS_TEST] = _testLane;
      _testLane.gridStatus = BacklogItem.STATUS_TEST;
      _testLane.percentHeight = 100;
      _testLane.percentWidth = 100;
      _testLane.setStyle("backgroundColor", "#ffffff");
      this.addChild(_testLane);

      spacer = new Spacer();
      spacer.width = 10;
      this.addChild(spacer);

      _doneLane = new CardBox();
      _laneMap[BacklogItem.STATUS_DONE] = _doneLane;
      _doneLane.gridStatus = BacklogItem.STATUS_DONE;
      _doneLane.percentHeight = 100;
      _doneLane.percentWidth = 100;
      _doneLane.setStyle("backgroundColor", "#ffffff");
      this.addChild(_doneLane);
      _laneMap[_story.status].addChild(_storyCard)

      this.minHeight = 100;
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
   }


   public function set openWidth(value:int):void {
      _openLane.width = value;
   }

   public function set progressWidth(value:int):void {
      _progressLane.width = value;
   }

   public function set testWidth(value:int):void {
      _testLane.width = value;
   }

   public function set doneWidth(value:int):void {
      _doneLane.width = value;
   }
}
}