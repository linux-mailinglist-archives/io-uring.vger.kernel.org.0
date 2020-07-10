Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229AC21B847
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 16:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgGJOUZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 10:20:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43775 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727097AbgGJOUV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 10:20:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QuqU3Vbf6mz/t3wiNDm6uN168TBBL7sMxA2awxIqYc=;
        b=ZcFXrciMqR9WIzO4p4t9Dm66JFnxlI7Q4ns/CSdsKZmIAKYIEMLdkZH/A9OSWwmcfqZRoA
        38Qj/DInX5zk71y4KjYRBPzZcpuKDFDhiVDCLKjicrlrz72RnpNZdmibakgJIaXUohDvPT
        no6Quo8Br2l4HEhD0lRn2HcMU/51mT4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-P8zfqDJoOUukHVhc33pOiA-1; Fri, 10 Jul 2020 10:20:15 -0400
X-MC-Unique: P8zfqDJoOUukHVhc33pOiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4991800EB6;
        Fri, 10 Jul 2020 14:20:13 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-4.ams2.redhat.com [10.36.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 146285C1D6;
        Fri, 10 Jul 2020 14:20:06 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH RFC 3/3] io_uring: allow disabling rings during the creation
Date:   Fri, 10 Jul 2020 16:19:45 +0200
Message-Id: <20200710141945.129329-4-sgarzare@redhat.com>
In-Reply-To: <20200710141945.129329-1-sgarzare@redhat.com>
References: <20200710141945.129329-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 fs/io_uring.c                 | 57 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4768a9973d4b..52a75bf4206f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6955,8 +6955,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static int io_sq_offload_start(struct io_ring_ctx *ctx,
-			       struct io_uring_params *p)
+static int io_sq_offload_create(struct io_ring_ctx *ctx,
+				struct io_uring_params *p)
 {
 	int ret;
 
@@ -6993,7 +6993,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			ctx->sqo_thread = NULL;
 			goto err;
 		}
-		wake_up_process(ctx->sqo_thread);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -7012,6 +7011,18 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static int io_sq_offload_start(struct io_ring_ctx *ctx)
+{
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		if (!ctx->sqo_thread)
+			return -EINVAL; /* TODO: check errno */
+
+		wake_up_process(ctx->sqo_thread);
+	}
+
+	return 0;
+}
+
 static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	atomic_long_sub(nr_pages, &user->locked_vm);
@@ -7632,9 +7643,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	int submitted = 0;
 	struct fd f;
 
-	if (current->task_works)
-		task_work_run();
-
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
 		return -EINVAL;
 
@@ -7651,6 +7659,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
@@ -7956,10 +7970,16 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	ret = io_sq_offload_start(ctx, p);
+	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
 
+	if (!(p->flags & IORING_SETUP_R_DISABLED)) {
+		ret = io_sq_offload_start(ctx);
+		if (ret)
+			goto err;
+	}
+
 	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
 	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
@@ -8020,7 +8040,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
@@ -8103,6 +8124,10 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 	size_t size;
 	int i, ret;
 
+	/* Restrictions allowed only if rings started disabled */
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
 	/* We allow only a single restrictions registration */
 	if (ctx->restrictions.enabled)
 		return -EINVAL; /* TODO: check ret value */
@@ -8159,6 +8184,16 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
+static int io_register_enable_rings(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+
+	return io_sq_offload_start(ctx);
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -8280,6 +8315,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 69f4684c988d..57081c746b06 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -94,6 +94,7 @@ enum {
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
+#define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 
 enum {
 	IORING_OP_NOP,
@@ -265,6 +266,7 @@ enum {
 	IORING_REGISTER_PERSONALITY,
 	IORING_UNREGISTER_PERSONALITY,
 	IORING_REGISTER_RESTRICTIONS,
+	IORING_REGISTER_ENABLE_RINGS,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
-- 
2.26.2

