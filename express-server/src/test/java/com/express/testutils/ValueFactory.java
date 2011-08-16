package com.express.testutils;


import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.Map;

import static org.mockito.Mockito.mock;


public class ValueFactory {
   private static final int A_NUMBER = 42;
   private static final int HALF_A_NUMBER = 21;

   private Map<Class<?>, Object> typeValues;

   public ValueFactory() {
      typeValues = new HashMap<Class<?>, Object>();
      typeValues.put(String.class, "test");
      typeValues.put(Long.class, new Long(A_NUMBER));
      typeValues.put(Long.TYPE, new Long(A_NUMBER));
      typeValues.put(Integer.class, Integer.valueOf(HALF_A_NUMBER));
      typeValues.put(Integer.TYPE, Integer.valueOf(HALF_A_NUMBER));
      typeValues.put(Boolean.class, Boolean.TRUE);
      typeValues.put(Boolean.TYPE, Boolean.TRUE);
      typeValues.put(long[].class, new long[0]);
      typeValues.put(Long[].class, new Long[0]);
      typeValues.put(int[].class, new int[0]);
      typeValues.put(Integer[].class, new Integer[0]);
      typeValues.put(String[].class, new String[0]);
      typeValues.put(Boolean[].class, new Boolean[0]);
   }

   public Object createValue(Class<?> type) {
      if(Modifier.isFinal(type.getModifiers())) {
         return typeValues.get(type);
      }
      return mock(type);
   }
}
