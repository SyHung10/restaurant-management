package com.restaurant.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "ServiceSession")
public class ServiceSession implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "session_id")
    private Long sessionId;

    @Column(name = "table_id", nullable = false)
    private String tableId;

    @Column(name = "num_people", nullable = false)
    private Integer numPeople;

    @Column(name = "start_time", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date startTime;

    @Column(name = "status", nullable = false)
    private String status;

    @Column(name = "promotion_id")
    private Long promotionId;

    // Getters and Setters
    public Long getSessionId() {
        return sessionId;
    }

    public void setSessionId(Long sessionId) {
        this.sessionId = sessionId;
    }

    public String getTableId() {
        return tableId;
    }

    public void setTableId(String tableId) {
        this.tableId = tableId;
    }

    // Helper methods để xử lý multiple table IDs
    public List<Long> getTableIds() {
        if (tableId == null || tableId.trim().isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> ids = new ArrayList<>();
        String[] parts = tableId.split(",");
        for (String part : parts) {
            try {
                ids.add(Long.parseLong(part.trim()));
            } catch (NumberFormatException e) {
                // Ignore invalid IDs
            }
        }
        return ids;
    }

    public void setTableIds(List<Long> tableIds) {
        if (tableIds == null || tableIds.isEmpty()) {
            this.tableId = "";
            return;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < tableIds.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append(tableIds.get(i));
        }
        this.tableId = sb.toString();
    }

    public void addTableId(Long newTableId) {
        List<Long> currentIds = getTableIds();
        if (!currentIds.contains(newTableId)) {
            currentIds.add(newTableId);
            setTableIds(currentIds);
        }
    }

    public void removeTableId(Long tableIdToRemove) {
        List<Long> currentIds = getTableIds();
        currentIds.remove(tableIdToRemove);
        setTableIds(currentIds);
    }

    public Long getPrimaryTableId() {
        List<Long> ids = getTableIds();
        return ids.isEmpty() ? null : ids.get(0); // Bàn đầu tiên là bàn chính
    }

    public boolean containsTableId(Long tableId) {
        return getTableIds().contains(tableId);
    }

    public Integer getNumPeople() {
        return numPeople;
    }

    public void setNumPeople(Integer numPeople) {
        this.numPeople = numPeople;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(Long promotionId) {
        this.promotionId = promotionId;
    }
}
