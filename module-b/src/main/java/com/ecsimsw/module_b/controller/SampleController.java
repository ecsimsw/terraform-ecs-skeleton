package com.ecsimsw.module_b.controller;

import com.ecsimsw.module_b.entity.SampleEntity;
import com.ecsimsw.module_b.service.SampleService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RequiredArgsConstructor
@RestController
public class SampleController {

    private final SampleService sampleService;
    private static final Logger LOGGER = LoggerFactory.getLogger(SampleController.class);

    @GetMapping("/up")
    ResponseEntity<String> isHealth() {
        LOGGER.info(LocalDateTime.now().toString());
        return ResponseEntity.ok(LocalDateTime.now().toString());
    }

    @PostMapping("/sample")
    ResponseEntity<String> save(String deviceId) {
        SampleEntity sample = sampleService.save(deviceId);
        return ResponseEntity.ok(sample.getDeviceId());
    }

    @GetMapping("/sample")
    ResponseEntity<String> read(String deviceId) {
        SampleEntity sample = sampleService.read(deviceId);
        return ResponseEntity.ok(sample.getDeviceId());
    }
}
