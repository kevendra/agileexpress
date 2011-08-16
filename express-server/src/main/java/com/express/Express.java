package com.express;

import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.nio.SelectChannelConnector;
import org.eclipse.jetty.webapp.WebAppContext;

public class Express {

   @SuppressWarnings("PMD")
   public static void main(String[] args) throws Exception {
      Server server = new Server();

      Connector connector = new SelectChannelConnector();
      connector.setPort(9000);
      connector.setHost("127.0.0.1");
      server.addConnector(connector);

      WebAppContext wac = new WebAppContext();
      wac.setContextPath("/");
      //expanded war or path of war file
      wac.setWar("/Users/adam/Projects/agileexpress/express-server/target/express-server-0.8-RC1/");
      server.setHandler(wac);
      server.setStopAtShutdown(true);

      //another way is to use an external jetty configuration file
      //XmlConfiguration configuration =
      //new XmlConfiguration(new File("/path/jetty-config.xml").toURL());
      //configuration.configure(server);

      server.start();
   }
}
