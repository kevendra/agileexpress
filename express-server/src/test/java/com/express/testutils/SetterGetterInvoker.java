package com.express.testutils;import org.apache.commons.logging.Log;import org.apache.commons.logging.LogFactory;import java.lang.reflect.Field;import java.lang.reflect.Method;import java.lang.reflect.Modifier;import java.util.ArrayList;import java.util.HashMap;import java.util.List;import java.util.Map;@SuppressWarnings("PMD")public class SetterGetterInvoker<T> {   private static final Log LOG = LogFactory.getLog(SetterGetterInvoker.class);   private T testTarget;   private Class testClass;   private ValueFactory valueFactory;   private Map<String, Method> methodMap = new HashMap<String, Method>();   public SetterGetterInvoker(T testTarget) {      this.testTarget = testTarget;      this.testClass = testTarget.getClass();      this.valueFactory = new ValueFactory();      for (Method method : testTarget.getClass().getMethods()) {         methodMap.put(method.getName(), method);      }   }   public boolean invokeSettersAndGettersFor(String[] fields) {      return invokeSettersAndGetters(fields);   }   public boolean invokeSettersAndGettersExcluding(String[] excludedFields) {      Field[] classFields = testClass.getDeclaredFields();      List<String> fields = new ArrayList<String>();      for(Field classField : classFields) {         String fieldName = classField.getName();         if(!in(fieldName, excludedFields) && !Modifier.isStatic(classField.getModifiers())) {            fields.add(fieldName);         }      }      return invokeSettersAndGetters(fields.toArray(new String[fields.size()]));   }   private boolean in(String field, String[] fields) {      for(String arrayField : fields) {         if( arrayField.equals(field)) {            return true;         }      }      return false;   }   private boolean invokeSettersAndGetters(String[] fields) {      for (String field : fields) {         LOG.debug("Invoking getter/setter for " + field);         String capitalizedFieldName = Character.toUpperCase(field.charAt(0)) + field.substring(1);         try {            Object testValue = invokeSetter(methodMap.get("set" + capitalizedFieldName));            Method getterMethod = methodMap.get(constructMethodName(capitalizedFieldName, testValue));            Object result = getterMethod.invoke(testTarget);            if (!testValue.equals(result)) {               LOG.error("Getter result did not match set value for field:" + field);               return false;            }         } catch (Exception e) {            LOG.error("Unable to invoke both getter and setter for " + field, e);            return false;         }      }      return true;   }   private Object invokeSetter(Method method) throws Exception {      Class<?>[] parameterTypes = method.getParameterTypes();      if (parameterTypes.length == 1) {         Object testValue = valueFactory.createValue(parameterTypes[0]);         method.invoke(testTarget, testValue);         return testValue;      }      return null;   }   private String constructMethodName(String capitalizedFieldName, Object testValue) {      String base =  "get";      if(testValue instanceof Boolean && testMethodNameDoesNotExists(base + capitalizedFieldName)) {         return "is" + capitalizedFieldName;      }      return base + capitalizedFieldName;   }   private boolean testMethodNameDoesNotExists(String methodName) {      try {         testClass.getMethod(methodName, null);         return false;      } catch (NoSuchMethodException e) {         return true;      }   }}