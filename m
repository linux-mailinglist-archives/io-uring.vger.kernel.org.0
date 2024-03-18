Return-Path: <io-uring+bounces-1070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49BFB87E156
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3BBC1F21093
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2B6208CE;
	Mon, 18 Mar 2024 00:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9gBQCxB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B3B1F959;
	Mon, 18 Mar 2024 00:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722630; cv=none; b=mTBi4iHyJ89gemrF6R2bRo2G2+9/lWEC921hBnxBmEoh6wIlqfHOdnfuA8e730Hzj7uPmHP/icwhASPeFX9XbzfFA0CVAxTzvRu656YiIP0NBV7nha4pOSEJ/DVL2FcMq33EtFHwfzwjiXLwEoDilswY0uyjWZj34lMVA/HEcNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722630; c=relaxed/simple;
	bh=I4FA13dkgmmuNG4n0r1xczqangu1VhnefSMMGZSB7hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBDIaU8YOgw6b2Xn1d2k/blRI74TU/67P/pudAEFfCLl+wOQ+0jb759EEAqgrFoSaWy9wtfzNZiM6LconqB8w8PJo/ZD5sPaGZFlTfx0YLJWpavKNtX7N7TNQdmIC+JXpHfDSobJ8a17rCg73/hi7ajgIyD+73rWWSLfZiQEO3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9gBQCxB; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d4698f4936so54382991fa.1;
        Sun, 17 Mar 2024 17:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722626; x=1711327426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qQestWxBXECy7oXqcNOqOE6lZ4//y3lbdvEiKFWaNno=;
        b=I9gBQCxB295irkeWaHHJi5hQxSNST32BtBxBSmI5BvpFdiaxcVQJ9hmEthYEdH16cm
         4vFRtLI2K5esvwjyOtWAxLdJ322AYSyEX28BosYd76PDoeadi4jgiBp7fL5/qd03Lef8
         1bWzbw+6gC9ueMBFzYH7R5Ia/m38OLuXDEj9loPCCgrUBKM1qjaV+cg9NAQdFS2WfBeo
         0EvQGtc5qTaczZTBky13+ure5p6NMBM8JVb45lRdBMC144R/DleUHEB3wkRAz7+6tTw1
         IVaRjvs2JpUa6hZhQT2D+/CNTP4tVEWovcA9DpSFpg5uT6ddMA1jUSa7SyjA/tXf+uwp
         P6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722626; x=1711327426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qQestWxBXECy7oXqcNOqOE6lZ4//y3lbdvEiKFWaNno=;
        b=nc44i/G8aBvzI4DykDHzxBGe+OpGmEDf7XhSi2cGbNDPI+5IoThzGjpgqbhhoizfDT
         oVkt3aT/7l9UyBVNrnN6xqe+j+N5OqEPdwET8dZ0WBRDAp0ZA2mrfwkdAsApUp9U7HvG
         SaYt0Kg2vFR/FvT2iiFqPgAd/oLnITgH7oq6SrKTy0AaLdXtwnH3+g7z3d4Gr5b5QD1K
         loF1uJ/iXQ++BrZ0VHTjiA/ySTXkYkgVEjgYEA3qJWHm4HnRsXyxSd/Ts8s2Km4kbQhe
         TLjLWtumR1sFxB0R8bv+TJbERjEj2diD3NsUu91BPXYZniJxJOINqYD7okkf2NyYkOWO
         mF2w==
X-Gm-Message-State: AOJu0Yy6Z4FmqatAy8B6Q5mqj7tmsG/zaMO9F5F08M3Wd0vZMXIbxiSe
	Y4M0fLdqPrtArUwFc0Cei7wmW2X8GngoqCdvenloA2C8XUkZIkXI1NnNhPaC
X-Google-Smtp-Source: AGHT+IGMuz5hDsj9rZkOXR1giw06fXqQq6D5mJ5PkG3GWCbYHwpVFQHzT+cIJeEEpVyP+7ywIRvaDg==
X-Received: by 2002:a2e:95c8:0:b0:2d4:7285:b997 with SMTP id y8-20020a2e95c8000000b002d47285b997mr5968301ljh.27.1710722626576;
        Sun, 17 Mar 2024 17:43:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 08/14] io_uring: force tw ctx locking
Date: Mon, 18 Mar 2024 00:41:53 +0000
Message-ID: <49af41a9127c06a8133a371b59390e771b39bae4.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
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
Link: https://lore.kernel.org/r/1f7f31f4075e766343055ff0d07482992038d467.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9d7bbdea6db5..3184d57f9a35 100644
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
2.44.0


