-- ===============================================
-- SCRIPT SETUP DỮ LIỆU MẪU CHO BẢNG PROMOTION
-- Phiên bản database mới - 2025
-- ===============================================

USE [NHAHANG_DB]
GO

-- Xóa dữ liệu cũ nếu có
DELETE FROM [dbo].[Payment] WHERE promotion_id IS NOT NULL;
DELETE FROM [dbo].[ServiceSession] WHERE promotion_id IS NOT NULL;
DELETE FROM [dbo].[Promotion];
GO

-- Reset identity
DBCC CHECKIDENT ('Promotion', RESEED, 0);
GO

-- ===============================================
-- INSERT DỮ LIỆU MẪU CHO PROMOTION
-- ===============================================

-- 1. Promotion giảm 20% toàn bộ - Happy Hour
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Happy Hour - Giảm 20%', 
    '2025-01-01 17:00:00', 
    '2025-12-31 19:00:00',
    20.00, 
    N'HAPPY20', 
    NULL, 
    1, 
    1000, 
    N'ACTIVE', 
    50000.00, 
    N'ALL', 
    NULL
);

-- 2. Promotion giảm 50,000đ cho đơn từ 200k
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Giảm 50K cho đơn từ 200K', 
    NULL, 
    NULL,
    NULL, 
    N'SAVE50K', 
    50000.00, 
    0, 
    500, 
    N'ACTIVE', 
    200000.00, 
    N'ALL', 
    NULL
);

-- 3. Promotion giảm 15% cho danh mục cơm (giả sử category_id = 1)
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Giảm 15% cho các món cơm', 
    '2025-01-01 00:00:00', 
    '2025-06-30 23:59:59',
    15.00, 
    N'RICE15', 
    NULL, 
    1, 
    300, 
    N'ACTIVE', 
    0.00, 
    N'CATEGORY', 
    1
);

-- 4. Promotion giảm 30,000đ cho món phở (giả sử dish_id = 1)
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Giảm 30K cho món Phở đặc biệt', 
    NULL, 
    NULL,
    NULL, 
    N'PHO30K', 
    30000.00, 
    0, 
    100, 
    N'ACTIVE', 
    0.00, 
    N'DISH', 
    1
);

-- 5. Promotion cuối tuần - giảm 25%
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Khuyến mãi cuối tuần', 
    '2025-01-01 00:00:00', 
    '2025-12-31 23:59:59',
    25.00, 
    N'WEEKEND25', 
    NULL, 
    1, 
    200, 
    N'ACTIVE', 
    150000.00, 
    N'ALL', 
    NULL
);

-- 6. Promotion cho nhóm bạn - giảm 100,000đ
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Ưu đãi nhóm bạn', 
    NULL, 
    NULL,
    NULL, 
    N'GROUP100', 
    100000.00, 
    0, 
    50, 
    N'ACTIVE', 
    500000.00, 
    N'ALL', 
    NULL
);

-- 7. Promotion giảm 10% cho danh mục đồ uống (giả sử category_id = 2)
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Giảm 10% tất cả đồ uống', 
    '2025-01-01 00:00:00', 
    '2025-03-31 23:59:59',
    10.00, 
    N'DRINK10', 
    NULL, 
    1, 
    500, 
    N'ACTIVE', 
    0.00, 
    N'CATEGORY', 
    2
);

-- 8. Promotion đặc biệt - giảm 35%
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Khuyến mãi đặc biệt', 
    '2025-02-01 00:00:00', 
    '2025-02-14 23:59:59',
    35.00, 
    N'SPECIAL35', 
    NULL, 
    1, 
    100, 
    N'ACTIVE', 
    300000.00, 
    N'ALL', 
    NULL
);

-- 9. Promotion không hoạt động (để test)
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Promotion đã hết hạn', 
    '2024-12-01 00:00:00', 
    '2024-12-31 23:59:59',
    20.00, 
    N'EXPIRED20', 
    NULL, 
    1, 
    100, 
    N'INACTIVE', 
    0.00, 
    N'ALL', 
    NULL
);

-- 10. Promotion cho món ăn cao cấp (giả sử dish_id = 5)
INSERT INTO [dbo].[Promotion] (
    [name], [start_time], [end_time], [discount_percent], [voucher_code], 
    [discount_value], [is_percent], [max_usage], [status], 
    [order_minimum], [scope_type], [target_id]
) VALUES (
    N'Giảm giá món đặc sản', 
    NULL, 
    NULL,
    NULL, 
    N'PREMIUM50', 
    50000.00, 
    0, 
    50, 
    N'ACTIVE', 
    0.00, 
    N'DISH', 
    5
);

GO

-- ===============================================
-- KIỂM TRA DỮ LIỆU ĐƯỢC INSERT
-- ===============================================

PRINT 'Đã insert thành công ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' bản ghi vào bảng Promotion'

SELECT 
    promotion_id,
    name,
    CASE 
        WHEN discount_percent IS NOT NULL THEN CAST(discount_percent AS NVARCHAR(10)) + '%'
        ELSE FORMAT(discount_value, 'N0') + 'đ'
    END AS discount_display,
    voucher_code,
    scope_type,
    target_id,
    FORMAT(order_minimum, 'N0') + 'đ' AS min_order,
    status,
    CASE 
        WHEN start_time IS NOT NULL THEN FORMAT(start_time, 'dd/MM/yyyy HH:mm')
        ELSE 'Không giới hạn'
    END AS start_display,
    CASE 
        WHEN end_time IS NOT NULL THEN FORMAT(end_time, 'dd/MM/yyyy HH:mm')
        ELSE 'Không giới hạn'
    END AS end_display
FROM [dbo].[Promotion]
ORDER BY promotion_id;

PRINT '==============================================='
PRINT 'HOÀN TẤT SETUP DỮ LIỆU MẪU CHO PROMOTION'
PRINT '===============================================' 