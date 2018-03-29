package com.snc.util;

import java.util.List;

public class Page<T> {

    private int page; // 当前页码

    private int total; // 页码总数

    private int records; // 数据行总数

    private List<T> rows; // 模型数据

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getRecords() {
        return records;
    }

    public void setRecords(int records) {
        this.records = records;
    }

    public List<T> getRows() {
        return rows;
    }

    public void setRows(List<T> rows) {
        this.rows = rows;
    }
}
