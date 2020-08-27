Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41D5254826
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgH0O73 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:59:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbgH0O7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCf0HL5axoQi6gogOTw+oBtKHNy8s+gbx0FTrn1OOvQ=;
        b=hrB9s2hw4cWCRqDLKDLFeNgtZUtVWNwgEr+2i3PjaKWHQ92HBJdtL8BkqBSQqEK/IniDV6
        ojTG41ZvUi3dyhCqlUzXLXIomyPbOLZoE9ag4fpBxkr4MN50zaZ8/Lo0h2Jko14llv7j+J
        g6mPVazcu7CvphpNgBnmWYqUm7mYPIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-Vey3m61ZMo-XaqY6mHgmDw-1; Thu, 27 Aug 2020 10:58:54 -0400
X-MC-Unique: Vey3m61ZMo-XaqY6mHgmDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 288B310A5D82;
        Thu, 27 Aug 2020 14:58:52 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-96.ams2.redhat.com [10.36.113.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AF5A59;
        Thu, 27 Aug 2020 14:58:43 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Date:   Thu, 27 Aug 2020 16:58:30 +0200
Message-Id: <20200827145831.95189-3-sgarzare@redhat.com>
In-Reply-To: <20200827145831.95189-1-sgarzare@redhat.com>
References: <20200827145831.95189-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode
permanently installs a feature allowlist on an io_ring_ctx.
The io_ring_ctx can then be passed to untrusted code with the
knowledge that only operations present in the allowlist can be
executed.

The allowlist approach ensures that new features added to io_uring
do not accidentally become available when an existing application
is launched on a newer kernel version.

Currently is it possible to restrict sqe opcodes, sqe flags, and
register opcodes.

IOURING_REGISTER_RESTRICTIONS can only be made once. Afterwards
it is not possible to change restrictions anymore.
This prevents untrusted code from removing restrictions.

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v6:
 - moved restriction checks in a function [Jens]
 - changed ret value handling in io_register_restrictions() [Jens]

v5:
 - explicitly assigned enum values [Kees]
 - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]

v3:
 - added IORING_RESTRICTION_SQE_FLAGS_ALLOWED and
   IORING_RESTRICTION_SQE_FLAGS_REQUIRED
 - removed IORING_RESTRICTION_FIXED_FILES_ONLY

RFC v2:
 - added 'restricted' flag in the ctx [Jens]
 - added IORING_MAX_RESTRICTIONS define
 - returned EBUSY instead of EINVAL when restrictions are already
   registered
 - reset restrictions if an error happened during the registration
---
 fs/io_uring.c                 | 124 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  31 +++++++++
 2 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6df08287c59e..5f62997c147b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -98,6 +98,8 @@
 #define IORING_MAX_FILES_TABLE	(1U << IORING_FILE_TABLE_SHIFT)
 #define IORING_FILE_TABLE_MASK	(IORING_MAX_FILES_TABLE - 1)
 #define IORING_MAX_FIXED_FILES	(64 * IORING_MAX_FILES_TABLE)
+#define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
+				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
@@ -219,6 +221,13 @@ struct io_buffer {
 	__u16 bid;
 };
 
+struct io_restriction {
+	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
+	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	u8 sqe_flags_allowed;
+	u8 sqe_flags_required;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -231,6 +240,7 @@ struct io_ring_ctx {
 		unsigned int		cq_overflow_flushed: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
+		unsigned int		restricted: 1;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -338,6 +348,7 @@ struct io_ring_ctx {
 	struct llist_head		file_put_llist;
 
 	struct work_struct		exit_work;
+	struct io_restriction		restrictions;
 };
 
 /*
@@ -6381,6 +6392,32 @@ static inline void io_consume_sqe(struct io_ring_ctx *ctx)
 	ctx->cached_sq_head++;
 }
 
+/*
+ * Check SQE restrictions (opcode and flags).
+ *
+ * Returns 'true' if SQE is allowed, 'false' otherwise.
+ */
+static inline bool io_check_restriction(struct io_ring_ctx *ctx,
+					struct io_kiocb *req,
+					unsigned int sqe_flags)
+{
+	if (!ctx->restricted)
+		return true;
+
+	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
+		return false;
+
+	if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
+	    ctx->restrictions.sqe_flags_required)
+		return false;
+
+	if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
+			  ctx->restrictions.sqe_flags_required))
+		return false;
+
+	return true;
+}
+
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
 				IOSQE_BUFFER_SELECT)
@@ -6414,6 +6451,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
 		return -EINVAL;
 
+	if (unlikely(!io_check_restriction(ctx, req, sqe_flags)))
+		return -EACCES;
+
 	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
 	    !io_op_defs[req->opcode].buffer_select)
 		return -EOPNOTSUPP;
@@ -8714,6 +8754,72 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 	return -EINVAL;
 }
 
+static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
+				    unsigned int nr_args)
+{
+	struct io_uring_restriction *res;
+	size_t size;
+	int i, ret;
+
+	/* We allow only a single restrictions registration */
+	if (ctx->restricted)
+		return -EBUSY;
+
+	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
+		return -EINVAL;
+
+	size = array_size(nr_args, sizeof(*res));
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	res = memdup_user(arg, size);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	ret = 0;
+
+	for (i = 0; i < nr_args; i++) {
+		switch (res[i].opcode) {
+		case IORING_RESTRICTION_REGISTER_OP:
+			if (res[i].register_op >= IORING_REGISTER_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].register_op,
+				  ctx->restrictions.register_op);
+			break;
+		case IORING_RESTRICTION_SQE_OP:
+			if (res[i].sqe_op >= IORING_OP_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
+			break;
+		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
+			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
+			break;
+		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
+			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+out:
+	/* Reset all restrictions if an error happened */
+	if (ret != 0)
+		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
+	else
+		ctx->restricted = 1;
+
+	kfree(res);
+	return ret;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -8760,6 +8866,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		if (ret) {
 			percpu_ref_resurrect(&ctx->refs);
 			ret = -EINTR;
+			goto out_quiesce;
+		}
+	}
+
+	if (ctx->restricted) {
+		if (opcode >= IORING_REGISTER_LAST) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (!test_bit(opcode, ctx->restrictions.register_op)) {
+			ret = -EACCES;
 			goto out;
 		}
 	}
@@ -8823,15 +8941,19 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_personality(ctx, nr_args);
 		break;
+	case IORING_REGISTER_RESTRICTIONS:
+		ret = io_register_restrictions(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
 	}
 
+out:
 	if (io_register_op_must_quiesce(opcode)) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
-out:
+out_quiesce:
 		reinit_completion(&ctx->ref_comp);
 	}
 	return ret;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5f12ae6a415c..6e7f2e5e917b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -267,6 +267,7 @@ enum {
 	IORING_REGISTER_PROBE			= 8,
 	IORING_REGISTER_PERSONALITY		= 9,
 	IORING_UNREGISTER_PERSONALITY		= 10,
+	IORING_REGISTER_RESTRICTIONS		= 11,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -295,4 +296,34 @@ struct io_uring_probe {
 	struct io_uring_probe_op ops[0];
 };
 
+struct io_uring_restriction {
+	__u16 opcode;
+	union {
+		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
+		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
+		__u8 sqe_flags;   /* IORING_RESTRICTION_SQE_FLAGS_* */
+	};
+	__u8 resv;
+	__u32 resv2[3];
+};
+
+/*
+ * io_uring_restriction->opcode values
+ */
+enum {
+	/* Allow an io_uring_register(2) opcode */
+	IORING_RESTRICTION_REGISTER_OP		= 0,
+
+	/* Allow an sqe opcode */
+	IORING_RESTRICTION_SQE_OP		= 1,
+
+	/* Allow sqe flags */
+	IORING_RESTRICTION_SQE_FLAGS_ALLOWED	= 2,
+
+	/* Require sqe flags (these flags must be set on each submission) */
+	IORING_RESTRICTION_SQE_FLAGS_REQUIRED	= 3,
+
+	IORING_RESTRICTION_LAST
+};
+
 #endif
-- 
2.26.2

