package com.ecsimsw.module_b.domain;

import com.ecsimsw.module_b.entity.SampleEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SampleRepository extends JpaRepository<SampleEntity, String> {
}
