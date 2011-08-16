package com.express.view.iterationSummary {
import com.express.ApplicationFacade;
import com.express.controller.IterationCreateCommand;
import com.express.controller.IterationLoadCommand;
import com.express.controller.IterationUpdateCommand;
import com.express.controller.ProjectLoadCommand;
import com.express.model.ProjectProxy;
import com.express.model.SecureContextProxy;
import com.express.model.domain.BacklogItem;
import com.express.model.domain.Iteration;
import com.express.print.BacklogPrintView;
import com.express.view.iteration.IterationMediator;
import com.express.view.renderer.CardPrintRenderer;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileReference;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;
import mx.controls.DateField;
import mx.controls.TileList;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.messaging.config.ServerConfig;
import mx.printing.FlexPrintJob;
import mx.printing.FlexPrintJobScaleType;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

public class IterationSummaryMediator extends Mediator {
   public static const NAME : String = "IterationSummaryMediator";
   public static const SHOW_PRINT_PREVIEW : String = "Note.showPrintPreview";

   private var _proxy : ProjectProxy;
   private var _secureContext : SecureContextProxy;
   private var _fileRef : FileReference;
   private var _backlog : Array;
   private var _printView : BacklogPrintView;

   public function IterationSummaryMediator(viewComp : IterationSummary, mediatorName : String = NAME) {
      super(mediatorName, viewComp);
      _proxy = ProjectProxy(facade.retrieveProxy(ProjectProxy.NAME));
      _secureContext = SecureContextProxy(facade.retrieveProxy(SecureContextProxy.NAME));
      viewComp.auth.userRoles = _secureContext.availableRoles;
      viewComp.printPopUp.addEventListener(ListEvent.ITEM_CLICK, handlePrintMenuSelection);
      viewComp.btnEdit.addEventListener(MouseEvent.CLICK, handleEditIteration);
      viewComp.lnkExport.addEventListener(MouseEvent.CLICK, handleIterationBacklogExport);
      viewComp.lnkClose.addEventListener(MouseEvent.CLICK, handleClose);
      viewComp.cboIterations.addEventListener(Event.CHANGE, handleIterationSelected);
      viewComp.lnkCreateIteration.addEventListener(MouseEvent.CLICK, handleCreateIteration);

      setupFileReference();
      viewComp.burndown.dataProvider = _proxy.iterationHistory;
      viewComp.cboIterations.dataProvider = _proxy.iterationList;
   }

   private function setupFileReference():void {
      _fileRef = new FileReference();
      _fileRef.addEventListener(Event.CANCEL, handleDownload);
      _fileRef.addEventListener(Event.COMPLETE, handleDownload);
      _fileRef.addEventListener(Event.OPEN, handleDownload);
      _fileRef.addEventListener(Event.SELECT, handleDownload);
      _fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleDownload);
      _fileRef.addEventListener(IOErrorEvent.IO_ERROR, handleDownload);
      _fileRef.addEventListener(ProgressEvent.PROGRESS, handleDownload);
      _fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleDownload);
   }

   private function handleDownload(evt:Event):void {
      /* Create shortcut to the FileReference object. */
//      var fr:FileReference = evt.currentTarget as FileReference;
   }

   private function handleClose(event:MouseEvent):void {
      view.visible = false;
   }

   private function handleIterationBacklogExport(event : Event) : void {
      var url : String = ServerConfig.getChannel("my-amf").endpoint;
      url = url.substr(0,url.length - 18);
      url += "/iteration/" + _proxy.selectedIteration.id + "/backlog";
      var request : URLRequest = new URLRequest(url);
      _fileRef.download(request, _proxy.selectedIteration.title + "_backlog.csv");
   }

   private function handleEditIteration(event : Event) : void {
      _proxy.newIteration = _proxy.selectedIteration;
      sendNotification(IterationMediator.EDIT);
   }

   private function handleDisplayBurndown(event : Event) : void {
      sendNotification(ApplicationFacade.NOTE_DISPLAY_BURNDOWN, view.burndown.chkWeekends);
   }

   private function handlePrintMenuSelection(event : ListEvent) : void {
      switch(event.rowIndex) {
         case 0 :
            printPreviewRequest(_proxy.selectedIteration.backlog.source);
            break;
         case 1 :
            var tasks : Array = [];
            for each(var item : BacklogItem in _proxy.selectedIteration.backlog) {
               for each(var task : BacklogItem in item.tasks) {
                  tasks.push(task);
               }
            }
            printPreviewRequest(tasks);
      }
   }

   private function handlePrintPreviewCreated(event : FlexEvent) : void {
      _printView.lnkPrint.addEventListener(MouseEvent.CLICK, handlePrintRequest);
      var length : int = _backlog.length;
      var tileList : TileList = createTileList(0);
      var dataProvider : Array = [];
      for(var index : int = 4; index <= length; index += 4) {
         dataProvider = _backlog.slice(index - 4, index);
         tileList = createTileList(index / 4);
         tileList.dataProvider = dataProvider;
         _printView.pages.addChild(tileList);
      }
      if(length % 4 != 0) {
         dataProvider = _backlog.slice(index - 4, length );
         tileList = createTileList(index / 4);
         tileList.dataProvider = dataProvider;
         _printView.pages.addChild(tileList);
      }
   }

   private function handlePrintRequest(event : Event) : void {
      var printJob:FlexPrintJob = new FlexPrintJob();
      if (printJob.start()) {
         for each(var tileList : TileList in _printView.pages.getChildren()) {
            printJob.addObject(tileList, FlexPrintJobScaleType.MATCH_WIDTH);
         }
         printJob.send();
      }
      _printView.parent.visible = false;
   }

   public function handleIterationSelected(event:Event):void {
      var iteration:Iteration = view.cboIterations.selectedItem as Iteration;
      sendNotification(ApplicationFacade.NOTE_LOAD_ITERATION, iteration.id);
   }

   public function handleCreateIteration(event:MouseEvent):void {
      _proxy.newIteration = new Iteration();
      _proxy.newIteration.project = _proxy.selectedProject;
      _proxy.newIteration.title = "Iteration " + (_proxy.selectedProject.iterations.length + 1);
      sendNotification(IterationMediator.CREATE);
   }
   
   override public function listNotificationInterests():Array {
      return [ProjectLoadCommand.SUCCESS,
              IterationUpdateCommand.SUCCESS,
              IterationCreateCommand.SUCCESS,
              ApplicationFacade.NOTE_LOAD_BACKLOG_COMPLETE,
              IterationLoadCommand.SUCCESS];
   }

   override public function handleNotification(notification : INotification):void {
      switch(notification.getName()) {
         case ProjectLoadCommand.SUCCESS :
            bindIterationDisplay();
            toggleBurndownAsLink();
            view.lnkCreateIteration.enabled = true;
            if (!_proxy.selectedIteration && ! _proxy.selectedProject.currentIteration) {
               view.cboIterations.selectedIndex = -1;
            } else if (_proxy.selectedIteration) {
               view.cboIterations.selectedIndex = getSelectionIndex(
                     view.cboIterations.dataProvider as ArrayCollection, _proxy.selectedIteration);
            }
            break;
         case IterationUpdateCommand.SUCCESS :
         case IterationCreateCommand.SUCCESS :
            var newIteration:Iteration = notification.getBody() as Iteration;
            view.cboIterations.selectedItem = newIteration;
            bindIterationDisplay();
            break;
         case IterationLoadCommand.SUCCESS :
            var index:int = getSelectionIndex(_proxy.selectedProject.iterations, _proxy.selectedIteration);
            view.cboIterations.selectedIndex = index;
            _proxy.updateIterationList();
            _proxy.newIteration = null;
            bindIterationDisplay();
            toggleBurndownAsLink();
            break;
         case ApplicationFacade.NOTE_LOAD_BACKLOG_COMPLETE :
            bindIterationDisplay();
            break;
      }
   }

   private function getSelectionIndex(list:ArrayCollection, iteration:Iteration):int {
      for (var index:int = 0; index < list.length; index++) {
         if (list.getItemAt(index).id == iteration.id) {
            return index;
         }
      }
      return -1;
   }

   public function bindIterationDisplay() : void {
      if(_proxy.selectedIteration) {
         view.startDate.text = DateField.dateToString(_proxy.selectedIteration.startDate, "DD/MM/YYYY");
         view.endDate.text = DateField.dateToString(_proxy.selectedIteration.endDate, "DD/MM/YYYY");
         view.iterationStatus.text = _proxy.selectedIteration.isOpen() ? "open" : "closed";
         view.totalPoints.text = "" + _proxy.selectedIteration.getPoints();
         view.hrsRemaining.text = "" + _proxy.selectedIteration.getTaskHoursRemaining();
         view.daysRemaining.text = "" + _proxy.selectedIteration.getDaysRemaining();
         view.goal.text = "" + _proxy.selectedIteration.goal;
         view.btnEdit.enabled = true;
         view.printPopUp.enabled = true;
         view.lnkExport.enabled = true;
         view.burndown.chkWeekends.enabled = true;
         view.burndown.xAxis.minimum = _proxy.selectedIteration.startDate;
         view.burndown.xAxis.maximum = _proxy.selectedIteration.endDate;
      }
      else {
         view.startDate.text = "";
         view.endDate.text = "";
         view.iterationStatus.text = "";
         view.totalPoints.text = "";
         view.hrsRemaining.text = "";
         view.daysRemaining.text = "";
         view.btnEdit.enabled = false;
         view.printPopUp.enabled = false;
         view.lnkExport.enabled = false;
         view.burndown.chkWeekends.enabled = false;
         view.burndown.xAxis.minimum = null;
         view.burndown.xAxis.maximum = null;
      }
   }

   private function printPreviewRequest(backlog : Array) : void {
      _printView = new BacklogPrintView();
      _backlog = backlog;
      _printView.addEventListener(FlexEvent.CREATION_COMPLETE, handlePrintPreviewCreated);
      sendNotification(SHOW_PRINT_PREVIEW, _printView);
   }

   private function createTileList(index : int) : TileList{
      var tileList : TileList = new TileList();
      tileList.id = "page_" + index;
      tileList.columnCount = 2;
      tileList.height = 550;
      tileList.width = 830;
      tileList.columnWidth = 380;
      tileList.styleName = "page";
      tileList.verticalScrollPolicy = "off";
      tileList.itemRenderer = new CardPrintRenderer();
      return tileList;
   }

   private function toggleBurndownAsLink() : void {
      view.burndown.chart.useHandCursor = _proxy.selectedIteration != null;
      view.burndown.chart.buttonMode = _proxy.selectedIteration != null;
      view.burndown.chart.mouseChildren = _proxy.selectedIteration == null;
      if(_proxy.selectedIteration) {
         view.burndown.chart.addEventListener(MouseEvent.CLICK, handleDisplayBurndown);
      }
      else {
         view.burndown.chart.removeEventListener(MouseEvent.CLICK, handleDisplayBurndown);
      }
   }
   
   public function get view() : IterationSummary {
      return this.viewComponent as IterationSummary;
   }
}
}