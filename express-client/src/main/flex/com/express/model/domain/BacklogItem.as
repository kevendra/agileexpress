package com.express.model.domain
{
import mx.collections.ArrayCollection;

[RemoteClass(alias="com.express.service.dto.BacklogItemDto")]
public class BacklogItem
{
   public static const STATUS_OPEN : String = "OPEN";
   public static const STATUS_PROGRESS : String = "IN PROGRESS";
   public static const STATUS_TEST : String = "TEST";
   public static const STATUS_DONE : String = "DONE";

   public function BacklogItem() {
      tasks = new ArrayCollection();
      themes = new ArrayCollection();
      acceptanceCriteria = new ArrayCollection();
   }

   public var id : Number;

   public var version : Number;

   [Bindable]
   public var title : String;

   [Bindable]
   public var reference : String;

   [Bindable]
   public var summary : String;

   public var detailedDescription : String;

   [Bindable]
   public var status : String = STATUS_OPEN;

   [Bindable]
   public var impediment : Issue;

   [Bindable]
   public var effort : int;

   [Bindable]
   public var businessValue : int;

   private var _assignedToLabel : String;

   private var _assignedTo : User;

   private var _colour : int;

   [Bindable]
   public var parent : BacklogItem;

   public var asA : String;

   public var want : String;

   public var soThat : String;

   public var project : Project;

   public var iteration : Iteration;

   public var tasks : ArrayCollection;

   public var themes : ArrayCollection;

   public var acceptanceCriteria : ArrayCollection;

   public function inProductBacklog() : Boolean {
      if(!parent) {
         return iteration == null;
      }
      else {
         return parent.inProductBacklog();
      }
   }

   public function hasTheme(theme:Theme) : Boolean {
      for each(var existingTheme:Theme in themes) {
         if(theme.id == existingTheme.id) {
            return true;
         }
      }
      return false;
   }

   public function isStory() : Boolean {
      return parent == null;
   }

   public function set assignedToLabel(value : String) : void {
      _assignedToLabel = value;
   }

   [Bindable]
   public function get assignedToLabel() : String {
      return _assignedToLabel;
   }

   public function get themesLabel() : String {
      if(parent) {
         return "-";
      }
      var length : int = themes.length;
      if(length == 0) {
         return "default";
      }
      var result : String = "";
      for(var index : int = 0; index < length; index++) {
         result += Theme(themes.getItemAt(index)).title;
         if(index < length - 1) {
            result += ", ";
         }
      }
      return result;
   }

   public function get titleLabel() : String {
      return !title || title == "" ? reference : title;
   }

   /**
    * Convenience method to retrieve the BacklogItem's project no matter whether it is in the
    * uncommittedBacklog, and iteration or a child of another BacklogItem.
    */
   public function getProject() : Project {
      if (project != null) {
         return project;
      }
      else if (iteration != null) {
         return iteration.project;
      }
      else if (parent != null) {
            return parent.getProject();
         }
      return null;
   }

   public function copyFrom(item : BacklogItem) : void {
      id = item.id;
      version = item.version;
      project = item.project;
      iteration = item.iteration;
      reference = item.reference;
      summary = item.summary;
      detailedDescription = item.detailedDescription;
      status = item.status;
      effort = item.effort;
      businessValue = item.businessValue;
      assignedTo = item.assignedTo;
      tasks = item.tasks;
      parent = item.parent;
      asA = item.asA;
      want = item.want;
      soThat = item.soThat;
      themes = item.themes;
      acceptanceCriteria = item.acceptanceCriteria;
      impediment = item.impediment;
   }

   public function get assignedTo():User {
      return _assignedTo;
   }

   public function set assignedTo(value:User):void {
      _assignedTo = value;
      if(!_assignedTo) {
         assignedToLabel =  "Unassigned";
         colour = 0;
      }
      else {
         assignedToLabel = _assignedTo.fullName;
         colour = _assignedTo.colour;
      }
   }

   [Bindable]
   public function get colour():int {
      return _colour;
   }

   public function set colour(value:int):void {
      _colour = value;
   }

   public function get canAddTask() : Boolean {
      return this.parent == null && this.project.methodology == Project.METHODOLOGY_SCRUM;
   }

}
}