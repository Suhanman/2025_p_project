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
(본 Repo는 프로젝트 종료 후 정리를 위한 Repo로 ReadMe의 끝부분에 실제 프로젝트 협업에 사용한 Repo 링크를 기술함)
</p>

<p align="center">
  <a href="#-프로젝트-개요">프로젝트 개요</a> ·
  <a href="#-문제-정의--선정-배경">선정 배경</a> ·
  <a href="#-핵심-기능">인프라 설계</a> ·
  <a href="#-시스템-아키텍처">AWS 클라우드 아키텍처</a> ·
  <a href="#-기술-스택">K8s 클러스터 아키텍쳐</a> ·
  <a href="#-시작하기">모니터링</a> ·
  <a href="#-ci--cd--운영">CI/CD</a> ·
  <a href="#-팀-구성--역할">기술 스택</a>
</p>



---

## 1) 프로젝트 개요

- **프로젝트명:** 2025년 p실무 6팀 _스터디링커_
- **목표:** 지역/관심사 기반 스터디 탐색 및 모집 과정의 비효율을 줄이고, 신뢰할 수 있는 스터디 참여 경험 제공
- **기간:**  2025.12.02~ 2025.12.22
- **팀원:**  전민지(팀장) , 박수한, 박지수, 김한수, 이호주
- **본인 담당:**  인프라 서버 개발 및 배포, CI/CD 구축, 컨테이너 오케스트레이션. Iac, 모니터링. Redis 구축


---

## 2) 문제 정의 / 선정 배경



1. **지역 선호도에 따른 매칭의 어려움**  
2. **정보 부족으로 인한 기회 상실**  
3. **스터디원 모집 및 신뢰성 문제**

> #### 스터디 매칭에 필요한 다양한 기능을 안정적으로 운영하기 위한 MSA 도입 및 위치 기반과 사용자 맞춤 기능을 갖춘 로컬 스터디 매칭서비스 도입




---

## 3) 인프라 설계

> ### Cloud Native 방식을 준수한 인프라 설계

- **MSA 기반 모듈 아키텍쳐**
  - 서비스 안정성과 확장성을 위한 MSA 구조
- **DevOPs/Iac**
  - Terraform을 통한 Iac 및 실시간 모니터링
- **컨테이너 및 오케스트레이션**
  - 컨테이너화 및 Kubernetes를 통한 동적 오케스트레이션
- **CI/CD**
  - GithubActions + ArgoCD 자동화 파이프라인 구축






---

## 4) AWS 클라우드 아키텍처

<p align="center">
  <img src="https://github.com/user-attachments/assets/22e8301d-2a60-4014-a539-77c0a18c1762" width="900" alt="Background 1"/>
</p>


- **웹/앱/DB의 분리 및 서브넷 분리를 통한 3-tier 아키텍쳐 준수**

- **AWS의 7계층 로드밸런서인 ALB를 통한 안정적 라우팅 및 트래픽 분산**

- **Bastion Host 기반의 접속 통제와 Security Group 정책으로 최소 권한 원칙을 적용해 기본 보안 수준을 확보**





---

## 5) k8s 클러스터 아키텍쳐

<p align="center">
  <img src="https://github.com/user-attachments/assets/e8c8ea64-d5b5-4ffa-b6ef-628dc0af9185" width="900" alt="Background 2"/>
</p>

- **Kubernetes 클러스터 구축을 통한 안정적인 MSA 환경의 서비스의 컨테이너 오케스트레이션**
  
- **명확한 NameSpace 분리 및 인프라의 문서화를 통한 운영표준화 구현**
  
- **pv/pvc 및 HPA 를 통한 고가용성 및 안정적인 대규모 트래픽 처리**



---

## 6) Prometheus + grafana 모니터링 구축

<p align="center">
  <img src="https://github.com/user-attachments/assets/2fcd1e55-a2f8-40f3-bfba-9b37c7a301cf" width="900" alt="Feature Overview"/>
</p>



<img width="1028" height="515" alt="image" src="https://github.com/user-attachments/assets/3787d760-16ac-4124-92ae-dac2b6840e76" />


### 성능 지표 

| 지표 | 목표 기준 | 수집 방법 | 달성 여부 |
|---|---|---|---|
| 응답시간(p95) | 1초 이하 | Prometheus | O |
| CPU 사용률 | 80% 이하 | Node Exporter | O |
| Memory 사용률 | 80% 이하 | cAdvisor | O |
| Disk 사용률 | 70% 이하 | Node Exporter | O |
| Pod 상태 | 100% Running | kube-state-metrics | O |
| Pod 재시작 횟수 | 0~1회 | kube-state-metrics | O |




## 7) CI/CD 

<p align="center">
  <img src="https://github.com/user-attachments/assets/e73fdc08-791e-4cbc-8240-392682f3ac6f" width="900" alt="Architecture"/>
</p>



<img width="1028" height="547" alt="image" src="https://github.com/user-attachments/assets/0c1d2fa6-99aa-4ce9-9080-cb3c23e8597f" />

### Github Actions을 통한 CI + ArgoCD를 통한 CD의 구축

Frontend / Backend / Infra Manifest 나뉘어진 3개의 Repo를 CI/CD를 통한 지속적 통합 및 배포 구현

### App of Apps 패턴 구현

helm chart를 이용해 Root-app 아래에 Application이 매달린 형태인 app of apps 패턴으로 

ArgoCD의 CI/CD를 구축함으로 일관화된 방식으로 배포/관리


## 8) 기술 스택

Front : React, Node.js, HTML, Css, React Router, Axios / Fetch API

Backend : JAVA, Spring Boot, Spring Data JPA, MySql, Lombok, Redis

Infra : AWS, Docker, k8s, Helm, Terraform, Git, Argocd, Prometheus, Grafana

(협업 레포)

[프로젝트 Manifest CI/CD Repo](https://github.com/Suhanman/studylinker_manifest.git)

[프로젝트 Backend CI/CD Repo](https://github.com/studylinker/backend-msa.git)

[프로젝트 Frontend CI/CD Repo](https://github.com/studylinker/frontend.git)

