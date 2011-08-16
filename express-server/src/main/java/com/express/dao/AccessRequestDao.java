package com.express.dao;

import com.express.domain.AccessRequest;

/**
 * @author Adam Boas
 *         Created on Mar 25, 2009
 */
public interface AccessRequestDao {

   AccessRequest findById(Long id);
}
