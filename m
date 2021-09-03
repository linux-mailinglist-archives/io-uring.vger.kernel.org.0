Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F0A3FFE90
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 13:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348398AbhICLCC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 07:02:02 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:39572 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231497AbhICLCA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 07:02:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Un61DbM_1630666849;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Un61DbM_1630666849)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 19:00:59 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 4/6] io_uring: let fast poll support multishot
Date:   Fri,  3 Sep 2021 19:00:47 +0800
Message-Id: <20210903110049.132958-5-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210903110049.132958-1-haoxu@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For operations like accept, multishot is a useful feature, since we can
reduce a number of accept sqe. Let's integrate it to fast poll, it may
be good for other operations in the future.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d6df60c4cdb9..dae7044e0c24 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5277,8 +5277,15 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
 		return;
 	}
 
-	hash_del(&req->hash_node);
-	io_poll_remove_double(req);
+	if (READ_ONCE(apoll->poll.canceled))
+		apoll->poll.events |= EPOLLONESHOT;
+	if (apoll->poll.events & EPOLLONESHOT) {
+		hash_del(&req->hash_node);
+		io_poll_remove_double(req);
+	} else {
+		add_wait_queue(apoll->poll.head, &apoll->poll.wait);
+	}
+
 	spin_unlock(&ctx->completion_lock);
 
 	if (!READ_ONCE(apoll->poll.canceled))
@@ -5366,7 +5373,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	__poll_t ret, mask = POLLERR | POLLPRI;
 	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
@@ -5388,6 +5395,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		rw = WRITE;
 		mask |= POLLOUT | POLLWRNORM;
 	}
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+		mask |= EPOLLONESHOT;
 
 	/* if we can't nonblock try, then no point in arming a poll handler */
 	if (!io_file_supports_nowait(req, rw))
-- 
2.24.4

