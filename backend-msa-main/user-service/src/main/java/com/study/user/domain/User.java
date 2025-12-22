package com.study.user.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import jakarta.persistence.FetchType;

@Entity
@Table(name = "Users")
public class User {

    // ============================
    // 기본 정보
    // ============================
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Role role;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private UserStatus status;

    // ============================
    // 관심사 태그 (User_interest_tags 테이블 매핑)
    // ============================
    @ElementCollection
    @CollectionTable(
            name = "User_interest_tags",
            joinColumns = @JoinColumn(name = "user_id")
    )
    @Column(name = "tag")
    @JsonIgnore   // 🔥 JSON 응답에서 제외 (DTO에서 필요하면 따로 넣기)
    private List<String> interestTags = new ArrayList<>();

    // ============================
    // 위치
    // ============================
    private Double latitude;
    private Double longitude;

    // ============================
    // 매너 점수 관련 필드
    // ============================
    @Column(name = "attendance_score")
    private Float attendanceScore = 0f;

    @Column(name = "leader_score")
    private Float leaderScore = 0f;

    @Column(name = "violation_score")
    private Float violationScore = 0f;

    @Column(name = "current_manner_score")
    private Float currentMannerScore = 60f;

    // ============================
    // 생성 / 수정 시각
    // ============================
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = this.createdAt;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // ============================
    // 매너 점수 비즈니스 로직
    // ============================
    public void addAttendanceScore(float amount) {
        if (attendanceScore == null) attendanceScore = 0f;
        attendanceScore += amount;
        recalcMannerScore();
    }

    public void addLeaderScore(float amount) {
        if (leaderScore == null) leaderScore = 0f;
        leaderScore += amount;
        recalcMannerScore();
    }

    public void addViolationScore(float amount) {
        if (violationScore == null) violationScore = 0f;
        violationScore += amount;
        recalcMannerScore();
    }

    private void recalcMannerScore() {
        if (attendanceScore == null) attendanceScore = 0f;
        if (leaderScore == null) leaderScore = 0f;
        if (violationScore == null) violationScore = 0f;

        float score = 60
                + attendanceScore
                + leaderScore
                - violationScore;

        score = Math.max(0, Math.min(100, score));
        currentMannerScore = score;
    }

    // ============================
    // Getter / Setter
    // ============================
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public UserStatus getStatus() { return status; }
    public void setStatus(UserStatus status) { this.status = status; }

    public List<String> getInterestTags() { return interestTags; }
    public void setInterestTags(List<String> interestTags) { this.interestTags = interestTags; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public Float getAttendanceScore() { return attendanceScore; }
    public Float getLeaderScore() { return leaderScore; }
    public Float getViolationScore() { return violationScore; }
    public Float getCurrentMannerScore() { return currentMannerScore; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
}