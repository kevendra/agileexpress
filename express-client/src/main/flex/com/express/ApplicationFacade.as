package com.express
{
import com.earthbrowser.ebutils.MacMouseWheelHandler;
import com.express.controller.AccessRequestsLoadCommand;
import com.express.controller.ApplicationStartUpCommand;
import com.express.controller.ApplicationUsersLoadCommand;
import com.express.controller.BacklogItemAssignCommand;
import com.express.controller.BacklogItemCreateCommand;
import com.express.controller.BacklogItemMarkDoneCommand;
import com.express.controller.BacklogItemRemoveCommand;
import com.express.controller.BacklogItemUpdateCommand;
import com.express.controller.BacklogLoadCommand;
import com.express.controller.ChangePasswordCommand;
import com.express.controller.ImpedimentCreateCommand;
import com.express.controller.ImpedimentRemoveCommand;
import com.express.controller.ImpedimentUpdateCommand;
import com.express.controller.IterationCreateCommand;
import com.express.controller.IterationLoadCommand;
import com.express.controller.IterationUpdateCommand;
import com.express.controller.LoginCommand;
import com.express.controller.ProjectAccessListLoadCommand;
import com.express.controller.ProjectAccessRequestCommand;
import com.express.controller.ProjectAccessResponseCommand;
import com.express.controller.ProjectCreateCommand;
import com.express.controller.ProjectListLoadCommand;
import com.express.controller.ProjectLoadCommand;
import com.express.controller.ProjectUpdateCommand;
import com.express.controller.ProjectWorkersUpdateCommand;
import com.express.controller.RegisterCommand;
import com.express.controller.RegisterConfirmCommand;
import com.express.controller.ThemesLoadCommand;
import com.express.controller.ThemesUpdateCommand;
import com.express.controller.UpdateUserCommand;

import org.puremvc.as3.patterns.facade.Facade;

public class ApplicationFacade extends Facade {
   public static const USER_SERVICE:String = "userService";
   public static const PROJECT_SERVICE:String = "projectService";
   public static const ITERATION_SERVICE:String = "iterationService";
   public static const BACKLOG_ITEM_SERVICE:String = "backlogItemService";

   // Notification name constants application
   public static const NOTE_STARTUP:String = "startup";
   public static const NOTE_LOAD_PROJECT:String = "Note.LoadProject";
   public static const NOTE_LOAD_PROJECT_LIST:String = "Note.LoadProjectList";
   public static const NOTE_LOAD_PROJECT_ACCESS_LIST:String = "Note.LoadProjectAccessList";
   public static const NOTE_CREATE_POJECT:String = "Note.CreateProject";
   public static const NOTE_UPDATE_PROJECT:String = "Note.UpdateProject";
   public static const NOTE_REQUEST_PROJECT_ACCESS:String = "Note.RequestProjectAccess";

   public static const NOTE_LOAD_ITERATION:String = "Note.LoadIteration";
   public static const NOTE_CREATE_ITERATION:String = "Note.CreateIteration";
   public static const NOTE_UPDATE_ITERATION:String = "Note.UpdateIteration";
   public static const NOTE_REMOVE_ITERATION:String = "Note.RemoveIteration";

   public static const NOTE_CREATE_BACKLOG_ITEM:String = "Note.CreateBacklogItem";
   public static const NOTE_UPDATE_BACKLOG_ITEM:String = "Note.UpdateBacklogItem";
   public static const NOTE_MARK_DONE_BACKLOG_ITEM:String = "Note.MarkDoneBacklogItem";
   public static const NOTE_REMOVE_BACKLOG_ITEM:String = "Note.RemoveBacklogItem";
   public static const NOTE_ASSIGN_BACKLOG_ITEM:String = "Note.AssignBacklogItem";
   public static const NOTE_EDIT_BACKLOG_ITEM:String = "Note.EditBacklogItem";
   public static const NOTE_LOAD_BACKLOG:String = "Note.LoadBacklog";
   public static const NOTE_LOAD_BACKLOG_COMPLETE:String = "Note.LoadBacklog.Complete";

   public static const NOTE_LOGIN:String = "Note.Login";

   public static const NOTE_CREATE_IMPEDIMENT:String = "Note.CreateImpediment";
   public static const NOTE_EDIT_IMPEDIMENT:String = "Note.EditImpediment";
   public static const NOTE_ADD_IMPEDIMENT:String = "Note.AddImpediment";
   public static const NOTE_REMOVE_IMPEDIMENT:String = "Note.RemoveImpediment";
   public static const NOTE_UPDATE_IMPEDIMENT:String = "Note.UpdateImpediment";

   public static const NOTE_REGISTER:String = "Note.Register";
   public static const NOTE_REGISTER_CONFIRM:String = "Note.RegisterConfirm";
   public static const NOTE_LOAD_APP_USERS:String = "Note.ApplicationUsersLoad";
   public static const NOTE_CHANGE_PASSWORD:String = "Note.ChangePassword";
   public static const NOTE_UPDATE_USER:String = "Note.UpdateUser";
   public static const NOTE_PROJECT_ACCESS_RESPONSE:String = "Note.ProjectAccessResponse";
   public static const NOTE_PROJECT_ACCESS_MANAGE:String = "Note.ProjectAccessManage";

   public static const NOTE_SHOW_COLOUR_GROUP:String = "Note.ShowColourGroup";
   public static const NOTE_HIDE_COLOUR_GROUP:String = "Note.HideColourGroup";

   public static const NOTE_SECONDARY_NAV:String = "Note.SecondaryNav";
   public static const NOTE_DISPLAY_BURNDOWN:String = "Note.DisplayBurndown";
   public static const NOTE_DISPLAY_VELOCITY:String = "Note.DisplayVelocityChart";
   public static const NOTE_DISPLAY_BURNUP:String = "Note.DisplayBurnUpChart";

   public static const NOTE_UPDATE_PROJECT_WORKERS:String = "Note.UpdateProjectWorkers";

   public static const NOTE_UPDATE_THEMES:String = "Note.UpdateThemes";
   public static const NOTE_LOAD_THEMES:String = "Note.LoadThemes";
   public static const NOTE_THEMES_MANAGE:String = "Note.ManageThemes";

   public static const NOTE_NAVIGATE:String = "Note.Navigate";

   public static const NOTE_SHOW_ERROR_MSG:String = "Note.ShowErrorMsg";
   public static const NOTE_SHOW_SUCCESS_MSG:String = "Note.ShowSuccessMsg";
   public static const NOTE_CLEAR_MSG:String = "Note.ClearMsg";
   public static const NOTE_SHOW_FILTER_DIALOG:String = "Note.ShowFilterDialog";
   public static const NOTE_APPLY_PRODUCT_BACKLOG_FILTER:String = "Note.ApplyProductBacklogFilter";
   public static const NOTE_APPLY_ITERATION_BACKLOG_FILTER : String = "Note.ApplyIterationBacklogFilter";
   public static const NOTE_CANCEL_BACKLOG_FILTER : String = "Note.CancelBacklogFilter";


   public static function getInstance():ApplicationFacade {
      if (instance == null) {
         instance = new ApplicationFacade();
      }
      return instance as ApplicationFacade;
   }

   /**
    * Register Commands with the Controller
    */
   override protected function initializeController():void {
      super.initializeController();
      registerCommand(NOTE_STARTUP, ApplicationStartUpCommand);

      registerCommand(NOTE_LOAD_PROJECT, ProjectLoadCommand);
      registerCommand(NOTE_LOAD_PROJECT_LIST, ProjectListLoadCommand);
      registerCommand(NOTE_LOAD_PROJECT_ACCESS_LIST, ProjectAccessListLoadCommand);
      registerCommand(NOTE_UPDATE_PROJECT, ProjectUpdateCommand);
      registerCommand(NOTE_CREATE_POJECT, ProjectCreateCommand);
      registerCommand(NOTE_REQUEST_PROJECT_ACCESS, ProjectAccessRequestCommand);

      registerCommand(NOTE_LOAD_ITERATION, IterationLoadCommand);
      registerCommand(NOTE_CREATE_ITERATION, IterationCreateCommand);
      registerCommand(NOTE_UPDATE_ITERATION, IterationUpdateCommand);

      registerCommand(NOTE_CREATE_BACKLOG_ITEM, BacklogItemCreateCommand);
      registerCommand(NOTE_UPDATE_BACKLOG_ITEM, BacklogItemUpdateCommand);
      registerCommand(NOTE_MARK_DONE_BACKLOG_ITEM, BacklogItemMarkDoneCommand);
      registerCommand(NOTE_REMOVE_BACKLOG_ITEM, BacklogItemRemoveCommand);
      registerCommand(NOTE_LOAD_BACKLOG, BacklogLoadCommand);
      registerCommand(NOTE_ASSIGN_BACKLOG_ITEM, BacklogItemAssignCommand);

      registerCommand(NOTE_UPDATE_PROJECT_WORKERS, ProjectWorkersUpdateCommand);
      registerCommand(NOTE_PROJECT_ACCESS_MANAGE, AccessRequestsLoadCommand);

      registerCommand(NOTE_UPDATE_THEMES, ThemesUpdateCommand);
      registerCommand(NOTE_LOAD_THEMES, ThemesLoadCommand);

      registerCommand(NOTE_ADD_IMPEDIMENT, ImpedimentCreateCommand);
      registerCommand(NOTE_REMOVE_IMPEDIMENT, ImpedimentRemoveCommand);
      registerCommand(NOTE_UPDATE_IMPEDIMENT, ImpedimentUpdateCommand);

      registerCommand(NOTE_LOGIN, LoginCommand);
      registerCommand(NOTE_REGISTER, RegisterCommand);
      registerCommand(NOTE_REGISTER_CONFIRM, RegisterConfirmCommand);
      registerCommand(NOTE_CHANGE_PASSWORD, ChangePasswordCommand);
      registerCommand(NOTE_LOAD_APP_USERS, ApplicationUsersLoadCommand);
      registerCommand(NOTE_UPDATE_USER, UpdateUserCommand);
      registerCommand(NOTE_PROJECT_ACCESS_RESPONSE, ProjectAccessResponseCommand);
   }

   public function startUp(app:Express):void {
      MacMouseWheelHandler.init(app.systemManager.stage);
      sendNotification(NOTE_STARTUP, app);
   }
}
}