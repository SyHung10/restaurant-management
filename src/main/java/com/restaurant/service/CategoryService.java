package com.restaurant.service;

import com.restaurant.dao.CategoryDAO;
import com.restaurant.entity.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CategoryService {

    @Autowired
    private CategoryDAO categoryDAO;

    public CategoryService() {
        // TODO Auto-generated constructor stub
    }

    public void save(Category category) {
        categoryDAO.save(category);
    }

    public void delete(Long id) {
        categoryDAO.delete(id);
    }

    public Category findById(Long id) {
        return categoryDAO.findById(id);
    }

    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    public List<Category> findAllActive() {
        return categoryDAO.findAllActive();
    }

    public Category findByCode(String code) {
        return categoryDAO.findByCode(code);
    }
}