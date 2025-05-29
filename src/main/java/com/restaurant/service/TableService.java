package com.restaurant.service;

import com.restaurant.dao.TableDAO;
import com.restaurant.entity.RestaurantTable; // Sử dụng RestaurantTable
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class TableService {

    @Autowired
    private TableDAO tableDAO;
    
	public TableService() {
		// TODO Auto-generated constructor stub
	}
    public void save(RestaurantTable table) {
        tableDAO.save(table);
    }

    public void delete(Long id) {
        tableDAO.delete(id);
    }

    public RestaurantTable findById(Long id) {
        return tableDAO.findById(id);
    }

    public List<RestaurantTable> findAll() {
        return tableDAO.findAll();
    }
}