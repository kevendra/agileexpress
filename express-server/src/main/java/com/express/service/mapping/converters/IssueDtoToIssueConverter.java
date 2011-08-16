package com.express.service.mapping.converters;

import com.express.dao.IssueDao;
import com.express.domain.Issue;
import com.express.service.dto.IssueDto;
import com.googlecode.simpleobjectassembler.converter.AbstractObjectConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class IssueDtoToIssueConverter extends AbstractObjectConverter<IssueDto, Issue> {

   private final IssueDao issueDao;

   @Autowired
   public IssueDtoToIssueConverter(IssueDao issueDao) {
      this.issueDao = issueDao;
   }

   @Override
   public Issue createDestinationObject(IssueDto dto) {
      return dto.getId() == 0 ? new Issue() : issueDao.findById(dto.getId());
   }

   @Override
   public void convert(IssueDto issueDto, Issue issue) {
      super.convert(issueDto, issue);
      if(issue.getId() == 0) {
         issue.setId(null);
         issue.setVersion(null);
      }
   }
}
