Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AB556BAE3
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 15:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbiGHNah (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 09:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbiGHNae (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 09:30:34 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F282CDD5
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 06:30:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d10so9760568pfd.9
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 06:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39SlS6NS1ui/steiqTOn7dlF7hk7Zbxqa+rOX/10Pw4=;
        b=CoaqZ63zFgb6H0DQbsbJ6CzLTFEZtS4eeqeDMyqFQm7lBfH9slPqXuEKokPKec8s9Z
         EdBAdY/EuNIkHfIG/E0uphNqXkLJn3aiFAbLMpbWTcTrRyupTOTIUud7X1V3v5DM2W4i
         cvvHtS9UKUmccn0Ej1JbQcQeQMYKftgysI6a7n25+0DCC6hOsrNsHjorEUpPjQRtguUV
         Q/hD+/Ry9sKkW/7lWE8GwrdWW08crja5embAGWH8747u5kLhZlDyeUtGxWGfaHZgpBha
         yn6fUbSkpw1O4W7TcgcbU6D0Fz6KpMyti8mtT3scD1yTP776vh7hRvojs3lRG4zPfOru
         zMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39SlS6NS1ui/steiqTOn7dlF7hk7Zbxqa+rOX/10Pw4=;
        b=PZIYKBNnd5ny8oJfw/Nl6MaYRnpQonxQysWlXOx08O19OobpQVYjRlY5DAnZq2PwYz
         rlkihaHcdUuR2izhuLmRXF1aKK7VTExMlu0rymWkVLeNh+ENoEgCfBEHCjS0wxOb5l0d
         qf1Njj6PRtqj2E5w4vWN4JSJKJ3HfHlo4fYtQZyJt5+9+BR5CMXoR+gU8Fvp9A1USFOm
         pTh4/MZ0sqSo3micDlAEK/teizxU3jPueTdeqV8uYfFJQpj+n8HM23h4I+E6cOsxFHvb
         8zH5YE4zv1lK2y8WYZ3kGh04a7e7H+6wOPrJRukpwcihQ4KtFONSAU98YqoG+z21zsia
         HTHA==
X-Gm-Message-State: AJIora/+nuS7Ep5P30GiTfo1V+rZNDPmaMMG6N5dnxKRG3Aj9QSkLG+l
        BNXO8qrIh8Z5y7fX1UfXTOoie6BgR4UKBg==
X-Google-Smtp-Source: AGRyM1sRwLGRZRb/mRnlt/fDgg67mXGCrtsBeksBgGhbK2jCutr/FRtpmvUkkCuZhreW8Q/GJ3CPqA==
X-Received: by 2002:a63:8bc8:0:b0:413:9952:6059 with SMTP id j191-20020a638bc8000000b0041399526059mr3252786pge.61.1657287031790;
        Fri, 08 Jul 2022 06:30:31 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a16-20020aa794b0000000b0052844157f09sm3800502pfl.51.2022.07.08.06.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 06:30:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, dylany@fb.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: add netmsg cache
Date:   Fri,  8 Jul 2022 07:30:22 -0600
Message-Id: <20220708133022.383961-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220708133022.383961-1-axboe@kernel.dk>
References: <20220708133022.383961-1-axboe@kernel.dk>
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
 include/linux/io_uring_types.h |  6 ++--
 io_uring/io_uring.c            |  3 ++
 io_uring/net.c                 | 63 +++++++++++++++++++++++++++++-----
 io_uring/net.h                 | 13 ++++++-
 4 files changed, 73 insertions(+), 12 deletions(-)

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
index c9c23e459766..f697ca4e8f55 100644
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
@@ -2469,6 +2471,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true);
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
+	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
diff --git a/io_uring/net.c b/io_uring/net.c
index 6679069eeef1..185553174437 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -12,6 +12,7 @@
 
 #include "io_uring.h"
 #include "kbuf.h"
+#include "alloc_cache.h"
 #include "net.h"
 
 #if defined(CONFIG_NET)
@@ -97,18 +98,55 @@ static bool io_net_retry(struct socket *sock, int flags)
 	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
 }
 
+static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_async_msghdr *hdr = req->async_data;
+
+	if (!hdr || issue_flags & IO_URING_F_UNLOCKED)
+		return;
+
+	/* Let normal cleanup path reap it if we fail adding to the cache */
+	if (io_alloc_cache_put(&req->ctx->netmsg_cache, &hdr->cache)) {
+		req->async_data = NULL;
+		req->flags &= ~REQ_F_ASYNC_DATA;
+	}
+}
+
+static struct io_async_msghdr *io_recvmsg_alloc_async(struct io_kiocb *req,
+						      unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_cache_entry *entry;
+
+	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
+	    (entry = io_alloc_cache_get(&ctx->netmsg_cache)) != NULL) {
+		struct io_async_msghdr *hdr;
+
+		hdr = container_of(entry, struct io_async_msghdr, cache);
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
@@ -195,7 +233,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg);
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -207,13 +245,13 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
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
@@ -221,6 +259,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+	io_netmsg_recycle(req, issue_flags);
 	if (ret >= 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -495,7 +534,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg);
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -519,13 +558,13 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -535,6 +574,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
+	io_netmsg_recycle(req, issue_flags);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret > 0)
 		ret += sr->done_io;
@@ -848,4 +888,9 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+void io_netmsg_cache_free(struct io_cache_entry *entry)
+{
+	kfree(container_of(entry, struct io_async_msghdr, cache));
+}
 #endif
diff --git a/io_uring/net.h b/io_uring/net.h
index 81d71d164770..178a6d8b76e0 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -3,9 +3,14 @@
 #include <linux/net.h>
 #include <linux/uio.h>
 
+#include "alloc_cache.h"
+
 #if defined(CONFIG_NET)
 struct io_async_msghdr {
-	struct iovec			fast_iov[UIO_FASTIOV];
+	union {
+		struct iovec		fast_iov[UIO_FASTIOV];
+		struct io_cache_entry	cache;
+	};
 	/* points to an allocated iov, if NULL we use fast_iov instead */
 	struct iovec			*free_iov;
 	struct sockaddr __user		*uaddr;
@@ -40,4 +45,10 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags);
 int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
+
+void io_netmsg_cache_free(struct io_cache_entry *entry);
+#else
+static inline void io_netmsg_cache_free(struct io_cache_entry *entry)
+{
+}
 #endif
-- 
2.35.1

