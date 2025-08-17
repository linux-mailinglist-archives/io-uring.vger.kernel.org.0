Return-Path: <io-uring+bounces-8988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F594B29554
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93D237AFA69
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12DA212B2F;
	Sun, 17 Aug 2025 22:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dUuY50Q8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E021A1C5D55
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755468492; cv=none; b=aleMOtOJvivqxDppALqURStGosrnL6UOIUPGdZM3MnfnD+lkKsWQp7zJxrn+5wSpCdpgwAjblDjxTrd4hAZDJx94LksJtRpPwoqk6rz/aRR+ybzsuYfaMND003PKTTlCNa1J34KyJIQ0hA8WyHjkdc7VV5vnT+9ss5Nzr0R5IhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755468492; c=relaxed/simple;
	bh=7jKJS7C2fCQBV9HLBbtwK8PEIs69HfcFh436vDLKF7o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Glf1qdF9sNS9M82t8iMLmoT1xTE8bOIfvcLiY3J5rNxgDZPLUk6/rU1vq5W1mPBUGRMGA2qJsq6NEMP/9qth1gwMMTz8Q/BJeAQSdViT3iqMQeupunO89PNWzwOLJVmfRmdQOjzI4MX/3tqj8Up4Ar/I1x0YOox7hQZpF5PboxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dUuY50Q8; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b05fe23so20146525e9.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755468489; x=1756073289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GUp+9fDcTswrUSeTnWp1eDpvjTgqhGC52CC8k2cnnw0=;
        b=dUuY50Q8+T/PMVIHXv5aHKpA9joD/vhfrhzvkUlw37LsMqxraaTLrbAKyAU8/KAc1m
         6liq21ID5Th5lGdRy/IuHTQw+gOlzjZNBGXtAEGKfodsknOrAAMmv8CLzre4dAAqDJfm
         aWTSl9J4Cvvs14hcLqT3pCfYcTFBRRfOXkbG5zDC/NWluXJsLj76/9/HSSC/9P25Z9Cy
         FUfBapgdTlmxQhh3aSYG9ZvTW35ZaT/fyjU6iDPIexvqpBQY9Yd1k43aOp8ES/a5NOLr
         7yqnGmMraRLAwseopeI9GZi1n87yprw3Wk62Mn8osNznVhswoPaJ+oLXAwcZWC0OpUCM
         hMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755468489; x=1756073289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUp+9fDcTswrUSeTnWp1eDpvjTgqhGC52CC8k2cnnw0=;
        b=rG3//27Jnd12OMeRfgosYR6bC5x5Qza2R4TrlPLGRe/+XDDMFDMRNOFE4NDpA6q94h
         f2wl1/muG3FalChqCUb18pMlzRqAvz5hMTyzHCzbCM4tb3KfimEFW49Ybz4FDzZOBKwK
         4Y7L3JlknuL+BWMA6w4tsxzL3nJ3fmz0+NgY/OC9ccf35YnauzAqZpcNYC6sn1pdDzZ7
         woiGljzyURfx1i0ekgFRmu493TWReR+W8spLTb9QhhmFQot1By8LUUsU+nmSAw1QQkSo
         WZiKGAPZezH+mtlVs7+qLY4COVLoovXmqsKO0ZheFCUkKjQUmdJxBs5Va/wq4FhbCVhv
         A4vg==
X-Gm-Message-State: AOJu0YzISQrNKrbl4bGh8fc7YVgKHk36dDf+7YlictnvZph98F5MSctv
	94kUOaK5Acb9DB9dlLzCwy2BxxH/CDuDdNzoJ8DHktwwPPCIE35uLGjiBRD22Q==
X-Gm-Gg: ASbGncuWdwQvdlccC/uqFqqzkra1djU/DSNXEah8Xtd5uPJwlJn+zIETRezLffTX7bw
	MBRh077bKLQFGBvyHjfLdFQoOs4uAUl0Ak9wDZl2c9PoDQS7d97kfuDj3w+KGYychro3uC4qtS+
	MJu3pJeNAG+8/VTRSYe5btDD0FtnfG964yoY1oH1yvYvMtc09TVzOfhpqnHjQXHQgKyah56bVUT
	YlrcYNxvyCNRD6SVPq8X6YDo0QJIT9u/krKABDnLlCQrCoa+NqNgsH9c5v6A2Xrt1Yx+iJyHAep
	5Ky511QhZ7gaEOQDfKx6F9K4HTgAQ0oC2nXoGiIpFiel7PNikBC/67vAA8iD3SnQV04Nwi1TXYe
	A9sv5ILYU9+Rvnsr019pJgIkyZKmJV4bAtw==
X-Google-Smtp-Source: AGHT+IGT0JYiZWBsc0MJguAkd3cvN+fJGUtK8v46fIMqoRMSr+yZT7skJtnaeDXjR/Tvo2vyeLmdGQ==
X-Received: by 2002:a05:600c:1390:b0:456:27a4:50ad with SMTP id 5b1f17b1804b1-45a21877909mr70194825e9.33.1755468488523;
        Sun, 17 Aug 2025 15:08:08 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a29e6d695sm43078825e9.22.2025.08.17.15.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:08:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/1] io_uring: add request poisoning
Date: Sun, 17 Aug 2025 23:09:18 +0100
Message-ID: <7a78e8a7f5be434313c400650b862e36c211b312.1755459452.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Poison various request fields on free. __io_req_caches_free() is a slow
path, so can be done unconditionally, but gate it on kasan for
io_req_add_to_cache(). Note that some fields are logically retained
between cache allocations and can't be poisoned in
io_req_add_to_cache().

Ideally, it'd be replaced with KASAN'ed caches, but that can't be
enabled because of some synchronisation nuances.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: don't poison cached async_data b/c of io_uring poll hacky
    entry assignment.

 include/linux/poison.h |  3 +++
 io_uring/io_uring.c    | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 8ca2235f78d5..299e2dd7da6d 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -90,4 +90,7 @@
 /********** lib/stackdepot.c **********/
 #define STACK_DEPOT_POISON ((void *)(0xD390 + POISON_POINTER_DELTA))
 
+/********** io_uring/ **********/
+#define IO_URING_PTR_POISON ((void *)(0x1091UL + POISON_POINTER_DELTA))
+
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ef69dd58734..402363725a66 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -179,6 +179,26 @@ static const struct ctl_table kernel_io_uring_disabled_table[] = {
 };
 #endif
 
+static void io_poison_cached_req(struct io_kiocb *req)
+{
+	req->ctx = IO_URING_PTR_POISON;
+	req->tctx = IO_URING_PTR_POISON;
+	req->file = IO_URING_PTR_POISON;
+	req->creds = IO_URING_PTR_POISON;
+	req->io_task_work.func = IO_URING_PTR_POISON;
+	req->apoll = IO_URING_PTR_POISON;
+}
+
+static void io_poison_req(struct io_kiocb *req)
+{
+	io_poison_cached_req(req);
+	req->async_data = IO_URING_PTR_POISON;
+	req->kbuf = IO_URING_PTR_POISON;
+	req->comp_list.next = IO_URING_PTR_POISON;
+	req->file_node = IO_URING_PTR_POISON;
+	req->link = IO_URING_PTR_POISON;
+}
+
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 {
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
@@ -235,6 +255,8 @@ static inline void req_fail_link_node(struct io_kiocb *req, int res)
 
 static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
+	if (IS_ENABLED(CONFIG_KASAN))
+		io_poison_cached_req(req);
 	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 }
 
@@ -2766,6 +2788,7 @@ static __cold void __io_req_caches_free(struct io_ring_ctx *ctx)
 
 	while (!io_req_cache_empty(ctx)) {
 		req = io_extract_req(ctx);
+		io_poison_req(req);
 		kmem_cache_free(req_cachep, req);
 		nr++;
 	}
-- 
2.49.0


