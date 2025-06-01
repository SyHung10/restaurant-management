package com.restaurant.service; // Đổi từ com.nhahang.service

import com.restaurant.dao.MenuDAO; // Đổi từ com.nhahang.dao
import com.restaurant.entity.Menu; // Đổi từ com.nhahang.model
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class MenuService {

    @Autowired
    private MenuDAO menuDAO;

    public MenuService() {
		// TODO Auto-generated constructor stub
	}

    public void save(Menu menu) {
        menuDAO.save(menu);
    }

    public void delete(Long id) {
        menuDAO.delete(id);
    }

    public Menu findById(Long id) {
        return menuDAO.findById(id);
    }

    public List<Menu> findAll() {
        return menuDAO.findAll();
    }

    public List<Menu> findByStatus(String status) {
        return menuDAO.findByStatus(status);
    }

    public List<Menu> findByCategoryId(Long categoryId) {
        return menuDAO.findByCategoryId(categoryId);
    }

    public List<Menu> findAvailableByCategoryId(Long categoryId) {
        return menuDAO.findAvailableByCategoryId(categoryId);
    }
}