Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE8325463A
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgH0Npl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 09:45:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34234 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728014AbgH0NlV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 09:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598535674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psWUqAIUCBktAIdbYbu1Z+WKwvyIp9OeRhsDYOnwnmE=;
        b=ScPOG99pAzWc5TdCRcPZdL9sTLSoXp/KdGMsDaT6CSPU7Xo2bySfT0VSy3hGJ0fZ+60nBo
        5yeQf7nC8BYiJLzKKfIAL3J61R9DmW5ecFaPW1buSu4yIr6w31IrczLkOHFLkrPTEbeK5F
        QII141/7x+F1QU321g8aWI4PwYodRm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-3AekxEdzOg64YY2A_-5ErA-1; Thu, 27 Aug 2020 09:41:10 -0400
X-MC-Unique: 3AekxEdzOg64YY2A_-5ErA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EA4D425D1;
        Thu, 27 Aug 2020 13:41:07 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-96.ams2.redhat.com [10.36.113.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B49CD702E7;
        Thu, 27 Aug 2020 13:41:03 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Aleksa Sarai <asarai@suse.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH v5 3/3] io_uring: allow disabling rings during the creation
Date:   Thu, 27 Aug 2020 15:40:44 +0200
Message-Id: <20200827134044.82821-4-sgarzare@redhat.com>
In-Reply-To: <20200827134044.82821-1-sgarzare@redhat.com>
References: <20200827134044.82821-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds a new IORING_SETUP_R_DISABLED flag to start the
rings disabled, allowing the user to register restrictions,
buffers, files, before to start processing SQEs.

When IORING_SETUP_R_DISABLED is set, SQE are not processed and
SQPOLL kthread is not started.

The restrictions registration are allowed only when the rings
are disable to prevent concurrency issue while processing SQEs.

The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
opcode with io_uring_register(2).

Suggested-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v4:
 - fixed io_uring_enter() exit path when ring is disabled

v3:
 - enabled restrictions only when the rings start

RFC v2:
 - removed return value of io_sq_offload_start()
---
 fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 93b023930b0b..1820f704e6ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -226,6 +226,7 @@ struct io_restriction {
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
+	bool registered;
 };
 
 struct io_ring_ctx {
@@ -7481,8 +7482,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static int io_sq_offload_start(struct io_ring_ctx *ctx,
-			       struct io_uring_params *p)
+static int io_sq_offload_create(struct io_ring_ctx *ctx,
+				struct io_uring_params *p)
 {
 	int ret;
 
@@ -7516,7 +7517,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			ctx->sqo_thread = NULL;
 			goto err;
 		}
-		wake_up_process(ctx->sqo_thread);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -7533,6 +7533,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static void io_sq_offload_start(struct io_ring_ctx *ctx)
+{
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sqo_thread)
+		wake_up_process(ctx->sqo_thread);
+}
+
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)
 {
@@ -8279,6 +8285,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (!percpu_ref_tryget(&ctx->refs))
 		goto out_fput;
 
+	if (ctx->flags & IORING_SETUP_R_DISABLED)
+		goto out_fput;
+
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
 	 * Just return the requested submit count, and wake the thread if
@@ -8596,10 +8605,13 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	ret = io_sq_offload_start(ctx, p);
+	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
 
+	if (!(p->flags & IORING_SETUP_R_DISABLED))
+		io_sq_offload_start(ctx);
+
 	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
 	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
@@ -8662,7 +8674,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -8745,8 +8758,12 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 	size_t size;
 	int i, ret;
 
+	/* Restrictions allowed only if rings started disabled */
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
 	/* We allow only a single restrictions registration */
-	if (ctx->restricted)
+	if (ctx->restrictions.registered)
 		return -EBUSY;
 
 	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
@@ -8791,7 +8808,7 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 		}
 	}
 
-	ctx->restricted = 1;
+	ctx->restrictions.registered = true;
 
 	ret = 0;
 out:
@@ -8803,6 +8820,21 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
+static int io_register_enable_rings(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
+	if (ctx->restrictions.registered)
+		ctx->restricted = 1;
+
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+
+	io_sq_offload_start(ctx);
+
+	return 0;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -8924,6 +8956,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_personality(ctx, nr_args);
 		break;
+	case IORING_REGISTER_ENABLE_RINGS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_register_enable_rings(ctx);
+		break;
 	case IORING_REGISTER_RESTRICTIONS:
 		ret = io_register_restrictions(ctx, arg, nr_args);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6e7f2e5e917b..a0c85e0e9016 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -95,6 +95,7 @@ enum {
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
+#define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 
 enum {
 	IORING_OP_NOP,
@@ -268,6 +269,7 @@ enum {
 	IORING_REGISTER_PERSONALITY		= 9,
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
+	IORING_REGISTER_ENABLE_RINGS		= 12,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
-- 
2.26.2

