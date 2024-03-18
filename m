Return-Path: <io-uring+bounces-1121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F7687F2D5
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 542192812A1
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18AB859B6D;
	Mon, 18 Mar 2024 22:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jq9pgAKe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568AB5A4D8;
	Mon, 18 Mar 2024 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799343; cv=none; b=igM3/YbNNev4jRQ2RiTa0Kknc+3+wLMFFcD2ZB7XwKZ3FAo8Mv5kD4gjUbmjr9V2jVDMO2cAosMDlRutMsaUcSSdkQ9Zy+jmxJGMinzn2YHmSt/cF2yxZNiC0sUhi68dsK5MFg/DjnwL8diAMTDZ3LGmbkL3B9q+HusscN1Zat0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799343; c=relaxed/simple;
	bh=Ae97tVzbWkRAu0LFf9aZ9RBHFn37wBgTKbXqflC4/ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJV2Bb8rcDZ0SLV/4kTY4qC7dTxj3AEyI8Hy9WYfdUSU9Z/8XnW5gQdD2F7xR3Nrj8rdf+7PGTA/+XUxCb2zkmkpal25VsI15K97aVtJnIbznV1T8S74HIUK5nbSSGx/S0vAt0supXRmoEarPS3onq0wDMgr7jKQouB5SPquqeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jq9pgAKe; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33ed4d8e9edso2026543f8f.2;
        Mon, 18 Mar 2024 15:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799339; x=1711404139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcROH2LXl8gKrYr6qUKYiPVrUt+epYbzK5tF/Y3MseE=;
        b=Jq9pgAKem6APyf9gZq2lsuYVZSEeiInBsyDv8XVP5vlVckoxiZzUorTu9/s4r6FOTB
         S+22suEQBTkSTMp5wSTTjYvZuJizSkyyBJCwGa3BcwPjs7vG/DpmSefaPErwQfllJ3Q/
         2X/RFQmhBPPn9FDW46gj8n34akigfLVhL4p4Pgv51vYdPjogl3ujtk9l4lkppW876Eg4
         w6c0rKmaKsyqIfQnWXzKHwFLZJZoS9law9waqhZN+AEETYYrbP+rlzIV6nFRkgc55k4l
         GAX6FdQo/LF/Hn80YmCyFSijrOpRZw1gwBK1wlpitQcSIjThKz0XJ2+9OHOUzzhSRU++
         4Aog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799339; x=1711404139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcROH2LXl8gKrYr6qUKYiPVrUt+epYbzK5tF/Y3MseE=;
        b=EvP7oOnMdVd3Hc5HJaSj7IHvm2xYnZQWG4sWb+KwYAD3BbwZTOlUmnLRNyhqIyVhPP
         llKLexi9EhY+e3L3EZenZPYafiEG8tvWmsOPOQOB97QyDoQqOLSakNwDnWpov6sK1qvD
         pwmF/mZtOCocXLdV02qcxzdVrJNahGTXG0SQzJbZCMJ2odG9Qa0qedjv8w7cFS6YPGHH
         +hmo9gTSuWU88yx6FoUlpjbt9vFqDwtv7dN2E2PwykulmDXwWFNTU9btcaSiORS0AOsJ
         OMUiNG3NgZIHeAPeky/iE9Jl3FyjQIVWLmQq3OyPUrrTEM0bJUsF8/0ulnq4Um8ixp5v
         4dMQ==
X-Gm-Message-State: AOJu0YxyIaGByqBu1NshC6E7+Y28p0BZFAmq86Wdq9ei7+Ob3hwHczvD
	oFzk+WXJAjuOp5w/dpac1StrtF73mCf4DBfxNyduwYbvj29fDoCeYUh/kH1Z
X-Google-Smtp-Source: AGHT+IGXgwHD5pHiwwmQT18GEQKxv6BNPQAqIYvsLZnQWeRdzzw7fpBEHTCqH4kr+zOOtQ/U8RWLxg==
X-Received: by 2002:a5d:5051:0:b0:33e:aea8:6969 with SMTP id h17-20020a5d5051000000b0033eaea86969mr10272351wrt.27.1710799339086;
        Mon, 18 Mar 2024 15:02:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 07/13] io_uring: force tw ctx locking
Date: Mon, 18 Mar 2024 22:00:29 +0000
Message-ID: <6ae858f2ef562e6ed9f13c60978c0d48926954ba.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
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
index feff8f530c22..66669cc9a675 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1185,8 +1185,9 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
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
@@ -1447,11 +1448,9 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 
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
@@ -1475,14 +1474,12 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 
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
2.44.0


