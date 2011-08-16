package com.express.view.form {
import mx.validators.Validator;
import org.puremvc.as3.patterns.mediator.Mediator;

/**
 * This class would be abstract if ActionScript supported such a construct. It is intended to provide
 * some basic shared functionality and a common interface for mediators which manage forms.
 * The following methods should be overriden to provide a proper, functioning, cpcrete form mediator
 * <ul>
 * <li>registerValidators - to add every vaidator on the form. validate and resetValidators will
 * only function correctly if this function is implemented</li>
 * <li>bindForm - to bind model fields onto the form</li>
 * <li>bindModel - to bind form fields back onto the model</li>
 */
public class FormMediator extends Mediator{
   protected var _validators : Array;

   public function FormMediator(mediatorName : String, viewComponent : Object) {
      super(mediatorName, viewComponent);
      _validators = [];
      registerValidators();
   }

   /**
    * This method should be overridden to initialise the list of validators so that reset validators
    * and validate fill work correctly
    */
   public function registerValidators() : void { }

   /**
    * This function should be overriden to bind model fields onto the form.
    */
   public function bindForm() : void { }

   /**
    * This function should be overriden to bind form fields onto the model.
    */
   public function bindModel() : void { }

   public function validate(revalidate : Boolean) : Boolean {
      return FormUtility.validateAll(_validators, revalidate);
   }

   public function resetValidation() : void {
      for each(var validator : Validator in _validators) {
         validator.source.errorString = "";
      }
   }
}
}