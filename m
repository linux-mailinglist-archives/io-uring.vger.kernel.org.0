Return-Path: <io-uring+bounces-7582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B37A8A94792
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 13:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4B953B3C62
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4951FDA;
	Sun, 20 Apr 2025 11:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNPAni80"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8557E1E51EB
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 11:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745148230; cv=none; b=STZhl8vOHodTJJpgW2zu0NdO9VnuCrRUH5H+txqDUd9fbaXV1M5DWgJ18aEk5c3j1m4kmECvW9gMWoWQEZ1AR4bK01h6PwjXVn2xA1N4r8CoqYMDvVnTII4HcBCo8J6HgaCKl5uxBcqwjWQaaZ+ycTs/jTvUsTOe2KQecY1GdB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745148230; c=relaxed/simple;
	bh=GtfvNK084HizzUHawU/ueQN9fx7LaxlAVKpfG6WQLFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxHl5gS7AcJZ5U+pxm8aP314flSdjonmNmqGXEipaw+rq43L5uY7azywxA7Oz1mpqs/co3Ku5O4eAJDLYaFCd2oNiz1BqaS3FxXjljnIXEcx0exoreEE6hEvzUaiKN7F8TYx0bVdZPSvySjT6ApBFDQYkx2+jg8U+shiBei9rCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WNPAni80; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so25226855e9.1
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 04:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745148226; x=1745753026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3T2WEQrVc5z1YQwbRy/dlJwUqv3uR5BEs5GTFB9j3R8=;
        b=WNPAni80MTG6w9iL8TK9Gh63SXdMAPG7pWIEOcTyFvadfStGZ4de5llUi+Vv0siA0J
         WLInOzn4tygnTS1cY31QJ+NPADCU3Sq20yY5YyQ6Ev9B9vnFZFsqK5oYqdCSWWZO5v/t
         kDUzTcGmKwAErGcNfb7LO9o+yRVH0UhfZH5VAwx3NZPtYx/d3hddoxwcjmk/pkj3ga/m
         JobIIvKF1GAkiacpLrpE3AAckWaopDZ/YmmIUWRCuL1e9ULm7X2fj6QohFwD52X6Yd10
         NyxUhOaYqz7VPXuSp7CwhZ6TMXwi7aP7L06rKtzkJrVnLZEiu0+67kfOhKwXaFqAGNLh
         wTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745148226; x=1745753026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3T2WEQrVc5z1YQwbRy/dlJwUqv3uR5BEs5GTFB9j3R8=;
        b=CsFhma2qDVMuubzEcBXjGAi/zLLNqJoe4rUI72WqSsMDzg2KKTbaNVeFcW1EG4Qr8l
         1x6JAMDXqu+buKHArWgG2QY4k9TRohUuJU/DNY3eonziFTcw+BELadS9JIdKqiTXtrmp
         TpOkcWasY9HjoJ61COyd84iaWqYZC2VeG0INe0nmSXX6tcDv2Jk/una/zWUTNQPGI0hl
         JJZqgRqeiUdxg29Yqen8rMPEiUn7JPv94WNRRP7gVHqON5PyMBDJLlM8NqXqnSSRfjra
         w4JC+IrUYWZERHfE+9xMjij9mXJQqAnsFJc+HuGdXGf3dxxvROLr+7aEgdmQEGc1UG4r
         4iPw==
X-Gm-Message-State: AOJu0Yzn7zMnw5ZWnUBUXkVEwzZscrWkoMeBtHtn1CafMkrfo7bnOBNI
	xShNak7pQUTq/+h27M4syhSALzCEyCOJM4NhD67WBr+0xXpl053ev/7MNw==
X-Gm-Gg: ASbGncvgmcgIGYN/k/0gODoHnfXZiEvIgP7GkcyygZ2J0vNYxCg7DmPDgFDTAZlgZbu
	eFoyCEwgIZi9fhYZXOceUuAgqRgDFA0uG9eyXCdj2mMuKUUcufULpxDHQUENTgNSgfgB9NL6Mw+
	y1x6sOs3Ai0/RAwnN7wySCJsekN6E4FYdXSRZagcjco+tvpk1VbPyrcXWsQeRHpND5Owm4Pfs3d
	7HQKoirPsvjRa8qzRuxXUl6KLS/8uW3Fd05Zg2vkiKUGX6G0wa95gT0u3NMx/4Ej38DaNB2vAip
	wGCqgfvMPpFd5mqz7Q1b7PyfEeM3bH2wgAooQEkI+85E5bmOV2OhCA==
X-Google-Smtp-Source: AGHT+IGgecwQ0CBgXKK3V7WYB/LjOq81VDUvYb2b4fSFC1ju6GM5nJ9TqCTRLktABBLDWrYC77E4xA==
X-Received: by 2002:a05:600c:3d96:b0:43d:97ea:2f4 with SMTP id 5b1f17b1804b1-4406ab97d5emr77304865e9.12.1745148226020;
        Sun, 20 Apr 2025 04:23:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5bbd35sm94447125e9.22.2025.04.20.04.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 04:23:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 3/3] examples/zcrx: add refill queue allocation modes
Date: Sun, 20 Apr 2025 12:24:48 +0100
Message-ID: <6a52feca4f8842c6aa3ad4595c1d1da8150f6fc1.1745146129.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745146129.git.asml.silence@gmail.com>
References: <cover.1745146129.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refill queue creating is backed by the region api, which can either be
user or kernel allocated. Add an option to switch between the modes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 8989c9a4..eafe1969 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -39,6 +39,13 @@
 #include "liburing.h"
 #include "helpers.h"
 
+enum {
+	RQ_ALLOC_USER,
+	RQ_ALLOC_KERNEL,
+
+	__RQ_ALLOC_MAX,
+};
+
 static long page_size;
 #define AREA_SIZE (8192 * page_size)
 #define SEND_SIZE (512 * 4096)
@@ -55,6 +62,7 @@ static int cfg_port = 8000;
 static const char *cfg_ifname;
 static int cfg_queue_id = -1;
 static bool cfg_verify_data = false;
+static unsigned cfg_rq_alloc_mode = RQ_ALLOC_USER;
 static struct sockaddr_in6 cfg_addr;
 
 static void *area_ptr;
@@ -79,6 +87,7 @@ static void setup_zcrx(struct io_uring *ring)
 {
 	unsigned int ifindex;
 	unsigned int rq_entries = 4096;
+	unsigned rq_flags = 0;
 	int ret;
 
 	ifindex = if_nametoindex(cfg_ifname);
@@ -95,19 +104,22 @@ static void setup_zcrx(struct io_uring *ring)
 		t_error(1, 0, "mmap(): zero copy area");
 
 	ring_size = get_refill_ring_size(rq_entries);
-	ring_ptr = mmap(NULL,
-			ring_size,
-			PROT_READ | PROT_WRITE,
-			MAP_ANONYMOUS | MAP_PRIVATE,
-			0,
-			0);
-	if (ring_ptr == MAP_FAILED)
-		t_error(1, 0, "mmap(): refill ring");
+
+	ring_ptr = NULL;
+	if (cfg_rq_alloc_mode == RQ_ALLOC_USER) {
+		ring_ptr = mmap(NULL, ring_size,
+				PROT_READ | PROT_WRITE,
+				MAP_ANONYMOUS | MAP_PRIVATE,
+				0, 0);
+		if (ring_ptr == MAP_FAILED)
+			t_error(1, 0, "mmap(): refill ring");
+		rq_flags |= IORING_MEM_REGION_TYPE_USER;
+	}
 
 	struct io_uring_region_desc region_reg = {
 		.size = ring_size,
 		.user_addr = (__u64)(unsigned long)ring_ptr,
-		.flags = IORING_MEM_REGION_TYPE_USER,
+		.flags = rq_flags,
 	};
 
 	struct io_uring_zcrx_area_reg area_reg = {
@@ -128,6 +140,15 @@ static void setup_zcrx(struct io_uring *ring)
 	if (ret)
 		t_error(1, 0, "io_uring_register_ifq(): %d", ret);
 
+	if (cfg_rq_alloc_mode == RQ_ALLOC_USER) {
+		ring_ptr = mmap(NULL, ring_size,
+				PROT_READ | PROT_WRITE,
+				MAP_SHARED | MAP_POPULATE,
+				ring->ring_fd, region_reg.mmap_offset);
+		if (ring_ptr == MAP_FAILED)
+			t_error(1, 0, "mmap(): refill ring");
+	}
+
 	rq_ring.khead = (unsigned int *)((char *)ring_ptr + reg.offsets.head);
 	rq_ring.ktail = (unsigned int *)((char *)ring_ptr + reg.offsets.tail);
 	rq_ring.rqes = (struct io_uring_zcrx_rqe *)((char *)ring_ptr + reg.offsets.rqes);
@@ -290,7 +311,7 @@ static void parse_opts(int argc, char **argv)
 	if (argc <= 1)
 		usage(argv[0]);
 
-	while ((c = getopt(argc, argv, "vp:i:q:")) != -1) {
+	while ((c = getopt(argc, argv, "vp:i:q:a:")) != -1) {
 		switch (c) {
 		case 'p':
 			cfg_port = strtoul(optarg, NULL, 0);
@@ -304,6 +325,11 @@ static void parse_opts(int argc, char **argv)
 		case 'v':
 			cfg_verify_data = true;
 			break;
+		case 'a':
+			cfg_rq_alloc_mode = strtoul(optarg, NULL, 0);
+			if (cfg_rq_alloc_mode >= __RQ_ALLOC_MAX)
+				t_error(1, 0, "invalid RQ allocation mode");
+			break;
 		}
 	}
 
-- 
2.48.1


