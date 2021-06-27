Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1F93B5546
	for <lists+io-uring@lfdr.de>; Sun, 27 Jun 2021 23:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhF0VkC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Jun 2021 17:40:02 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:41535 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231676AbhF0VkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Jun 2021 17:40:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UdpdEhf_1624829850;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UdpdEhf_1624829850)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 28 Jun 2021 05:37:36 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: spin in iopoll() only when reqs are in a single queue
Date:   Mon, 28 Jun 2021 05:37:30 +0800
Message-Id: <1624829850-38536-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently spin in iopoll() when requests to be iopolled are for
same file(device), while one device may have multiple hardware queues.
given an example:

hw_queue_0     |    hw_queue_1
req(30us)           req(10us)

If we first spin on iopolling for the hw_queue_0. the avg latency would
be (30us + 30us) / 2 = 30us. While if we do round robin, the avg
latency would be (30us + 10us) / 2 = 20us since we reap the request in
hw_queue_1 in time. So it's better to do spinning only when requests
are in same hardware queue.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

I writed a test case fot it, the test logic is what I memtioned in
this thread:
https://lore.kernel.org/io-uring/4c341c96-8d66-eae3-ba4a-e1655ee463a8@linux.alibaba.com/
One thread for heavy IO, one for fast IO, and another to iopoll.
All of them bind to different cpu and the two cpus for submittion are
bound to different hardware queues. The thing is that requests are
always completed before reaping IO, so fops->iopoll() is not entered.
I've tested this patch for normal situations, as fast as before.

 fs/io_uring.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23c51786708b..2eb290f68aa3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -434,7 +434,7 @@ struct io_ring_ctx {
 		struct list_head	iopoll_list;
 		struct hlist_head	*cancel_hash;
 		unsigned		cancel_hash_bits;
-		bool			poll_multi_file;
+		bool			poll_multi_queue;
 	} ____cacheline_aligned_in_smp;
 
 	struct io_restriction		restrictions;
@@ -2333,7 +2333,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	 * Only spin for completions if we don't have multiple devices hanging
 	 * off our complete list, and we're under the requested amount.
 	 */
-	spin = !ctx->poll_multi_file && *nr_events < min;
+	spin = !ctx->poll_multi_queue && *nr_events < min;
 
 	ret = 0;
 	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
@@ -2572,14 +2572,22 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * different devices.
 	 */
 	if (list_empty(&ctx->iopoll_list)) {
-		ctx->poll_multi_file = false;
-	} else if (!ctx->poll_multi_file) {
+		ctx->poll_multi_queue = false;
+	} else if (!ctx->poll_multi_queue) {
 		struct io_kiocb *list_req;
+		unsigned int queue_num0, queue_num1;
 
 		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
 						inflight_entry);
-		if (list_req->file != req->file)
-			ctx->poll_multi_file = true;
+
+		if (list_req->file != req->file) {
+			ctx->poll_multi_queue = true;
+		} else {
+			queue_num0 = blk_qc_t_to_queue_num(list_req->rw.kiocb.ki_cookie);
+			queue_num1 = blk_qc_t_to_queue_num(req->rw.kiocb.ki_cookie);
+			if (queue_num0 != queue_num1)
+				ctx->poll_multi_queue = true;
+		}
 	}
 
 	/*
-- 
1.8.3.1

