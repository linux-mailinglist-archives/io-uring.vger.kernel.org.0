Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC526CC56B
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 17:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbjC1POP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 11:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjC1PNn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 11:13:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730661041C
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 08:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680016265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=siKKh0x5p/UqrBQe9QYa+cxMAYrLZPJZiVZtx1DzXec=;
        b=Yl5FdRpJp7RFWDKyfDFsAPK0F5bnCA7FwbVoN1lxGqUm8CpdNfhfoAY1x7uEyFTPEKdhQH
        F2DiweAWSTtWmru4/AWrrQIgDg1kJql0vYBrhf3kQ4R0y7lF/nPAf4/p6JoJl1Y8UQv982
        MKAAU+B7MLoBUv65rWYxuEv38fuKb0s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-TbRalWqROt-cqgLg3YGivw-1; Tue, 28 Mar 2023 11:11:00 -0400
X-MC-Unique: TbRalWqROt-cqgLg3YGivw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E82993C17124;
        Tue, 28 Mar 2023 15:10:58 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0416C1121330;
        Tue, 28 Mar 2023 15:10:57 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 03/16] io_uring: support normal SQE for fused command
Date:   Tue, 28 Mar 2023 23:09:45 +0800
Message-Id: <20230328150958.1253547-4-ming.lei@redhat.com>
In-Reply-To: <20230328150958.1253547-1-ming.lei@redhat.com>
References: <20230328150958.1253547-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

So far, the secondary sqe is saved in the 2nd 64 byte of primary sqe, which
requires that SQE128 has to be enabled. Relax this limit by allowing to
fetch secondary SQE from SQ directly.

IORING_URING_CMD_FUSED_SPLIT_SQE has to be set for this usage, and
userspace has to put secondary SQE following the primary sqe.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h |  8 ++++++-
 io_uring/fused_cmd.c          | 42 ++++++++++++++++++++++++++++-------
 io_uring/io_uring.c           | 23 +++++++++++++------
 io_uring/io_uring.h           |  2 ++
 4 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 98b7f21623f9..b379677dff9d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -235,9 +235,15 @@ enum io_uring_op {
  * sqe->uring_cmd_flags
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ *
+ * IORING_URING_CMD_FUSED_SPLIT_SQE fused command only, secondary sqe is
+ * 				    provided from another new sqe; without
+ * 				    setting the flag, secondary sqe is from
+ * 				    2nd 64byte of this sqe, so SQE128 has
+ * 				    to be enabled
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
-
+#define IORING_URING_CMD_FUSED_SPLIT_SQE	(1U << 1)
 
 /*
  * sqe->fsync_flags
diff --git a/io_uring/fused_cmd.c b/io_uring/fused_cmd.c
index 7af3ddb182c1..25577cbb0e9c 100644
--- a/io_uring/fused_cmd.c
+++ b/io_uring/fused_cmd.c
@@ -43,18 +43,34 @@ static inline void io_fused_cmd_update_link_flags(struct io_kiocb *req,
 		req->flags |= REQ_F_LINK;
 }
 
+static const struct io_uring_sqe *fused_cmd_get_secondary_sqe(
+		struct io_ring_ctx *ctx, const struct io_uring_sqe *primary,
+		bool split_sqe)
+{
+	if (unlikely(!(ctx->flags & IORING_SETUP_SQE128) && !split_sqe))
+		return NULL;
+
+	if (split_sqe) {
+		const struct io_uring_sqe *sqe;
+
+		if (unlikely(!io_get_secondary_sqe(ctx, &sqe)))
+			return NULL;
+		return sqe;
+	}
+
+	return primary + 1;
+}
+
 int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	const struct io_uring_sqe *secondary_sqe = sqe + 1;
+	const struct io_uring_sqe *secondary_sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *secondary;
 	u8 secondary_op;
 	int ret;
-
-	if (unlikely(!(ctx->flags & IORING_SETUP_SQE128)))
-		return -EINVAL;
+	bool split_sqe;
 
 	if (unlikely(sqe->__pad1))
 		return -EINVAL;
@@ -67,7 +83,12 @@ int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
-	if (unlikely(ioucmd->flags))
+	if (unlikely(ioucmd->flags & ~IORING_URING_CMD_FUSED_SPLIT_SQE))
+		return -EINVAL;
+
+	split_sqe = ioucmd->flags & IORING_URING_CMD_FUSED_SPLIT_SQE;
+	secondary_sqe = fused_cmd_get_secondary_sqe(ctx, sqe, split_sqe);
+	if (unlikely(!secondary_sqe))
 		return -EINVAL;
 
 	secondary_op = READ_ONCE(secondary_sqe->opcode);
@@ -78,8 +99,12 @@ int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	req->fused_cmd_kbuf = NULL;
 
-	/* take one extra reference for the secondary request */
-	io_get_task_refs(1);
+	/*
+	 * Take one extra reference for the secondary request built from
+	 * builtin SQE since io_uring core code doesn't grab it for us
+	 */
+	if (!split_sqe)
+		io_get_task_refs(1);
 
 	ret = -ENOMEM;
 	if (unlikely(!io_alloc_req(ctx, &secondary)))
@@ -103,7 +128,8 @@ int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 fail_free_req:
 	io_free_req(secondary);
 fail:
-	current->io_uring->cached_refs += 1;
+	if (!split_sqe)
+		current->io_uring->cached_refs += 1;
 	return ret;
 }
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ddbc9b9e51d3..9d9bc5b06ca2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2414,7 +2414,8 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
  * used, it's important that those reads are done through READ_ONCE() to
  * prevent a re-load down the line.
  */
-static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
+static inline bool io_get_sqe(struct io_ring_ctx *ctx,
+		const struct io_uring_sqe **sqe)
 {
 	unsigned head, mask = ctx->sq_entries - 1;
 	unsigned sq_idx = ctx->cached_sq_head++ & mask;
@@ -2443,19 +2444,26 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	return false;
 }
 
+bool io_get_secondary_sqe(struct io_ring_ctx *ctx,
+		const struct io_uring_sqe **sqe)
+{
+	return io_get_sqe(ctx, sqe);
+}
+
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
-	unsigned int left;
+	unsigned old_head = ctx->cached_sq_head;
+	unsigned int left = 0;
 	int ret;
 
 	if (unlikely(!entries))
 		return 0;
 	/* make sure SQ entry isn't read before tail */
-	ret = left = min3(nr, ctx->sq_entries, entries);
-	io_get_task_refs(left);
-	io_submit_state_start(&ctx->submit_state, left);
+	ret = min3(nr, ctx->sq_entries, entries);
+	io_get_task_refs(ret);
+	io_submit_state_start(&ctx->submit_state, ret);
 
 	do {
 		const struct io_uring_sqe *sqe;
@@ -2474,11 +2482,12 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		 */
 		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
 		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
-			left--;
+			left = 1;
 			break;
 		}
-	} while (--left);
+	} while ((ctx->cached_sq_head - old_head) < ret);
 
+	left = ret - (ctx->cached_sq_head - old_head) - left;
 	if (unlikely(left)) {
 		ret -= left;
 		/* try again if it submitted nothing and can't allocate a req */
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dd193c612348..8ede804b3caf 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -78,6 +78,8 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
+bool io_get_secondary_sqe(struct io_ring_ctx *ctx,
+		const struct io_uring_sqe **sqe);
 int io_init_secondary_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		const struct io_uring_sqe *sqe);
 
-- 
2.39.2

