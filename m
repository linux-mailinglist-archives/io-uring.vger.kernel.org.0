Return-Path: <io-uring+bounces-7821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3064AA77D4
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 18:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 017A49E388C
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 16:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F79267F59;
	Fri,  2 May 2025 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gCeGM482"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C692571D5
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746204787; cv=none; b=Z5UN6v0LDq2pa+ShkKzRnGltNH5sLW54LCV1IQ3b7p0Zk+qrwZ8iCo0SjdiKam98sJ8JGzS7sQ/eYbvSDNTyrXFUec73pVcjsQpp+g2lVP7W8Y3qWNW9OBQFKcxwg8K27tGZSx5uNlQd6g4fNvmxeA8MSkhpNhkH0VxRAPxyjW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746204787; c=relaxed/simple;
	bh=c6tqNcph7VoPkwadfCKZG9+S7WfkA9WNcHFROPMzQ0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMWX8MFA0c4DPuevSTpaasZ/WCWE+gG8cCKQJe+zWUYf55qnDv5u6/3/lfbzc+NHo7jm0uIx6m9e3spR4Utza8m7NK7Up7zJBHdi90mcCRfbK3YujCJtdGSxf1JVWoklvH1xZ5m4BdFi3wpPT857WvK9Gy1eO0heVBSEQXUGgMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gCeGM482; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39ac9aea656so2275636f8f.3
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 09:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746204784; x=1746809584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIS8bNuf8DoyFXFywD4fMR/3THUYI6VqjX52BWHx9BA=;
        b=gCeGM482QKBEM8ncEZwisDKAWCis3v4mudIJZtnUqdYlRgcbyS/NhUEYmAhhvbfWAr
         EWwBF3qjRrdPU97EFud4ZopTMwEKaQxPgo/s3SDvuhYm96HNASEPForwnnvlDyrjFVZy
         LBVwDd6Zgu27vYgk9DM4GP8tSLJIxL48DfsNV3jlHIoIKpIfObX8nKVZmUtBLktjuoge
         ouodbwB4CKc86z+FYvt6bUtiHmegc+CA4QNl+SgV9hFWqJUtN3yHTpTSUoeHvWaFY/h5
         fX448VwmaHGV8M/4IfFVu2dA9FfsVAPtC2Wxn1cbW6ORzHoAOIsO/zFnr2gGG0+Lwsue
         En4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746204784; x=1746809584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fIS8bNuf8DoyFXFywD4fMR/3THUYI6VqjX52BWHx9BA=;
        b=nn/65vD2EbqxYYYzeUyUhv2oD+Y5elQkBQPursiBIBWH/piZKGgbk6KmCq2+A2Lg27
         y7nRu92qfMUzMTdZZaosynWhiM0KufBz+m1DAQ9j85UOl1NCXICXqs653dJECNaV2FLz
         mH8E0Ci03mcqlC44HD+I/8RbZ64UWtwWOAI0rWwJAiyjDWyoBD5kqFrm4si6T42uPTnq
         tXYsXRT1Wma45HEYINXnxFIvqVrs4jpcr1Gx/MzZvN2NNbpHTykLLmESbDBzfMa5T6ji
         yoTBWfZT19HdZmrE79WkMutqt6PYsF9p/5+N3mt8wTpYDgZzQU9a6JlRvb6TeQx0i26t
         Ntfg==
X-Gm-Message-State: AOJu0Yw38+nW8OTsX4drdF+FXuFW924abqZ+EBOPxvZ8l/SQD7xKqVc5
	HXPXIs9UQ9Hbu1ODPKmaqFRC5ezR3zkjCnJ6TDyznBXCUr4L7v7T8u9z4A==
X-Gm-Gg: ASbGncsiV7+qu+ziSiPxe9wXBO1JbPQOpThVuXDZZUtB4lfhiwCaca4kkU6UxyCJ7WV
	z2WLF4xXXxc0xCQeNOQufW/6mFWKMRQ8Y3EcnudwnqrjwJvPFZKuupBt9CyDS2c2OpS9cAo54Q1
	/x3QRkStO6w5dRkyABHObXm5QIVhmp/Pc2/JA0k/y388yiiC5OsEVkDhOl+hFsSeaW04p/hJu2p
	FjitfhMvIuQ4x8P8J0a2uL/aqwqUPzgXV/X0+pUbxe/gJUP67vRm0ZolGkMHzZfETC8F+X7nNio
	VnFSW1R/b2cvhhShhQc7VPL1rodcGxdKFoLSUIQDqx7/a3czvbmpw6g6+ZE/eTcDrg==
X-Google-Smtp-Source: AGHT+IGMZjSGsqvANfF/NM5V3VR3NGS4xpcEgTD4r82hWwdSW+HPLMm2ddLSrT7n3Ou5lmq+2XrH1g==
X-Received: by 2002:a05:6000:2586:b0:3a0:8a13:3244 with SMTP id ffacd0b85a97d-3a099add3ffmr2871834f8f.27.1746204783626;
        Fri, 02 May 2025 09:53:03 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0f125sm2586013f8f.72.2025.05.02.09.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 09:53:02 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 3/5] examples/send-zc: optionally fill data with a pattern
Date: Fri,  2 May 2025 17:54:00 +0100
Message-ID: <bc15b140e8f5d261a091377c874a9042d9bfca2b.1746204705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746204705.git.asml.silence@gmail.com>
References: <cover.1746204705.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

-v option tells to make the outgoing traffic to follow a pattern, which
is repeating all lower case letters. zcrx already has an option to
verify received data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 70 ++++++++++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index b4721672..a7465812 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -43,6 +43,8 @@
 
 #include "liburing.h"
 
+#define PATTERN_SIZE	26
+
 #define ZC_TAG 0xfffffffULL
 #define MAX_SUBMIT_NR 512
 #define MAX_THREADS 100
@@ -76,11 +78,12 @@ static int  cfg_payload_len;
 static int  cfg_port		= 8000;
 static int  cfg_runtime_ms	= 4200;
 static bool cfg_rx_poll		= false;
+static bool cfg_verify;
 
 static socklen_t cfg_alen;
 static char *str_addr = NULL;
 
-static char payload_buf[IP_MAXPACKET] __attribute__((aligned(4096)));
+static char payload_buf[IP_MAXPACKET + PATTERN_SIZE] __attribute__((aligned(4096)));
 static char *payload;
 static struct thread_data threads[MAX_THREADS];
 static pthread_barrier_t barrier;
@@ -376,7 +379,7 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 	}
 
 	iov.iov_base = payload;
-	iov.iov_len = cfg_payload_len;
+	iov.iov_len = cfg_payload_len + PATTERN_SIZE;
 
 	ret = io_uring_register_buffers(&ring, &iov, 1);
 	if (ret)
@@ -403,13 +406,18 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 		unsigned msg_flags = MSG_WAITALL;
 
 		for (i = 0; i < cfg_nr_reqs; i++) {
+			char *buf = payload;
+
+			if (cfg_verify && cfg_type == SOCK_STREAM)
+				buf += td->bytes % PATTERN_SIZE;
+
 			sqe = io_uring_get_sqe(&ring);
 
 			if (!cfg_zc)
-				io_uring_prep_send(sqe, fd, payload,
+				io_uring_prep_send(sqe, fd, buf,
 						   cfg_payload_len, 0);
 			else {
-				io_uring_prep_send_zc(sqe, fd, payload,
+				io_uring_prep_send_zc(sqe, fd, buf,
 						     cfg_payload_len, msg_flags, 0);
 				if (cfg_fixed_buf) {
 					sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
@@ -527,7 +535,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:I:b:l:dC:T:Ry")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:I:b:l:dC:T:Ryv")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -582,6 +590,9 @@ static void parse_opts(int argc, char **argv)
 		case 'R':
 			cfg_rx = 1;
 			break;
+		case 'v':
+			cfg_verify = true;
+			break;
 		case 'y':
 			cfg_rx_poll = 1;
 			break;
@@ -604,8 +615,13 @@ static void parse_opts(int argc, char **argv)
 		t_error(1, 0, "-n: submit batch can't be zero");
 	if (cfg_ifname && cfg_rx)
 		t_error(1, 0, "Interface can only be specified for tx");
-	if (cfg_nr_reqs > 1 && cfg_type == SOCK_STREAM)
+	if (cfg_nr_reqs > 1 && cfg_type == SOCK_STREAM) {
 		printf("warning: submit batching >1 with TCP sockets will cause data reordering");
+		if (cfg_verify)
+			t_error(1, 0, "can't verify data because of reordering");
+	}
+	if (cfg_rx && cfg_verify)
+		t_error(1, 0, "Server mode doesn't support data verification");
 
 	str_addr = daddr;
 
@@ -613,6 +629,32 @@ static void parse_opts(int argc, char **argv)
 		usage(argv[0]);
 }
 
+static void init_buffers(void)
+{
+	size_t size;
+	int i;
+
+	payload = payload_buf;
+	size = sizeof(payload_buf);
+
+	if (cfg_hugetlb) {
+		size = 1 << 21;
+		payload = mmap(NULL, size, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_HUGETLB | MAP_HUGE_2MB | MAP_ANONYMOUS,
+				-1, 0);
+		if (payload == MAP_FAILED)
+			t_error(0, 1, "huge pages alloc failed");
+	}
+
+	if (cfg_payload_len + PATTERN_SIZE > size)
+		t_error(1, 0, "Buffers are too small");
+
+	if (cfg_verify) {
+		for (i = 0; i < size; i++)
+			payload[i] = 'a' + (i % PATTERN_SIZE);
+	}
+}
+
 int main(int argc, char **argv)
 {
 	unsigned long long tsum = 0;
@@ -622,24 +664,10 @@ int main(int argc, char **argv)
 	void *res;
 
 	parse_opts(argc, argv);
+	init_buffers();
 	set_cpu_affinity();
 
-	payload = payload_buf;
-	if (cfg_hugetlb) {
-		payload = mmap(NULL, 2*1024*1024, PROT_READ | PROT_WRITE,
-				MAP_PRIVATE | MAP_HUGETLB | MAP_HUGE_2MB | MAP_ANONYMOUS,
-				-1, 0);
-		if (payload == MAP_FAILED) {
-			fprintf(stderr, "hugetlb alloc failed\n");
-			return 1;
-		}
-	}
-
 	pthread_barrier_init(&barrier, NULL, cfg_nr_threads);
-
-	for (i = 0; i < IP_MAXPACKET; i++)
-		payload[i] = 'a' + (i % 26);
-
 	for (i = 0; i < cfg_nr_threads; i++) {
 		td = &threads[i];
 		td->idx = i;
-- 
2.48.1


