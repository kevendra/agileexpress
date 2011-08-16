package com.express.model.domain {

[RemoteClass(alias="com.express.service.dto.ThemeDto")]
public class Theme {

   public function Theme() {
   }

   public var id : Number;

   public var version : Number;

   public var title : String;

   public var description : String;

   public var project : Project;
}
}