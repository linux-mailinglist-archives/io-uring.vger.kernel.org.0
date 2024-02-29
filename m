Return-Path: <io-uring+bounces-802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3775F86CF6A
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 17:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E12E628652C
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 16:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF2B160652;
	Thu, 29 Feb 2024 16:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nfs5lsJX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49576160645
	for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 16:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709224676; cv=none; b=F3fxnOGb4GTNm+OoQJkhUlK7cmH8O5AvXCVABlQZezDrD0FYICBwzgFcpEL6km8LxfEo+J7IUqw1w1E6dS1HP/kZX+H81aTmlEw0M4DFvi+TSd7l+6DLETOZrS2R/wZK3XyXe6F3fprjZ02gEHww5la7ms+EOVNEWWkgzpaWxp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709224676; c=relaxed/simple;
	bh=WUBmFDzH4eDwOquV5B7ninUlinwjehUs03qDVXuSQ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=anUzEOQk+lFbLQU+zUkkdriDWqD2Kd/YfSkGtRoKGP5UcGRBTilueoOq2luxhqKgkTbvqXMDL00U1JoWn9CxSlNIk23G0/Obnl+MoDNUvM0+CdIEsxxsTFp8o6Vng/Buot+FbqfxaavCZVVVTTBnXOxE5UlR2d1y5Qd6O8+e1Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nfs5lsJX; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d24a727f78so13055801fa.0
        for <io-uring@vger.kernel.org>; Thu, 29 Feb 2024 08:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709224672; x=1709829472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Dyod7hphllntqoaynrSo2oCsfkhQHdgx1o78WtnfGwg=;
        b=Nfs5lsJX/bgHgeHVozxlEYK92uaVDgP1nq4sThDlV1mDYIFOVYsFVfdPZJ2RzcIKn2
         9sLquT3Di9GNpsbOBgUJC0VoRosuos7ruTVA597I7q5ZcxM8Kl5wg7Tu0577yI8niwFH
         /lBOj/wqir2R3KMibXrkD/EzR+Tg89na3cZvdZg0x0JjRU/bAlxXHVRRRQW6flQa1jAp
         v34LWuqwz5/xJrs2pb2WHorgo+VokSPGr9O87GYoZBbgWNqv0eA15+CW7Olye6yO/2Ku
         xRVljijPdFJU73j0LFvcXwNNQAygIcWSZ2JryCKOykXT+AF//3KRZ0fo/vvY+O6jrQ78
         bSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709224672; x=1709829472;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dyod7hphllntqoaynrSo2oCsfkhQHdgx1o78WtnfGwg=;
        b=FfMPrAhgknPyUpDGrprwkfKwtDn9DF/TJ3AdtoojVFE1vrzm1phFtMoPjAOsa/tI0e
         h+CeGEegAXk+On8yXaA2PyLQHNKoCLqRDpFRhHn1QGBi1yRDzGimWWiZTasLRjHdeDso
         YzHf0GXjncKJyjpK31FLnczICZ/3+SBQB3rKMysY96cHjBbfngLWIwhxM4nh8/AAmLWt
         pLlrHufsWRnmIi1HenU1lsrGLm7FtYJDaBD8ouMqDFBQm2/HdobiGNWCVgsVTM8AOTBa
         q9uC+FEkHOvTKAKxjcubeZO0rHzr24yJSy2SaBAV1lPpSr+CUgdhk722jx2ujDv8nNh4
         gVcg==
X-Gm-Message-State: AOJu0Yw+ZTQkqFaZDEOpOHOwHNH89uustoQx+04AS2wyMESsg2hXJVcv
	foou/be4+UA4l2k/UJF9dEeFZYs4U82sY+G+j58o5JQa9SIxSxSgWpRIWNKG
X-Google-Smtp-Source: AGHT+IFYGbyVOsnMVlk+H/x94z14FsnEeScI2z4h9Tm3y9i4uZcNUbiAwNzPJYrsZ0S9gVnwh7s60w==
X-Received: by 2002:ac2:5dcd:0:b0:513:24f3:839f with SMTP id x13-20020ac25dcd000000b0051324f3839fmr1805194lfq.58.1709224671889;
        Thu, 29 Feb 2024 08:37:51 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:9e1b])
        by smtp.gmail.com with ESMTPSA id n3-20020adfe783000000b0033b79d385f6sm2164793wrm.47.2024.02.29.08.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 08:37:51 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH] io_uring: get rid of intermediate aux cqe caches
Date: Thu, 29 Feb 2024 16:36:37 +0000
Message-ID: <935d517f0e71218bfc1d40352a4754abb610176d.1709224453.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With defer taskrun we store aux cqes into a cache array and then flush
into the CQ, and we also maintain the ordering so aux cqes are flushed
before request completions. Why do we need the cache instead of pushing
them directly? We acutally don't, so let's kill it.

One nuance is synchronisation -- the path we touch here is only for
DEFER_TASKRUN and guaranteed to be executed in the task context, and
all cqe posting is serialised by that. We also don't need locks because
of that, see __io_cq_lock().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  4 +--
 io_uring/io_uring.c            | 55 ++++------------------------------
 2 files changed, 8 insertions(+), 51 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 854ad67a5f70..35c2945cb1bf 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -204,7 +204,9 @@ struct io_submit_state {
 
 	bool			plug_started;
 	bool			need_plug;
+	bool			flush_cqes;
 	unsigned short		submit_nr;
+
 	unsigned int		cqes_count;
 	struct blk_plug		plug;
 };
@@ -338,8 +340,6 @@ struct io_ring_ctx {
 		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
-	struct io_uring_cqe	completion_cqes[16];
-
 	spinlock_t		completion_lock;
 
 	/* IRQ completion list, under ->completion_lock */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 86761ec623f9..07f683368855 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -173,7 +173,7 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
-	    ctx->submit_state.cqes_count)
+	    ctx->submit_state.flush_cqes)
 		__io_submit_flush_completions(ctx);
 }
 
@@ -886,31 +886,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
-static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_submit_state *state = &ctx->submit_state;
-	unsigned int i;
-
-	lockdep_assert_held(&ctx->uring_lock);
-	for (i = 0; i < state->cqes_count; i++) {
-		struct io_uring_cqe *cqe = &ctx->completion_cqes[i];
-
-		if (!io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags)) {
-			if (ctx->lockless_cq) {
-				spin_lock(&ctx->completion_lock);
-				io_cqring_event_overflow(ctx, cqe->user_data,
-							cqe->res, cqe->flags, 0, 0);
-				spin_unlock(&ctx->completion_lock);
-			} else {
-				io_cqring_event_overflow(ctx, cqe->user_data,
-							cqe->res, cqe->flags, 0, 0);
-			}
-		}
-	}
-	state->cqes_count = 0;
-}
-
 static bool __io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags,
 			      bool allow_overflow)
 {
@@ -938,32 +913,15 @@ bool io_fill_cqe_req_aux(struct io_kiocb *req, bool defer, s32 res, u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	u64 user_data = req->cqe.user_data;
-	struct io_uring_cqe *cqe;
 
 	if (!defer)
 		return __io_post_aux_cqe(ctx, user_data, res, cflags, false);
 
 	lockdep_assert_held(&ctx->uring_lock);
+	io_lockdep_assert_cq_locked(ctx);
 
-	if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->completion_cqes)) {
-		__io_cq_lock(ctx);
-		__io_flush_post_cqes(ctx);
-		/* no need to flush - flush is deferred */
-		__io_cq_unlock_post(ctx);
-	}
-
-	/* For defered completions this is not as strict as it is otherwise,
-	 * however it's main job is to prevent unbounded posted completions,
-	 * and in that it works just as well.
-	 */
-	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
-		return false;
-
-	cqe = &ctx->completion_cqes[ctx->submit_state.cqes_count++];
-	cqe->user_data = user_data;
-	cqe->res = res;
-	cqe->flags = cflags;
-	return true;
+	ctx->submit_state.flush_cqes = true;
+	return io_fill_cqe_aux(ctx, user_data, res, cflags);
 }
 
 static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
@@ -1546,9 +1504,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_wq_work_node *node;
 
 	__io_cq_lock(ctx);
-	/* must come first to preserve CQE ordering in failure cases */
-	if (state->cqes_count)
-		__io_flush_post_cqes(ctx);
+
 	__wq_list_for_each(node, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
@@ -1570,6 +1526,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
+	ctx->submit_state.flush_cqes = false;
 }
 
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-- 
2.43.0


