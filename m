Return-Path: <io-uring+bounces-7974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94419AB6540
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 10:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 510F618954B4
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 08:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479F1219A90;
	Wed, 14 May 2025 08:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHvlSSdE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF5A216386
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 08:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209984; cv=none; b=gKTB3nf7baq+Rrt9TSQpEW1ainhX2r8uGzKcXryO2bAVTHeOIeWPA3b4YPmqzulI4Y+XoqBWoL8a4Va/PxZBsWnhcyziWwx6A3Mb6eBmxRxKrTEZHhT+nuWGzOHS/Y/Q5sW+gAoQjoNltjXEsPPHB0E1M+piKOTtGr5HN0F1dd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209984; c=relaxed/simple;
	bh=204pmrYjTfgBN0mS2MdJhJIdCcMi5belC1jnHSvLhdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNWPFBTh18YabzpV1Q2QFZZmFdSduMaHF/sSjYHi5a9i9DgRQdd9fZy6yssD3R/6bstm3JX+gqboRfRI51yBhpZG7nDZtJHyrVIhP56QhjWDeXM/zaxM6E5YpIo/Kk1NWFB5T6F4klO39SUIAlHB3O62QdEFP/Z1nPuWyJuFdFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NHvlSSdE; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5fbc736f0c7so1691767a12.2
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 01:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747209980; x=1747814780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+j4bbviRRSShgMw1jC9iBGi3IVPPNSQKVGpKLTB5Kd8=;
        b=NHvlSSdEfgu+VFYcynRJ7RvfdjXuRy3ZP6CH5H8ZizjRKo2ZnPJe8wafPSOhJdeurg
         SEqfNvKcspGaetK/SM2TXdJNj8gn2/CTutysZT06Gkbf1Kmya4rmOP5QWOWmsofymH8z
         0+IJOSb1nrTG/nYTH60jQw+BsCdkl/QzDpywQlkvug2+2jRYU3uRYtPKREuLJ+cfMwEc
         KyLtgjU3wkqj3OxTxJGW7zOSx4dqw5M0SC6uylAIqSMXOMoYkQjJ+QiiLq8SV6+E39Vk
         Fsed7ju6or/RhZ8LvgOvf/Mv5CyDP9qom7kQBwDFleuPMeXmPkiCjuVh5nlNX0J2ADNu
         netg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747209980; x=1747814780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+j4bbviRRSShgMw1jC9iBGi3IVPPNSQKVGpKLTB5Kd8=;
        b=gB8rvYq2Jxgkdso+ryQW636hBGMRo0agkvT9KgO10UGFKyrf0x77PZyi2i8UveJyHH
         53WmwHqbDB/f6Wt1yqfAZiWmazQtl7dRJtZDF6X7kUMqVIlA/AbiA8c/L3D93FARdh3i
         UNnnOmsVJPrXcOMZy2PqWVgXJzNnsTugpVR6HdXGtrm7jQ7tWpXVL3MoM2e+48aAty2H
         SZkqv853mWHGDRSGJWUHvHQ/vAilU89p2beUGM7EbPDqhMiK3WS/RMeZWyEbId60CT2F
         rrJXcFxST5088AN8c70vJY0nh69xn4NLSDssC5YnwYAUZpfwL+OFaE6FQ5tpSCyO8kLF
         DgMQ==
X-Gm-Message-State: AOJu0YyPlW3KCOpvZWTDAW+RJkW6tyJll2qnbRmWVgsNi6WqkEZGZqZ+
	XLGzk7EguLyLsjO80p0bekcF/jHfEMhZjCqza1ckTtbhVJ2a+dw8c9GRag==
X-Gm-Gg: ASbGncu8WArGe6IH/gqg0BgrsT0n/mMZ/nc6JIAtdmrsXfxEuQeHiJpXGvT5t2SwF+x
	X3NfabEHNsHBN0yTbtAA1L1UFg/GVX/dJu4jrUl+YEabAOz1jVmoSKPPVJhx5j0EOieQsmMRPhR
	cOgFhmrH6KT4Ih81CDhWis2n42cVQ/4jwkS4FDcJxcBYRGsJPKC52XK8yuXByWAqgM9bPF7UkFK
	12cl2wHXsZvVd8dYWl/SEj3MFt2KjmSec5k6XWSep8oh9+RPZ1OZJM+vJywvhMULEyZu2S79CSh
	Oq7xThBrgd0NhqYx96YlwwaKmKI40pp3jPQ=
X-Google-Smtp-Source: AGHT+IF42meUi5LmZ83mn1kogTG818AqyZo2hGZSmYKO3CH9U7XEoyPoMqiGT2gxAvCswjJLTByqwg==
X-Received: by 2002:a05:6402:254d:b0:5fb:1bd8:2f95 with SMTP id 4fb4d7f45d1cf-5ff988dd383mr1631401a12.29.1747209979733;
        Wed, 14 May 2025 01:06:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ee61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fd29adb7absm4969579a12.32.2025.05.14.01.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 01:06:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring: move locking inside overflow posting
Date: Wed, 14 May 2025 09:07:21 +0100
Message-ID: <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747209332.git.asml.silence@gmail.com>
References: <cover.1747209332.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation patch moving locking protecting the overflow list into
io_cqring_event_overflow(). The locking needs to be conditional because
callers might already hold the lock. It's not the prettiest option, but
it's not much different from the current state. Hopefully, one day we'll
get rid of this nasty locking pattern.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 53 +++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 068e140b6bd8..5b253e2b6c49 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -718,8 +718,9 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 	}
 }
 
-static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     s32 res, u32 cflags, u64 extra1, u64 extra2)
+static bool __io_cqring_event_overflow(struct io_ring_ctx *ctx,
+				       u64 user_data, s32 res, u32 cflags,
+				       u64 extra1, u64 extra2)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
@@ -760,6 +761,24 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
+static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
+				     u64 user_data, s32 res, u32 cflags,
+				     u64 extra1, u64 extra2)
+{
+	bool queued;
+
+	if (locked) {
+		queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
+						    extra1, extra2);
+	} else {
+		spin_lock(&ctx->completion_lock);
+		queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
+						    extra1, extra2);
+		spin_unlock(&ctx->completion_lock);
+	}
+	return queued;
+}
+
 /*
  * writes to the cq entry need to come after reading head; the
  * control dependency is enough as we're using WRITE_ONCE to
@@ -825,7 +844,8 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (!filled)
-		filled = io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+		filled = io_cqring_event_overflow(ctx, true,
+						  user_data, res, cflags, 0, 0);
 	io_cq_unlock_post(ctx);
 	return filled;
 }
@@ -839,11 +859,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 	lockdep_assert_held(&ctx->uring_lock);
 	lockdep_assert(ctx->lockless_cq);
 
-	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
-		spin_lock(&ctx->completion_lock);
-		io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-		spin_unlock(&ctx->completion_lock);
-	}
+	if (!io_fill_cqe_aux(ctx, user_data, res, cflags))
+		io_cqring_event_overflow(ctx, false, user_data, res, cflags, 0, 0);
+
 	ctx->submit_state.cq_flush = true;
 }
 
@@ -1432,20 +1450,13 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		 */
 		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			if (ctx->lockless_cq) {
-				spin_lock(&ctx->completion_lock);
-				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-							req->cqe.res, req->cqe.flags,
-							req->big_cqe.extra1,
-							req->big_cqe.extra2);
-				spin_unlock(&ctx->completion_lock);
-			} else {
-				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-							req->cqe.res, req->cqe.flags,
-							req->big_cqe.extra1,
-							req->big_cqe.extra2);
-			}
+			bool locked = !ctx->lockless_cq;
 
+			io_cqring_event_overflow(req->ctx, locked,
+						req->cqe.user_data,
+						req->cqe.res, req->cqe.flags,
+						req->big_cqe.extra1,
+						req->big_cqe.extra2);
 			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
-- 
2.49.0


