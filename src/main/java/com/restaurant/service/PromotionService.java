package com.restaurant.service;

import com.restaurant.dao.PromotionDAO;
import com.restaurant.entity.Promotion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class PromotionService {

    @Autowired
    private PromotionDAO promotionDAO;

    public PromotionService() {
        // TODO Auto-generated constructor stub
    }

    public void save(Promotion promotion) {
        promotionDAO.save(promotion);
    }

    public void delete(Long id) {
        promotionDAO.delete(id);
    }

    public Promotion findById(Long id) {
        return promotionDAO.findById(id);
    }

    public List<Promotion> findAll() {
        return promotionDAO.findAll();
    }

    public Promotion findByVoucherCode(String voucherCode) {
        return promotionDAO.findByVoucherCode(voucherCode);
    }
}
