package com.express.model.domain
{
import mx.collections.ArrayCollection;

[RemoteClass(alias="com.express.service.dto.UserDto")]
public class User
{
   public function User() {
      projects = new ArrayCollection();
   }

   public var id : Number;

   public var version : Number;

   public var email : String; //unique field, used as username.

   private var _fullName : String;

   public var firstName : String;

   public var lastName : String;

   public var password : String;

   public var passwordHint : String;

   public var phone1 : String;

   public var phone2 : String;

   [Bindable]
   public var colour : uint;

   public var projects : ArrayCollection;

   public var accessRequests : ArrayCollection;

   public var hasProjects : Boolean;

   public var storyWindowPreference : WindowMetrics;

   public function get fullName() : String {
      if(!firstName && !lastName) {
         return email.substr(0,email.indexOf("@"));
      }
      return firstName + " " + lastName;
   }

   public function copyFrom(user : User) : void {
      email = user.email;
      firstName = user.firstName;
      lastName = user.lastName;
      colour = user.colour;
      id = user.id;
      version = user.version;
      phone1 = user.phone1;
      phone2 = user.phone2;
      password = user.password;
      passwordHint = user.passwordHint;
      projects.source = user.projects.source;
      storyWindowPreference = user.storyWindowPreference;
   }

}
}