package com.study.stats.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 카테고리 비율 통계 조회용 레포지토리
 * - Study_groups 테이블의 category 컬럼 기준으로 그룹화
 */
@Repository
public class MemberRatioRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @SuppressWarnings("unchecked")
    public List<Object[]> getCategoryRatio() {
        String sql = "SELECT category, COUNT(*) FROM Study_groups GROUP BY category";
        return entityManager.createNativeQuery(sql).getResultList();
    }
}