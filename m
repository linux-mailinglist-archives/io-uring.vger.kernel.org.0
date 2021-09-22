Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8E64145E7
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 12:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhIVKOg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 06:14:36 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:38070 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234827AbhIVKOR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 06:14:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpDsdJl_1632305558;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpDsdJl_1632305558)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Sep 2021 18:12:46 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/3] io_uring: fix potential req refcount underflow
Date:   Wed, 22 Sep 2021 18:12:38 +0800
Message-Id: <20210922101238.7177-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210922101238.7177-1-haoxu@linux.alibaba.com>
References: <20210922101238.7177-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For multishot mode, there may be cases like:
    iowq                          original context
io_poll_add
  _arm_poll()
  mask = vfs_poll() is not 0
  if mask
(2)  io_poll_complete()
  compl_unlock
   (interruption happens
    tw queued to original
    context)
                                     io_poll_task_func()
                                     compl_lock
                                 (3) done = io_poll_complete() is true
                                     compl_unlock
                                     put req ref
(1) if (poll->flags & EPOLLONESHOT)
      put req ref

EPOLLONESHOT flag in (1) may be from (2) or (3), so there are multiple
combinations that can cause ref underfow.
Let's address it by:
- check the return value in (2) as done
- change (1) to if (done)
    in this way, we only do ref put in (1) if 'oneshot flag' is from
    (2)
- do poll.done check in io_poll_task_func(), so that we won't put ref
  for the second time.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b7c9fcce2de2..b008edccad46 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5370,6 +5370,10 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	} else {
 		bool done;
 
+		if (req->poll.done) {
+			spin_unlock(&ctx->completion_lock);
+			return;
+		}
 		done = __io_poll_complete(req, req->result);
 		if (done) {
 			io_poll_remove_double(req);
@@ -5833,6 +5837,7 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_table ipt;
 	__poll_t mask;
+	bool done;
 
 	ipt.pt._qproc = io_poll_queue_proc;
 
@@ -5841,13 +5846,13 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
-		io_poll_complete(req, mask);
+		done = io_poll_complete(req, mask);
 	}
 	spin_unlock(&ctx->completion_lock);
 
 	if (mask) {
 		io_cqring_ev_posted(ctx);
-		if (poll->events & EPOLLONESHOT)
+		if (done)
 			io_put_req(req);
 	}
 	return ipt.error;
-- 
2.24.4

