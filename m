Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976A4315B04
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhBJAUC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbhBJAKi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:10:38 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B95EC0617A9
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:27 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id y134so326849wmd.3
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NVlzbUjj2GDrj7HjU5PLdrE+uwgyTlgPjY0ggkDiXI0=;
        b=KdAPR7pydyQ5xx+J+Rk6TS8MZOjxpTD+o+CN0Ko3DOPpu2yONkRwazSbKyT6oXjG1S
         NI0KFfMLGfx5GUJlDQFW06jhhrmhTH0MqO0lN/hRC1dE8nqGicW/BvltGsdtx8EFc0Du
         6Q/nzajVoMzxdG1+SV18zQg2rqeQniMVgzCMr6I16FKGgaxzQtUtU2hDVm/KNsdReMQx
         wRVYgSoTJJPMVaAFlVvTydQkLY4a983cChKvMwQbl0FuuT0S35Fi7Z144WWpUEBFyYIh
         xYm9LHU6hB/g/A7lpPiV7v+mPiLL/Lh/e8p79eTBM8TYYXBG9Nj1cerhtgboOiPZNB1D
         obEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NVlzbUjj2GDrj7HjU5PLdrE+uwgyTlgPjY0ggkDiXI0=;
        b=pqDP8a3ghW3p8kcEwbeM8f3mk4hHF0eaOGyuL+o6CVz5O4Y5ryQtYjs3XcUqujVYVl
         gs/80s0JoqRrZ3W8YH41SVOyMowUdIsQcQsg+EFUGlYcC0eijXboGPzURR5VGUfPQDd7
         qPDI5huXmWC31Cv+TF/zVFSHl0tY/lSyOyQ7AAcP/W4+tko9EUuAToIODcw8zWwsaVPY
         GCFzXCGgpBb7kPbuNt5QSn4XuAZLZbImbmThiKXh8ejY91lHANIE64sts19X4H9uPL0p
         tLpH/XPHApZ7nQH1GKCWPRm1w1uJzXUZIdKEQL18hg+KcCGn/gxwcy8jtpPo6ShtCoU+
         wDgA==
X-Gm-Message-State: AOAM531v/bh7QyxCd4tL0jwManzWyqiKMgFBiQDTwCl3rBn32c7bP5+Y
        /BXltZD/p3ZlNRuThONYK2B0p09b2Ce//Q==
X-Google-Smtp-Source: ABdhPJzIKwsENLiazEo02p1m0GZPQ0Ypz4DQMRj3F3EQ7gd1UC/vRnS3do2hZr2+2MpfoGd9g4WCow==
X-Received: by 2002:a05:600c:430b:: with SMTP id p11mr471780wme.29.1612915645989;
        Tue, 09 Feb 2021 16:07:25 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/17] io_uring: persistent req cache
Date:   Wed, 10 Feb 2021 00:03:17 +0000
Message-Id: <2f4c62a484d1bb298a05df63ea1a922df42914aa.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't free batch-allocated requests across syscalls.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c1f7dd17a62f..3711ae2633cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -266,6 +266,8 @@ struct io_sq_data {
 
 #define IO_IOPOLL_BATCH			8
 #define IO_COMPL_BATCH			32
+#define IO_REQ_CACHE_SIZE		8
+#define IO_REQ_ALLOC_BATCH		8
 
 struct io_comp_state {
 	unsigned int		nr;
@@ -278,7 +280,7 @@ struct io_submit_state {
 	/*
 	 * io_kiocb alloc cache
 	 */
-	void			*reqs[IO_IOPOLL_BATCH];
+	void			*reqs[IO_REQ_CACHE_SIZE];
 	unsigned int		free_reqs;
 
 	bool			plug_started;
@@ -1948,13 +1950,14 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
+	BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
+
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
-		size_t sz;
 		int ret;
 
-		sz = min_t(size_t, state->ios_left, ARRAY_SIZE(state->reqs));
-		ret = kmem_cache_alloc_bulk(req_cachep, gfp, sz, state->reqs);
+		ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
+					    state->reqs);
 
 		/*
 		 * Bulk alloc is all-or-nothing. If we fail to get a batch,
@@ -6641,10 +6644,6 @@ static void io_submit_state_end(struct io_submit_state *state,
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
 	io_state_file_put(state);
-	if (state->free_reqs) {
-		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
-		state->free_reqs = 0;
-	}
 }
 
 /*
@@ -8644,6 +8643,8 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
+	struct io_submit_state *submit_state = &ctx->submit_state;
+
 	io_finish_async(ctx);
 	io_sqe_buffers_unregister(ctx);
 
@@ -8654,6 +8655,10 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		ctx->mm_account = NULL;
 	}
 
+	if (submit_state->free_reqs)
+		kmem_cache_free_bulk(req_cachep, submit_state->free_reqs,
+				     submit_state->reqs);
+
 #ifdef CONFIG_BLK_CGROUP
 	if (ctx->sqo_blkcg_css)
 		css_put(ctx->sqo_blkcg_css);
-- 
2.24.0

