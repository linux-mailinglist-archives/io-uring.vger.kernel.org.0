Return-Path: <io-uring+bounces-3815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC859A433F
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:07:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D30261F2320C
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 16:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C512200B93;
	Fri, 18 Oct 2024 16:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5A3dbRj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B934207A
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 16:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729267664; cv=none; b=Nqhe0lEw6Jp/41jY77VP3QK2pDmCSm6ugKBzC8n49LOL1dYkb+91Rw/dpxVrrcFHACqiMGNKOsjY/zvbNiRr3N2ADStnMmM6qOLS88AiHGncmVRTE0VGbUy6Q8hJFhkzwaumLkbmYV28Io/ZPIyLhwZMBsUZ0j24fY13129CvMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729267664; c=relaxed/simple;
	bh=lahtz40P5VsxgarcwiM5yv2i4R6wsVj7HbDCDsw2d5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RPm0sOofsLLRNiGnYEjmkkq0pRK4iDDgT2MtbUTdZbDLTPWoefdxlDmb3Qh6zSiSKt2C/bWvwl2FQGFif820JqJ60han74m35axOIjZkYFdZZNlLvn9wIRFBispQKVnl2uSWlk/NJIeyxDErwu0JZpju4cYtetXjpe+/7AsSNe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K5A3dbRj; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c984352742so2444615a12.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 09:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729267660; x=1729872460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qexXWxFLItDRlI9IcBrD9DjbVVG0MB/dG8QTyI5k2cY=;
        b=K5A3dbRjB/xeVq+nGthPTyJiWLtOk9UJBhhFFmkZVqAgk6D9pOIZUwx6k8TDXL6LaS
         BuuNGPrRHDn5PMTxtw5M7fXHd+7UwmLtdehv0ApJyT+MTn83Dc0GFZ6PVTlxRW7PMieD
         NDbYp9/VvB282V1ACSK7RgVr3y1pv3uussjh7wll+5b4gWc8dGx/7da41pHdni4Q9hhc
         7hrjlIptJc3cjgFl4HxEIoRU5QaDtbMuVoiBRqXgZZMBRN/YeEOq5jBxoOfxa+melixX
         vczzVW5x+7Xiu/AtMveafq5GGYjc0MQvumYziB1Ousevtnxjl6qw5wJB1lpB10//c8My
         T4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729267660; x=1729872460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qexXWxFLItDRlI9IcBrD9DjbVVG0MB/dG8QTyI5k2cY=;
        b=DWtguz3gi7re70QSsko//9VFnEQgv7NaR/vtKDU2cMgnDjw4x+3wrRwW1FZFVRzxzI
         8a6HesgahS/TWUDZgtsC8DiGulhtYdsqFcyEp74g3CslNua0g/ZsV91QFykg4Ln7HuCu
         +s3J93jjywH87vnNcmSyKNf1Rig9ugmN6xAXl10DdEQPCIsre40gSV/1BILSXkioMDiH
         PWhvwqweRbghYx8NeTYBNAxj1RQGaadhslfTbFlh0QF50Xcur6ZKUD1tUag1FsJXdmNG
         kOF1NPZApnGZ6LgLzDoIC+mgZ5ye87R1XSWffJ27XyGl1idToORFtXnzbOtn7f2WyNSB
         NyoQ==
X-Gm-Message-State: AOJu0YyduHlJmFFaj1xv14ZWflL86CxzbYucO6Ac/Tz690kqxnQ84KUX
	1vnR85AkISgGnXsOoMjb0+DqgF7RH6WuuDx/+PERmtXueU/EdvFBNlhexQ==
X-Google-Smtp-Source: AGHT+IFGlJMbLaadM1QktFIsANE0r5UR0oSSPgwJP7C/gRKtw45dxVBMOvzQ2qE8VxfU5MR78pL9iQ==
X-Received: by 2002:a17:907:94d2:b0:a9a:4b95:d4 with SMTP id a640c23a62f3a-a9a69ccfffdmr269278766b.59.1729267659789;
        Fri, 18 Oct 2024 09:07:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a68bf5db0sm112503366b.159.2024.10.18.09.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 09:07:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: static_key for !IORING_SETUP_NO_SQARRAY
Date: Fri, 18 Oct 2024 17:07:59 +0100
Message-ID: <c164a48542fbb080115e2377ecf160c758562742.1729264988.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_SETUP_NO_SQARRAY should be preferred and used by default by
liburing, optimise flag checking in io_get_sqe() with a static key.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ed34f356d703..e253f0176d0a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -70,6 +70,7 @@
 #include <linux/io_uring/cmd.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <linux/jump_label.h>
 #include <asm/shmparam.h>
 
 #define CREATE_TRACE_POINTS
@@ -149,6 +150,8 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 
 static void io_queue_sqe(struct io_kiocb *req);
 
+static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
+
 struct kmem_cache *req_cachep;
 static struct workqueue_struct *iou_wq __ro_after_init;
 
@@ -2249,7 +2252,8 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	unsigned mask = ctx->sq_entries - 1;
 	unsigned head = ctx->cached_sq_head++ & mask;
 
-	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY)) {
+	if (static_branch_unlikely(&io_key_has_sqarray) &&
+	    (!(ctx->flags & IORING_SETUP_NO_SQARRAY))) {
 		head = READ_ONCE(ctx->sq_array[head]);
 		if (unlikely(head >= ctx->sq_entries)) {
 			/* drop invalid entries */
@@ -2753,6 +2757,9 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 	io_rings_free(ctx);
 
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		static_branch_dec(&io_key_has_sqarray);
+
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
@@ -3545,6 +3552,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->clockid = CLOCK_MONOTONIC;
 	ctx->clock_offset = 0;
 
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		static_branch_inc(&io_key_has_sqarray);
+
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
-- 
2.46.0


