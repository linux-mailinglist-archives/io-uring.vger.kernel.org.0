Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CC954B370
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbiFNOhs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237722AbiFNOhr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:47 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE5217A9D
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:46 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o37-20020a05600c512500b0039c4ba4c64dso6346536wms.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XgZAW0m4+0LZD+WHW8dXUET6dvmfsAmhLr96GJWzonE=;
        b=C+OW6ff8rC8QaFOQt9W94DfNOMVOwIf8JAioNFBdBCJL3vyoiTNMy8d5kfQN0AP4dP
         ZYfjsxAYp/fgL0u63Mdzb4Tu/Feea67touwH6maVVqAZAq7bf7pKyYn4DSpBbOhkV9Lc
         jV+cSkF2NGptc4QwlRZij//tsGPvo87B+3AdZ6r4PPmkGSjXyUIxdycLahyByOXS9BLi
         nwKeIaVSGxXrFqK9wvzIrdNKptYxUDrU3WXnf1AFrTWMxE1pk+2Mg4F9rLFFXLogdljs
         LirbajDySVGF48wvZvMva/tCqEnzViXjk39c0JQLm3hTExkmJSeKOP5LrCjxglqQhGWJ
         NP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XgZAW0m4+0LZD+WHW8dXUET6dvmfsAmhLr96GJWzonE=;
        b=fVc3QYc8v7tPvkUCzeSe/rkiIIwPF4/oYZQaqNbQiTYRmIrokMTJruy4lXpLKUUax2
         BKRyx7vg5CIZeIQiLqDOYJdpmx11a1znRIIBu/uRHCV4sUxTicv1uzv4r195AWOhKlq/
         i611E4iwjNI9DgyxRgROeB+CISaZmv8mAgeifml3NMqkF/lCccS9ByyStZlUR2Gt4jVH
         Y3ILB9mNgrQPw80bQnV8zbXH20EmtiUf8t2RzL9ZSkdh9kwZ4He8q2WcT4nCq8PYSGWz
         afyagWFU80MwT7lrobYZ1XoqfA3oGnN/EOUP3jzCBKevcR9BugaadpU9ZVF9byPKJpFH
         vMwg==
X-Gm-Message-State: AOAM533YXMjRnb6VyF97lhu0HIOdDftS8z0cFkn/cpfysqEQaYsLKV+D
        H2aYogZgZS5N4dRPOXB7iNk+MOVUv36S9Q==
X-Google-Smtp-Source: ABdhPJzzKVcfVvLKKIl5DMzNFmCCmHx1KRg/sG1ER/h4eH3lqsZX5MoF/3sw6/gCSMfZWpjOW1snvg==
X-Received: by 2002:a05:600c:3588:b0:39c:87f1:b31 with SMTP id p8-20020a05600c358800b0039c87f10b31mr4603447wmq.4.1655217464603;
        Tue, 14 Jun 2022 07:37:44 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 05/25] io_uring: move small helpers to headers
Date:   Tue, 14 Jun 2022 15:36:55 +0100
Message-Id: <7bef8769a1f74a0af7c45f8c20d2fb2a6abc9f89.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a bunch of inline helpers that will be useful not only to the
core of io_uring, move them to headers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 22 ----------------------
 io_uring/io_uring.h | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6a94d1682aaf..3fdb368820c9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -616,14 +616,6 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
-static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
-{
-	if (!*locked) {
-		mutex_lock(&ctx->uring_lock);
-		*locked = true;
-	}
-}
-
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
@@ -879,15 +871,6 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
-static inline void io_req_add_compl_list(struct io_kiocb *req)
-{
-	struct io_submit_state *state = &req->ctx->submit_state;
-
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		state->flush_cqes = true;
-	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
-}
-
 void io_queue_iowq(struct io_kiocb *req, bool *dont_use)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
@@ -1293,11 +1276,6 @@ static void io_req_complete_post32(struct io_kiocb *req, u64 extra1, u64 extra2)
 	io_cqring_ev_posted(ctx);
 }
 
-static inline void io_req_complete_state(struct io_kiocb *req)
-{
-	req->flags |= REQ_F_COMPLETE_INLINE;
-}
-
 inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
 {
 	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3660df80e589..26b669746d61 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -193,6 +193,28 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
+static inline void io_req_complete_state(struct io_kiocb *req)
+{
+	req->flags |= REQ_F_COMPLETE_INLINE;
+}
+
+static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
+{
+	if (!*locked) {
+		mutex_lock(&ctx->uring_lock);
+		*locked = true;
+	}
+}
+
+static inline void io_req_add_compl_list(struct io_kiocb *req)
+{
+	struct io_submit_state *state = &req->ctx->submit_state;
+
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		state->flush_cqes = true;
+	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+}
+
 int io_run_task_work_sig(void);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete32(struct io_kiocb *req, unsigned int issue_flags,
-- 
2.36.1

