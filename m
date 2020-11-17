Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9802B59A2
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 07:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgKQGRa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 01:17:30 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:59155 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbgKQGRa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 01:17:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UFfrlDN_1605593844;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UFfrlDN_1605593844)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Nov 2020 14:17:25 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for registered files in IOPOLL mode
Date:   Tue, 17 Nov 2020 14:17:23 +0800
Message-Id: <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
percpu_ref_put() for registered files, but it's hard to say they're very
light-weight synchronization primitives. In one our x86 machine, I get below
perf data(registered files enabled):
Samples: 480K of event 'cycles', Event count (approx.): 298552867297
Overhead  Comman  Shared Object     Symbol
   0.45%  :53243  [kernel.vmlinux]  [k] io_file_get

Currently I don't find any good and generic solution for this issue, but
in IOPOLL mode, given that we can always ensure get/put registered files
under uring_lock, we can use a simple and plain u64 counter to synchronize
with registered files update operations in __io_sqe_files_update().

With this patch, perf data show shows:
Samples: 480K of event 'cycles', Event count (approx.): 298811248406
Overhead  Comma  Shared Object     Symbol
   0.25%  :4182  [kernel.vmlinux]  [k] io_file_get

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 219609c38e48..0fa48ea50ff9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -201,6 +201,11 @@ struct fixed_file_table {
 
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
@@ -1926,10 +1931,17 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 static inline void io_put_file(struct io_kiocb *req, struct file *file,
 			  bool fixed)
 {
-	if (fixed)
-		percpu_ref_put(&req->ref_node->refs);
-	else
+	if (fixed) {
+		/* See same comments in io_file_get(). */
+		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+			if (!--req->ref_node->count)
+				percpu_ref_kill(&req->ref_node->refs);
+		} else {
+			percpu_ref_put(&req->ref_node->refs);
+		}
+	} else {
 		fput(file);
+	}
 }
 
 static void io_dismantle_req(struct io_kiocb *req)
@@ -6344,8 +6356,16 @@ static struct file *io_file_get(struct io_submit_state *state,
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
 		if (file) {
+			/*
+			 * IOPOLL mode can always ensure get/put registered files under uring_lock,
+			 * so we can use a simple plain u64 counter to synchronize with registered
+			 * files update operations in __io_sqe_files_update.
+			 */
 			req->ref_node = ctx->file_data->node;
-			percpu_ref_get(&req->ref_node->refs);
+			if (ctx->flags & IORING_SETUP_IOPOLL)
+				req->ref_node->count++;
+			else
+				percpu_ref_get(&req->ref_node->refs);
 		}
 	} else {
 		trace_io_uring_file_get(ctx, fd);
@@ -7215,7 +7235,12 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		ref_node = list_first_entry(&data->ref_list,
 				struct fixed_file_ref_node, node);
 	spin_unlock(&data->lock);
-	if (ref_node)
+	/*
+	 * If count is not zero, that means we're in IOPOLL mode, and there are
+	 * still reqs that reference this ref_node, let the final req do the
+	 * percpu_ref_kill job.
+	 */
+	if (ref_node && (!--ref_node->count))
 		percpu_ref_kill(&ref_node->refs);
 
 	percpu_ref_kill(&data->refs);
@@ -7625,6 +7650,7 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->file_list);
 	ref_node->file_data = ctx->file_data;
+	ref_node->count = 1;
 	return ref_node;
 }
 
@@ -7877,7 +7903,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	}
 
 	if (needs_switch) {
-		percpu_ref_kill(&data->node->refs);
+		/* See same comments in io_sqe_files_unregister(). */
+		if (!--data->node->count)
+			percpu_ref_kill(&data->node->refs);
 		spin_lock(&data->lock);
 		list_add(&ref_node->node, &data->ref_list);
 		data->node = ref_node;
-- 
2.17.2

