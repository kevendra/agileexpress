package com.express.model
{
import com.express.model.domain.User;
import com.express.model.request.ProjectAccessData;
import com.express.model.request.ProjectAccessRequest;

import mx.collections.ArrayCollection;

import org.puremvc.as3.patterns.proxy.Proxy;

public class ProfileProxy extends Proxy
{
   public static const NAME : String = "UserAccountProxy";

   public var user : User;

   public var projectAccessRequest : ProjectAccessRequest;

   private var _availableList : ArrayCollection;
   private var _existingList : ArrayCollection;
   private var _pendingList : ArrayCollection;

   public function ProfileProxy()
   {
      super(NAME, null);
      _availableList = new ArrayCollection();
      _existingList = new ArrayCollection();
      _pendingList = new ArrayCollection();
   }


   public function get availableProjectList() : ArrayCollection {
      return _availableList;
   }

   public function get pendingProjectList() : ArrayCollection {
      return _pendingList;
   }

   public function get existingProjectList() : ArrayCollection {
      return _existingList;
   }

   public function set existingProjectList(list : ArrayCollection) : void {
      _existingList.source = list.source;
   }

   public function setProjectAccessLists(projectAccessData : ProjectAccessData) : void {
      _existingList.source = projectAccessData.grantedList.source;
      _pendingList.source = projectAccessData.pendingList.source;
      _availableList.source = projectAccessData.availableList.source;
   }
}
}