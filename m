Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CCD315B05
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhBJAUS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbhBJAKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:10:46 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0148DC0617AA
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:28 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o24so320422wmh.5
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dKTfuBKdSBg7QhQzgBlQZu28600RsQDiNzMn11aTZ7c=;
        b=rMjBnJmPutdqSgS4QDsKcTMDkRhtVN1uevs5r61roVj2WEcXsewZ91J29EXCefVxFg
         Var3IR/iWQ2ooIXcN0tkLO1HleIFi+njDDrTqfCEPYKye12NhQz6rjGKLliOIoKULNEA
         WU0l5dRGzfm0dMcfkL+ACOZ3O66Pd6Tb1T11HuwOEpe9LrD6YvD7ruCT663ctPpSoJu1
         yYs6CVHgwlbCA9m3oJPlEV0QotSfq7p43cHNbJl9L7E7sxbg+NO6CKpdlMqP30T8W9wb
         jatWJ3ZkO3fyr7PV2vJGHlDUV4kxmJjNCJ5QL8DpyfhS3mTHuH727LYBg/sX+yT6+lJZ
         dTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dKTfuBKdSBg7QhQzgBlQZu28600RsQDiNzMn11aTZ7c=;
        b=knCOkpGfENcuniW7SdTa1kgsGPIMBTf+54fcquOfuX7T143Ax0ebTQQQD5yM9e9Jp7
         9qZm+6LoI4YjyXlj3h+Y5uwMDpArQU1Y9IIDSfw2ytkX4rHSwHcoHCHOsy+7NJq7CFUm
         6OWp7zT5fsnJ60OITwLKnCZ9ZFDeooAZcCngTfaD7ScubJZ0UwaFRazTFPvSHy3cD62l
         1oiErdwZQTzImjZEHncPi9CHmogb7A68wR5g3Di6p5LR0o39HXU7GI13KGZHwIoDWRmS
         3pCV8krRcd24ppqnSahi5tAQzq4AxvsmYl60ROttaA3ve+lkNfiHD37BwY3mRSJsw3Qs
         EZdg==
X-Gm-Message-State: AOAM533oiTkPbujb/sijDDM2Q+4ivu2enZchiOLIdJOjZbWabA4JafTY
        P7cXFDsMBiw7MX7DA4C8OF8=
X-Google-Smtp-Source: ABdhPJw5TNC8K4NmlLKIuC+leZQ+enkQhMxsoR15P0GcbR8VYQwdR8WLY3a6TSv/jkh3hhfExg86TQ==
X-Received: by 2002:a05:600c:2141:: with SMTP id v1mr462716wml.5.1612915646800;
        Tue, 09 Feb 2021 16:07:26 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/17] io_uring: feed reqs back into alloc cache
Date:   Wed, 10 Feb 2021 00:03:18 +0000
Message-Id: <5fa696daa5ee9e8708fcc52cce3480fd92d29740.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_req_free_batch(), which is used for inline executed requests and
IOPOLL, to return requests back into the allocation cache, so avoid
most of kmalloc()/kfree() for those cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3711ae2633cb..1918b410b6f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -266,7 +266,7 @@ struct io_sq_data {
 
 #define IO_IOPOLL_BATCH			8
 #define IO_COMPL_BATCH			32
-#define IO_REQ_CACHE_SIZE		8
+#define IO_REQ_CACHE_SIZE		32
 #define IO_REQ_ALLOC_BATCH		8
 
 struct io_comp_state {
@@ -2270,7 +2270,8 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
 }
 
-static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
+static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
+			      struct io_submit_state *state)
 {
 	io_queue_next(req);
 
@@ -2284,9 +2285,13 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 	rb->ctx_refs++;
 
 	io_dismantle_req(req);
-	rb->reqs[rb->to_free++] = req;
-	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
-		__io_req_free_batch_flush(req->ctx, rb);
+	if (state->free_reqs != ARRAY_SIZE(state->reqs)) {
+		state->reqs[state->free_reqs++] = req;
+	} else {
+		rb->reqs[rb->to_free++] = req;
+		if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
+			__io_req_free_batch_flush(req->ctx, rb);
+	}
 }
 
 static void io_submit_flush_completions(struct io_comp_state *cs,
@@ -2311,7 +2316,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 
 		/* submission and completion refs */
 		if (refcount_sub_and_test(2, &req->refs))
-			io_req_free_batch(&rb, req);
+			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
 	io_req_free_batch_finish(ctx, &rb);
@@ -2464,7 +2469,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		(*nr_events)++;
 
 		if (refcount_dec_and_test(&req->refs))
-			io_req_free_batch(&rb, req);
+			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
 	io_commit_cqring(ctx);
-- 
2.24.0

