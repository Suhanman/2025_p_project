<!-- =========================================================
  2025_p_project | StudyLinker (스터디링커)
  README Template v1
========================================================== -->

<p align="center">
  <img src="https://github.com/user-attachments/assets/730e2818-d50c-431b-9c3c-82a2307fb2c4" width="900" alt="StudyLinker Banner"/>
</p>

<h1 align="center">스터디링커 (StudyLinker)</h1>

<p align="center">
  지역·관심사 기반으로 스터디를 더 쉽게 찾고, 더 빠르게 모집하는 스터디 매칭/모집 플랫폼
</p>

<p align="center">
  <!-- 필요 시 배지 추가 -->
  <!-- 예: 빌드/배포/라이선스/버전 -->
  <!-- ![CI](https://img.shields.io/badge/CI-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white) -->
  <!-- ![K8s](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white) -->
  <!-- ![Terraform](https://img.shields.io/badge/Terraform-844FBA?logo=terraform&logoColor=white) -->
</p>

<p align="center">
  <a href="#-프로젝트-개요">프로젝트 개요</a> ·
  <a href="#-문제-정의--선정-배경">선정 배경</a> ·
  <a href="#-핵심-기능">핵심 기능</a> ·
  <a href="#-시스템-아키텍처">아키텍처</a> ·
  <a href="#-기술-스택">기술 스택</a> ·
  <a href="#-시작하기">시작하기</a> ·
  <a href="#-ci--cd--운영">CI/CD</a> ·
  <a href="#-팀-구성--역할">팀</a>
</p>

---

## 1) 프로젝트 개요

- **프로젝트명:** 2025년 p실무 6팀 _스터디링커_
- **목표:** 지역/관심사 기반 스터디 탐색 및 모집 과정의 비효율을 줄이고, 신뢰할 수 있는 스터디 참여 경험 제공
- **기간:** `TODO (예: 2025.XX ~ 2025.XX)`
- **데모/배포 URL:** `TODO`
- **API 문서(Swagger 등):** `TODO`
- **발표자료/시연영상:** `TODO`

---

## 2) 문제 정의 / 선정 배경

스터디를 “찾고 들어가는 과정”에서 아래 문제가 반복적으로 발생했다.

1. **지역 선호도에 따른 매칭의 어려움**  
2. **정보 부족으로 인한 기회 상실**  
3. **스터디원 모집 및 신뢰성 문제**

> 해결 방향: 지역/관심사 기반 추천 + 모집/관리 플로우 단순화 + 신뢰성 강화를 위한 운영/모니터링 기반 마련

<p align="center">
  <img src="https://github.com/user-attachments/assets/22e8301d-2a60-4014-a539-77c0a18c1762" width="900" alt="Background 1"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e8c8ea64-d5b5-4ffa-b6ef-628dc0af9185" width="900" alt="Background 2"/>
</p>

---

## 3) 핵심 기능

> 아래 항목은 “README에서 보는 사람이 10초 안에 이해”하도록 요약 문장 중심으로 구성

- **스터디 탐색/검색**
  - 지역, 카테고리, 태그 기반 탐색
- **추천(매칭)**
  - 거리 + 관심 태그 유사도 기반 추천 점수 산정
- **스터디 모집/관리**
  - 스터디 개설, 모집 상태 관리, 참여 신청/승인 플로우
- **신뢰성/운영**
  - 캐싱(Redis) 및 모니터링 기반으로 안정적인 운영 고려

<p align="center">
  <img src="https://github.com/user-attachments/assets/2fcd1e55-a2f8-40f3-bfba-9b37c7a301cf" width="900" alt="Feature Overview"/>
</p>

---

## 4) 추천 알고리즘 (요약)

- **거리 점수:** `거리점수 = 1 / (1 + 거리(km))`  
- **태그 유사도:** 사용자 관심태그와 스터디 카테고리/태그 간 **Jaccard Similarity**
- **최종 추천점수:** `추천점수 = (거리점수 × α) + (태그유사도 × β)`  
  - α, β는 운영/관리자가 조정 가능한 가중치

> 실제 운영에서는 거리 편향/태그 편향을 조절할 수 있도록 가중치를 분리했다.

---

## 5) 시스템 아키텍처

<p align="center">
  <img src="https://github.com/user-attachments/assets/e73fdc08-791e-4cbc-8240-392682f3ac6f" width="900" alt="Architecture"/>
</p>

### 인프라/운영 포인트(요약)
- **컨테이너 오케스트레이션:** Kubernetes 기반 배포/확장
- **CI/CD:** GitHub Actions 기반 자동 빌드·배포 파이프라인
- **캐싱/세션/성능:** Redis 적용 (예: 세션/캐시/빈번 조회 최적화)
- **모니터링:** 지표/대시보드 구성으로 장애 탐지 및 운영 가시성 확보

<p align="center">
  <img src="https://github.com/user-attachments/assets/5613013f-d491-432c-9c03-8ca7c5d0bc54" width="900" alt="Infra Detail"/>
</p>

---

## 6) 기술 스택

> 실제 사용 스택에 맞춰 수정/추가

### Backend
- `TODO (예: Spring Boot / Node.js / FastAPI 등)`
- `TODO (예: JPA / MyBatis / Prisma 등)`

### Database / Cache
- `TODO (예: MySQL / PostgreSQL)`
- **Redis** (캐시/세션/빈번 조회 최적화)

### DevOps / Infra
- **Kubernetes**
- **IaC:** `TODO (예: Terraform)`
- **CI/CD:** GitHub Actions
- **Container:** Docker

### Observability
- `TODO (예: Prometheus / Grafana / Loki / ELK 등)`

---

## 7) 시작하기

아래는 “로컬 실행”과 “Kubernetes 실행” 템플릿이다. 실제 프로젝트 명령어에 맞게 정리하면 완성도가 크게 올라간다.

### 7.1 로컬 실행 (예: Docker Compose)
```bash
# TODO: 예시
# git clone ...
# cp .env.example .env
# docker compose up -d
