package com.ecsimsw.module_a.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Table(name = "sample")
@Entity
public class SampleEntity {

    @Id
    private String deviceId;

    @Builder
    public SampleEntity(String deviceId) {
        this.deviceId = deviceId;
    }
}
