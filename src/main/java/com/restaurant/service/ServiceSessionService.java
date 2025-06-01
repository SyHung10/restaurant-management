package com.restaurant.service;

import com.restaurant.dao.ServiceSessionDAO;
import com.restaurant.entity.ServiceSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ServiceSessionService {
    @Autowired
    private ServiceSessionDAO serviceSessionDAO;

    public void save(ServiceSession session) {
        serviceSessionDAO.save(session);
    }

    public void delete(Long id) {
        serviceSessionDAO.delete(id);
    }

    public ServiceSession findById(Long id) {
        return serviceSessionDAO.findById(id);
    }

    public List<ServiceSession> findAll() {
        return serviceSessionDAO.findAll();
    }

    public ServiceSession findActiveByTableId(Long tableId) {
        return serviceSessionDAO.findActiveByTableId(tableId);
    }

    public List<ServiceSession> findByTableId(Long tableId) {
        return serviceSessionDAO.findByTableId(tableId);
    }
}
