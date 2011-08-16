package com.express.testutils;

import static org.unitils.dbmaintainer.util.DatabaseModuleConfigUtils.getConfiguredDatabaseTaskInstance;

import java.util.Properties;

import javax.sql.DataSource;

import org.unitils.core.ConfigurationLoader;
import org.unitils.core.dbsupport.SQLHandler;
import org.unitils.dbmaintainer.structure.ConstraintsDisabler;


/**
 * Disables database constraints for tests
 *
 */
public class UnitilsDatabaseConstraintsDisabler implements DatabaseConstraintsDisabler {

    private final DataSource dataSource;
    
    protected UnitilsDatabaseConstraintsDisabler(DataSource dataSource) {
        super();
        this.dataSource = dataSource;
    }

    public void disableDatabaseConstraints() {
        Properties configuration = new ConfigurationLoader().loadConfiguration();

        SQLHandler sqlHandler = new SQLHandler(dataSource);
        ConstraintsDisabler constraintsDisabler =
                getConfiguredDatabaseTaskInstance(ConstraintsDisabler.class, configuration, sqlHandler);
        constraintsDisabler.removeConstraints();

    }

}
