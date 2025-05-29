package com.restaurant.controller;

import com.restaurant.entity.Promotion;
import com.restaurant.service.PromotionService;
import com.restaurant.dto.PromotionWithUsage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.beans.PropertyEditorSupport;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/manager")
public class PromotionController {

    @Autowired
    private PromotionService promotionService;

    // Danh sách khuyến mãi
    @RequestMapping(value = "/promotions", method = RequestMethod.GET)
    public String listPromotions(Model model) {
        List<Promotion> promotions = promotionService.findAll();
        List<PromotionWithUsage> promotionsWithUsage = new ArrayList<PromotionWithUsage>();
        
        for (Promotion promotion : promotions) {
            long usageCount = promotionService.countUsageByPromotionId(promotion.getPromotionId());
            PromotionWithUsage promotionWithUsage = new PromotionWithUsage(promotion, usageCount);
            promotionsWithUsage.add(promotionWithUsage);
        }
        
        model.addAttribute("promotions", promotionsWithUsage);
        return "manager/promotion-list";
    }

    // Form thêm mới khuyến mãi
    @RequestMapping(value = "/promotions/new", method = RequestMethod.GET)
    public String newPromotionForm(Model model) {
        model.addAttribute("promotion", new Promotion());
        return "manager/promotion-form";
    }

    // Lưu khuyến mãi (thêm/sửa)
    @RequestMapping(value = "/promotions/save", method = RequestMethod.POST)
    public String savePromotion(HttpServletRequest req) {
        // Lấy id để phân biệt thêm mới hay sửa
        Long id = null;
        try {
            String idStr = req.getParameter("promotionId");
            if (idStr != null && !idStr.isEmpty()) {
                id = Long.valueOf(idStr);
            }
        } catch (NumberFormatException e) {
            // bỏ qua nếu không hợp lệ
        }
        // Lấy hoặc tạo mới Promotion
        Promotion p = (id != null) ? promotionService.findById(id) : new Promotion();
        // Gán các thuộc tính từ form
        p.setType(req.getParameter("type"));
        p.setName(req.getParameter("name"));
        // startTime, endTime (HH:mm)
        try {
            String st = req.getParameter("startTime");
            p.setStartTime(st == null || st.isEmpty() ? null : java.sql.Time.valueOf(st + ":00"));
        } catch (Exception e) {
        }
        try {
            String et = req.getParameter("endTime");
            p.setEndTime(et == null || et.isEmpty() ? null : java.sql.Time.valueOf(et + ":00"));
        } catch (Exception e) {
        }
        // discountPercent
        try {
            String dp = req.getParameter("discountPercent");
            p.setDiscountPercent(dp == null || dp.isEmpty() ? null : new java.math.BigDecimal(dp));
        } catch (Exception e) {
        }
        // voucherCode
        p.setVoucherCode(req.getParameter("voucherCode"));
        // discountValue
        try {
            String dv = req.getParameter("discountValue");
            p.setDiscountValue(dv == null || dv.isEmpty() ? null : new java.math.BigDecimal(dv));
        } catch (Exception e) {
        }
        // isPercent
        p.setIsPercent("true".equalsIgnoreCase(req.getParameter("isPercent")));
        // expiryDate (yyyy-MM-dd)
        try {
            String ex = req.getParameter("expiryDate");
            if (ex != null && !ex.isEmpty()) {
                java.text.SimpleDateFormat fmt = new java.text.SimpleDateFormat("yyyy-MM-dd");
                p.setExpiryDate(fmt.parse(ex));
            } else {
                p.setExpiryDate(null);
            }
        } catch (Exception e) {
            // Log lỗi để debug
            System.out.println("Lỗi parse expiryDate: " + e.getMessage());
            p.setExpiryDate(null);
        }
        // maxUsage
        try {
            String mu = req.getParameter("maxUsage");
            p.setMaxUsage(mu == null || mu.isEmpty() ? null : Integer.valueOf(mu));
        } catch (Exception e) {
        }
        // status
        p.setStatus(req.getParameter("status"));
        // Lưu vào DB
        promotionService.save(p);
        return "redirect:/manager/promotions";
    }

    // Form sửa khuyến mãi
    @RequestMapping(value = "/promotions/edit/{id}", method = RequestMethod.GET)
    public String editPromotionForm(@PathVariable("id") Long id, Model model) {
        Promotion promotion = promotionService.findById(id);
        model.addAttribute("promotion", promotion);
        return "manager/promotion-form";
    }

    // Xóa khuyến mãi
    @RequestMapping(value = "/promotions/delete/{id}", method = RequestMethod.GET)
    public String deletePromotion(@PathVariable("id") Long id) {
        promotionService.delete(id);
        return "redirect:/manager/promotions";
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        // LocalTime
        binder.registerCustomEditor(LocalTime.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                if (text == null || text.isEmpty()) {
                    setValue(null);
                } else {
                    setValue(LocalTime.parse(text));
                }
            }
        });
        // Date
        binder.registerCustomEditor(Date.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                try {
                    if (text == null || text.isEmpty()) {
                        setValue(null);
                    } else {
                        setValue(new SimpleDateFormat("yyyy-MM-dd").parse(text));
                    }
                } catch (Exception e) {
                    setValue(null);
                }
            }
        });
        // Time
        binder.registerCustomEditor(java.sql.Time.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                if (text == null || text.isEmpty()) {
                    setValue(null);
                } else {
                    setValue(java.sql.Time.valueOf(text + ":00")); // text dạng HH:mm
                }
            }
        });
        // Boolean
        binder.registerCustomEditor(Boolean.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                setValue("true".equalsIgnoreCase(text));
            }
        });
    }
}
