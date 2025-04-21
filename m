Return-Path: <io-uring+bounces-7594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 626B5A94D19
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 09:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE3D83AA9F0
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 07:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767A620E002;
	Mon, 21 Apr 2025 07:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EITVOkJy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F3420DD63
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 07:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745220276; cv=none; b=JVCVnSyCXtksa6lkMbXmIiKfJFQBfiYNXOKtiGigf657MeKpz033ClzZ0Wq/w3FEUzN9BOymMiiYcs1q3FrOLRyrixqvjOqdJYTKoy30K42xNNNYFczGFs0UvsNnxFiQqrO7ZI8+aEc8llLGI1pyNjag/utLnbORNnFxEMFtsWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745220276; c=relaxed/simple;
	bh=SJYI3RiG+4X6h6jWvIrFREzhw4PAa+FV2EcEse3mpjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReaVD8H/UMsM9vFrpY5Hdvb+I/4IvZf9R/Z7R+RPb8D6zpd8jKdTR/lPijgFJDQKCYW7uzGnUBLawboTSOfvoNGOKqcPycbrnfQZk0nB1d17inK7RadguoNxI/EDpJb5kyRzIDLmXegu75z2/h0NWaCXBTR+qgJvfIBMlf1Pad4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EITVOkJy; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9eb12so3190122a12.1
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 00:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745220272; x=1745825072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ejeaGhAQRRdc14QC6nR8CB1WJXH8m4ZqG1U4h0PqcdQ=;
        b=EITVOkJyxbcnkSySKted0CdcEluLh6aMW/JGufPE5/nT79Pn6ng322quHuW2cHzizF
         EGcYGvUUiyXzx0ouoA5UD6SX7b4zO9Hf6e880PdjnKV20iXOyF6ShLp0W7fFekKirR2j
         o8vowUQyKPkP/Isp8IVFcSi5xNntMgDPIJ/ZURIKmq5swb4T+LfWeM9hT+EVKhLuP//L
         KVt9gUXNnVYHB6/yYDx+mJAkI9RPHI+p6A60hOvHt2v3E0/zGiG0qizi4N+rwhbAzlTE
         y3zX5Vhxg2SnlywhvZe/TyTVP9cQkQpFAi5l6yiICWHLGNCPDOysz290xW6McgO45qqz
         sk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745220272; x=1745825072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ejeaGhAQRRdc14QC6nR8CB1WJXH8m4ZqG1U4h0PqcdQ=;
        b=eAjkYdNVzur2EwJ/jTC/hn+fzzEUB3jiZzWZMxCIMvwr2EEBtWsmmYjdUGZ7hYuK54
         GWnIOLFS5XkLBiyHcb9hHSWAH/S76IH+k1D3AHI4GEWeIItmx401PD29VOEVdC87Sa2Q
         0bYyPdnY58X6x4nrUvNpP6rvA/sH4qLYqg3UoT+OyLqDcJCgYSLnzJbJXotpda6T0rl/
         AaIIFmAnZRNCFyfKjRE4+fnvcobrFGmttC1JCBBlH+gxuxmOSjcSkE3PZdX8z5ylJVhI
         0xvu6KSNy97z7h0zFb/kpda0iJNvz9oxoGblLIM6MFOA66+9C3bAoe7JuahGepLk/B3h
         XVFg==
X-Gm-Message-State: AOJu0Yx8ZWXyrTT8/VwAWCNdxBUcBs7TXFU0w1ZjZ78uU4IR/vsvd0Y5
	VqbtKBEVgU054Lt/CBTun+egD2IZjSmOo1EN6n/6CzRNNhqrBP34ht4bXA==
X-Gm-Gg: ASbGncuOfpjZxRjIiF6nujWsufjacn46oz/pmwGNgOWhMCdD8DpISxuolXN/CwszidE
	X0WBDDWuNLS+3lq6bK19TXGV43y+ppWoqc/rEMuFR3GjZE95zapgMTN68MP7NSSJVNvSH4Ta5aU
	Fl3tfiggrXnfjBrEpOPfjbOIvuwN6tNTWV1BVvB1wvneE5tZgdfHJVvheRRJhZ2Musaj7XW5Gqf
	cnhwHs9oV+DPCCR/bqyFO88D9+dzJIpnpDtsZbBzFwQaPeQVleh1k0pV2uRVQFGh/fczv/CrHXh
	cqbx0ou4/RTklfUgwIEHzahcEqwiPiXcH+W2/iit1mebqXTDjf8xeUKK3WeozhQ1
X-Google-Smtp-Source: AGHT+IFU7tFib3UEi/eUWw4CMMzz9Z+ZnN65PJuXVrAxDxD4JTcs3BxV/Xk5ebREhHJAy2bWcv9n8Q==
X-Received: by 2002:a05:6402:1e8e:b0:5f4:c2d0:fbb2 with SMTP id 4fb4d7f45d1cf-5f628597fbbmr9838639a12.18.1745220272497;
        Mon, 21 Apr 2025 00:24:32 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625a5ec5bsm4175562a12.81.2025.04.21.00.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 00:24:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing v2 4/4] examples/zcrx: add refill queue allocation modes
Date: Mon, 21 Apr 2025 08:25:32 +0100
Message-ID: <694d179e262574db3e74d08809d722583af007f6.1745220124.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745220124.git.asml.silence@gmail.com>
References: <cover.1745220124.git.asml.silence@gmail.com>
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
index e5c3c6ec..40a4f0ad 100644
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
@@ -56,6 +63,7 @@ static const char *cfg_ifname;
 static int cfg_queue_id = -1;
 static bool cfg_verify_data = false;
 static size_t cfg_size = 0;
+static unsigned cfg_rq_alloc_mode = RQ_ALLOC_USER;
 static struct sockaddr_in6 cfg_addr;
 
 static void *area_ptr;
@@ -80,6 +88,7 @@ static void setup_zcrx(struct io_uring *ring)
 {
 	unsigned int ifindex;
 	unsigned int rq_entries = 4096;
+	unsigned rq_flags = 0;
 	int ret;
 
 	ifindex = if_nametoindex(cfg_ifname);
@@ -96,19 +105,22 @@ static void setup_zcrx(struct io_uring *ring)
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
@@ -129,6 +141,15 @@ static void setup_zcrx(struct io_uring *ring)
 	if (ret)
 		t_error(1, 0, "io_uring_register_ifq(): %d", ret);
 
+	if (cfg_rq_alloc_mode == RQ_ALLOC_KERNEL) {
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
@@ -292,7 +313,7 @@ static void parse_opts(int argc, char **argv)
 	if (argc <= 1)
 		usage(argv[0]);
 
-	while ((c = getopt(argc, argv, "vp:i:q:s:")) != -1) {
+	while ((c = getopt(argc, argv, "vp:i:q:s:r:")) != -1) {
 		switch (c) {
 		case 'p':
 			cfg_port = strtoul(optarg, NULL, 0);
@@ -309,6 +330,11 @@ static void parse_opts(int argc, char **argv)
 		case 'v':
 			cfg_verify_data = true;
 			break;
+		case 'r':
+			cfg_rq_alloc_mode = strtoul(optarg, NULL, 0);
+			if (cfg_rq_alloc_mode >= __RQ_ALLOC_MAX)
+				t_error(1, 0, "invalid RQ allocation mode");
+			break;
 		}
 	}
 
-- 
2.48.1


