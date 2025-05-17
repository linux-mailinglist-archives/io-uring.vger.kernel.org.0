Return-Path: <io-uring+bounces-8034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C25ABAA0C
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22BFD3B279E
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 12:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A811FC8;
	Sat, 17 May 2025 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbRDJy8m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8A14B1E7F
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 12:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484803; cv=none; b=Cgdblob/+6MNg6eNHlSyD+9M0ZxON6bexRngN+Wp6HLPsrfK+zwt1/poDhPAPO2EyCZi10T0f2SkNauDURc+gtMMuNXyOdOSOQpQ78fdsPsWENXQqhbTTjhldjyVmu9jHU4gCMfUxqEKz+3onSRQl/YlPf/nG15mjAa1+ekgA+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484803; c=relaxed/simple;
	bh=U6SjYYK9h0uOt1tUMtx0b1mI4a8L5f0yTTJ55lSuOmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ+x2DoGTWcoA8g6DBbWPsgOLoci23ueChYzpAo5RSYKDKU98MtsrI0GJ4rzt/OMAsXBceMZwF4FRmFVrhx9JOWQm9iek685bdX+lTs4G4poxfSH0Dp2E/fPA8nt6FT5lC8hMHOD1fNrIHGaZUy9heyboR0VxUUA/1DuddbzzzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AbRDJy8m; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5f624291db6so4635184a12.3
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 05:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747484799; x=1748089599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5yAWntb3VfhbgYC+JCKqeiNNaVXqVYmvsV20FMAdIo=;
        b=AbRDJy8mgR85Fy5y0brI5dSAB2AmWIsKyUlHxxQYof/ZoCzQjPupI+mygpNczQF7t0
         TQIOHInDy0bEhzib2IImQjkoTN3r29SXKaBaLU3L///9uBq1TslrnDxUPUpz02CSfL5b
         /4tf5w2OUCpsiphNqJ7xZPhHivOwD+p/bG8TfDgJhshnjRbhg8n0DdQLZCgoafn0eZzS
         q44tMl39NzSStKSe+GQwC+LMwtt3RUGrbpFy2LUfDp6g9lTPuD9T3ZDFvPTFbhsS8Pbd
         4Ro+CZ0Ua6iEnPF9z4CNuJu8VsQtJAAzD1WA1Kwd1o6wbzMyQ/T2hB/2Nvm70yYSiTVe
         D4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747484799; x=1748089599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x5yAWntb3VfhbgYC+JCKqeiNNaVXqVYmvsV20FMAdIo=;
        b=Fgb1gsMmUbqcAo6z6h5pVlfAKwJshqwWV4fQhhO7Pbkw/k3xzHGxpDFch2qrGC9/1M
         FdWxIKb3arp8bnXplfz0E4apMYpDoGfyLAib+SvljyqtmGxd/ebwBo13fc046MtgXuDN
         JbOzvBSFaSAlr8ATULRFeShqI1Zd+0t/sg8dLvCU1wXLkOrHYM5UPFGh8i2YglzM0bGt
         qqfz3Nt/3SSsAIFZCzB7KmFNbf2ll3e2qdGylBo2xN7mK5SsGuzv/hT1G9USFdsl+xBs
         TxS4TtrLJ2eA3r2iFlTolz/DFIO5ld5gh6a2R5kK9bTR+iE5ReiaZPdZHkmhWFxK4PpU
         ICLQ==
X-Gm-Message-State: AOJu0Yz3P0RaJsbNM9g9Wq1blPPI9m0YAlwAUxgbzYM6FEu5m38vww8C
	AKmoL4fbY9fEPMfacEgrFvzcWeGv6nci4MG6iUXizecZ4AT8zsjtLSFDrQZRfg==
X-Gm-Gg: ASbGnct/nnXeBLhyl11yWFNo0Ji7HdiE3lKMOFFLRP6+VysDeMp93TphYY+BkWZKopj
	fZgJ2VkZL6/wpSjZlEzTz3VN5Y0ofOgbfjCShzWbSz1+tGKvnMnUYDcQqkF2nGQxWqZzH495Pcn
	fZ8tliaz5FuEwWyFjp+Y6deIcaF+NlVZlFazLbqFcFP9i4jsfm41eqK8ksFs/hGwX/y5hujcprd
	k3Cmk8WhxNFzZlV6nGPPKI+9ZsCdrH8uVzRmjNyoM8YMPucdjr8+o9YKRZlUYSzTyF9pTKZ5jui
	VgnBCtdOi/80MnKpIL3K6dMG3CKMz1wIbf2SU6pyJ61zkfRP/qY6H4nvM3sTgXU=
X-Google-Smtp-Source: AGHT+IGE0rVDXmzVjgexCXlgQX6IyQyYqChabYqFzHMOKl15H8ih/+YySwizUaDtjzNyr/iUOUIlzg==
X-Received: by 2002:aa7:cd5b:0:b0:600:99ba:2217 with SMTP id 4fb4d7f45d1cf-60099ba27eemr4673347a12.16.1747484798888;
        Sat, 17 May 2025 05:26:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e6884sm2876604a12.46.2025.05.17.05.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 05:26:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 4/7] io_uring: split __io_cqring_overflow_flush()
Date: Sat, 17 May 2025 13:27:40 +0100
Message-ID: <eba950e086695f6d9a45819e41f881bd4765aee3.1747483784.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747483784.git.asml.silence@gmail.com>
References: <cover.1747483784.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract a helper function from __io_cqring_overflow_flush() and keep the
CQ locking and lock dropping in the caller.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 57 +++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fff9812f53c0..a2a4e1319033 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -617,56 +617,63 @@ static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	io_commit_cqring_flush(ctx);
 }
 
-static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
+static bool io_flush_overflow_list(struct io_ring_ctx *ctx, bool dying)
 {
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
-	lockdep_assert_held(&ctx->uring_lock);
-
-	/* don't abort if we're dying, entries must get freed */
-	if (!dying && __io_cqring_events(ctx) == ctx->cq_entries)
-		return;
-
 	if (ctx->flags & IORING_SETUP_CQE32)
 		cqe_size <<= 1;
 
-	io_cq_lock(ctx);
 	while (!list_empty(&ctx->cq_overflow_list)) {
 		struct io_uring_cqe *cqe;
 		struct io_overflow_cqe *ocqe;
 
+		/*
+		 * For silly syzbot cases that deliberately overflow by huge
+		 * amounts, check if we need to resched and drop and
+		 * reacquire the locks if so. Nothing real would ever hit this.
+		 * Ideally we'd have a non-posting unlock for this, but hard
+		 * to care for a non-real case.
+		 */
+		if (need_resched())
+			return false;
+
 		ocqe = list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
 
 		if (!dying) {
 			if (!io_get_cqe_overflow(ctx, &cqe, true))
-				break;
+				return true;
 			memcpy(cqe, &ocqe->cqe, cqe_size);
 		}
 		list_del(&ocqe->list);
 		kfree(ocqe);
-
-		/*
-		 * For silly syzbot cases that deliberately overflow by huge
-		 * amounts, check if we need to resched and drop and
-		 * reacquire the locks if so. Nothing real would ever hit this.
-		 * Ideally we'd have a non-posting unlock for this, but hard
-		 * to care for a non-real case.
-		 */
-		if (need_resched()) {
-			ctx->cqe_sentinel = ctx->cqe_cached;
-			io_cq_unlock_post(ctx);
-			mutex_unlock(&ctx->uring_lock);
-			cond_resched();
-			mutex_lock(&ctx->uring_lock);
-			io_cq_lock(ctx);
-		}
 	}
 
 	if (list_empty(&ctx->cq_overflow_list)) {
 		clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
 		atomic_andnot(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 	}
+	return true;
+}
+
+static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+
+	/* don't abort if we're dying, entries must get freed */
+	if (!dying && __io_cqring_events(ctx) == ctx->cq_entries)
+		return;
+
+	io_cq_lock(ctx);
+	while (!io_flush_overflow_list(ctx, dying)) {
+		ctx->cqe_sentinel = ctx->cqe_cached;
+		io_cq_unlock_post(ctx);
+		mutex_unlock(&ctx->uring_lock);
+		cond_resched();
+		mutex_lock(&ctx->uring_lock);
+		io_cq_lock(ctx);
+	}
 	io_cq_unlock_post(ctx);
 }
 
-- 
2.49.0


