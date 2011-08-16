package com.express.matcher;import com.express.domain.PersistableEqualityStrategy;import org.apache.commons.logging.Log;import org.apache.commons.logging.LogFactory;import org.hamcrest.Description;import org.hamcrest.TypeSafeMatcher;import java.lang.reflect.Field;import static org.mockito.Matchers.anyInt;import static org.mockito.Mockito.mock;import static org.mockito.Mockito.verify;@SuppressWarnings("PMD.NcssMethodCount")public class UsesPersistableHashCodeStrategyMatcher<T> extends TypeSafeMatcher<T> {   private static final Log LOG = LogFactory.getLog(UsesPersistableHashCodeStrategyMatcher.class);   @Override   public boolean matchesSafely(T persistable) {      try {         PersistableEqualityStrategy equalityStrategy = mock(PersistableEqualityStrategy.class);         setEqualityStrategy(persistable, equalityStrategy);         persistable.hashCode();         verify(equalityStrategy).entityHashCode(anyInt());         return true;      } catch (Exception e) {         LOG.info("class provided does not contain an equality strategy field", e);         return false;      }   }   public void describeTo(Description description) {      description.appendText("Class does not provide hash code using PersistableEqualityStrategy");   }   private void setEqualityStrategy(T persistable, PersistableEqualityStrategy equalityStrategy) throws NoSuchFieldException, IllegalAccessException {      Field equalityStrategyField = persistable.getClass().getDeclaredField("equalityStrategy");      equalityStrategyField.setAccessible(true);      equalityStrategyField.set(persistable, equalityStrategy);   }}