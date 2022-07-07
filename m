Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C71556AEFD
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 01:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbiGGXYY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 19:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbiGGXYX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 19:24:23 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B567E24BE7
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 16:24:22 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r22so14030990pgr.2
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 16:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JGIYQNoCNQyFDgOi5BBnQH0Ka82LgrDzI6+kpC1AjqQ=;
        b=iSThwNZ1znE657nL0l7zklqrL6vZLXqO7pFuAKMMo/ZaqCHnsxzMAVenIwataTRaZs
         QD3Z9u0ActDe4Nq6LY6f685uRwVNjIIgKnJXOlazpgXLfy7lrOEHbqPJajD6NkWL8hwT
         g14wEqfPpvFCtRa2Nj1ZjnPZtt4oWuBp8sNcm2sb+MNNeNhho6TohlhOF/bZhM5K1bIR
         bHdlOwGfbUS97I7ndR/POUjXwlnEUdvv23VaI9lzzXxmEE5VIoN3m65QEbmSXhbJtRyS
         Yq4S5ZjZJdnzOYIN1Tb83VeFUchzcsHOqlE2OzTPgLpOMDXCAIYfqa/SoUHacOIAcDHE
         yFow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JGIYQNoCNQyFDgOi5BBnQH0Ka82LgrDzI6+kpC1AjqQ=;
        b=X7nqVtgYpblP7wvHJADxVBtJ0i8MoHZcn4nfOxEY/onD7DtZj4GSOkUX0pKfylKOVZ
         FTjRcsQau4NGiJ+zFjCVi/4C0jMORYWUmcmiL0QmujFJGlERmLwLafWtg6MQsSEc/zQh
         JxrIU9fUIdgT5JZx2wI2xESSpByDZIEPW6FhX1XaRL0wuaOJld1Azxo9eGfLjRxwNSKN
         SNihpc0+J/pRlCOP3Ijh1Sr6zP0s8N8SDolYzXaJAUdxFQRcQ0t5V9rL0ihzo881wk7G
         tv7WQOLdxhwZ+aNFz87JSBdyQgcw4IoNkp70OJk4dk7M2mxvZiN6+X6cohjDxIvhIX46
         C0rg==
X-Gm-Message-State: AJIora+P40/H3HES3TCXbeYpmFfhz6OW0Qyi5/YhDN3UqKiYM1EzOCjp
        jxWWb1klIU7DpKOn6oytOezvV3Ecyu//mQ==
X-Google-Smtp-Source: AGRyM1sUyzJKZoFDrFmPszUhyZ1rbKynBtCZ1CGc+DQBFLH/mE/yD7Oy/QTuyBQRy1xbeRwz8Yc3/Q==
X-Received: by 2002:a63:9701:0:b0:40c:a588:b488 with SMTP id n1-20020a639701000000b0040ca588b488mr488060pge.303.1657236261784;
        Thu, 07 Jul 2022 16:24:21 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s65-20020a17090a69c700b001efeb4c813csm94014pjj.13.2022.07.07.16.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 16:24:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: add netmsg cache
Date:   Thu,  7 Jul 2022 17:23:46 -0600
Message-Id: <20220707232345.54424-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220707232345.54424-1-axboe@kernel.dk>
References: <20220707232345.54424-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For recvmsg/sendmsg, if they don't complete inline, we currently need
to allocate a struct io_async_msghdr for each request. This is a
somewhat large struct.

Hook up sendmsg/recvmsg to use the io_alloc_cache. This reduces the
alloc + free overhead considerably, yielding 4-5% of extra performance
running netbench.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  6 ++-
 io_uring/io_uring.c            |  3 ++
 io_uring/net.c                 | 73 +++++++++++++++++++++++++++++-----
 io_uring/net.h                 | 11 ++++-
 4 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index bf8f95332eda..d54b8b7e0746 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -222,8 +222,7 @@ struct io_ring_ctx {
 		struct io_hash_table	cancel_table_locked;
 		struct list_head	cq_overflow_list;
 		struct io_alloc_cache	apoll_cache;
-		struct xarray		personalities;
-		u32			pers_next;
+		struct io_alloc_cache	netmsg_cache;
 	} ____cacheline_aligned_in_smp;
 
 	/* IRQ completion list, under ->completion_lock */
@@ -241,6 +240,9 @@ struct io_ring_ctx {
 	unsigned int		file_alloc_start;
 	unsigned int		file_alloc_end;
 
+	struct xarray		personalities;
+	u32			pers_next;
+
 	struct {
 		/*
 		 * We cache a range of free CQEs we can use, once exhausted it
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b5098773d924..32110c5b4059 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -89,6 +89,7 @@
 #include "kbuf.h"
 #include "rsrc.h"
 #include "cancel.h"
+#include "net.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -297,6 +298,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
 	io_alloc_cache_init(&ctx->apoll_cache);
+	io_alloc_cache_init(&ctx->netmsg_cache);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -2473,6 +2475,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true);
 	io_eventfd_unregister(ctx);
 	io_flush_apoll_cache(ctx);
+	io_flush_netmsg_cache(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
diff --git a/io_uring/net.c b/io_uring/net.c
index 6679069eeef1..ba7e94ff287c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -12,6 +12,7 @@
 
 #include "io_uring.h"
 #include "kbuf.h"
+#include "alloc_cache.h"
 #include "net.h"
 
 #if defined(CONFIG_NET)
@@ -97,18 +98,57 @@ static bool io_net_retry(struct socket *sock, int flags)
 	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
 }
 
+static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_async_msghdr *hdr = req->async_data;
+
+	if (!hdr || issue_flags & IO_URING_F_UNLOCKED)
+		return;
+
+	if (io_alloc_cache_store(&req->ctx->netmsg_cache)) {
+		hlist_add_head(&hdr->cache_list, &req->ctx->netmsg_cache.list);
+		req->async_data = NULL;
+		req->flags &= ~REQ_F_ASYNC_DATA;
+	}
+}
+
+static struct io_async_msghdr *io_recvmsg_alloc_async(struct io_kiocb *req,
+						      unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
+	    !hlist_empty(&ctx->netmsg_cache.list)) {
+		struct io_async_msghdr *hdr;
+
+		hdr = hlist_entry(ctx->netmsg_cache.list.first,
+					struct io_async_msghdr, cache_list);
+		ctx->netmsg_cache.nr_cached--;
+		hlist_del(&hdr->cache_list);
+		req->flags |= REQ_F_ASYNC_DATA;
+		req->async_data = hdr;
+		return hdr;
+	}
+
+	if (!io_alloc_async_data(req))
+		return req->async_data;
+
+	return NULL;
+}
+
 static int io_setup_async_msg(struct io_kiocb *req,
-			      struct io_async_msghdr *kmsg)
+			      struct io_async_msghdr *kmsg,
+			      unsigned int issue_flags)
 {
 	struct io_async_msghdr *async_msg = req->async_data;
 
 	if (async_msg)
 		return -EAGAIN;
-	if (io_alloc_async_data(req)) {
+	async_msg = io_recvmsg_alloc_async(req, issue_flags);
+	if (!async_msg) {
 		kfree(kmsg->free_iov);
 		return -ENOMEM;
 	}
-	async_msg = req->async_data;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	async_msg->msg.msg_name = &async_msg->addr;
@@ -195,7 +235,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg);
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -207,13 +247,13 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
-			return io_setup_async_msg(req, kmsg);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		req_set_fail(req);
 	}
@@ -221,6 +261,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+	io_netmsg_recycle(req, issue_flags);
 	if (ret >= 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -495,7 +536,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg);
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -519,13 +560,13 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg, kmsg->uaddr, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock)
-			return io_setup_async_msg(req, kmsg);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
-			return io_setup_async_msg(req, kmsg);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
@@ -535,6 +576,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
+	io_netmsg_recycle(req, issue_flags);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret > 0)
 		ret += sr->done_io;
@@ -848,4 +890,17 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+void io_flush_netmsg_cache(struct io_ring_ctx *ctx)
+{
+	while (!hlist_empty(&ctx->netmsg_cache.list)) {
+		struct io_async_msghdr *hdr;
+
+		hdr = hlist_entry(ctx->netmsg_cache.list.first,
+					struct io_async_msghdr, cache_list);
+		hlist_del(&hdr->cache_list);
+		kfree(hdr);
+	}
+	ctx->netmsg_cache.nr_cached = 0;
+}
 #endif
diff --git a/io_uring/net.h b/io_uring/net.h
index 81d71d164770..576efb602c7f 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -5,7 +5,10 @@
 
 #if defined(CONFIG_NET)
 struct io_async_msghdr {
-	struct iovec			fast_iov[UIO_FASTIOV];
+	union {
+		struct iovec		fast_iov[UIO_FASTIOV];
+		struct hlist_node	cache_list;
+	};
 	/* points to an allocated iov, if NULL we use fast_iov instead */
 	struct iovec			*free_iov;
 	struct sockaddr __user		*uaddr;
@@ -40,4 +43,10 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags);
 int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
+
+void io_flush_netmsg_cache(struct io_ring_ctx *ctx);
+#else
+static inline void io_flush_netmsg_cache(struct io_ring_ctx *ctx)
+{
+}
 #endif
-- 
2.35.1

