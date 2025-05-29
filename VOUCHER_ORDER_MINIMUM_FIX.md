# Hướng dẫn sửa lỗi Order Minimum trong Voucher Scope

## 🚨 Vấn đề đã phát hiện

### Lỗi logic hiện tại:
```java
// SAI: Kiểm tra order_minimum dựa trên applicableAmount (chỉ món áp dụng voucher)
if (applicableAmount.compareTo(promotion.getOrderMinimum()) < 0) {
    return BigDecimal.ZERO;
}
```

### Vấn đề gây ra:
- Voucher `NUONG10` có `order_minimum = 50,000đ` cho category "Thịt bò" 
- Khách đặt: Salad 90K + Bò nướng 40K (tổng 130K)
- Logic cũ: Chỉ kiểm tra 40K (bò nướng) < 50K → Báo lỗi ❌
- **Logic đúng:** Phải kiểm tra 130K (tổng session) ≥ 50K → OK ✅

## 🔧 Giải pháp đã thực hiện

### Logic mới trong `calculateVoucherDiscountByScope`:

```java
// BƯỚC 1: Tính tổng tiền CẢ SESSION (để kiểm tra order_minimum)
BigDecimal totalSessionAmount = BigDecimal.ZERO;
for (OrderDetail detail : orderDetails) {
    // Bỏ qua món tặng và đã hủy
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

## 🧪 Test Cases

### Test Case 1: Voucher category với đủ điều kiện
```
Voucher: NUONG10 (10% cho thịt bò, tối thiểu 50K)
Đơn hàng:
- Salad Cá hồi: 90,000đ (category_id=1) 
- Bò nướng: 60,000đ (category_id=2)
Tổng: 150,000đ

Kết quả:
- totalSessionAmount = 150,000đ ≥ 50,000đ ✅ Đủ điều kiện  
- applicableAmount = 60,000đ (chỉ bò nướng)
- discount = 60,000 * 10% = 6,000đ ✅
```

### Test Case 2: Voucher category với không đủ điều kiện
```
Voucher: NUONG10 (10% cho thịt bò, tối thiểu 50K)
Đơn hàng:
- Salad Cá hồi: 30,000đ (category_id=1)
- Bò nướng: 15,000đ (category_id=2)  
Tổng: 45,000đ

Kết quả:
- totalSessionAmount = 45,000đ < 50,000đ ❌ Không đủ điều kiện
- discount = 0đ
- Thông báo: "Chưa đủ điều kiện tối thiểu 50,000đ"
```

### Test Case 3: Voucher dish specific
```
Voucher: SALAD20K (giảm 20K cho Salad Cá hồi, không có tối thiểu)
Đơn hàng:
- Salad Cá hồi: 90,000đ (dish_id=1)
- Bò nướng: 60,000đ (dish_id=6)
Tổng: 150,000đ

Kết quả:
- totalSessionAmount = 150,000đ ≥ 0đ ✅ Đủ điều kiện
- applicableAmount = 90,000đ (chỉ salad)  
- discount = min(20,000đ, 90,000đ) = 20,000đ ✅
```

## 📊 So sánh Logic

| Trường hợp | Logic CŨ (Sai) | Logic MỚI (Đúng) |
|------------|------------------|-------------------|
| **Order minimum check** | Dựa trên `applicableAmount` | Dựa trên `totalSessionAmount` |
| **Discount calculation** | Dựa trên `applicableAmount` | Dựa trên `applicableAmount` |
| **Ví dụ:** Salad 90K + Bò 40K<br/>Voucher NUONG10 (min 50K) | 40K < 50K → Fail ❌ | 130K ≥ 50K → Pass ✅<br/>Discount = 40K * 10% = 4K |

## ⚠️ Lưu ý quan trọng

### Các nguyên tắc không thay đổi:
- ✅ **order_minimum** luôn dựa trên tổng tiền cả session
- ✅ **discount** chỉ áp dụng cho món thuộc scope  
- ✅ **discount amount** không vượt quá giá trị món áp dụng
- ✅ Bỏ qua món tặng (`is_gift = true`) và món đã hủy (`status = 'CANCELLED'`)

### Tuân thủ yêu cầu:
- ✅ Không sử dụng AJAX
- ✅ Form submission thuần túy
- ✅ Server-side rendering với JSP
- ✅ Không vi phạm kiến trúc monolithic

## 🔄 Files đã sửa

- `src/main/java/com/restaurant/service/PromotionService.java`
  - Method `calculateVoucherDiscountByScope()` 
  - Sửa logic kiểm tra `order_minimum`

## ✅ Kết quả mong đợi

Sau khi sửa, voucher sẽ hoạt động đúng theo business logic:
1. **Kiểm tra điều kiện** dựa trên tổng đơn hàng
2. **Tính discount** chỉ cho món thuộc scope
3. **Thông báo rõ ràng** khi không đủ điều kiện
4. **Không crash** khi có món tặng hoặc món hủy 