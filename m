Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0F0243C97
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 17:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgHMPeP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 11:34:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58284 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726576AbgHMPeO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 11:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597332852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzivr37W6Sz/OFkat8WISQrphMPdi2PlV4uzOfubSgg=;
        b=gGvfwBtkh5RtP18LZlcKA9J+cw7xGLCj5l+bfM0324WOmoi8NqG3kv8oxRLZ+MaLkSdlYo
        hrul+0KRTn5d4EmXhB0mpW6XbB6em9FEFsya3yTDU/a1qfEQLkHfjzNShrDf1QgkiGG8AZ
        3d1n8UU1aBoaZ4c8qoM9b9HTsyrXVhw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-14sqnvJ0PGe7-Ac8Ox3DLQ-1; Thu, 13 Aug 2020 11:34:10 -0400
X-MC-Unique: 14sqnvJ0PGe7-Ac8Ox3DLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C53A1807321;
        Thu, 13 Aug 2020 15:34:08 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-140.ams2.redhat.com [10.36.113.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6443C60C04;
        Thu, 13 Aug 2020 15:33:49 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <asarai@suse.de>,
        io-uring@vger.kernel.org
Subject: [PATCH v4 3/3] io_uring: allow disabling rings during the creation
Date:   Thu, 13 Aug 2020 17:32:54 +0200
Message-Id: <20200813153254.93731-4-sgarzare@redhat.com>
In-Reply-To: <20200813153254.93731-1-sgarzare@redhat.com>
References: <20200813153254.93731-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index cb365e6e0af7..09fedc380a41 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -226,6 +226,7 @@ struct io_restriction {
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
+	bool registered;
 };
 
 struct io_ring_ctx {
@@ -7420,8 +7421,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static int io_sq_offload_start(struct io_ring_ctx *ctx,
-			       struct io_uring_params *p)
+static int io_sq_offload_create(struct io_ring_ctx *ctx,
+				struct io_uring_params *p)
 {
 	int ret;
 
@@ -7458,7 +7459,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			ctx->sqo_thread = NULL;
 			goto err;
 		}
-		wake_up_process(ctx->sqo_thread);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -7479,6 +7479,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
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
@@ -8218,6 +8224,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (!percpu_ref_tryget(&ctx->refs))
 		goto out_fput;
 
+	if (ctx->flags & IORING_SETUP_R_DISABLED)
+		goto out_fput;
+
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
 	 * Just return the requested submit count, and wake the thread if
@@ -8532,10 +8541,13 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
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
@@ -8598,7 +8610,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -8681,8 +8694,12 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8732,7 +8749,7 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 		}
 	}
 
-	ctx->restricted = 1;
+	ctx->restrictions.registered = true;
 
 	ret = 0;
 out:
@@ -8744,6 +8761,21 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8865,6 +8897,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index be54bc3cf173..ddb30513e027 100644
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
 	IORING_REGISTER_PERSONALITY,
 	IORING_UNREGISTER_PERSONALITY,
 	IORING_REGISTER_RESTRICTIONS,
+	IORING_REGISTER_ENABLE_RINGS,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
-- 
2.26.2

