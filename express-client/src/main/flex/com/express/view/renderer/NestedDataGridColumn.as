package com.express.view.renderer {
import mx.controls.dataGridClasses.DataGridColumn;

public class NestedDataGridColumn extends DataGridColumn {

   public function NestedDataGridColumn(columnName:String = null) {
      super(columnName);
      this.sortable = false;
   }

   override public function itemToLabel(data:Object):String {
      if (!data) {
         return null;
      }
      var fields:Array;
      var attribute:String;
      var label:String;

      var dataFieldSplit:String = dataField;
      var currentData:Object = data;

      if (dataField.indexOf("@") != -1) {
         fields = dataFieldSplit.split("@");
         dataFieldSplit = fields[0];
         attribute = fields[1];
      }

      if (dataField.indexOf(".") != -1) {
         fields = dataFieldSplit.split(".");

         for each(var field:String in fields) {
            currentData = currentData[field];
         }

         if (currentData is String) {
            return String(currentData);
         }
      }
      else {
         if (dataFieldSplit != "") {
            currentData = currentData[dataFieldSplit];
         }
      }

      if (attribute) {
         if (currentData is XML || currentData is XMLList) {
            currentData = XML(currentData).attribute(attribute);
         }
         else {
            currentData = currentData[attribute];
         }
      }

      try {
         label = currentData.toString();
      }
      catch(e:Error) {
         label = super.itemToLabel(data);
      }

      return label;
   }
}
}