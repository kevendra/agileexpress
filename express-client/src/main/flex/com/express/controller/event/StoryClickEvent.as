package com.express.controller.event
{
import com.express.model.domain.BacklogItem;

import flash.events.Event;

public class StoryClickEvent extends Event
{
   public static const STORY_EDIT : String = "storyClick";
   public static const TASK_ADD : String = "taskAdd";

   private var _story : BacklogItem;

   public function StoryClickEvent(story : BacklogItem, bubbles:Boolean = false, cancelable:Boolean = false, eventName : String = STORY_EDIT)
   {
      super(eventName, bubbles, cancelable);
      _story = story;
   }

   public function get story() : BacklogItem {
      return _story;
   }

}
}