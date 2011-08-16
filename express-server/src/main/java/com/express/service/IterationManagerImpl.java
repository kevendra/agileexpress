package com.express.service;

import com.express.dao.IterationDao;
import com.express.dao.ProjectDao;
import com.express.domain.Iteration;
import com.express.domain.Project;
import com.express.service.dto.IterationDto;
import com.express.service.mapping.DomainFactory;
import com.express.service.mapping.RemoteObjectFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 */
@Service("iterationManager")
public class IterationManagerImpl implements IterationManager {

   private final ProjectDao projectDao;

   private final IterationDao iterationDao;

   private final DomainFactory domainFactory;

   private final RemoteObjectFactory remoteObjectFactory;

   @Autowired
   public IterationManagerImpl(@Qualifier("projectDao") ProjectDao projectDao,
                             @Qualifier("remoteObjectFactory") RemoteObjectFactory remoteObjectFactory,
                             @Qualifier("domainFactory") DomainFactory domainFactory,
                             @Qualifier("iterationDao") IterationDao iterationDao) {
      this.projectDao = projectDao;
      this.remoteObjectFactory = remoteObjectFactory;
      this.domainFactory = domainFactory;
      this.iterationDao = iterationDao;
   }

   @Transactional(readOnly = true)
   public IterationDto findIteration(Long id) {
      Iteration iteration = iterationDao.findById(id);
      return remoteObjectFactory.createIterationDto(iteration);
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public IterationDto createIteration(IterationDto iterationDto) {
      Iteration iteration = domainFactory.createIteration(iterationDto);
      Project project = projectDao.findById(iterationDto.getProject().getId());
      project.addIteration(iteration);
      projectDao.save(project);
      return remoteObjectFactory.createIterationDto(
            project.findIterationByTitle(iteration.getTitle()));
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public IterationDto updateIteration(IterationDto iterationDto) {
      Iteration iteration = domainFactory.createIteration(iterationDto);
      projectDao.save(iteration.getProject());
      return remoteObjectFactory.createIterationDto(iteration);
   }
}
