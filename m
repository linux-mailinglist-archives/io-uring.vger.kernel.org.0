Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF635A953F
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiIAK6w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 06:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiIAK6k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 06:58:40 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3B2C7414
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 03:58:38 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id p16so30718455ejb.9
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 03:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=OjX390DsH1Kp+02it10+FD3PDGAsJzS0kqcQGN91yks=;
        b=lK8DQIRoKIHl+OR+eejno3tPDyWXycFW566jTdnkDU4uP4YR30luZkEhSLf8StY2pn
         p9FxIVElTfhDvJ0Dg5Dx1el1axW3l4eRm9zrQVqhFAXIBkO0Cyz9uvRojGApmWlWSqzz
         6bMoV1Ok+QKh/UkocAdEo+2fcvGAY7txkr0FRU0C8SgoDZep+lMMiN/W1JIh2hVVT69f
         kRTYjHQ9rYLut4HW4Juz5Sv07lDEgQPaCaQ+enVPZKLDK0uHJw/vGK9/d5UPUbTlXHlM
         CG2NKV+NnNKDTIhtXTNIYrPP6tiuRTP/pSyJ5rHi8LMtfikwUomOMSTBbNnMuguY10JS
         NQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OjX390DsH1Kp+02it10+FD3PDGAsJzS0kqcQGN91yks=;
        b=wce5lTetwBlDxdkoOQJc51MV7WFrpKMy89KmDRu1dU1Qs1Q5rNRfsmCyxTiBG9wizW
         YncatdZMUy+TcDhIjG31exnHh3vuvbL+ZekVAS6QzukfuJZTbO+sBwSADYJ1x8MaiDRU
         0P/RYH35ritVZTJ0KwFzTTivoCBBqYdTceomtSWIz3d6MPD2J+dfQRvnMUMdygTSK10g
         fSC4k5GC1I8l/q/7mzNfIVsJNi8whSouioRmxzXzNFGHWLZHunc+S7lfxponzen+zCYn
         Qm/PDyZfLIol8XOxqarY4qvCsd9Jn+heEjFagqh86pwdqXp6qXTYg4D697ThJ4U+kln5
         vzfw==
X-Gm-Message-State: ACgBeo1gQw+yrbi4fF/ak5BPBBHVgOVkr+vZWJytc6UFo93pMYbJ26jh
        z34Kq9AcgUeZSdqzt9XSNnO4DoN3SLY=
X-Google-Smtp-Source: AA6agR7g1MBj8WTrShpRw9uTDuflbxaEEewfW3yl2vJlAopfbSOd8msnxs10e1FX5EK528Jhvv3Qkw==
X-Received: by 2002:a17:906:ef90:b0:730:9cd8:56d7 with SMTP id ze16-20020a170906ef9000b007309cd856d7mr22086752ejb.94.1662029916243;
        Thu, 01 Sep 2022 03:58:36 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e81f])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709060ace00b0073d6d6e698bsm8277762ejf.187.2022.09.01.03.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:58:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 5/6] io_uring/net: simplify zerocopy send user API
Date:   Thu,  1 Sep 2022 11:54:04 +0100
Message-Id: <95287640ab98fc9417370afb16e310677c63e6ce.1662027856.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662027856.git.asml.silence@gmail.com>
References: <cover.1662027856.git.asml.silence@gmail.com>
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

Following user feedback, this patch simplifies zerocopy send API. One of
the main complaints is that the current API is difficult with the
userspace managing notification slots, and then send retries with error
handling make it even worse.

Instead of keeping notification slots change it to the per-request
notifications model, which posts both completion and notification CQEs
for each request when any data has been sent, and only one CQE if it
fails. All notification CQEs will have IORING_CQE_F_NOTIF set and
IORING_CQE_F_MORE in completion CQEs indicates whether to wait a
notification or not.

IOSQE_CQE_SKIP_SUCCESS is disallowed with zerocopy sends for now.

This is less flexible, but greatly simplifies the user API and also the
kernel implementation. We reuse notif helpers in this patch, but in the
future there won't be need for keeping two requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  7 +++--
 io_uring/io_uring.c           |  4 +--
 io_uring/net.c                | 53 ++++++++++++++++++++++-------------
 io_uring/net.h                |  1 +
 io_uring/notif.c              | 12 ++------
 io_uring/notif.h              | 43 ++--------------------------
 io_uring/opdef.c              |  3 +-
 7 files changed, 47 insertions(+), 76 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b11c57b0ebb5..6b83177fd41d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -71,8 +71,8 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 		struct {
-			__u16	notification_idx;
 			__u16	addr_len;
+			__u16	__pad3[1];
 		};
 	};
 	union {
@@ -205,7 +205,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
-	IORING_OP_SENDZC_NOTIF,
+	IORING_OP_SEND_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -326,10 +326,13 @@ struct io_uring_cqe {
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
  * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
  * IORING_CQE_F_SOCK_NONEMPTY	If set, more data to read after socket recv
+ * IORING_CQE_F_NOTIF	Set for notification CQEs. Can be used to distinct
+ * 			them from sends.
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
+#define IORING_CQE_F_NOTIF		(1U << 3)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c2e06a3aa18d..f9be9b7eb654 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3923,8 +3923,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
-	BUILD_BUG_SQE_ELEM(44, __u16,  notification_idx);
-	BUILD_BUG_SQE_ELEM(46, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
diff --git a/io_uring/net.c b/io_uring/net.c
index aac6997b7d88..7047c1342541 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -65,12 +65,12 @@ struct io_sendzc {
 	struct file			*file;
 	void __user			*buf;
 	size_t				len;
-	u16				slot_idx;
 	unsigned			msg_flags;
 	unsigned			flags;
 	unsigned			addr_len;
 	void __user			*addr;
 	size_t				done_io;
+	struct io_kiocb 		*notif;
 };
 
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
@@ -879,12 +879,26 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+void io_sendzc_cleanup(struct io_kiocb *req)
+{
+	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+
+	zc->notif->flags |= REQ_F_CQE_SKIP;
+	io_notif_flush(zc->notif);
+	zc->notif = NULL;
+}
+
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *notif;
 
-	if (READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3))
+	if (READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3) ||
+	    READ_ONCE(sqe->__pad3[0]))
+		return -EINVAL;
+	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
+	if (req->flags & REQ_F_CQE_SKIP)
 		return -EINVAL;
 
 	zc->flags = READ_ONCE(sqe->ioprio);
@@ -900,11 +914,17 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->imu = READ_ONCE(ctx->user_bufs[idx]);
 		io_req_set_rsrc_node(req, ctx, 0);
 	}
+	notif = zc->notif = io_alloc_notif(ctx);
+	if (!notif)
+		return -ENOMEM;
+	notif->cqe.user_data = req->cqe.user_data;
+	notif->cqe.res = 0;
+	notif->cqe.flags = IORING_CQE_F_NOTIF;
+	req->flags |= REQ_F_NEED_CLEANUP;
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	zc->len = READ_ONCE(sqe->len);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
-	zc->slot_idx = READ_ONCE(sqe->notification_idx);
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
@@ -976,33 +996,20 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address, *addr = NULL;
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
-	struct io_notif_slot *notif_slot;
-	struct io_kiocb *notif;
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-	unsigned msg_flags;
+	unsigned msg_flags, cflags;
 	int ret, min_ret = 0;
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
-
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		return -EAGAIN;
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	notif_slot = io_get_notif_slot(ctx, zc->slot_idx);
-	if (!notif_slot)
-		return -EINVAL;
-	notif = io_get_notif(ctx, notif_slot);
-	if (!notif)
-		return -ENOMEM;
-
 	msg.msg_name = NULL;
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
@@ -1033,7 +1040,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 					  &msg.msg_iter);
 		if (unlikely(ret))
 			return ret;
-		ret = io_notif_account_mem(notif, zc->len);
+		ret = io_notif_account_mem(zc->notif, zc->len);
 		if (unlikely(ret))
 			return ret;
 	}
@@ -1045,7 +1052,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	msg.msg_flags = msg_flags;
-	msg.msg_ubuf = &io_notif_to_data(notif)->uarg;
+	msg.msg_ubuf = &io_notif_to_data(zc->notif)->uarg;
 	msg.sg_from_iter = io_sg_from_iter;
 	ret = sock_sendmsg(sock, &msg);
 
@@ -1060,6 +1067,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_addr(req, addr, issue_flags);
 		}
+		if (ret < 0 && !zc->done_io)
+			zc->notif->flags |= REQ_F_CQE_SKIP;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1069,7 +1078,11 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		ret += zc->done_io;
 	else if (zc->done_io)
 		ret = zc->done_io;
-	io_req_set_res(req, ret, 0);
+
+	io_notif_flush(zc->notif);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
+	io_req_set_res(req, ret, cflags);
 	return IOU_OK;
 }
 
diff --git a/io_uring/net.h b/io_uring/net.h
index f91f56c6eeac..d744a0a874e7 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -55,6 +55,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_sendzc_cleanup(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
 #else
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 11f45640684a..38d77165edc3 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -42,8 +42,7 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 	}
 }
 
-struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
-				struct io_notif_slot *slot)
+struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_kiocb *notif;
@@ -59,27 +58,20 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 	io_get_task_refs(1);
 	notif->rsrc_node = NULL;
 	io_req_set_rsrc_node(notif, ctx, 0);
-	notif->cqe.user_data = slot->tag;
-	notif->cqe.flags = slot->seq++;
-	notif->cqe.res = 0;
 
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
 	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	nd->uarg.callback = io_uring_tx_zerocopy_callback;
-	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
 }
 
-void io_notif_slot_flush(struct io_notif_slot *slot)
+void io_notif_flush(struct io_kiocb *notif)
 	__must_hold(&slot->notif->ctx->uring_lock)
 {
-	struct io_kiocb *notif = slot->notif;
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
-	slot->notif = NULL;
-
 	/* drop slot's master ref */
 	if (refcount_dec_and_test(&nd->uarg.refcnt)) {
 		notif->io_task_work.func = __io_notif_complete_tw;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 8380eeff2f2e..5b4d710c8ca5 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -15,53 +15,14 @@ struct io_notif_data {
 	unsigned long		account_pages;
 };
 
-struct io_notif_slot {
-	/*
-	 * Current/active notifier. A slot holds only one active notifier at a
-	 * time and keeps one reference to it. Flush releases the reference and
-	 * lazily replaces it with a new notifier.
-	 */
-	struct io_kiocb		*notif;
-
-	/*
-	 * Default ->user_data for this slot notifiers CQEs
-	 */
-	u64			tag;
-	/*
-	 * Notifiers of a slot live in generations, we create a new notifier
-	 * only after flushing the previous one. Track the sequential number
-	 * for all notifiers and copy it into notifiers's cqe->cflags
-	 */
-	u32			seq;
-};
-
-void io_notif_slot_flush(struct io_notif_slot *slot);
-struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
-				struct io_notif_slot *slot);
+void io_notif_flush(struct io_kiocb *notif);
+struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx);
 
 static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 {
 	return io_kiocb_to_cmd(notif, struct io_notif_data);
 }
 
-static inline struct io_kiocb *io_get_notif(struct io_ring_ctx *ctx,
-					    struct io_notif_slot *slot)
-{
-	if (!slot->notif)
-		slot->notif = io_alloc_notif(ctx, slot);
-	return slot->notif;
-}
-
-static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
-						      unsigned idx)
-	__must_hold(&ctx->uring_lock)
-{
-	if (idx >= ctx->nr_notif_slots)
-		return NULL;
-	idx = array_index_nospec(idx, ctx->nr_notif_slots);
-	return &ctx->notif_slots[idx];
-}
-
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 {
 	struct io_ring_ctx *ctx = notif->ctx;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 10b301ccf5cd..c61494e0a602 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -470,7 +470,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_uring_cmd,
 		.prep_async		= io_uring_cmd_prep_async,
 	},
-	[IORING_OP_SENDZC_NOTIF] = {
+	[IORING_OP_SEND_ZC] = {
 		.name			= "SENDZC_NOTIF",
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
@@ -483,6 +483,7 @@ const struct io_op_def io_op_defs[] = {
 		.prep			= io_sendzc_prep,
 		.issue			= io_sendzc,
 		.prep_async		= io_sendzc_prep_async,
+		.cleanup		= io_sendzc_cleanup,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.37.2

