package com.ecsimsw.module_a.domain;

import com.ecsimsw.module_a.entity.SampleEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SampleRepository extends JpaRepository<SampleEntity, String> {
}
