Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3818B230EB4
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 18:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbgG1QCW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 12:02:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53076 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731133AbgG1QCW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 12:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595952140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SFNyFdVtoA6jvFVEx573pwq9MAUjMHekOy6Q4vgiQx8=;
        b=a40FZ3ZRUGLwIxCLQZEi43bVzi3LoAg+lfUdOFKG8ycvCgtGiSd7niM5t/M6YFMssB6+vX
        SoEMvIfC9lqL5G6MbrohzA2guplmZ8L53Y2g+rexbHHnTyKfrxZJ7luynZSbkBjZANFDH0
        Gnia86SuM6fok/K+fo/KaZPVciT6Ljc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-Gr6INdQuMBmOzpXrDYCGiA-1; Tue, 28 Jul 2020 12:02:16 -0400
X-MC-Unique: Gr6INdQuMBmOzpXrDYCGiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 894DE800688;
        Tue, 28 Jul 2020 16:02:11 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE14B5DA72;
        Tue, 28 Jul 2020 16:01:45 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>
Subject: [PATCH v3 3/3] io_uring: allow disabling rings during the creation
Date:   Tue, 28 Jul 2020 18:01:01 +0200
Message-Id: <20200728160101.48554-4-sgarzare@redhat.com>
In-Reply-To: <20200728160101.48554-1-sgarzare@redhat.com>
References: <20200728160101.48554-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
v3:
 - enabled restrictions only when the rings start

RFC v2:
 - removed return value of io_sq_offload_start()
---
 fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++------
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 518986371aae..49db8899fefb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -225,6 +225,7 @@ struct io_restriction {
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
+	bool registered;
 };
 
 struct io_ring_ctx {
@@ -6991,8 +6992,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static int io_sq_offload_start(struct io_ring_ctx *ctx,
-			       struct io_uring_params *p)
+static int io_sq_offload_create(struct io_ring_ctx *ctx,
+				struct io_uring_params *p)
 {
 	int ret;
 
@@ -7029,7 +7030,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			ctx->sqo_thread = NULL;
 			goto err;
 		}
-		wake_up_process(ctx->sqo_thread);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -7048,6 +7048,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static void io_sq_offload_start(struct io_ring_ctx *ctx)
+{
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sqo_thread)
+		wake_up_process(ctx->sqo_thread);
+}
+
 static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	atomic_long_sub(nr_pages, &user->locked_vm);
@@ -7676,9 +7682,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	int submitted = 0;
 	struct fd f;
 
-	if (current->task_works)
-		task_work_run();
-
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
 		return -EINVAL;
 
@@ -7695,6 +7698,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (!percpu_ref_tryget(&ctx->refs))
 		goto out_fput;
 
+	if (ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADF;
+
+	if (current->task_works)
+		task_work_run();
+
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
 	 * Just return the requested submit count, and wake the thread if
@@ -8000,10 +8009,13 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
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
@@ -8064,7 +8076,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -8147,8 +8160,12 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8199,7 +8216,7 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 		}
 	}
 
-	ctx->restricted = 1;
+	ctx->restrictions.registered = true;
 
 	ret = 0;
 out:
@@ -8211,6 +8228,21 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8332,6 +8364,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 7303500fc6d3..7f9c92313795 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -94,6 +94,7 @@ enum {
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
+#define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 
 enum {
 	IORING_OP_NOP,
@@ -266,6 +267,7 @@ enum {
 	IORING_REGISTER_PERSONALITY,
 	IORING_UNREGISTER_PERSONALITY,
 	IORING_REGISTER_RESTRICTIONS,
+	IORING_REGISTER_ENABLE_RINGS,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
-- 
2.26.2

