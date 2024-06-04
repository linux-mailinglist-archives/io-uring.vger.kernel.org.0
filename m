Return-Path: <io-uring+bounces-2101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4664E8FBC5F
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 21:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA9DD1F24B9D
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 19:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC5114A629;
	Tue,  4 Jun 2024 19:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LVgP9Y6o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4014AD32
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 19:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528411; cv=none; b=AqKx7kBxX8TSUMDACO56xujDTYs+FSdnDUugb+ZcS0FS6MhHzfE6dJ+k9ncrEDWsLsWk7lWI2mM7pG9bq8vVotqWNqHNESjDT+o/VJ5VMepsYtXNpuEdLWhJQIWkPOOWVGEw93VwwxbOhhwb3uN6mMLGUNZqIHZfhch1XaasgyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528411; c=relaxed/simple;
	bh=elsAwSpveYyAAJD935fO32pChhAOuw2D+06WGsnF6u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKxQrKd6EMeFc6rg6cA9eoFRihQdSNLhCXKe/X+h2g5/SdPWotuZ6Iu1Xf1TsMTQA974sX7rW2hXm/PhuT1zFmNHyp+fah2yWXA9U3KBjqfhTlc+A7R5ryoYwa6I0ZMfWHlG7BfqCoYnpMqj45p5InwR2n350q+4z4i7Xpx/qD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LVgP9Y6o; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2c1b16b9755so581822a91.0
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 12:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717528409; x=1718133209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cml926L31b1JFRrdBC6XRZijdltsC3bbHEbQVTJZY4Q=;
        b=LVgP9Y6oxyAysuzC+Y1zbICJiMvSXFZMjrrGB3FR8Hi7KDSs8uJPC5c4LfJWVd/Gbt
         27w7sXGcEpomDGPofL8CoWR1Af4SZ8wE431xCiernpHSyH1Aw06i96rS/22OzRenMFog
         OTK2ZAMMj+bgzpByvn66WngMWB2nwpEjYSwASLzSNXpwKEMELqJJKmO5x6S1BG98+7Q/
         /5+S0l/vSSooLD1PUgULikanCbaXlhE22CeKquZ97LE4a+pNH2jNN1li5rFFehAYcmhZ
         f47Z0GB4VvtxKVEOGqX+hKpPQSti8HPAk5x6mKvoskGh5TR0k+dh4wrUBYyRxaj6/BjE
         ywjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717528409; x=1718133209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cml926L31b1JFRrdBC6XRZijdltsC3bbHEbQVTJZY4Q=;
        b=I+iYiBoeYqhQW9sfFgwVg17hX54mNylpbfleG25eAwCJ4Wtsm9XpjcJM46rpXusw9E
         sP4qLTcaMMqwEd0zbHBqjA1PoiJe0tzbxEmxhhZHwOStRG8ejxqqqmabmN0ewo5qJEWO
         jW0SBUd+LNdKEm12I7HaP6npZkj1lXx6xQZ658L0cj2nmVie115g5HwY5yKma49VMtaS
         F/KUtVqP+uF985DHoZyBuSalwleK5gkEqborcP36ouGlGYFVpB+9+unISZjdxJsEq9xE
         YMB5LZKCftYksH6h5mBy3FkCNay/wvoMoIL4HY75zXnDPlm6SI+dI/dW/hMJd+11iYJl
         R34Q==
X-Gm-Message-State: AOJu0YwyIGJkTkEWTmIm37LM1CFeRg156+6T+ZrKu7Vuq1JGEy90r5yB
	/KSlCXzQSewz+CNB/eWs9/B004WCXBfQpP8xdsGc1cLIer/CaYs+wa0T5al6yTk7Dc0nYVPlECo
	A
X-Google-Smtp-Source: AGHT+IHlhF1P6eAZVCMo1Vx28B0RdpEEO7jMoEXVU16L3e7psSUfjOmHSefhGmNsh/vXzeOvIuQ2CQ==
X-Received: by 2002:a17:90a:eb17:b0:2bd:e340:377f with SMTP id 98e67ed59e1d1-2c27dd6073bmr362026a91.3.1717528408771;
        Tue, 04 Jun 2024 12:13:28 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1c283164fsm8960265a91.37.2024.06.04.12.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 12:13:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: wait for cancelations on final ring put
Date: Tue,  4 Jun 2024 13:01:32 -0600
Message-ID: <20240604191314.454554-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240604191314.454554-1-axboe@kernel.dk>
References: <20240604191314.454554-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We still offload the cancelation to a workqueue, as not to introduce
dependencies between the exiting task waiting on cleanup, and that
task needing to run task_work to complete the process.

This means that once the final ring put is done, any request that was
inflight and needed cancelation will be done as well. Notably requests
that hold references to files - once the ring fd close is done, we will
have dropped any of those references too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index fc1e0e65d474..a6b5f041423f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -420,6 +420,8 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+
+	struct completion		*exit_comp;
 };
 
 struct io_tw_state {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5a4699170136..3000a865baec 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2730,6 +2730,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
 	unsigned long timeout = jiffies + HZ * 60 * 5;
 	unsigned long interval = HZ / 20;
+	struct completion *exit_comp;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -2788,6 +2789,10 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 
 	io_kworker_tw_end();
 
+	exit_comp = READ_ONCE(ctx->exit_comp);
+	if (exit_comp)
+		complete(exit_comp);
+
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
@@ -2851,9 +2856,20 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 static int io_uring_release(struct inode *inode, struct file *file)
 {
 	struct io_ring_ctx *ctx = file->private_data;
+	DECLARE_COMPLETION_ONSTACK(exit_comp);
 
 	file->private_data = NULL;
+	WRITE_ONCE(ctx->exit_comp, &exit_comp);
 	io_ring_ctx_wait_and_kill(ctx);
+
+	/*
+	 * Wait for cancel to run before exiting task
+	 */
+	do {
+		if (current->io_uring)
+			io_fallback_tw(current->io_uring, false);
+	} while (wait_for_completion_interruptible(&exit_comp));
+
 	return 0;
 }
 
-- 
2.43.0


