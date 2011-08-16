package com.express.service;

import com.express.dao.BacklogItemDao;
import com.express.dao.IterationDao;
import com.express.dao.ProjectDao;
import com.express.dao.UserDao;
import com.express.domain.*;
import com.express.service.dto.AddImpedimentRequest;
import com.express.service.dto.BacklogItemAssignRequest;
import com.express.service.dto.BacklogItemDto;
import com.express.service.dto.CreateBacklogItemRequest;
import com.express.service.mapping.DomainFactory;
import com.express.service.mapping.RemoteObjectFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;

import static com.express.service.matchers.IsNullOrZeroMatcher.isNullOrZero;

/**
 *
 */
@Service("backlogItemManager")
public class BacklogItemManagerImpl implements BacklogItemManager {

   private final ProjectDao projectDao;

   private final UserDao userDao;

   private final IterationDao iterationDao;

   private final BacklogItemDao backlogItemDao;

   private final DomainFactory domainFactory;

   private final RemoteObjectFactory remoteObjectFactory;

   @Autowired
   public BacklogItemManagerImpl(@Qualifier("projectDao") ProjectDao projectDao,
                                 @Qualifier("userDao") UserDao userDao,
                                 @Qualifier("backlogItemDao") BacklogItemDao backlogItemDao,
                                 @Qualifier("iterationDao") IterationDao iterationDao,
                                 @Qualifier("domainFactory") DomainFactory domainFactory,
                                 @Qualifier("remoteObjectFactory") RemoteObjectFactory remoteObjectFactory) {
      this.projectDao = projectDao;
      this.userDao = userDao;
      this.iterationDao = iterationDao;
      this.backlogItemDao = backlogItemDao;
      this.domainFactory = domainFactory;
      this.remoteObjectFactory = remoteObjectFactory;
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public BacklogItemDto createBacklogItem(CreateBacklogItemRequest request) {
      BacklogItem item = domainFactory.createBacklogItem(request.getBacklogItem());
      if (request.getBacklogItem().getAssignedTo() != null) {
         item.setAssignedTo(userDao.findById(request.getBacklogItem().getAssignedTo().getId()));
      }
      item.makeStatusConsistent();
      addBacklogItemByType(request.getType(), request.getParentId(), item);
      item.createReference();
      backlogItemDao.save(item);
      return remoteObjectFactory.createBacklogItemDto(item);
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void updateBacklogItem(BacklogItemDto backlogItemDto) {
      BacklogItem backlogItem = domainFactory.createBacklogItem(backlogItemDto);
      backlogItem.makeStatusConsistent();
      projectDao.save(backlogItem.getProject());
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void markStoryDone(Long id) {
      BacklogItem story = backlogItemDao.findById(id);
      story.setDone();
      projectDao.save(story.getProject());
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void removeBacklogItem(Long id) {
      BacklogItem backlogItem = backlogItemDao.findById(id);
      Project project = backlogItem.getProject();
      if (backlogItem.getParent() != null) {
         BacklogItem parent = backlogItem.getParent();
         parent.removeTask(backlogItem);
      }
      else if (backlogItem.getIteration() != null) {
         Iteration iteration = backlogItem.getIteration();
         iteration.removeBacklogItem(backlogItem);
      }
      else {
         project.removeBacklogItem(backlogItem);
      }
      projectDao.save(project);
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void backlogItemAssignmentRequest(BacklogItemAssignRequest request) {
      Project project = projectDao.findById(request.getProjectId());
      BacklogContainer from = getAssignmentSource(request);
      BacklogContainer to = getAssignmentTarget(request);
      int initialItemCount = to.getBacklog().size();
      for (Long itemId : request.getItemIds()) {
         BacklogItem item = backlogItemDao.findById(itemId);
         to.addBacklogItem(from.removeBacklogItem(item), false);
      }
      if(to.getBacklog().size() !=  initialItemCount + request.getItemIds().length) {
         throw new IllegalArgumentException("Unable to assign all backlog items in request");
      }
      projectDao.save(project);
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void addImpediment(AddImpedimentRequest request) {
      BacklogItem item = backlogItemDao.findById(request.getBacklogItemId());
      Issue impediment = domainFactory.createIssue(request.getImpediment());
      item.setImpediment(impediment);
      projectDao.save(item.getProject());
   }

   @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
   public void removeImpediment(BacklogItemDto dto) {
      BacklogItem item = backlogItemDao.findById(dto.getId());
      Issue impediment = item.getImpediment();
      impediment.setEndDate(Calendar.getInstance());
      item.setImpediment(null);
      projectDao.save(item.getProject());
   }

   private BacklogContainer getAssignmentSource(BacklogItemAssignRequest request) {
      if (!isNullOrZero(request.getIterationFromId())) {
         return iterationDao.findById(request.getIterationFromId());
      }
      return projectDao.findById(request.getProjectId());
   }

   private BacklogContainer getAssignmentTarget(BacklogItemAssignRequest request) {
      if (!isNullOrZero(request.getIterationToId())) {
         return iterationDao.findById(request.getIterationToId());
      }
      return projectDao.findById(request.getProjectId());
   }

   private void addBacklogItemByType(int type, Long id, BacklogItem item) {
      switch (type) {
         case CreateBacklogItemRequest.PRODUCT_BACKLOG_STORY:
            Project project = projectDao.findById(id);
            project.addBacklogItem(item, true);
            break;
         case CreateBacklogItemRequest.STORY:
            Iteration iteration = iterationDao.findById(id);
            iteration.addBacklogItem(item, true);
            break;
         case CreateBacklogItemRequest.TASK:
            BacklogItem parent = backlogItemDao.findById(id);
            parent.addTask(item);
            break;
      }
   }
}