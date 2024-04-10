Return-Path: <io-uring+bounces-1487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB8889E7CA
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 03:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF4CFB21AE5
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 01:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D5DA59;
	Wed, 10 Apr 2024 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q71b6cAZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306CB15A4
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712436; cv=none; b=r62QOwD2tp07g6XerfrNIhpIXlfT3Cgp2Pt5oAtQpL4VwWsWmtxqY1XlPOb0wea2wdemyLHnAc2UdvmzECOd8bwLBgbshZ1ephMhu3ABsAHGzdjDteTDBg8pi7zRr5jdunESQoNrgg4hJVb4Ucnz4x3geOMSHPmkveG3KzZmbrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712436; c=relaxed/simple;
	bh=M2OwH7UgBGLSXnOA61HS0oQI62bTMeOZlWXGfZVIGp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyzWkoUNUj/NkGiH9K2ylXEBugTZS2yi0+9ZtlKH/M7trRPZ9nRs137X2hVqy7RC/68Wy2/CjRu9K2UHThX06z86V/cPfObwhKwyjqVUJC+sG8gBPU2xUIzNOSvFBc797fxVQ9BKJsokrpg6wfCo4Au4WCVaNAQVBqCMnMRFGA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q71b6cAZ; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-346359c8785so676395f8f.0
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 18:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712712433; x=1713317233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNziGC8hKSnzMEKFyxJNNwyB2Vte56ZYQCL3ALYbRl8=;
        b=Q71b6cAZYgfYr1aBVP5LzrEHT2bhevfRbnMc9TPP1zJ8c2TKZES3915PXurOu+rxVr
         z0Ms8q1iFuWu0OorrtaqOhrf4HWNPD+KV5j3f+CKNM4RIE+infHjqlQv6qxvEF7wY2i9
         b65Kl9Vtt7BVcOUMv3UZLq89XO1gAZs5ZvbhVFZES/aIZ25+ZP+WCz4ocdXlZv0Fkoir
         qLC2FO28lTKqhVFl+V8cWB9/zQKnPMmFh++lEfbS+TDi0pZkmaSIxiEZJgsZnAyvngAp
         +ct1lJeBqNV7mzyhXDw15aIa0B8KLWqz16tyXpEqlblH5kWVRRs2TMR9enmodjuHP70g
         Upzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712712433; x=1713317233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FNziGC8hKSnzMEKFyxJNNwyB2Vte56ZYQCL3ALYbRl8=;
        b=KHS6jmGEUhHJkSBqhbm83o4K+9/jRdEG3O9KkSTT+nKCDldMAE5spfSxnB0hI0ywf2
         qdpYyV+wKdMyNdO1M9UhBqggNIP07GslZLlb9Tu8j8ponRtM+rtDLxpV/mj8d5hzFQpW
         VgG+bQ1CUMHszuBmVS2IWYP1gpifx2Huk38sn3XM8mHeF9nei7aCIaAIIiuWMOoB9l/1
         WVvS9AxL3vCsHaObJcNsvK5NZxAbV+21ZinKBVi5HhIFfguu0QFhEt43pLudcW3b2rdE
         nzZU1tVDmAiGK+EgEK3/C6k7Z6ZSjJKSY0yFHwLm2C7Jm+74yt6xp/7FnuUBMO5s8CLm
         +s3g==
X-Gm-Message-State: AOJu0YxynHuWzlAjEVDHDHq0A02XC13fqgB/kpozRQv5u6ByweV+LX9s
	YXtBO6gtXZmUa4OMIuOcRE7B1Jnna1uRwK8Bmpj5Tg8jJFjw+qZtV6ja1gfE
X-Google-Smtp-Source: AGHT+IEFDxfVSDSAhGK3F5PE9uR8uNE2dPD/XP/KJzJjPEegQ5nBm73L+dnpuGN3TQBFzrkfMJ6goA==
X-Received: by 2002:a5d:64ea:0:b0:345:6c39:5f4c with SMTP id g10-20020a5d64ea000000b003456c395f4cmr983296wri.12.1712712433436;
        Tue, 09 Apr 2024 18:27:13 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d6944000000b00343b09729easm12737693wrw.69.2024.04.09.18.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 18:27:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 5/5] io_uring: consolidate overflow flushing
Date: Wed, 10 Apr 2024 02:26:55 +0100
Message-ID: <986b42c35e76a6be7aa0cdcda0a236a2222da3a7.1712708261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712708261.git.asml.silence@gmail.com>
References: <cover.1712708261.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate __io_cqring_overflow_flush and io_cqring_overflow_kill()
into a single function as it once was, it's easier to work with it this
way.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d6cb7d0d5e1d..7a9bfbc1c080 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -668,26 +668,7 @@ static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	io_commit_cqring_flush(ctx);
 }
 
-static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
-{
-	struct io_overflow_cqe *ocqe;
-	LIST_HEAD(list);
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	spin_lock(&ctx->completion_lock);
-	list_splice_init(&ctx->cq_overflow_list, &list);
-	clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
-	spin_unlock(&ctx->completion_lock);
-
-	while (!list_empty(&list)) {
-		ocqe = list_first_entry(&list, struct io_overflow_cqe, list);
-		list_del(&ocqe->list);
-		kfree(ocqe);
-	}
-}
-
-static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
+static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 {
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
@@ -704,11 +685,14 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 		struct io_uring_cqe *cqe;
 		struct io_overflow_cqe *ocqe;
 
-		if (!io_get_cqe_overflow(ctx, &cqe, true))
-			break;
 		ocqe = list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
-		memcpy(cqe, &ocqe->cqe, cqe_size);
+
+		if (!dying) {
+			if (!io_get_cqe_overflow(ctx, &cqe, true))
+				break;
+			memcpy(cqe, &ocqe->cqe, cqe_size);
+		}
 		list_del(&ocqe->list);
 		kfree(ocqe);
 	}
@@ -720,10 +704,16 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 	io_cq_unlock_post(ctx);
 }
 
+static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
+{
+	if (ctx->rings)
+		__io_cqring_overflow_flush(ctx, true);
+}
+
 static void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
-	__io_cqring_overflow_flush(ctx);
+	__io_cqring_overflow_flush(ctx, false);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -1531,7 +1521,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	check_cq = READ_ONCE(ctx->check_cq);
 	if (unlikely(check_cq)) {
 		if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
-			__io_cqring_overflow_flush(ctx);
+			__io_cqring_overflow_flush(ctx, false);
 		/*
 		 * Similarly do not spin if we have not informed the user of any
 		 * dropped CQE.
-- 
2.44.0


