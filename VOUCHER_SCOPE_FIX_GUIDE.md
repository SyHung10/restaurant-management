# Hướng dẫn sửa lỗi Voucher Scope theo Danh mục và Món ăn

## 🚨 Các vấn đề đã phát hiện và sửa

### Vấn đề 1: Logic voucher scope không hoạt động
**Lỗi:** PaymentController không kiểm tra `scope_type` của voucher
- Voucher `scope_type = 'CATEGORY'` áp dụng sai cho tất cả món
- Voucher `scope_type = 'DISH'` áp dụng sai cho tất cả món  

### Vấn đề 2: Order minimum logic sai ❗ **MỚI PHÁT HIỆN**
**Lỗi:** Kiểm tra `order_minimum` dựa trên `applicableAmount` thay vì `totalSessionAmount`
- Voucher `NUONG10` (min 50K cho thịt bò)
- Đơn: Salad 90K + Bò 40K = 130K total
- Logic cũ: Kiểm tra 40K < 50K → Fail ❌
- **Logic đúng:** Phải kiểm tra 130K ≥ 50K → Pass ✅

## 🔧 Giải pháp đã thực hiện

### 1. Thêm method mới trong PromotionService:
```java
public BigDecimal calculateVoucherDiscountByScope(Promotion promotion, List<OrderDetail> orderDetails)
```

**Chức năng:**
- ✅ **BƯỚC 1:** Tính `totalSessionAmount` (tổng cả session) 
- ✅ **BƯỚC 2:** Kiểm tra `order_minimum` dựa trên `totalSessionAmount`
- ✅ **BƯỚC 3:** Tính `applicableAmount` (chỉ món áp dụng voucher)
- ✅ **BƯỚC 4:** Tính discount dựa trên `applicableAmount`
- ✅ Kiểm tra `scope_type` (ALL/CATEGORY/DISH)
- ✅ Bỏ qua món tặng và món đã hủy

### 2. Logic mới trong calculateVoucherDiscountByScope:

```java
// BƯỚC 1: Tính tổng tiền CẢ SESSION (để kiểm tra order_minimum)
BigDecimal totalSessionAmount = BigDecimal.ZERO;
for (OrderDetail detail : orderDetails) {
    if (!isGiftOrCancelled(detail)) {
        totalSessionAmount += detail.getPrice() * detail.getQuantity();
    }
}

// BƯỚC 2: Kiểm tra order_minimum dựa trên TỔNG SESSION
if (totalSessionAmount.compareTo(promotion.getOrderMinimum()) < 0) {
    return BigDecimal.ZERO; // Không đủ điều kiện
}

// BƯỚC 3: Tính applicableAmount (chỉ món áp dụng voucher)
BigDecimal applicableAmount = BigDecimal.ZERO;
for (OrderDetail detail : orderDetails) {
    if (isApplicableForVoucher(detail, promotion)) {
        applicableAmount += detail.getPrice() * detail.getQuantity();
    }
}

// BƯỚC 4: Tính discount trên applicableAmount
if (promotion.isPercentageDiscount()) {
    discount = applicableAmount * promotion.getDiscountPercent() / 100;
} else {
    discount = promotion.getDiscountValue();
}
```

### 3. Sửa PaymentController:
**Trước:**
```java
voucherDiscount = promotionService.calculateDiscount(promo, total);
```

**Sau:**
```java  
voucherDiscount = promotionService.calculateVoucherDiscountByScope(promo, allDetails);
```

### 4. Inject MenuService để check category:
```java
@Autowired
private MenuService menuService;

private boolean checkCategoryScope(Long dishId, Long targetCategoryId) {
    Menu dish = menuService.findById(dishId);
    return dish != null && dish.getCategory() != null && 
           dish.getCategory().getCategoryId().equals(targetCategoryId);
}
```

## 🧪 Data test đã thêm

Trong `NHAHANG_DB_NEW4.sql` đã thêm 4 voucher test:

```sql
-- 1. KHAIVI15: Giảm 15% cho danh mục "Khai vị" (category_id = 1) - Không tối thiểu
INSERT [Promotion] VALUES (9, 'Giảm 15% cho danh mục Khai vị', NULL, NULL, 15.00, 'KHAIVI15', NULL, 1, 100, 'ACTIVE', 0.00, 'CATEGORY', 1)

-- 2. SALAD20K: Giảm 20K cho món "Salad Cá hồi" (dish_id = 1) - Không tối thiểu  
INSERT [Promotion] VALUES (10, 'Giảm 20K cho Salad Cá hồi', NULL, NULL, NULL, 'SALAD20K', 20000.00, 0, 50, 'ACTIVE', 0.00, 'DISH', 1)

-- 3. NUONG10: Giảm 10% cho danh mục "Thịt bò" (category_id = 2) - Tối thiểu 50K
INSERT [Promotion] VALUES (11, 'Giảm 10% cho đồ nướng', NULL, NULL, 10.00, 'NUONG10', NULL, 1, 200, 'ACTIVE', 50000.00, 'CATEGORY', 2)

-- 4. VIP25: Giảm 25% tất cả món - Tối thiểu 500K (edge case)
INSERT [Promotion] VALUES (12, 'Giảm 25% đơn hàng VIP', NULL, NULL, 25.00, 'VIP25', NULL, 1, 10, 'ACTIVE', 500000.00, 'ALL', NULL)
```

## 📊 Test scenarios

### Test Case 1: NUONG10 - Đủ điều kiện tối thiểu
```
Voucher: NUONG10 (10% cho thịt bò, tối thiểu 50K)
Đơn hàng:
- Salad Cá hồi: 90,000đ (category_id=1) 
- Bò nướng: 60,000đ (category_id=2)
Tổng: 150,000đ

Logic mới:
- totalSessionAmount = 150,000đ ≥ 50,000đ ✅ Đủ điều kiện  
- applicableAmount = 60,000đ (chỉ bò nướng)
- discount = 60,000 * 10% = 6,000đ ✅

Logic cũ (sai):
- applicableAmount = 60,000đ ≥ 50,000đ ✅ Cũng pass nhưng logic sai
```

### Test Case 2: NUONG10 - Không đủ điều kiện tối thiểu  
```
Voucher: NUONG10 (10% cho thịt bò, tối thiểu 50K)
Đơn hàng:
- Salad Cá hồi: 30,000đ (category_id=1)
- Bò nướng: 15,000đ (category_id=2)  
Tổng: 45,000đ

Logic mới:
- totalSessionAmount = 45,000đ < 50,000đ ❌ Không đủ điều kiện
- discount = 0đ
- Thông báo: "Chưa đủ điều kiện tối thiểu 50,000đ"

Logic cũ (sai):
- applicableAmount = 15,000đ < 50,000đ ❌ Cũng fail nhưng lý do sai
```

### Test Case 3: Edge case quan trọng ❗
```
Voucher: NUONG10 (10% cho thịt bò, tối thiểu 50K)
Đơn hàng:
- Salad Cá hồi: 90,000đ (category_id=1)
- Bò nướng: 40,000đ (category_id=2)
Tổng: 130,000đ

Logic mới:
- totalSessionAmount = 130,000đ ≥ 50,000đ ✅ Đủ điều kiện
- applicableAmount = 40,000đ (chỉ bò nướng)  
- discount = 40,000 * 10% = 4,000đ ✅

Logic cũ (sai):
- applicableAmount = 40,000đ < 50,000đ ❌ Fail sai
- Customer bị từ chối voucher dù đã mua đủ 130K!
```

## ⚠️ Lưu ý quan trọng

### Nguyên tắc business logic:
- ✅ **order_minimum** LUÔN dựa trên tổng tiền cả session
- ✅ **discount** chỉ áp dụng cho món thuộc scope  
- ✅ **discount amount** không vượt quá giá trị món áp dụng
- ✅ Bỏ qua món tặng (`is_gift = true`) và món đã hủy (`status = 'CANCELLED'`)

### Tuân thủ yêu cầu:
- ✅ **KHÔNG** sử dụng AJAX calls
- ✅ **KHÔNG** có @ResponseBody  
- ✅ Pure traditional web app với JSP
- ✅ Form submissions standard
- ✅ Server-side rendering hoàn toàn

### Files đã chỉnh sửa:
- `src/main/java/com/restaurant/service/PromotionService.java`
- `src/main/java/com/restaurant/controller/PaymentController.java`
- `NHAHANG_DB_NEW4.sql`

## 🔄 Cách áp dụng

1. **Chạy lại database script:** 
   ```sql
   -- Chạy NHAHANG_DB_NEW4.sql để có voucher test
   ```

2. **Build và deploy project lại**

3. **Test theo scenarios đã định:**
   - Test case edge case: Salad 90K + Bò 40K với voucher NUONG10
   - Kiểm tra thông báo lỗi khi không đủ điều kiện
   - Test voucher dish specific và category

## ✅ Kết quả mong đợi

Sau khi fix:
- ✅ Voucher `scope_type = 'ALL'` → Áp dụng cho tất cả món
- ✅ Voucher `scope_type = 'CATEGORY'` → Chỉ áp dụng cho món thuộc category đó
- ✅ Voucher `scope_type = 'DISH'` → Chỉ áp dụng cho món cụ thể đó
- ✅ **order_minimum** kiểm tra đúng theo tổng session 
- ✅ Thông báo lỗi rõ ràng khi voucher không áp dụng được
- ✅ Customer không bị từ chối voucher một cách sai lệch 