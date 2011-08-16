package com.express.domain;

import java.util.Set;

public interface BacklogContainer {

   void addBacklogItem(BacklogItem item, boolean isNew);

   BacklogItem removeBacklogItem(BacklogItem item);

   Set<BacklogItem> getBacklog();
}
