Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EC851E7A7
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446509AbiEGOKO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446516AbiEGOKM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:10:12 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD8145526;
        Sat,  7 May 2022 07:06:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e5so8360772pgc.5;
        Sat, 07 May 2022 07:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GWQlqvW5av/MtO8yCNmmjt4jG3JJ3yBcvjIk01r0GHM=;
        b=qxoTKuQx/zjhyFQ+JyZmCAuRJU5gKWkKTXH+vhx6IlmPr4UIzx8qQBT1d0dNmwlsu3
         7sA/GB19v32FdCxCvwMsksYtvjED0o6lwoNO1+GTHWYTqQmCb7vv+MPSIbyHUlm4LPqq
         E2QWigAn01WxQraD4FfwY1/xfTuA/P8YYBId/yAr3PSQpfoCHLjZ9pUGmFH0NSettN5F
         dsfPOvO0aYaSTbbpb7Tw9Ej97aGJjAmGxhJ7646ImzEii9Cf1i7MGtqIhgVrsLCwlbmR
         rukNbBV4p90r5zRER4kEIrS12/8VA+YjmsIFwbL+su1qoKWuFVHQzjgYNsSmdTs2G3XM
         UAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWQlqvW5av/MtO8yCNmmjt4jG3JJ3yBcvjIk01r0GHM=;
        b=5kGG0Jq+DTl8aO2Nx+ZBXwtD7sdONBo+J8aCLM+OCYeHHS7rSzKjs+py9pRkcGrQUy
         2eftOtxmZ5oA8V77zaoqu1Ag0dEzlTK7bn+YxFSu9cvm/GIMLj+f5pC9sEdivagESpid
         d8cnbgQQlCsyvTrE/PpH2EoR6z6rSLTFV+uqy+p9xLXwWUoz1Yfppg0d5AHajT0AVyh0
         llP8/44FpQVLmSNcecMWa2FdIrvMACtttJfd2TiigiNG/6Q/9NgFiGecn8Iv8BJAJ7rH
         Q6FnF25jGxPe+Ah5aJGZ5SGKxJqSYwhoblK/KdVaI5mvYag0ozWaAkQZmJi9v3s8VJ7R
         3sSA==
X-Gm-Message-State: AOAM531KMTGSYlhfTn7vYuxIZJFTwCN6f+DkxsnApegjUlPvgJNA9gyE
        JFrsAUVH4KlkJPpOEiW45VCKKGoAS0TJ5w==
X-Google-Smtp-Source: ABdhPJzAiLKoptVZbG+LjHRRp45n05E0JiPSgE7jy66qYHNLfHCzXqlM2n8i8AGS219bkFEjZK2Gaw==
X-Received: by 2002:a65:6e8b:0:b0:3ab:a3fb:e95a with SMTP id bm11-20020a656e8b000000b003aba3fbe95amr6622654pgb.433.1651932384347;
        Sat, 07 May 2022 07:06:24 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015e8d4eb2acsm3674813plj.246.2022.05.07.07.06.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 May 2022 07:06:24 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] io_uring: let fast poll support multishot
Date:   Sat,  7 May 2022 22:06:19 +0800
Message-Id: <20220507140620.85871-4-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220507140620.85871-1-haoxu.linux@gmail.com>
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
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
[fold in cleaning up]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c2ee184ac693..e0d12af04cd1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5955,6 +5955,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 	rcu_read_unlock();
 }
 
+static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags);
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -5963,10 +5964,10 @@ static void io_poll_remove_entries(struct io_kiocb *req)
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
@@ -5990,23 +5991,37 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
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
@@ -6021,7 +6036,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req, *locked);
+	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
@@ -6046,7 +6061,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req, *locked);
+	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
@@ -6286,7 +6301,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	__poll_t mask = POLLERR | POLLPRI;
 	int ret;
 
 	if (!def->pollin && !def->pollout)
@@ -6295,6 +6310,8 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+		mask |= EPOLLONESHOT;
 
 	if (def->pollin) {
 		mask |= POLLIN | POLLRDNORM;
-- 
2.36.0

