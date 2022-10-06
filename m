Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F4D5F5E4E
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 03:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiJFBIE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Oct 2022 21:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiJFBHv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Oct 2022 21:07:51 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6F07F262
        for <io-uring@vger.kernel.org>; Wed,  5 Oct 2022 18:07:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id iv17so140517wmb.4
        for <io-uring@vger.kernel.org>; Wed, 05 Oct 2022 18:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NeBe1cap0U1tPjihDnkNieRZh/P2hvuTrEE/iEOYMOw=;
        b=N8jTZQya77dyARFSfcnSQqiC5voTJVyhwz/zA9a5uyaidQF+dhhVIqUTvw0/JVObi4
         zucmRP0s+LVYBEW9a/82DU3mqX/pUsRzoY88cwQL+cDZu1xsT/uJEgETF8s6fBkeLy3y
         I8svbnd5bYbQKbyy1+CJJOJGmNd+ioiQBa+7iqPeI+UWjjxDIQd25Ll1faqOBrHIc6qs
         FLr7F+mPNdolsvZqtVla9oQOBCK3gSRrNuKYW0TdplHrJMdkUrWLZSH0IpugKn+cFdLQ
         ZK+IYwz/e/Ln+pTiXBGdvikiZQZenp1rBowvf2rL3klnsdNdugyDtonEHwDKcY3QEZcQ
         nWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NeBe1cap0U1tPjihDnkNieRZh/P2hvuTrEE/iEOYMOw=;
        b=BpLlz+r8/IgpAAsPGiUk2HnXxPLZRd9QR2SbHPWAWcRF63CamG9C9DFKrrg7iKqTqe
         8QKvyIs3WFMCT6XU8Gm4CtgJZ3ejd+6Hnt7YrLMd6FBP+tjUMoHVp6fUe8zFuZAUT0fZ
         83vfsPoSFv+19/cyIu19yB/CZPplI/AK47GT10eyk7GntmsoVuViXkFbOIof69WRAJi2
         T0nGrZwkUeQGP+LLjKfEP++3dKhQuIUbOabby8KJG7uq++MamnfxQ8QtJRj/d4DbxY6R
         PYpeSMroGETcC+SCqmCDScKTBDoP8xRGHbknJlHpNEGBqvhPgLSK5PBdwlt16n0nzzVn
         Y58w==
X-Gm-Message-State: ACrzQf3cT8QbJhP51Zw3oouyRxsHE9Y4jmNCLEyYt3CiK7ZhO00o6Jmh
        XvBNILeIbfYF7GoF5Hk3jMdqecoEWoI=
X-Google-Smtp-Source: AMsMyM5vposABGzw7L+7dkm+MgBfX1CLiea7xiOtNTv7bR0ZmkJm4UC988Yfk8/GlAP6ld6hCBFyFw==
X-Received: by 2002:a05:600c:3781:b0:3b4:63c8:554b with SMTP id o1-20020a05600c378100b003b463c8554bmr4947121wmr.25.1665018443410;
        Wed, 05 Oct 2022 18:07:23 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.209.4.threembb.co.uk. [94.196.209.4])
        by smtp.gmail.com with ESMTPSA id q3-20020a1c4303000000b003b4bd18a23bsm3369982wma.12.2022.10.05.18.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 18:07:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: optimise mb() in io_req_local_work_add
Date:   Thu,  6 Oct 2022 02:06:10 +0100
Message-Id: <43983bc8bc507172adda7a0f00cab1aff09fd238.1665018309.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_cqring_wake() needs a barrier for the waitqueue_active() check.
However, in case of io_req_local_work_add() prior it calls llist_add(),
which implies an atomic, and with that we can replace smb_mb() with
smp_mb__after_atomic().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  5 +++--
 io_uring/io_uring.h | 11 +++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5e7c086685bf..355fc1f3083d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1106,6 +1106,8 @@ static void io_req_local_work_add(struct io_kiocb *req)
 
 	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
 		return;
+	/* need it for the following io_cqring_wake() */
+	smp_mb__after_atomic();
 
 	if (unlikely(atomic_read(&req->task->io_uring->in_idle))) {
 		io_move_task_work_from_local(ctx);
@@ -1117,8 +1119,7 @@ static void io_req_local_work_add(struct io_kiocb *req)
 
 	if (ctx->has_evfd)
 		io_eventfd_signal(ctx);
-	io_cqring_wake(ctx);
-
+	__io_cqring_wake(ctx);
 }
 
 static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 177bd55357d7..e733d31f31d2 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -203,17 +203,24 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 }
 
-static inline void io_cqring_wake(struct io_ring_ctx *ctx)
+/* requires smb_mb() prior, see wq_has_sleeper() */
+static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 {
 	/*
 	 * wake_up_all() may seem excessive, but io_wake_function() and
 	 * io_should_wake() handle the termination of the loop and only
 	 * wake as many waiters as we need to.
 	 */
-	if (wq_has_sleeper(&ctx->cq_wait))
+	if (waitqueue_active(&ctx->cq_wait))
 		wake_up_all(&ctx->cq_wait);
 }
 
+static inline void io_cqring_wake(struct io_ring_ctx *ctx)
+{
+	smp_mb();
+	__io_cqring_wake(ctx);
+}
+
 static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 {
 	struct io_rings *r = ctx->rings;
-- 
2.37.3

