package com.express;

import org.unitils.UnitilsJUnit4;
import org.unitils.database.annotations.Transactional;
import org.unitils.database.util.TransactionMode;
import org.unitils.spring.annotation.SpringApplicationContext;

@SpringApplicationContext({"classpath:testApplicationContextDataSource.xml",
                           "classpath:applicationContext.xml",
                           "applicationContextNotification.xml"})
@Transactional(TransactionMode.COMMIT)
public abstract class AbstractUnitilsTestBase extends UnitilsJUnit4 {

}
