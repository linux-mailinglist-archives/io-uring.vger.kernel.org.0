Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BA15271E2
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiENOUl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbiENOUi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:20:38 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED4F2B3
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id k16so3371364pff.5
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2FIFHdUPWdaPGI4xDJjIhjnONdaloxgrMvTH+estFXM=;
        b=M+uHcL66cFvyfd3So8vDo6owMSxqPZaKTCbyUULhErQWXk3REmtrLprojF0NZj/zq4
         2vr838tj8O3j8f2VN6OEoWhcM459123Oti9Bc86nhSfyTratc0Tr+Kjmz8wTafrP86sm
         Q8RXEI38phigQPNLfi7K7oK+xEv4Urq5c0FVvjluSsowNSNo/m1OkSptAi6km0qiXqr+
         rjrcDr1wuCO2BysjInSts4TUNsG0hpf8pqsCjziQZ2VnxU4DHudQ8msUW4UKryLEs+j3
         cBhCsIMey1YX3/FaUELG0+N3UV9PfbUFPcvr/RvsSFLButnuGI/OT96GOg4Ay18dPM0Y
         jygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2FIFHdUPWdaPGI4xDJjIhjnONdaloxgrMvTH+estFXM=;
        b=XcQuthWg3tp5/dk74tRZHtLYFzu2bdgHE6oDy9T96krnQpYns6aEob0CZl4I2L+5It
         Ea3Y3eEGvhTfdS4aeTUAxyXR1uwHbbefJU230yXQlMaWtsC3p2GMaLO6tU9Aochur8fm
         MUQX7zgRH6ItAatuDw8/h4Y0mqj9bJJHvydyByIzbtK5skwqtAyr/95DbaRgxR9kVNDG
         vGL47suNFUbL/stKBNyHQwuHN4VyEaAo4VlPyj+0zYZA3AiX/30Gwkjj4gCXFVay+dMA
         wAor8kulniQ1lQwmL7ehsiuJGs+r5AY7nuPdcon8Q2BXqf9aS9aWS9YMA9oa+iYBlpmv
         IymA==
X-Gm-Message-State: AOAM532CWW02NqimshD8gHrzZUsAO6tZ3DywOr6VQM9XphpBFq73V8Kk
        Uhrm8Hc4mBV7hnf4OHBxCCjOoQnKqvtQB8WZ
X-Google-Smtp-Source: ABdhPJxm5nNvMsAsVsswXTHoCKTuxXfK6wCe/deUBt5XqQuzX2qb0mpwaIV2XMjBCwXoUyoy1VUAUw==
X-Received: by 2002:a05:6a00:c8f:b0:510:60cf:55fa with SMTP id a15-20020a056a000c8f00b0051060cf55famr9268881pfv.37.1652538036013;
        Sat, 14 May 2022 07:20:36 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b0015e8d4eb27csm3815968plg.198.2022.05.14.07.20.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:20:35 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/4] io_uring: let fast poll support multishot
Date:   Sat, 14 May 2022 22:20:45 +0800
Message-Id: <20220514142046.58072-4-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514142046.58072-1-haoxu.linux@gmail.com>
References: <20220514142046.58072-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

For operations like accept, multishot is a useful feature, since we can
reduce a number of accept sqe. Let's integrate it to fast poll, it may
be good for other operations in the future.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e1e550de5956..a83405f657e0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6011,6 +6011,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 	rcu_read_unlock();
 }
 
+static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags);
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -6019,10 +6020,10 @@ static void io_poll_remove_entries(struct io_kiocb *req)
  * either spurious wakeup or multishot CQE is served. 0 when it's done with
  * the request, then the mask is stored in req->cqe.res.
  */
-static int io_poll_check_events(struct io_kiocb *req, bool locked)
+static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
+	int v, ret;
 
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
@@ -6046,23 +6047,37 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 			req->cqe.res = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
-		/* multishot, just fill an CQE and proceed */
-		if (req->cqe.res && !(req->apoll_events & EPOLLONESHOT)) {
-			__poll_t mask = mangle_poll(req->cqe.res & req->apoll_events);
+		if ((unlikely(!req->cqe.res)))
+			continue;
+		if (req->apoll_events & EPOLLONESHOT)
+			return 0;
+
+		/* multishot, just fill a CQE and proceed */
+		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+			__poll_t mask = mangle_poll(req->cqe.res &
+						    req->apoll_events);
 			bool filled;
 
 			spin_lock(&ctx->completion_lock);
-			filled = io_fill_cqe_aux(ctx, req->cqe.user_data, mask,
-						 IORING_CQE_F_MORE);
+			filled = io_fill_cqe_aux(ctx, req->cqe.user_data,
+						 mask, IORING_CQE_F_MORE);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
-			if (unlikely(!filled))
-				return -ECANCELED;
-			io_cqring_ev_posted(ctx);
-		} else if (req->cqe.res) {
-			return 0;
+			if (filled) {
+				io_cqring_ev_posted(ctx);
+				continue;
+			}
+			return -ECANCELED;
 		}
 
+		io_tw_lock(req->ctx, locked);
+		if (unlikely(req->task->flags & PF_EXITING))
+			return -EFAULT;
+		ret = io_issue_sqe(req,
+				   IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+		if (ret)
+			return ret;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
@@ -6077,7 +6092,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req, *locked);
+	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
@@ -6102,7 +6117,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req, *locked);
+	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
@@ -6343,7 +6358,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = IO_ASYNC_POLL_COMMON | POLLERR;
+	__poll_t mask = POLLPRI | POLLERR;
 	int ret;
 
 	if (!def->pollin && !def->pollout)
@@ -6352,6 +6367,8 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+		mask |= EPOLLONESHOT;
 
 	if (def->pollin) {
 		mask |= POLLIN | POLLRDNORM;
-- 
2.36.0

