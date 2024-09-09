package com.ecsimsw.module_a.service;

import com.ecsimsw.module_a.domain.SampleRepository;
import com.ecsimsw.module_a.entity.SampleEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class SampleService {

    private final SampleRepository sampleRepository;

    @Transactional
    public SampleEntity save(String deviceId) {
        return sampleRepository.save(new SampleEntity(deviceId));
    }

    @Transactional(readOnly = true)
    public SampleEntity read(String deviceId) {
        return sampleRepository.findById(deviceId).orElseThrow();
    }
}
