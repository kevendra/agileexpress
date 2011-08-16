package com.express.view {
import com.adobe.components.SizeableTitleWindow;
import com.express.model.ProjectProxy;
import com.express.model.SecureContextProxy;
import com.express.model.domain.WindowMetrics;
import com.express.print.BacklogPrintView;
import com.express.view.backlogItem.BacklogItemMediator;
import com.express.view.backlogItem.BacklogItemView;
import com.express.view.charts.BurnUpChart;
import com.express.view.charts.BurndownChart;
import com.express.view.charts.VelocityChart;
import com.express.view.filter.FilterPanel;
import com.express.view.filter.FilterPanelMediator;
import com.express.view.issue.IssueForm;
import com.express.view.issue.IssueMediator;
import com.express.view.iteration.IterationForm;
import com.express.view.iteration.IterationMediator;
import com.express.view.projectDetails.ProjectDetailsForm;
import com.express.view.projectDetails.ProjectDetailsMediator;
import com.express.view.projectWorkers.ProjectAdmin;
import com.express.view.projectWorkers.ProjectAdminMediator;
import com.express.view.themes.ThemesForm;
import com.express.view.themes.ThemesMediator;

import flash.events.Event;

import mx.core.UIComponent;
import mx.effects.Effect;
import mx.effects.Iris;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;

import org.puremvc.as3.interfaces.IFacade;
import org.puremvc.as3.interfaces.INotification;

public class ExpressPopUpManager {

   private var _backlogItemView:BacklogItemView;
   private var _iterationForm:IterationForm;
   private var _issueForm:IssueForm;
   private var _projectForm:ProjectDetailsForm;
   private var _projectAdminForm:ProjectAdmin;
   private var _themesForm:ThemesForm;
   private var _burndownChart:BurndownChart;
   private var _burnUpChart:BurnUpChart;
   private var _velocityChart:VelocityChart;
   private var _filterPanel : FilterPanel;
   private var _lastWindowNotification:INotification;
   private var _popUp:SizeableTitleWindow;
   private var _popUpVisible:Boolean = false;

   private var _openEffect:Effect;
   private var _closeEffect:Effect;

   private var _facade:IFacade;
   private var _application:Express;
   private var _secureContext:SecureContextProxy;
   private var _projectProxy:ProjectProxy;

   public function ExpressPopUpManager(facade:IFacade, application:Express) {
      _facade = facade;
      _application = application;
      _secureContext = SecureContextProxy(_facade.retrieveProxy(SecureContextProxy.NAME));
      _projectProxy = ProjectProxy(_facade.retrieveProxy(ProjectProxy.NAME));
      _popUp = new SizeableTitleWindow();
      _popUp.styleName = "mainPopup";
      _popUp.verticalScrollPolicy = "off";
      _popUp.horizontalScrollPolicy = "off";
      _popUp.showCloseButton = true;
      _popUp.addEventListener(CloseEvent.CLOSE, handleHidePopup);
      createOpenCloseEffects();
   }

   private function createOpenCloseEffects() : void {
      var irisOpen : Iris = new Iris(_popUp);
      irisOpen.scaleXFrom = 0;
      irisOpen.scaleYFrom = 0;
      irisOpen.scaleXTo = 1;
      irisOpen.scaleYTo = 1;
      irisOpen.duration = 200;
      _openEffect = irisOpen;
      var irisClose : Iris = new Iris(_popUp);
      irisClose.scaleXFrom = 1;
      irisClose.scaleYFrom = 1;
      irisClose.scaleXTo = 0;
      irisClose.scaleYTo = 0;
      irisClose.duration = 200;
      _closeEffect = irisClose;
   }

   private function handleHidePopup(event:Event):void {
      PopUpManager.removePopUp(_popUp);
      _popUp.removeAllChildren();
      _closeEffect.end();
      _closeEffect.play();
      _popUpVisible = false;
      if (_lastWindowNotification && (_lastWindowNotification.getName() == BacklogItemMediator.CREATE || _lastWindowNotification.getName() == BacklogItemMediator.EDIT)) {
         _secureContext.currentUser.storyWindowPreference.x = _popUp.x;
         _secureContext.currentUser.storyWindowPreference.y = _popUp.y;
         _secureContext.currentUser.storyWindowPreference.height = _popUp.height;
         _secureContext.currentUser.storyWindowPreference.width = _popUp.width;
      }
   }

   private function createBacklogItemForm():void {
      _backlogItemView = new BacklogItemView();
      _backlogItemView.addEventListener(FlexEvent.CREATION_COMPLETE, handleBacklogItemFormCreated);
   }

   private function createProjectAdmin():void {
      _projectAdminForm = new ProjectAdmin();
      _projectAdminForm.addEventListener(FlexEvent.CREATION_COMPLETE, handleProjectAdminCreated);
   }

   private function createThemesForm():void {
      _themesForm = new ThemesForm();
      _themesForm.addEventListener(FlexEvent.CREATION_COMPLETE, handleThemesFormCreated);
   }

   private function createIterationForm():void {
      _iterationForm = new IterationForm();
      _iterationForm.addEventListener(FlexEvent.CREATION_COMPLETE, handleIterationFormCreated);
   }

   private function createIssueForm():void {
      _issueForm = new IssueForm();
      _issueForm.addEventListener(FlexEvent.CREATION_COMPLETE, handleIssueFormCreated);
   }

   private function createProjectForm():void {
      _projectForm = new ProjectDetailsForm();
      _projectForm.addEventListener(FlexEvent.CREATION_COMPLETE, handleProjectDetailsFormCreated);
   }

   private function createBurndownChart():void {
      _burndownChart = new BurndownChart();
      _burndownChart.addEventListener(FlexEvent.CREATION_COMPLETE, handleBurndownCreated);
   }

   private function createFilterPanel() : void {
      _filterPanel = new FilterPanel();
      _filterPanel.addEventListener(FlexEvent.CREATION_COMPLETE, handleFilterPanelCreated);
   }

   private function handleBurndownCreated(event:FlexEvent):void {
      _burndownChart.xAxis.minimum = _projectProxy.selectedIteration.startDate;
      _burndownChart.xAxis.maximum = _projectProxy.selectedIteration.endDate;
      _burndownChart.chkWeekends.selected = _lastWindowNotification.getBody() as Boolean;
      _burndownChart.dataProvider = _projectProxy.iterationHistory;
   }
   
   private function createBurnUpChart():void {
      _burnUpChart = new BurnUpChart();
      _burnUpChart.addEventListener(FlexEvent.CREATION_COMPLETE, handleBurnUpCreated);
   }

   private function handleBurnUpCreated(event:FlexEvent):void {
      _burnUpChart.xAxis.minimum = _projectProxy.selectedProject.startDate;
      _burnUpChart.xAxis.maximum = _projectProxy.selectedProject.targetReleaseDate;
      _burnUpChart.seriesCompletedPoints.dataProvider = _projectProxy.projectHistoryCompleted;
      _burnUpChart.seriesRequiredPoints.dataProvider = _projectProxy.projectHistoryRequired;
   }

   private function createVelocityChart():void {
      _velocityChart = new VelocityChart();
   }

   public function handleThemesFormCreated(event:Event):void {
      _facade.registerMediator(new ThemesMediator(_themesForm));
   }

   private function handleBacklogItemFormCreated(event:FlexEvent):void {
      var mediator:BacklogItemMediator = new BacklogItemMediator(_backlogItemView);
      _facade.registerMediator(mediator);
      mediator.handleNotification(_lastWindowNotification);
   }

   private function handleProjectAdminCreated(event:FlexEvent):void {
      _facade.registerMediator(new ProjectAdminMediator(_projectAdminForm));
   }

   private function handleIterationFormCreated(event:FlexEvent):void {
      var mediator:IterationMediator = new IterationMediator(_iterationForm);
      _facade.registerMediator(mediator);
      mediator.handleNotification(_lastWindowNotification);
   }

   private function handleIssueFormCreated(event:FlexEvent):void {
      var mediator:IssueMediator = new IssueMediator(_issueForm);
      _facade.registerMediator(mediator);
      mediator.handleNotification(_lastWindowNotification);
   }

   private function handleProjectDetailsFormCreated(event:FlexEvent):void {
      var mediator:ProjectDetailsMediator = new ProjectDetailsMediator(_projectForm, "MainProjectDetailsMediator");
      _facade.registerMediator(mediator);
      mediator.handleNotification(_lastWindowNotification);
   }

   private function handleFilterPanelCreated(event:FlexEvent):void {
      var mediator:FilterPanelMediator = new FilterPanelMediator(_filterPanel);
      _facade.registerMediator(mediator);
      mediator.handleNotification(_lastWindowNotification);
   }

   public function showPrintPreview(previewPanel:BacklogPrintView):void {
      _popUp.title = "Print Preview - Print in landscape on A4";
      _popUp.width = 825;
      _popUp.height = 500;
      _popUp.x = (_application.width / 2) - 405;
      _popUp.y = 40;
      showPopUp(previewPanel);
   }

   public function showProjectAdminWindow(notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_projectAdminForm) {
         createProjectAdmin();
      }
      _popUp.title = "Project Access Requests";
      _popUp.width = 550;
      _popUp.height = 450;
      _popUp.x = (_application.width / 2) - 225;
      _popUp.y = 40;
      showPopUp(_projectAdminForm);
   }

   public function showThemesWindow(notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_themesForm) {
         createThemesForm();
      }
      _popUp.title = "Project Themes";
      _popUp.width = 450;
      _popUp.height = 410;
      _popUp.x = (_application.width / 2) - 225;
      _popUp.y = 40;
      showPopUp(_themesForm);
   }

   public function showBurndownWindow(title:String, notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_burndownChart) {
         createBurndownChart();
      }
      else {
         _burndownChart.xAxis.minimum = _projectProxy.selectedIteration.startDate;
         _burndownChart.xAxis.maximum = _projectProxy.selectedIteration.endDate;
         _burndownChart.chkWeekends.selected = notification.getBody() as Boolean;
      }

      _popUp.title = title;
      _popUp.width = 600;
      _popUp.height = 450;
      _popUp.x = (_application.width / 2) - (_popUp.width / 2);
      _popUp.y = 40;
      showPopUp(_burndownChart);
   }
   
   public function showBurnUpWindow(title:String, notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_burnUpChart) {
         createBurnUpChart();
      }
      else {
         _burnUpChart.xAxis.minimum = _projectProxy.selectedProject.startDate;
         _burnUpChart.xAxis.maximum = _projectProxy.selectedProject.targetReleaseDate;
      }
      _popUp.title = title;
      _popUp.width = 650;
      _popUp.height = 450;
      _popUp.x = (_application.width / 2) - (_popUp.width / 2);
      _popUp.y = 40;
      showPopUp(_burnUpChart);
   }

   public function showVelocityWindow(title:String, notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_velocityChart) {
         createVelocityChart();
      }
      _velocityChart.dataProvider = notification.getBody();
      _popUp.title = title;
      _popUp.width = 600;
      _popUp.height = 450;
      _popUp.x = (_application.width / 2) - (_popUp.width / 2);
      _popUp.y = 40;
      showPopUp(_velocityChart);
   }

   public function showBacklogWindow(notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_backlogItemView) {
         createBacklogItemForm();
      }
      var metrics:WindowMetrics = _secureContext.currentUser.storyWindowPreference;
      if (!metrics) {
         metrics = new WindowMetrics();
         metrics.x = (_application.width / 2) - 450;
         metrics.y = 40;
         metrics.width = 900;
         metrics.height = 550;
         _secureContext.currentUser.storyWindowPreference = metrics;
      }
      _popUp.width = metrics.width;
      _popUp.height = metrics.height;
      _popUp.x = metrics.x;
      _popUp.y = metrics.y;
      showPopUp(_backlogItemView);
   }

   public function showIterationWindow(title:String, notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_iterationForm) {
         createIterationForm();
      }
      _popUp.title = title;
      _popUp.width = 450;
      _popUp.height = 410;
      _popUp.x = (_application.width / 2) - 225;
      _popUp.y = 40;
      showPopUp(_iterationForm);
   }

   public function showIssueWindow(title:String, notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_issueForm) {
         createIssueForm();
      }
      _popUp.title = title;
      _popUp.width = 500;
      _popUp.height = 410;
      _popUp.x = (_application.width / 2) - 225;
      _popUp.y = 40;
      showPopUp(_issueForm);
   }

   public function showProjectWindow(title:String, notification:INotification):void {
      _lastWindowNotification = notification;
      if (!_projectForm) {
         createProjectForm();
      }
      _popUp.title = title;
      _popUp.width = 450;
      _popUp.height = 410;
      _popUp.x = (_application.width / 2) - 225;
      _popUp.y = 40;
      showPopUp(_projectForm);
   }

   public function showFilterPanel(notification : INotification, y : uint, x : uint) : void {
      _lastWindowNotification = notification;
      if (!_filterPanel) {
         createFilterPanel();
      }
      PopUpManager.addPopUp(_filterPanel, _application);
      _filterPanel.x = x;
      _filterPanel.y = y;
   }

   public function removeFilterPanel() : void {
      PopUpManager.removePopUp(_filterPanel);
   }

   private function showPopUp(child:UIComponent):void {
      if (_popUpVisible) {
         _popUp.removeAllChildren();
      }
      else {
         PopUpManager.addPopUp(_popUp, _application);
         _popUpVisible = true;
         _openEffect.end();
         _openEffect.play();
      }
      _popUp.addChild(child);
   }
}
}