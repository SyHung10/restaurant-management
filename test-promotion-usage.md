# Test Tính Năng Usage Tracking cho Voucher

## Tóm tắt tính năng đã triển khai

### 1. Backend Changes
- **PromotionDAO**: Thêm method `countUsageByPromotionId()` để đếm số lần sử dụng voucher từ bảng Payment
- **PromotionService**: Thêm method `countUsageByPromotionId()` và `isVoucherAvailable()` 
- **PromotionWithUsage DTO**: Class mới chứa thông tin promotion + usage count + availability
- **PromotionController**: Cập nhật `listPromotions()` để sử dụng DTO mới

### 2. Frontend Changes
- **promotion-list.jsp**: 
  - Hiển thị số lượt sử dụng (x/y lượt)
  - Progress bar màu sắc theo mức độ sử dụng
  - Badge cảnh báo "Sắp hết" (≥80%) và "Hết lượt" (≥100%)
  - Hiển thị số lượt còn lại
- **promotion-usage.css**: Styling cho progress bar và badges
- **promotion-usage.js**: JavaScript enhance UX với filter và search

### 3. Logic hoạt động
- **Voucher có giới hạn**: Hiển thị x/y lượt với progress bar
- **Voucher không giới hạn**: Hiển thị "Đã sử dụng: x lượt" với icon infinity
- **Màu sắc progress bar**:
  - Xanh lá: < 80%
  - Cam: 80-99%
  - Đỏ: ≥ 100%

## Cách test

### 1. Truy cập trang quản lý khuyến mãi
```
http://localhost:8081/NHAHANG_HUNGTUAN2/manager/promotions
```

### 2. Kiểm tra hiển thị
- [ ] Stats cards hiển thị đúng số lượng promotion
- [ ] Mỗi voucher hiển thị thông tin usage
- [ ] Progress bar có màu sắc phù hợp
- [ ] Badge trạng thái hiển thị đúng

### 3. Test với dữ liệu mẫu
Tạo voucher test với:
- maxUsage = 10
- Tạo vài payment sử dụng voucher này
- Kiểm tra số đếm có chính xác không

### 4. Test edge cases
- [ ] Voucher không có maxUsage (unlimited)
- [ ] Voucher đã hết lượt (usage >= maxUsage)
- [ ] Voucher sắp hết (usage >= 80% maxUsage)

## Database Query để test
```sql
-- Kiểm tra số lần sử dụng voucher
SELECT 
    p.name,
    p.voucherCode,
    p.maxUsage,
    COUNT(pay.paymentId) as usageCount
FROM Promotion p
LEFT JOIN Payment pay ON p.promotionId = pay.promotionId
WHERE p.type = 'VOUCHER'
GROUP BY p.promotionId, p.name, p.voucherCode, p.maxUsage;

-- Tạo dữ liệu test
INSERT INTO Payment (sessionId, totalAmount, promotionId, paymentMethod, paymentDate, status)
VALUES (1, 100000, 1, 'CASH', GETDATE(), 'COMPLETED');
```

## Kết quả mong đợi
1. Trang hiển thị đúng số lượt sử dụng cho mỗi voucher
2. Progress bar và badge cảnh báo hoạt động chính xác
3. Voucher hết lượt không thể sử dụng được nữa
4. UI responsive và đẹp mắt

## Lưu ý
- Lỗi linter trong JSP là do editor không hiểu JSP syntax, không ảnh hưởng chức năng
- Tính năng tuân thủ yêu cầu: không dùng AJAX, pure server-side rendering
- Sử dụng Spring MVC thuần, Hibernate 4.x như yêu cầu 