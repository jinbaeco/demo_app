package com.example.demo.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import  org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
	
	@RequestMapping("/")
	public String index() {
		
		return "Hello World argocd 2024-04-02";
		
	}
}
