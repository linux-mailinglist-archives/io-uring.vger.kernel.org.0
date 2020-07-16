Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CB62222CB
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 14:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgGPMtW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 08:49:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40594 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728548AbgGPMtV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 08:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594903759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3IGotHJLDWHOMS4jfIFhav0o5esf4avDkRICTFAhyCo=;
        b=BJCvd5uIGtgfTXD3qhMtI2Ae2gsT6eDP6OGRk4Ro9Rs7npfisWbo0mGEu7YR42nwqDfsKS
        NATV69HYhBETqx+EMxrkfDjh9t+el4rwCSwPL0P0AynduwWlx4qxSNa+a4Cy3cRdrRp5RS
        ZdpOC6rpEgCXSg4GoY1NVCkTVhFBOpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-wSe4nHhrMv606IQIZUQ-PQ-1; Thu, 16 Jul 2020 08:49:15 -0400
X-MC-Unique: wSe4nHhrMv606IQIZUQ-PQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A2C71B18BC1;
        Thu, 16 Jul 2020 12:49:13 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-107.ams2.redhat.com [10.36.114.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 727D117D04;
        Thu, 16 Jul 2020 12:49:00 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 3/3] io_uring: allow disabling rings during the creation
Date:   Thu, 16 Jul 2020 14:48:33 +0200
Message-Id: <20200716124833.93667-4-sgarzare@redhat.com>
In-Reply-To: <20200716124833.93667-1-sgarzare@redhat.com>
References: <20200716124833.93667-1-sgarzare@redhat.com>
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
RFC v2:
 - removed return value of io_sq_offload_start()
---
 fs/io_uring.c                 | 50 +++++++++++++++++++++++++++++------
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23a2b03d9528..2f2ecfa10c94 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6969,8 +6969,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static int io_sq_offload_start(struct io_ring_ctx *ctx,
-			       struct io_uring_params *p)
+static int io_sq_offload_create(struct io_ring_ctx *ctx,
+				struct io_uring_params *p)
 {
 	int ret;
 
@@ -7007,7 +7007,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			ctx->sqo_thread = NULL;
 			goto err;
 		}
-		wake_up_process(ctx->sqo_thread);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -7026,6 +7025,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
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
@@ -7654,9 +7659,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	int submitted = 0;
 	struct fd f;
 
-	if (current->task_works)
-		task_work_run();
-
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
 		return -EINVAL;
 
@@ -7673,6 +7675,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
@@ -7978,10 +7986,13 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
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
@@ -8042,7 +8053,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -8125,6 +8137,10 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 	size_t size;
 	int i, ret;
 
+	/* Restrictions allowed only if rings started disabled */
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
 	/* We allow only a single restrictions registration */
 	if (ctx->restricted)
 		return -EBUSY;
@@ -8183,6 +8199,18 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
+static int io_register_enable_rings(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
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
@@ -8304,6 +8332,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 0774d5382c65..ce52333bdc2b 100644
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

