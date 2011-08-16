package com.express.model.domain
{
import mx.collections.ArrayCollection;

[RemoteClass(alias="com.express.service.dto.ProjectDto")]
public class Project
{
   public static const EFFORT_HOURS : String = "hrs";
   public static const EFFORT_DAYS : String = "days";
   public static const EFFORT_STORY_PTS : String = "pts";

   public static const METHODOLOGY_SCRUM : String = "Scrum";
   public static const METHODOLOGY_XP : String = "XP";

   public static const EFFORT_UNITS : Array = [EFFORT_STORY_PTS, EFFORT_DAYS, EFFORT_HOURS];
   public static const METHODOLOGIES : Array = [METHODOLOGY_SCRUM, METHODOLOGY_XP];

   public function Project() {
      iterations = new ArrayCollection();
      productBacklog = new ArrayCollection();
      projectWorkers = new ArrayCollection();
      defects = new ArrayCollection();
      accessRequests = new ArrayCollection();
      actors = new ArrayCollection();
      themes = new ArrayCollection();
   }

   public var id :Number;

   public var version : Number;

   public var title : String;

   public var description : String;

   public var reference : String;

   public var effortUnit : String = EFFORT_STORY_PTS;

   public var startDate : Date;

   public var methodology : String;

   private var _targetReleaseDate : Date;

   public var productBacklog : ArrayCollection;

   public var iterations : ArrayCollection;

   public var projectWorkers : ArrayCollection;

   public var defects : ArrayCollection;

   public var accessRequests : ArrayCollection;

   public var actors : ArrayCollection;

   public var themes : ArrayCollection;

   public var history : ArrayCollection;

   public function get currentIteration() : Iteration {
      var today : Date = new Date();
      for each(var iteration : Iteration in iterations) {
         if(iteration.getDaysRemaining() > 0) {
            return iteration;
         }
      }
      return null;
   }

   public function addActor(actor : String) : void {
      if(!containsActor(actor)) {
         actors.addItem(actor);
      }
   }

   private function containsActor(actor : String) : Boolean {
      for each(var existing : String in actors) {
         if(existing == actor) {
            return true;
         }
      }
      return false;
   }

   public function isDeveloper(user : User) : Boolean {
      for each(var worker : ProjectWorker in projectWorkers) {
         if (worker.worker.id == user.id) {
            return true;
         }
      }
      return false;
   }

   public function isProjectAdmin(user : User) : Boolean {
      for each(var worker : ProjectWorker in projectWorkers) {
         if (worker.worker.id == user.id && worker.permissions.projectAdmin) {
            return true;
         }
      }
      return false;
   }

   public function isIterationAdmin(user : User) : Boolean {
      for each(var worker : ProjectWorker in projectWorkers) {
         if (worker.worker.id == user.id && worker.permissions.iterationAdmin) {
            return true;
         }
      }
      return false;
   }

   public function get admins() : ArrayCollection {
      var admins : ArrayCollection = new ArrayCollection();
      for each(var worker : ProjectWorker in projectWorkers) {
         if(worker.permissions.projectAdmin) {
            admins.addItem(worker.worker);
         }
      }
      return admins;
   }

   public function copyFrom(project : Project) : void {
      id = project.id;
      version = project.version;
      reference = project.reference;
      title = project.title;
      actors = project.actors;
      startDate = project.startDate;
      projectWorkers.source = project.projectWorkers.source;
      iterations = project.iterations;
      productBacklog = project.productBacklog;
      accessRequests = project.accessRequests;
      defects = project.defects;
      themes = project.themes;
      history = project.history;
   }

   public function get targetReleaseDate():Date {
      if(iterations.length == 0) {
         return startDate;
      }
      return Iteration(iterations.getItemAt(iterations.length-1)).endDate;
   }
//
//   public function set targetReleaseDate(value:Date):void {
//      targetReleaseDate = value;
//   }
}
}