package com.express.view.form
{
import mx.validators.Validator;

public class FormUtility
{
   public static function validateAll(validators:Array, triggerValidation : Boolean = false) : Boolean
   {
      if (triggerValidation) {
         doValidate(validators);
      }
      for each (var validator : Validator in validators) {
         if (validator.source.errorString != "") {
            return false;
         }
      }
      return true;
   }

   public static function clearValidationErrors(validators:Array) : void {
      for each (var validator : Validator in validators) {
         validator.source.errorString = "";
      }
   }

   public static function doValidate(validators:Array) : void {
      for each (var validator : Validator in validators) {
         validator.validate();
      }
   }

}
}