package com.express.view.filter {

import com.express.ApplicationFacade;
import com.express.model.ProjectProxy;
import com.express.model.domain.BacklogFilter;
import com.express.view.form.FormMediator;

import flash.events.MouseEvent;

import mx.events.FlexEvent;

public class FilterPanelMediator extends FormMediator {
   public static const NAME:String = "FilterPanelMediator";
   private var _proxy:ProjectProxy;

   public function FilterPanelMediator(viewComp:FilterPanel, name:String = NAME) {
      super(name, viewComp);
      _proxy = ProjectProxy(facade.retrieveProxy(ProjectProxy.NAME));
      viewComp.addEventListener(FlexEvent.SHOW, handleShowView);
      viewComp.lstTheme.dataProvider = _proxy.themes;
      viewComp.lnkCancel.addEventListener(MouseEvent.CLICK, handleCancelFilter);
      viewComp.btnFilter.addEventListener(MouseEvent.CLICK, handleApplyFilter);
   }

   private function handleShowView(event:FlexEvent):void {
      view.lstTheme.selectedIndices = [];
   }

   private function handleApplyFilter(event:MouseEvent):void {
      var filter:BacklogFilter = new BacklogFilter();
      filter.themes = view.lstTheme.selectedItems;
      sendNotification(_proxy.filterNotificationName, filter);
   }

   private function handleCancelFilter(event:MouseEvent):void {
      sendNotification(ApplicationFacade.NOTE_CANCEL_BACKLOG_FILTER);
   }

   public function get view():FilterPanel {
      return viewComponent as FilterPanel;
   }

}
}