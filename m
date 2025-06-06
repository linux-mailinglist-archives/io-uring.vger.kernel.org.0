Return-Path: <io-uring+bounces-8271-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6884AD09C8
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26246189E80A
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745FF2367BA;
	Fri,  6 Jun 2025 21:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GQUR4bNA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908D236A79
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749247002; cv=none; b=BHcFs15TPQmunbd1iDEGN692OaYHI3I3ft2cG8IeNILX8jJZGjwMUkT3yvUrW51HH3uZYBGsJRJlXEGpy8+VJRjQ1wJJzjBhBFP6Mn8vAyc9ZdHtuVyDcB651s/MF6kbzQao1Fr+ZuACips3C0jjzyyglYnkktN6Sr9R3x0qEl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749247002; c=relaxed/simple;
	bh=uM9itJ4Vhkppsk2GZPoXiK66BdmFNHwmPkwefnHt9HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elpLnRJ8rT/BDC4exb4e+XcDJAXpiUdYyp2j+pw23EVrnd/KLReDLrLM9cuwD++C/d1+1cKRsyAF22+EMZW2WJv7dg3w4kqRv1AWmKc9SmzFUumMkR+dtwTi/BvKqmd1icUmoVxWPGceo90WTLiQ/FuoWbOu0oS5Gusi8VoXpFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GQUR4bNA; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3dc75fe4e9bso11681685ab.0
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749246999; x=1749851799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bq5UVaO8WLAJ6L2WXHM9W8SxcYdD73ixpBtxoBMViTU=;
        b=GQUR4bNAPtuFdvg4PABKslGM68gFoZw6gBIdTZoMGxRJj4UOHKWsyiVqqRsXpgVJ2h
         G3UUoUiBOuZJaYGC3nO0Zz4fvpSQY63+SVUCLe1aFNg3V270RQX8o7HKjjHfBGqtQFM1
         eCkJ6bryv4gmT+Is8+yDqZ8u2JejoqVEILQSuke1ulPssjKa5OnCDc32iKscFBbXsolE
         t6doEN1Lun7ON/mvQMs45myP4PErNfcbR0dXnQB00tUoQ8+jSDDFhz7RckqmB4KKCqV0
         UgSHKri++MU6GDX7HdDQY1ZNz+X2i1luhUxgu72nZU8nspQ4wf2DjNpzWBzF8cPNoHi5
         soDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749246999; x=1749851799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bq5UVaO8WLAJ6L2WXHM9W8SxcYdD73ixpBtxoBMViTU=;
        b=uRf1mWMhaG5VRB5dgbZeYqcECCCvLGHsLzP0s+vAJjbN8e7FJ8rLIYZfmcqfbE3xb8
         UlV0g020OcabX0/4RJtM69D0Mqxc9siwE1VjB/rNNCKdhx9t25qkNzcfF4Yfzu/l7uep
         l6s+hbmo3kJPGtDum0CtiG/upBBUhJEy6bSE1Wyaic+P0W9MQyRJw36Ij2/5UJQuOTel
         LT9kb1Lhv3IoXX3ERVEfcZw5sJU2k/WOIMre0Yr/RKjX2F4zej/KMFTVLBg12cxH3fWp
         AWSZkjrY7nofT0OASaTuRoTfWShSZ6lbu30DQMlJTJgW6DWMT/hXKiINIxPNjI0NSW3f
         88BA==
X-Gm-Message-State: AOJu0YxemFaDCWihb0ij8p1Q/QHXSQusE++Y9kd8Yv1o9x+T1rOnJETR
	MGlq+jUxup04Q2QoUnflxhIb4mdef2+xwGzeUPqvl9Z0zcufRX4+eAsq/M0/l89ogtaVXmbQEfF
	SOrti
X-Gm-Gg: ASbGncudyPf8tTC7h3MrTjcuTDLKbP1khuA2Zw91xoBZnYg1FUcfJAa7gorTQoEdbsN
	tLhv9zhyG7ijihq+MYMiJTljGccT2ns7uL0afFOUNTH7lgd5nusryVyaUVPeF8AI1QwcfQbtRMQ
	jCaqgNp71qmwUmmoMSjZTI6KHMs2ZkasoJZYl/i8AF6raY+yALW+2uCrV+MEENLmN+dUVBCJHOH
	if22oCxhDPigqmHFwOvkVrdbhGqp5iAAm7Tixu+Yl3ARgPmATvZvOeB2zU7wRfA4wWLtG6owU4m
	mps+5v04yj99ddEbqLtKItuI4T7Z1ufNQ+i2WuY8TGYSzSBvvmHxpsYiKIDhn+R3CGA=
X-Google-Smtp-Source: AGHT+IHa64xCbIprejVku32m2URowAjFjCkU3M1GFsG5gBpsP+jkYx5ffm35g2CiE4ynu0+6T5mZDg==
X-Received: by 2002:a05:6e02:3186:b0:3dd:b602:88 with SMTP id e9e14a558f8ab-3ddce66f1ccmr54430585ab.9.1749246998960;
        Fri, 06 Jun 2025 14:56:38 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf1585bfsm5735105ab.30.2025.06.06.14.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 14:56:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
Date: Fri,  6 Jun 2025 15:54:27 -0600
Message-ID: <20250606215633.322075-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250606215633.322075-1-axboe@kernel.dk>
References: <20250606215633.322075-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Will be called by the core of io_uring, if inline issue is not going
to be tried for a request. Opcodes can define this handler to defer
copying of SQE data that should remain stable.

Only called if IO_URING_F_INLINE is set. If it isn't set, then there's a
bug in the core handling of this, and -EFAULT will be returned instead
to terminate the request. This will trigger a WARN_ON_ONCE(). Don't
expect this to ever trigger, and down the line this can be removed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 25 ++++++++++++++++++++++---
 io_uring/opdef.h    |  1 +
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0f9f6a173e66..9799a31a2b29 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1935,14 +1935,31 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 	return file;
 }
 
-static void io_queue_async(struct io_kiocb *req, int ret)
+static int io_req_sqe_copy(struct io_kiocb *req, unsigned int issue_flags)
+{
+	const struct io_cold_def *def = &io_cold_defs[req->opcode];
+
+	if (!def->sqe_copy)
+		return 0;
+	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_INLINE)))
+		return -EFAULT;
+	def->sqe_copy(req);
+	return 0;
+}
+
+static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int ret)
 	__must_hold(&req->ctx->uring_lock)
 {
 	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
+fail:
 		io_req_defer_failed(req, ret);
 		return;
 	}
 
+	ret = io_req_sqe_copy(req, issue_flags);
+	if (unlikely(ret))
+		goto fail;
+
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
 		io_kbuf_recycle(req, 0);
@@ -1971,7 +1988,7 @@ static inline void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags)
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (unlikely(ret))
-		io_queue_async(req, ret);
+		io_queue_async(req, issue_flags, ret);
 }
 
 static void io_queue_sqe_fallback(struct io_kiocb *req)
@@ -1986,6 +2003,8 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		req->flags |= REQ_F_LINK;
 		io_req_defer_failed(req, req->cqe.res);
 	} else {
+		/* can't fail with IO_URING_F_INLINE */
+		io_req_sqe_copy(req, IO_URING_F_INLINE);
 		if (unlikely(req->ctx->drain_active))
 			io_drain_req(req);
 		else
@@ -2201,7 +2220,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		link->last = req;
 
 		if (req->flags & IO_REQ_LINK_FLAGS)
-			return 0;
+			return io_req_sqe_copy(req, IO_URING_F_INLINE);
 		/* last request of the link, flush it */
 		req = link->head;
 		link->head = NULL;
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 719a52104abe..c2f0907ed78c 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -38,6 +38,7 @@ struct io_issue_def {
 struct io_cold_def {
 	const char		*name;
 
+	void (*sqe_copy)(struct io_kiocb *);
 	void (*cleanup)(struct io_kiocb *);
 	void (*fail)(struct io_kiocb *);
 };
-- 
2.49.0


