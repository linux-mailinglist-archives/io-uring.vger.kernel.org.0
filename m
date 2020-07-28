Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A53D230EB2
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 18:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgG1QBy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 12:01:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49186 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731240AbgG1QBx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 12:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595952111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jNrC58ZGSkUMr5qrUApDM8W+Fk8SmgNkRBc4mmuFeCs=;
        b=iqC5x6F8Wh/69uWSmw5cA81cy2jWIi8N0LAZJZRZ6zCNz+RGIK+QhR6k/z2gPsonpOF9Qe
        wO5R+3FKRjSCHhmtmMvc495a+hwBgnDMLLfGvCeEARaOMMikm75BjZdKDOIcSC22vKlD42
        cg0ac5cvS8yG+ioqbNDj0658i/yxIrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-1K9sQ9GJPYyJ4gZ3bTHCpQ-1; Tue, 28 Jul 2020 12:01:47 -0400
X-MC-Unique: 1K9sQ9GJPYyJ4gZ3bTHCpQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77EE5100CCC5;
        Tue, 28 Jul 2020 16:01:45 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 046A15D9CD;
        Tue, 28 Jul 2020 16:01:32 +0000 (UTC)
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
Subject: [PATCH v3 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Date:   Tue, 28 Jul 2020 18:01:00 +0200
Message-Id: <20200728160101.48554-3-sgarzare@redhat.com>
In-Reply-To: <20200728160101.48554-1-sgarzare@redhat.com>
References: <20200728160101.48554-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
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
 fs/io_uring.c                 | 113 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  31 ++++++++++
 2 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 32b0064f806e..518986371aae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -97,6 +97,8 @@
 #define IORING_MAX_FILES_TABLE	(1U << IORING_FILE_TABLE_SHIFT)
 #define IORING_FILE_TABLE_MASK	(IORING_MAX_FILES_TABLE - 1)
 #define IORING_MAX_FIXED_FILES	(64 * IORING_MAX_FILES_TABLE)
+#define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
+				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
@@ -218,6 +220,13 @@ struct io_buffer {
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
@@ -230,6 +239,7 @@ struct io_ring_ctx {
 		unsigned int		cq_overflow_flushed: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
+		unsigned int		restricted: 1;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -337,6 +347,7 @@ struct io_ring_ctx {
 	struct llist_head		file_put_llist;
 
 	struct work_struct		exit_work;
+	struct io_restriction		restrictions;
 };
 
 /*
@@ -5925,6 +5936,19 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
 		return -EINVAL;
 
+	if (unlikely(ctx->restricted)) {
+		if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
+			return -EACCES;
+
+		if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
+		    ctx->restrictions.sqe_flags_required)
+			return -EACCES;
+
+		if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
+				  ctx->restrictions.sqe_flags_required))
+			return -EACCES;
+	}
+
 	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
 	    !io_op_defs[req->opcode].buffer_select)
 		return -EOPNOTSUPP;
@@ -8116,6 +8140,77 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
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
+	res = kmalloc(size, GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	if (copy_from_user(res, arg, size)) {
+		ret = -EFAULT;
+		goto out;
+	}
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
+
+		}
+	}
+
+	ctx->restricted = 1;
+
+	ret = 0;
+out:
+	/* Reset all restrictions if an error happened */
+	if (ret != 0)
+		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
+
+	kfree(res);
+	return ret;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -8162,6 +8257,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
@@ -8225,15 +8332,19 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index efc50bd0af34..7303500fc6d3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -265,6 +265,7 @@ enum {
 	IORING_REGISTER_PROBE,
 	IORING_REGISTER_PERSONALITY,
 	IORING_UNREGISTER_PERSONALITY,
+	IORING_REGISTER_RESTRICTIONS,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -293,4 +294,34 @@ struct io_uring_probe {
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
+	IORING_RESTRICTION_REGISTER_OP,
+
+	/* Allow an sqe opcode */
+	IORING_RESTRICTION_SQE_OP,
+
+	/* Allow sqe flags */
+	IORING_RESTRICTION_SQE_FLAGS_ALLOWED,
+
+	/* Require sqe flags (these flags must be set on each submission) */
+	IORING_RESTRICTION_SQE_FLAGS_REQUIRED,
+
+	IORING_RESTRICTION_LAST
+};
+
 #endif
-- 
2.26.2

