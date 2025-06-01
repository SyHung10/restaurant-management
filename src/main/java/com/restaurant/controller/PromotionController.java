package com.restaurant.controller;

import com.restaurant.entity.Promotion;
import com.restaurant.service.PromotionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.beans.PropertyEditorSupport;
import java.text.SimpleDateFormat;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;


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
        
        // Tạo Map để lưu usage count cho từng promotion
        Map<Long, Long> usageCounts = new HashMap<>();
        Map<Long, Boolean> usabilityStatus = new HashMap<>();
        
        for (Promotion promotion : promotions) {
            Long usageCount = promotionService.countUsageByPromotionId(promotion.getPromotionId());
            boolean isUsable = promotionService.isPromotionUsable(promotion.getPromotionId());
            
            usageCounts.put(promotion.getPromotionId(), usageCount);
            usabilityStatus.put(promotion.getPromotionId(), isUsable);
        }
        
        model.addAttribute("promotions", promotions);
        model.addAttribute("usageCounts", usageCounts);
        model.addAttribute("usabilityStatus", usabilityStatus);
        
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
    public String savePromotion(HttpServletRequest req, RedirectAttributes redirectAttributes) {
        try {
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
            
            // =============================================
            // VALIDATION PHASE
            // =============================================
            
            StringBuilder errors = new StringBuilder();
            
            // 1. Validate required fields
            String name = req.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                errors.append("Tên khuyến mãi là bắt buộc. ");
            }
            
            String voucherCode = req.getParameter("voucherCode");
            if (voucherCode == null || voucherCode.trim().isEmpty()) {
                errors.append("Mã khuyến mãi là bắt buộc. ");
            } else {
                // Validate voucher code format
                voucherCode = voucherCode.trim().toUpperCase();
                if (!voucherCode.matches("^[A-Z0-9_-]+$")) {
                    errors.append("Mã khuyến mãi chỉ được chứa chữ cái, số, dấu gạch ngang và gạch dưới. ");
                } else if (voucherCode.length() < 3 || voucherCode.length() > 20) {
                    errors.append("Mã khuyến mãi phải từ 3-20 ký tự. ");
                } else {
                    // Check duplicate voucher code (except current promotion)
                    Promotion existingPromo = promotionService.findByVoucherCode(voucherCode);
                    if (existingPromo != null && !existingPromo.getPromotionId().equals(id)) {
                        errors.append("Mã khuyến mãi '" + voucherCode + "' đã tồn tại. ");
                    }
                }
            }
            
            String scopeType = req.getParameter("scopeType");
            if (scopeType == null || scopeType.trim().isEmpty()) {
                errors.append("Phạm vi áp dụng là bắt buộc. ");
            }
            
            String status = req.getParameter("status");
            if (status == null || status.trim().isEmpty()) {
                errors.append("Trạng thái là bắt buộc. ");
            }
            
            // 2. Validate discount fields
            String discountPercentStr = req.getParameter("discountPercent");
            String discountValueStr = req.getParameter("discountValue");
            
            boolean hasPercent = discountPercentStr != null && !discountPercentStr.trim().isEmpty();
            boolean hasValue = discountValueStr != null && !discountValueStr.trim().isEmpty();
            
            if (!hasPercent && !hasValue) {
                errors.append("Phải nhập phần trăm giảm hoặc giá trị giảm. ");
            } else if (hasPercent && hasValue) {
                errors.append("Chỉ được chọn một loại giảm giá (phần trăm hoặc giá trị cố định). ");
            } else {
                // Validate discount percent
                if (hasPercent) {
                    try {
                        BigDecimal percent = new BigDecimal(discountPercentStr);
                        if (percent.compareTo(BigDecimal.ZERO) <= 0 || percent.compareTo(new BigDecimal("100")) > 0) {
                            errors.append("Phần trăm giảm phải từ 0.01% đến 100%. ");
                        }
                    } catch (NumberFormatException e) {
                        errors.append("Phần trăm giảm không hợp lệ. ");
                    }
                }
                
                // Validate discount value
                if (hasValue) {
                    try {
                        BigDecimal value = new BigDecimal(discountValueStr);
                        if (value.compareTo(BigDecimal.ZERO) <= 0) {
                            errors.append("Giá trị giảm phải lớn hơn 0. ");
                        } else if (value.compareTo(new BigDecimal("10000000")) > 0) {
                            errors.append("Giá trị giảm không được vượt quá 10,000,000 VNĐ. ");
                        }
                    } catch (NumberFormatException e) {
                        errors.append("Giá trị giảm không hợp lệ. ");
                    }
                }
            }
            
            // 3. Validate datetime fields
            Date startTime = null;
            Date endTime = null;
            
            String startTimeStr = req.getParameter("startTime");
            if (startTimeStr != null && !startTimeStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    startTime = fmt.parse(startTimeStr);
                    
                    // Check if start time is in the past (only for new promotions)
                    if (id == null && startTime.before(new Date())) {
                        errors.append("Thời gian bắt đầu không được trong quá khứ. ");
                    }
                } catch (Exception e) {
                    errors.append("Thời gian bắt đầu không hợp lệ. ");
                }
            }
            
            String endTimeStr = req.getParameter("endTime");
            if (endTimeStr != null && !endTimeStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    endTime = fmt.parse(endTimeStr);
                    
                    // Check if end time is in the past
                    if (endTime.before(new Date())) {
                        errors.append("Thời gian kết thúc không được trong quá khứ. ");
                    }
                } catch (Exception e) {
                    errors.append("Thời gian kết thúc không hợp lệ. ");
                }
            }
            
            // Check date logic
            if (startTime != null && endTime != null) {
                if (!endTime.after(startTime)) {
                    errors.append("Thời gian kết thúc phải sau thời gian bắt đầu. ");
                } else {
                    // Check minimum duration (1 hour)
                    long diffHours = (endTime.getTime() - startTime.getTime()) / (1000 * 60 * 60);
                    if (diffHours < 1) {
                        errors.append("Khuyến mãi phải kéo dài ít nhất 1 giờ. ");
                    }
                }
            }
            
            // 4. Validate target ID
            if (scopeType != null && !scopeType.equals("ALL")) {
                String targetIdStr = req.getParameter("targetId");
                if (targetIdStr == null || targetIdStr.trim().isEmpty()) {
                    String targetType = scopeType.equals("CATEGORY") ? "danh mục" : "món ăn";
                    errors.append("ID " + targetType + " là bắt buộc khi chọn phạm vi áp dụng. ");
                } else {
                    try {
                        Long targetId = Long.valueOf(targetIdStr);
                        if (targetId <= 0) {
                            errors.append("ID đối tượng phải là số nguyên dương. ");
                        }
                    } catch (NumberFormatException e) {
                        errors.append("ID đối tượng không hợp lệ. ");
                    }
                }
            }
            
            // 5. Validate numeric fields
            String maxUsageStr = req.getParameter("maxUsage");
            if (maxUsageStr != null && !maxUsageStr.trim().isEmpty()) {
                try {
                    int maxUsage = Integer.valueOf(maxUsageStr);
                    if (maxUsage <= 0) {
                        errors.append("Số lần sử dụng tối đa phải lớn hơn 0. ");
                    } else if (maxUsage > 999999) {
                        errors.append("Số lần sử dụng tối đa không được vượt quá 999,999. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Số lần sử dụng tối đa không hợp lệ. ");
                }
            }
            
            String orderMinimumStr = req.getParameter("orderMinimum");
            if (orderMinimumStr != null && !orderMinimumStr.trim().isEmpty()) {
                try {
                    BigDecimal orderMinimum = new BigDecimal(orderMinimumStr);
                    if (orderMinimum.compareTo(BigDecimal.ZERO) < 0) {
                        errors.append("Giá trị đơn hàng tối thiểu không được âm. ");
                    } else if (orderMinimum.compareTo(new BigDecimal("100000000")) > 0) {
                        errors.append("Giá trị đơn hàng tối thiểu không được vượt quá 100,000,000 VNĐ. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Giá trị đơn hàng tối thiểu không hợp lệ. ");
                }
            }
            
            // =============================================
            // CHECK VALIDATION RESULTS
            // =============================================
            
            if (errors.length() > 0) {
                redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + errors.toString().trim());
                if (id != null) {
                    return "redirect:/manager/promotions/edit/" + id;
                } else {
                    return "redirect:/manager/promotions/new";
                }
            }
            
            // =============================================
            // SAVE PROMOTION
            // =============================================
            
            // Lấy hoặc tạo mới Promotion
            Promotion p = (id != null) ? promotionService.findById(id) : new Promotion();
            
            // Gán các thuộc tính từ form
            p.setName(name.trim());
            p.setVoucherCode(voucherCode.trim().toUpperCase());
            p.setScopeType(scopeType);
            p.setStatus(status);
            
            // Set times
            p.setStartTime(startTime);
            p.setEndTime(endTime);
            
            // Set discount
            if (hasPercent) {
                p.setDiscountPercent(new BigDecimal(discountPercentStr));
                p.setDiscountValue(null);
                p.setIsPercent(true);
            } else {
                p.setDiscountValue(new BigDecimal(discountValueStr));
                p.setDiscountPercent(null);
                p.setIsPercent(false);
            }
            
            // Set optional fields
            if (maxUsageStr != null && !maxUsageStr.trim().isEmpty()) {
                p.setMaxUsage(Integer.valueOf(maxUsageStr));
            } else {
                p.setMaxUsage(null);
            }
            
            if (orderMinimumStr != null && !orderMinimumStr.trim().isEmpty()) {
                p.setOrderMinimum(new BigDecimal(orderMinimumStr));
            } else {
                p.setOrderMinimum(BigDecimal.ZERO);
            }
            
            // Set target ID
            if (scopeType != null && !scopeType.equals("ALL")) {
                String targetIdStr = req.getParameter("targetId");
                if (targetIdStr != null && !targetIdStr.trim().isEmpty()) {
                    p.setTargetId(Long.valueOf(targetIdStr));
                } else {
                    p.setTargetId(null);
                }
            } else {
                p.setTargetId(null);
            }
            
            // Lưu vào DB
            promotionService.save(p);
            
            String action = (id != null) ? "cập nhật" : "tạo mới";
            redirectAttributes.addFlashAttribute("success", "Đã " + action + " khuyến mãi '" + p.getName() + "' thành công!");
            
            return "redirect:/manager/promotions";
            
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi hệ thống xảy ra: " + e.getMessage());
            return "redirect:/manager/promotions";
        }
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
        // Date
        binder.registerCustomEditor(Date.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                try {
                    if (text == null || text.isEmpty()) {
                        setValue(null);
                    } else {
                        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                        setValue(fmt.parse(text));
                    }
                } catch (Exception e) {
                    setValue(null);
                }
            }
        });
        
        // BigDecimal
        binder.registerCustomEditor(BigDecimal.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) {
                try {
                    if (text == null || text.isEmpty()) {
                        setValue(null);
                    } else {
                        setValue(new BigDecimal(text));
                    }
                } catch (Exception e) {
                    setValue(null);
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
