package com.express.domain;

import com.express.security.Role;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.hibernate.annotations.OptimisticLock;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.util.StringUtils;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.TableGenerator;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.persistence.Version;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * The core actor in the Express system. Users accesses Projects through their relationship as a ProjectWorker.
 *
 * @author Adam Boas
 */
@Entity
@Table(name = "express_user")
@NamedQueries({
      @NamedQuery(name = "User.findByUsername", query = "SELECT U FROM User U WHERE LOWER(U.email) = :email")
})
public class User implements Persistable, UserDetails, Comparable<User> {
   private static final long serialVersionUID = -7572241766772304908L;

   public static final String QUERY_FIND_BY_USERNAME = "User.findByUsername";

   @Transient
   private PersistableEqualityStrategy equalityStrategy = new PersistableEqualityStrategy(this);

   @Id
   @GeneratedValue(strategy = GenerationType.TABLE, generator = "gen_user")
   @TableGenerator(name = "gen_user", table = "sequence_list", pkColumnName = "name",
         valueColumnName = "next_value", allocationSize = 1, initialValue = 100,
         pkColumnValue = "express_user")
   @Column(name = "user_id")
   private Long id;

   @Version
   @Column(name = "version_no")
   private Long version;

   @Column(name = "created_date")
   @Temporal(value = TemporalType.TIMESTAMP)
   private Calendar createdDate;

   @Column(name = "email", unique = true, nullable = false)
   private String email;

   @Column(name = "f_name")
   private String firstName;

   @Column(name = "l_name")
   private String lastName;

   @Column(name = "password")
   private String password;

   @Column(name = "passwd_hint")
   private String passwordHint;

   @Column(name = "phone1")
   private String phone1;

   @Column(name = "phone2")
   private String phone2;

   @Column(name = "active")
   private Boolean active = false;

   @Column(name = "colour")
   private Integer colour;

   @OneToMany(mappedBy = "requestor")
   @OptimisticLock(excluded = true)
   private final Set<AccessRequest> accessRequests;

   public User() {
      this.accessRequests = new HashSet<AccessRequest>();
   }

   public Long getId() {
      return id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public Calendar getCreatedDate() {
      return createdDate;
   }

   public void setCreatedDate(Calendar createdDate) {
      this.createdDate = createdDate;
   }

   public String getEmail() {
      return email;
   }

   public void setEmail(String email) {
      this.email = email;
   }

   public String getFirstName() {
      return firstName;
   }

   public void setFirstName(String firstName) {
      this.firstName = firstName;
   }

   public String getLastName() {
      return lastName;
   }

   public void setLastName(String lastName) {
      this.lastName = lastName;
   }

   public String getPassword() {
      return password;
   }

   public void setPassword(String password) {
      this.password = password;
   }

   public String getPasswordHint() {
      return passwordHint;
   }

   public void setPasswordHint(String passwordHint) {
      this.passwordHint = passwordHint;
   }

   public String getPhone1() {
      return phone1;
   }

   public void setPhone1(String phone1) {
      this.phone1 = phone1;
   }

   public String getPhone2() {
      return phone2;
   }

   public void setPhone2(String phone2) {
      this.phone2 = phone2;
   }

   public void setActive(Boolean active) {
      this.active = active;
   }

   public Boolean isActive() {
      return active;
   }


   public Integer getColour() {
      return colour;
   }


   public void setColour(Integer colour) {
      this.colour = colour;
   }

   public Long getVersion() {
      return version;
   }

   public void setVersion(Long version) {
      this.version = version;
   }

   public List<AccessRequest> getAccessRequests() {
      List<AccessRequest> requestList = new ArrayList<AccessRequest>(accessRequests);
      Collections.sort(requestList);
      return requestList;
   }

   public void setAccessRequests(List<AccessRequest> requestList) {
      this.accessRequests.clear();
      if (requestList != null) {
         this.accessRequests.addAll(requestList);
      }
   }

   public void addAccessRequest(AccessRequest accessRequest) {
      this.accessRequests.add(accessRequest);
      accessRequest.setRequestor(this);
   }

   public void removeAccessRequest(AccessRequest accessRequest) {
      this.accessRequests.remove(accessRequest);
      accessRequest.setRequestor(null);
   }

   public String getFullName() {
      if (StringUtils.hasText(firstName) || StringUtils.hasText(lastName)) {
         return firstName + " " + lastName;
      }
      return email.substring(0, email.indexOf('@'));
   }

   public boolean hasPendingRequest(Project project) {
      for (AccessRequest request : accessRequests) {
         if (AccessRequest.UNRESOLVED.equals(request.getStatus()) && project.equals(request.getProject())) {
            return true;
         }
      }
      return false;
   }

   public int compareTo(User user) {
      return this.getFullName().compareTo(user.getFullName());
   }

   @Override
   public boolean equals(Object obj) {
      return equalityStrategy.entityEquals(obj);
   }

   @Override
   public int hashCode() {
      return equalityStrategy.entityHashCode(super.hashCode());
   }

   @Override
   public String toString() {
      return new ReflectionToStringBuilder(this).toString();
   }

   //UserDetails implementation

   public GrantedAuthority[] getAuthorities() {
      GrantedAuthority authority = new GrantedAuthorityImpl(Role.USER.getCode());
      return new GrantedAuthority[]{authority};
   }

   public String getUsername() {
      return email;
   }

   public boolean isAccountNonExpired() {
      return true;
   }

   public boolean isAccountNonLocked() {
      return true;
   }

   public boolean isCredentialsNonExpired() {
      return active;
   }

   public boolean isEnabled() {
      return active;
   }
}
