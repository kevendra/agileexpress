package com.express.service.matchers;

public class IsNullOrZeroMatcher {

   public static boolean isNullOrZero(Number number) {
      return number == null || number.longValue() == 0;
   }
}
