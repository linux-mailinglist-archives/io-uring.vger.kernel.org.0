Return-Path: <io-uring+bounces-550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 634C384BAEB
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 205D3288F77
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DAC134742;
	Tue,  6 Feb 2024 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="shsoSwgN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C812E1ED
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236869; cv=none; b=XtH+GaHK093awGJ4UwuQFl0Y+NK7Ds3B2eyneDLv65xx0QJzF+dqE2k27CiM8xixXAhyRWpTSP1hwSdAvdKgr481XBMYq1xLD+HyoshyaoV+L+OSHubVP6ZnYMcKxD8GMxPU6FtbG8aRspAZf7V8SNZtIo+lrSc0i+VhwJjpK84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236869; c=relaxed/simple;
	bh=DlYjb0sbIRkTLLxGvUyzYN7iueaFJ0VjPTWMKSPeDpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vr8yEp3yaxe5EkTSOEONo4uamLQ3D3Cbnw5LkXXecp5cvKBa8hAkxwFRPxrHdjeVH2A5WqtsCj3cftuYUdBhh86qtodyjDFk2F9tKrodpaNsbOoZPAJLfmusfa9gMArwIWkKi8BfXYpdvply5t4RUFhJSVIdJmpDW7+3msGOkYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=shsoSwgN; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso74155239f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236866; x=1707841666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiutwst3+hWMfhhEkUvjQCiZBWfne+AuIbP8Pq0y0gY=;
        b=shsoSwgNjTzlcdmYVD0LPM5idr63Gxjo/SYtdSF/W7v2HREyo9O5gtixfhl1wwwmqI
         guIAaD5NwwqtH+pAd6fN5ZjQSNOxljmRpgIqUpbwJo0q261qZvTagd5S0NueDlmWWQ3x
         mupDMxmdlg0BPTvqP+BMNDUpqlnM3PE/UU8FfZmV8UMnKXk6wiBxoZdpxZyzmQ+J+P1c
         DDFmalhZyVQFrfaUess+NpG1Tk2UCD27wRsw1h0rtk+vzASAMZpOv6On4p7nK+QDG2dD
         w5dy5zH8LnCWaWnJ0+jieMyuf4ADZ1bI7fRs51J4D/mh70BfZ2xkX9g4HX/pnIBq/1QH
         ia1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236866; x=1707841666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiutwst3+hWMfhhEkUvjQCiZBWfne+AuIbP8Pq0y0gY=;
        b=wrk8xP7pKIbQBUb5t0GaKL+Vo4q30xRUzvZpG7SG0GKbRFW3iR4J9cLj2QZhD+uh0l
         SbpeeNf/BN3x0mM+5tNU6It6kSYcXZY+lqF0DyJQDVpOBVhL7Z2jOaiA685bpEsDZTap
         pi7sU3VI3i8RfHdYFMSnRxMxm2qoJgesBQuiqtj2QGIjhmTWs9ewPbHSo+7kTZzycdb8
         U9qoooo24OnH9Z6b4jQiIzegt/qwB8MH2xeHIjWAvK6I5bH9qa4H2k/JtzXh6ibF2mRx
         0Wxdr3vTPfwYFTJZlCkwcQ6MfjO+wmIdm5wzvhrYdbcCDD8sPFk3WxQ8UdNSDm/p2wK1
         CS2Q==
X-Gm-Message-State: AOJu0YwgAB7JCtjVIHWcAfygP01yu8QKoBRjayLuvHwrAHNBDHhGk82r
	5ybq6CxryOnDkokvFp5h8M6O3UhAJMm3UisRzfVcB9a3JycPlBIFihB2JAQtpsd2WwISdI5onYh
	gHnM=
X-Google-Smtp-Source: AGHT+IH2mYCGJZEwqv2o/uOY6+S1TNfy2cU/9OPAxHlP8zVezDaAMxBo24HLfrYDJzn1rLuCE9iuTQ==
X-Received: by 2002:a5e:990c:0:b0:7c3:f75f:7b12 with SMTP id t12-20020a5e990c000000b007c3f75f7b12mr859245ioj.0.1707236866314;
        Tue, 06 Feb 2024 08:27:46 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/10] io_uring: pass in counter to handle_tw_list() rather than return it
Date: Tue,  6 Feb 2024 09:24:43 -0700
Message-ID: <20240206162726.644202-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, just in preparation for returning
something other than count from this helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index df02ed6677c5..20421bf36cc1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1173,11 +1173,10 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 	percpu_ref_put(&ctx->refs);
 }
 
-static unsigned int handle_tw_list(struct llist_node *node)
+static void handle_tw_list(struct llist_node *node, unsigned int *count)
 {
 	struct io_ring_ctx *ctx = NULL;
 	struct io_tw_state ts = { };
-	unsigned int count = 0;
 
 	do {
 		struct llist_node *next = node->next;
@@ -1195,7 +1194,7 @@ static unsigned int handle_tw_list(struct llist_node *node)
 				io_poll_task_func, io_req_rw_complete,
 				req, &ts);
 		node = next;
-		count++;
+		(*count)++;
 		if (unlikely(need_resched())) {
 			ctx_flush_and_put(ctx, &ts);
 			ctx = NULL;
@@ -1204,7 +1203,6 @@ static unsigned int handle_tw_list(struct llist_node *node)
 	} while (node);
 
 	ctx_flush_and_put(ctx, &ts);
-	return count;
 }
 
 /**
@@ -1263,7 +1261,7 @@ void tctx_task_work(struct callback_head *cb)
 
 	node = llist_del_all(&tctx->task_list);
 	if (node)
-		count = handle_tw_list(llist_reverse_order(node));
+		handle_tw_list(llist_reverse_order(node), &count);
 
 	/* relaxed read is enough as only the task itself sets ->in_cancel */
 	if (unlikely(atomic_read(&tctx->in_cancel)))
-- 
2.43.0


