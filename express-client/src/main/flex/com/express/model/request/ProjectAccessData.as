package com.express.model.request {
import mx.collections.ArrayCollection;

[RemoteClass(alias="com.express.service.dto.ProjectAccessData")]
public class ProjectAccessData {
   public function ProjectAccessData() {
   }

   public var grantedList : ArrayCollection;

   public var pendingList : ArrayCollection;

   public var availableList : ArrayCollection;
}
}