package com.restaurant.dto;

import com.restaurant.entity.Menu;
import com.restaurant.entity.Order;
import com.restaurant.entity.OrderDetail;

public class OrderDetailView {
    private OrderDetail orderDetail;
    private Menu menu;
    private Order order;

    public OrderDetailView() {
    }

    public OrderDetailView(OrderDetail orderDetail, Menu menu) {
        this.orderDetail = orderDetail;
        this.menu = menu;
    }

    public OrderDetailView(OrderDetail orderDetail, Menu menu, Order order) {
        this.orderDetail = orderDetail;
        this.menu = menu;
        this.order = order;
    }

    public OrderDetail getOrderDetail() {
        return orderDetail;
    }

    public void setOrderDetail(OrderDetail orderDetail) {
        this.orderDetail = orderDetail;
    }

    public Menu getMenu() {
        return menu;
    }

    public void setMenu(Menu menu) {
        this.menu = menu;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }
}
