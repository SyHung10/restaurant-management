# Nhà Hàng Hưng Tuấn 2 - Hệ Thống Quản Lý Nhà Hàng

## Mô tả
Hệ thống quản lý nhà hàng được phát triển bằng Java Spring MVC thuần (không sử dụng Spring Boot), sử dụng Eclipse Dynamic Web Project.

## Công nghệ sử dụng
- **Framework**: Spring MVC (phiên bản < 4.3)
- **ORM**: Hibernate 4.x
- **Database**: MySQL/MariaDB
- **View**: JSP (Server-side rendering)
- **IDE**: Eclipse Dynamic Web Project
- **Build**: Traditional WAR deployment

## Tính năng chính
- Quản lý menu món ăn
- Quản lý bàn ăn
- Quản lý đơn hàng
- Quản lý khách hàng
- Hệ thống khuyến mãi
- Báo cáo doanh thu

## Cấu trúc project
```
NHAHANG_HUNGTUAN2/
├── src/                    # Source code Java
├── WebContent/            # Web resources (JSP, CSS, JS)
├── .project              # Eclipse project file
├── .classpath           # Eclipse classpath
├── web.xml             # Web deployment descriptor
└── NHAHANG_DB_NEW3.sql # Database schema
```

## Cài đặt và chạy
1. Import project vào Eclipse IDE
2. Cấu hình database connection trong file hibernate configuration
3. Import file SQL `NHAHANG_DB_NEW3.sql` vào database
4. Deploy trên Tomcat server thông qua Eclipse
5. Truy cập ứng dụng qua browser

## Database
File `NHAHANG_DB_NEW3.sql` chứa schema và dữ liệu mẫu cho hệ thống.

## Lưu ý kỹ thuật
- Không sử dụng AJAX calls
- Không có @ResponseBody annotations
- Pure traditional web application
- Server-side rendering với JSP
- Standard form submissions
- Monolithic architecture

## Tài liệu
Thư mục chứa các file PDF hướng dẫn Spring MVC lessons từ 1-8.

## Tác giả
Hưng Tuấn 