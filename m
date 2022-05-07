Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C611C51E901
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 19:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446730AbiEGRtS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 13:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446724AbiEGRtP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 13:49:15 -0400
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E847663A5
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 10:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=WT245
        C0vvnBEu1WIcBRmsxn7sTaTPu5eMdcA1Qtj8aY=; b=PiM37I3VTywe1q/VMzBFI
        iqHMLrtmQXD6lyU3tijIrZMdnzODU/iV8zbd24UZJCQ71VEGwxpC/5zmEwgOme6r
        96/vGYW/2fOoDapug/q9IWugMGYGrB4O5Ey18oto+9mYj6hnFFYfQTbxQXISJ8kn
        jWZH6ORZYSD6uSAwF4BaJU=
Received: from localhost.localdomain (unknown [115.197.24.253])
        by smtp3 (Coremail) with SMTP id DcmowADX5p4YqXZiJmdFBQ--.6995S5;
        Sun, 08 May 2022 01:15:05 +0800 (CST)
From:   Hao Xu <haoxu_linux@126.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/4] io_uring: let fast poll support multishot
Date:   Sun,  8 May 2022 01:15:03 +0800
Message-Id: <20220507171504.151739-4-haoxu_linux@126.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220507171504.151739-1-haoxu_linux@126.com>
References: <20220507171504.151739-1-haoxu_linux@126.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowADX5p4YqXZiJmdFBQ--.6995S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxXFWrXw17ZF1UZFWkZrW3Awb_yoWrWr1rpr
        43Aay5KFs5Jr1xW3Z5JFs8Zw1Y9rZ2vayxJFWSkw4fGrs3ZF12qa1rta4rtFWrJryrAFW2
        ya1kta98uw45ZFDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bnNVkUUUUU=
X-Originating-IP: [115.197.24.253]
X-CM-SenderInfo: xkdr53xbol03b06rjloofrz/1tbimxn5V1x5gYVXAAAAsa
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
2.25.1

