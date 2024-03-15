Return-Path: <io-uring+bounces-960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F9587D057
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 854001C21456
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D231405FF;
	Fri, 15 Mar 2024 15:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0KO2kzj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED564086B;
	Fri, 15 Mar 2024 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516682; cv=none; b=OUZOWyJmi7E4G28jCOEhlXApsH2rewUBt8wqy+/Tmq/zuc7qHKntcp3Krc7CwL0eLr3wBtZZVlP27xjFpDd1g14j/yEtuG3pbn6YCe8oJAqJaNC2gP4MHykwi6SyixGJEbg1zRDSjseQQxMFl6K5wxgYbDnbl4ZkItkbmecbYs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516682; c=relaxed/simple;
	bh=pOxqMnA5//xNqR/l/9qyCO0QVi0Nf7fBsjJO69oEKZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdM/oDyztSFAZmJw/qENUvaaF2xeqbY/1QoQUYu5M4AJh3BdJ4Sj3YV16Soc2Ck1uOuzQGb5hkdYbwZroXH4sV0TgE9orcPS92Fkq442jQjpkAseqdFTRyTYsvHgKIGJUbVxFAasOoCMGCTRiscEOZFmtcL6xSMMijCAUXy5J1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q0KO2kzj; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33ec8f13c62so1332118f8f.0;
        Fri, 15 Mar 2024 08:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516678; x=1711121478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E0rH3o8gsWbVH7l8R+hddelxY97sk4QbAKjhLNyqc/Y=;
        b=Q0KO2kzj3UDjer2cUOkqsfMSpWb0WN0e0bx46wYe6Fv2pVPHTaFeSjKMmseVWgZ0bU
         NqXyo+CuHdolif3ixyCQqfjw9MX3zpdR/wgl3JXzcjyZNvGLrHj1pqOE1LhRiUyfSoc4
         Xm/8JaEj4MR7z2Qyir7AQ+mq+YnqefhJpGHTJp9CsvI6PRmXBSDRAvw1vkT7nj740C5W
         3BGLJ+G0gJH0lZXrNZctdVX0ZP14wOSo27Lvbp6XZ0RofVugZXbHlwesztSR96kGxm6j
         /Vj2MSxW9ablCffJNHiIPxhytbQNkwGQ3MPTlnZvuyNlSyQkDjbTTqGe+Se82UEj/RdA
         QuMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516678; x=1711121478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E0rH3o8gsWbVH7l8R+hddelxY97sk4QbAKjhLNyqc/Y=;
        b=Y9uJqgSOGEAu3FzDJxhuijlW1fffv0P/R3VSpxMfYqTSi19PMTZhbiLdc19DJ1Evrj
         GDrjAcO/pJN7A4n0VLzbiwf8NZuh3IaSrcXJWKUM535Th6uOWr1/Ja0LHtEM98X66tyy
         Z1+m/6+m6J2GVUf97pin3tYBqcN4kv5ufPrmpBlFEHwpNOPdHvkh6MSL4ancrJ/kEmVj
         JZIntbGj6/ZUcG81+Z99G9gMt7nCNQwCq29GpQ9LZgYD1G+H6ItVYP/5Y7eeCBMzeHYT
         8aKPLfZuCqqKApHeg0VlgdErv8uF8irvEFaMQUBQR41V2BXeHm9imNZxKHbsJa38BX0g
         7e7Q==
X-Gm-Message-State: AOJu0Ywo0DaqKZa8t+iv00cIMwPQoFBIL7ogrrDKIb1IeOQaVFwgaw29
	6REM1Arj3GmOQ4LW7Sidp1pnHbm+SUSmriiotID4gaaEY4MNuG+qvNVNh3cx
X-Google-Smtp-Source: AGHT+IGMIhW+A9ETRPyFAXld8B50pHwELGumJxK14YyAzes6IvnsEUiztGAiRG27dVnZNImv0tC3uw==
X-Received: by 2002:adf:e253:0:b0:33e:d244:4870 with SMTP id bl19-20020adfe253000000b0033ed2444870mr1707979wrb.59.1710516678577;
        Fri, 15 Mar 2024 08:31:18 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 08/11] io_uring: force tw ctx locking
Date: Fri, 15 Mar 2024 15:29:58 +0000
Message-ID: <1f7f31f4075e766343055ff0d07482992038d467.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can run normal task_work without locking the ctx, however we try to
lock anyway and most handlers prefer or require it locked. It might have
been interesting to multi-submitter ring with high contention completing
async read/write requests via task_work, however that will still need to
go through io_req_complete_post() and potentially take the lock for
rsrc node putting or some other case.

In other words, it's hard to care about it, so alawys force the locking.
The case described would also because of various io_uring caches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ad85460ed2a..0cef5c4ddc98 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1191,8 +1191,9 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 		if (req->ctx != ctx) {
 			ctx_flush_and_put(ctx, &ts);
 			ctx = req->ctx;
-			/* if not contended, grab and improve batching */
-			ts.locked = mutex_trylock(&ctx->uring_lock);
+
+			ts.locked = true;
+			mutex_lock(&ctx->uring_lock);
 			percpu_ref_get(&ctx->refs);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
@@ -1453,11 +1454,9 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 
 	if (io_run_local_work_continue(ctx, ret, min_events))
 		goto again;
-	if (ts->locked) {
-		io_submit_flush_completions(ctx);
-		if (io_run_local_work_continue(ctx, ret, min_events))
-			goto again;
-	}
+	io_submit_flush_completions(ctx);
+	if (io_run_local_work_continue(ctx, ret, min_events))
+		goto again;
 
 	trace_io_uring_local_work_run(ctx, ret, loops);
 	return ret;
@@ -1481,14 +1480,12 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 
 static int io_run_local_work(struct io_ring_ctx *ctx, int min_events)
 {
-	struct io_tw_state ts = {};
+	struct io_tw_state ts = { .locked = true };
 	int ret;
 
-	ts.locked = mutex_trylock(&ctx->uring_lock);
+	mutex_lock(&ctx->uring_lock);
 	ret = __io_run_local_work(ctx, &ts, min_events);
-	if (ts.locked)
-		mutex_unlock(&ctx->uring_lock);
-
+	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
 
-- 
2.43.0


