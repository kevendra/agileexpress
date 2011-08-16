package com.express.model.domain {

[RemoteClass(alias="com.express.service.dto.ProjectWorkerDto")]
public class ProjectWorker {

   public function ProjectWorker() {
   }

   public var id : Number;

   public var version : Number;

   public var createdDate : Date;

   public var worker : User;

   public var project : Project;

   public var permissions : Permissions;
}
}