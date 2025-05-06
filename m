Return-Path: <io-uring+bounces-7856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF799AAC45A
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BA66B2158A
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B6E280324;
	Tue,  6 May 2025 12:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ixfhgL0E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DF7280A4E
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534588; cv=none; b=iC0/PBjaP7zoKWvWhAjKJeHwx5XW1tJTNJfoFrUbVjsBmfBv1+PafsZtlSsuxIN01CLURYNYHBkheScQSwrewRpFcsfhqjzX3CleMBy4wH4scRpZl0aQejDweqFVeTzpTZVUOLk/KkWuz6JeIWtalvzAImNmnkwvwneOaPJqfBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534588; c=relaxed/simple;
	bh=meJy6KbGUjPfFbw54GnWDogMmALcJtOokVF8w1dJZU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OZrqlQ50+qTSq8lN2F4NqbLFl2EzWry0O3mr06jgV5RPP39/pkJBaq66C3T2REfQ+jE6pUiOrwonDDvL5CHism8zbYJKPN7dtZNjqUf9sXmKllW5cpOrTWlJnSrZDcw1ogk0BG7NzurgRUanCobsAE/EokiXWIsZQtmTx6i6XdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ixfhgL0E; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5fbcd9088a7so230638a12.0
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 05:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746534583; x=1747139383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HMhTCDj7eVr1atYZViac1HFl/7zT+OFH7Bcx2BLoaoY=;
        b=ixfhgL0EKgmL4bmTKK1M1JH3E93uBvhzKJjMW1Ii8dzU18uPZhk338ZslwvUfkZ3r2
         j4WLWmv//GLwn97eFBaVudZ6+Xi54IZv/+cg/0zsWN64rrfWh7xdCAY8VLXk0Ky2KUWK
         RHULnkqu/CSNLQ8qnOvd7utddoSXuI7i4sH47mcI4UMkb1+BCoNzG5l7pPF0NAMRPuZF
         bA1vRa/r+Fs3+4zt2NE6nQhcZDXozSW3BW8QwJOlU3UdvKfFcD+79U64mZxiXP8e94RF
         ZXggkZcGd7l+Uewe1eluabRYWbYSnFL3B8Lc8gBER586ReszxUOlc0kspK49LzI/8z4S
         9t+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746534583; x=1747139383;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HMhTCDj7eVr1atYZViac1HFl/7zT+OFH7Bcx2BLoaoY=;
        b=e0EUnEEtFVqlJr/ytuv/hDN04tTi4iyTa8/iriwgkoqIiiiP3H32B9SW0HTJfh/IQK
         eqo+l1CZoJNF6Z4cXuY/doDOt2Bl04/WA4+LVhiZnfR2XrPWoWv2CIoI+4JKW98ERNaH
         hQ2L8gPtTqQl8mkoQju18uW86CqwwW8sSyLvUrMpp7PmV+/VGDsd0CYv3kzmIE15OsNq
         +9fzLOHDvfaVce5UGhYNG6nMh8EWuMeyXt/cazHWmdfQA1nyP+KPZetZ+3e5OQ60UYTH
         gNdPS2MpYvqMqAqq76QSHQcsC05D3mgRNgZsrDa9qladVr59OTb4yfknpo1TS03RiF/8
         yOwg==
X-Gm-Message-State: AOJu0YwXNYm+ozVpxjosAiek9txLvnJlJ+ex1KnZaKWCpY1QkxVMPvxq
	Ti9dYuWHyFAHr8ErNSCFH6wPrhfj8qdtGeD38ANOT3RDs+eTyfUdxwyyrQ==
X-Gm-Gg: ASbGnctqW+IREe/ZcCOVvgba597JO8GApawJTZZXPD75/MVT15AzCBR2euhpKelFXSk
	dqBUP02AT3/miTbA/bnK0IaH4OV5fNeDuO+LoztgdnLuhA17/RR4Koqb+YORfkB/zh6waDyIplY
	WcgDIEH+gd16/yOXFQYWo1J+ruWfLSGhu8OBlnhOdHFuq+nWARJf49/WAM0/IujddsuRWJIcgMm
	ExNwIiHUctTR74S7q+SyTwmNbAjmnjgfKHViEPW1OkcMUnFTqPm6C4ypl+59GXqoraPOGwH1cPz
	1+ab/TO+IrDgaoXDyGzOlX81
X-Google-Smtp-Source: AGHT+IEH6K3M4uIwnVFeyNhvH+mIT9mTLFeC2hpHMnFA1HDSboBSt6LAPqfQHdYFVPk8z2AHeK913A==
X-Received: by 2002:a05:6402:d0e:b0:5ec:6feb:5742 with SMTP id 4fb4d7f45d1cf-5fb61a2e3a5mr2656240a12.16.1746534582978;
        Tue, 06 May 2025 05:29:42 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b5bd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fa77b914b4sm7389623a12.51.2025.05.06.05.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 05:29:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/timeout: don't export link t-out disarm helper
Date: Tue,  6 May 2025 13:30:47 +0100
Message-ID: <1eb200911255e643bf252a8e65fb2c787340cf18.1746533800.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[__]io_disarm_linked_timeout() are only used inside timeout.c. so
confine them inside the file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 11 ++++++++---
 io_uring/timeout.h | 13 -------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 2a107665230b..a6ff8c026b1f 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -35,6 +35,9 @@ struct io_timeout_rem {
 	bool				ltimeout;
 };
 
+static struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
+						   struct io_kiocb *link);
+
 static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 {
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
@@ -218,7 +221,9 @@ void io_disarm_next(struct io_kiocb *req)
 		struct io_ring_ctx *ctx = req->ctx;
 
 		raw_spin_lock_irq(&ctx->timeout_lock);
-		link = io_disarm_linked_timeout(req);
+		if (req->link && req->link->opcode == IORING_OP_LINK_TIMEOUT)
+			link = __io_disarm_linked_timeout(req, req->link);
+
 		raw_spin_unlock_irq(&ctx->timeout_lock);
 		if (link)
 			io_req_queue_tw_complete(link, -ECANCELED);
@@ -228,8 +233,8 @@ void io_disarm_next(struct io_kiocb *req)
 		io_fail_links(req);
 }
 
-struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
-					    struct io_kiocb *link)
+static struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
+						   struct io_kiocb *link)
 	__must_hold(&req->ctx->completion_lock)
 	__must_hold(&req->ctx->timeout_lock)
 {
diff --git a/io_uring/timeout.h b/io_uring/timeout.h
index e91b32448dcf..2b7c9ad72992 100644
--- a/io_uring/timeout.h
+++ b/io_uring/timeout.h
@@ -8,19 +8,6 @@ struct io_timeout_data {
 	u32				flags;
 };
 
-struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
-					    struct io_kiocb *link);
-
-static inline struct io_kiocb *io_disarm_linked_timeout(struct io_kiocb *req)
-{
-	struct io_kiocb *link = req->link;
-
-	if (link && link->opcode == IORING_OP_LINK_TIMEOUT)
-		return __io_disarm_linked_timeout(req, link);
-
-	return NULL;
-}
-
 __cold void io_flush_timeouts(struct io_ring_ctx *ctx);
 struct io_cancel_data;
 int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd);
-- 
2.48.1


