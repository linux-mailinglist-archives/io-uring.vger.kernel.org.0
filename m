Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1256225A4C8
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 07:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgIBFFv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 01:05:51 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:49337 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgIBFFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 01:05:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U7gnjga_1599023145;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U7gnjga_1599023145)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Sep 2020 13:05:45 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: don't take percpu_ref operations for registered files in IOPOLL mode
Date:   Wed,  2 Sep 2020 13:05:38 +0800
Message-Id: <20200902050538.8350-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
percpu_ref_put() for registered files, but it's hard to say they're very
light-weight synchronization primitives, especially in arm platform. In one
our arm machine, I get below perf data(registered files enabled):
Samples: 98K of event 'cycles:ppp', Event count (approx.): 63789396810
Overhead  Command      Shared Object     Symbol
   ...
   0.78%  io_uring-sq  [kernel.vmlinux]  [k] io_file_get
There is an obvious overhead that can not be ignored.

Currently I don't find any good and generic solution for this issue, but
in IOPOLL mode, given that we can always ensure get/put registered files
under uring_lock, we can use a simple and plain u64 counter to synchronize
with registered files update operations in __io_sqe_files_update().

With this patch, perf data show shows:
Samples: 104K of event 'cycles:ppp', Event count (approx.): 67478249890
Overhead  Command      Shared Object     Symbol
   ...
   0.27%  io_uring-sq  [kernel.vmlinux]  [k] io_file_get

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce69bd9b0838..186072861af9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -195,6 +195,11 @@ struct fixed_file_table {
 
 struct fixed_file_ref_node {
 	struct percpu_ref		refs;
+	/*
+	 * Track the number of reqs that reference this node, currently it's
+	 * only used in IOPOLL mode.
+	 */
+	u64				count;
 	struct list_head		node;
 	struct list_head		file_list;
 	struct fixed_file_data		*file_data;
@@ -651,7 +656,10 @@ struct io_kiocb {
 	 */
 	struct list_head		inflight_entry;
 
-	struct percpu_ref		*fixed_file_refs;
+	union {
+		struct percpu_ref		*fixed_file_refs;
+		struct fixed_file_ref_node	*fixed_file_ref_node;
+	};
 	struct callback_head		task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
@@ -1544,9 +1552,20 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 static inline void io_put_file(struct io_kiocb *req, struct file *file,
 			  bool fixed)
 {
-	if (fixed)
-		percpu_ref_put(req->fixed_file_refs);
-	else
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (fixed) {
+		/* See same comments in io_sqe_files_unregister(). */
+		if (ctx->flags & IORING_SETUP_IOPOLL) {
+			struct fixed_file_ref_node *ref_node = req->fixed_file_ref_node;
+			struct percpu_ref *refs = &ref_node->refs;
+
+			ref_node->count--;
+			if ((ctx->file_data->cur_refs != refs) && !ref_node->count)
+				percpu_ref_kill(refs);
+		} else
+			percpu_ref_put(req->fixed_file_refs);
+	} else
 		fput(file);
 }
 
@@ -5967,8 +5986,21 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
 		if (file) {
-			req->fixed_file_refs = ctx->file_data->cur_refs;
-			percpu_ref_get(req->fixed_file_refs);
+			struct percpu_ref *refs = ctx->file_data->cur_refs;
+
+			/*
+			 * In IOPOLL mode, we can always ensure get/put registered files under
+			 * uring_lock, so we can use a simple and plain u64 counter to synchronize
+			 * with registered files update operations in __io_sqe_files_update.
+			 */
+			if (ctx->flags & IORING_SETUP_IOPOLL) {
+				req->fixed_file_ref_node = container_of(refs,
+						struct fixed_file_ref_node, refs);
+				req->fixed_file_ref_node->count++;
+			} else {
+				req->fixed_file_refs = refs;
+				percpu_ref_get(refs);
+			}
 		}
 	} else {
 		trace_io_uring_file_get(ctx, fd);
@@ -6781,7 +6813,12 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		ref_node = list_first_entry(&data->ref_list,
 				struct fixed_file_ref_node, node);
 	spin_unlock(&data->lock);
-	if (ref_node)
+	/*
+	 * If count is not zero, that means we're in IOPOLL mode, and there are
+	 * still reqs that reference this ref_node, let the final req do the
+	 * percpu_ref_kill job.
+	 */
+	if (ref_node && !ref_node->count)
 		percpu_ref_kill(&ref_node->refs);
 
 	percpu_ref_kill(&data->refs);
@@ -7363,7 +7400,12 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	}
 
 	if (needs_switch) {
-		percpu_ref_kill(data->cur_refs);
+		struct fixed_file_ref_node *old_ref_node = container_of(data->cur_refs,
+				struct fixed_file_ref_node, refs);
+
+		/* See same comments in io_sqe_files_unregister(). */
+		if (!old_ref_node->count)
+			percpu_ref_kill(data->cur_refs);
 		spin_lock(&data->lock);
 		list_add(&ref_node->node, &data->ref_list);
 		data->cur_refs = &ref_node->refs;
-- 
2.17.2

