package com.express.dao.jpa;

import org.springframework.orm.ObjectRetrievalFailureException;
import org.springframework.orm.jpa.support.JpaDaoSupport;

import com.express.dao.GenericDao;
import com.express.domain.Persistable;

/**
 * This is a basic implementation of CRUD operations using the Spring JpaTemplate. It provides a
 * base implementation which can be extended.
 * 
 * @author Adam Boas
 *
 * Created on Oct 5, 2007
 */
public class JpaGenericDao<T> extends JpaDaoSupport implements GenericDao<T>
{
   private final  Class<T> persistentClass;
   
   public JpaGenericDao(final Class<T> persistentClass)
   {
      this.persistentClass = persistentClass;
   }

   public T findById(final Long id)
   {
      T result = getJpaTemplate().find(this.persistentClass, id);
      if (result == null) {
         throw new ObjectRetrievalFailureException(persistentClass, id);
      }
      return result;
   }

   public void remove(final Long id)
   {
      getJpaTemplate().remove(this.findById(id));
   }

   public void save(final T object)
   {
      if(((Persistable)object).getId() != null) {
         getJpaTemplate().merge(object);
      }
      else {
         getJpaTemplate().persist(object);
      }
   }
}
