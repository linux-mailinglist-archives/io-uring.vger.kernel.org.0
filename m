Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C859221B844
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgGJOUS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 10:20:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20707 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727097AbgGJOUO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 10:20:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S6cQhuOcDdhnVYpuDpB8H3qcMEL452aYxMh3H44NLcU=;
        b=gFu0cLjE/IQiYuafn8GAAu8t37cZ/7ujlcnm/bO4ZdFwu/9G7cYbYkimrQ9qgJimYWIDvi
        tK8UM00gx0C22ufypo+6iuaMZJPNWuJ46jb6FRRvp05NYS8zk0jvMb4vEnqe0pcah+/iuL
        pSebH7FPMMH26GSOKSBUCq3QxQw4fEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-vMgFKFOeON6292laPskXsQ-1; Fri, 10 Jul 2020 10:20:08 -0400
X-MC-Unique: vMgFKFOeON6292laPskXsQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A33B78005B0;
        Fri, 10 Jul 2020 14:20:06 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-4.ams2.redhat.com [10.36.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB4795C3F8;
        Fri, 10 Jul 2020 14:19:59 +0000 (UTC)
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
Subject: [PATCH RFC 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Date:   Fri, 10 Jul 2020 16:19:44 +0200
Message-Id: <20200710141945.129329-3-sgarzare@redhat.com>
In-Reply-To: <20200710141945.129329-1-sgarzare@redhat.com>
References: <20200710141945.129329-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode
permanently installs a feature whitelist on an io_ring_ctx.
The io_ring_ctx can then be passed to untrusted code with the
knowledge that only operations present in the whitelist can be
executed.

The whitelist approach ensures that new features added to io_uring
do not accidentally become available when an existing application
is launched on a newer kernel version.

Currently is it possible to restrict sqe opcodes and register
opcodes. It is also possible to allow only fixed files.

IOURING_REGISTER_RESTRICTIONS can only be made once. Afterwards
it is not possible to change restrictions anymore.
This prevents untrusted code from removing restrictions.

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 fs/io_uring.c                 | 98 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h | 30 +++++++++++
 2 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d37d7ea5ebe5..4768a9973d4b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -218,6 +218,13 @@ struct io_buffer {
 	__u16 bid;
 };
 
+struct io_restriction {
+	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
+	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	DECLARE_BITMAP(restriction_op, IORING_RESTRICTION_LAST);
+	bool enabled; /* TODO: remove and use a flag ?? */
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -337,6 +344,7 @@ struct io_ring_ctx {
 	struct llist_head		file_put_llist;
 
 	struct work_struct		exit_work;
+	struct io_restriction		restrictions;
 };
 
 /*
@@ -5491,6 +5499,11 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	if (unlikely(!fixed && io_async_submit(req->ctx)))
 		return -EBADF;
 
+	if (unlikely(!fixed && req->ctx->restrictions.enabled &&
+		     test_bit(IORING_RESTRICTION_FIXED_FILES_ONLY,
+			      req->ctx->restrictions.restriction_op)))
+		return -EACCES;
+
 	return io_file_get(state, req, fd, &req->file, fixed);
 }
 
@@ -5895,6 +5908,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
 
+	if (unlikely(ctx->restrictions.enabled &&
+		     !test_bit(req->opcode, ctx->restrictions.sqe_op)))
+		return -EACCES;
+
 	if (unlikely(io_sq_thread_acquire_mm(ctx, req)))
 		return -EFAULT;
 
@@ -8079,6 +8096,69 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
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
+	if (ctx->restrictions.enabled)
+		return -EINVAL; /* TODO: check ret value */
+
+	/* TODO: Is it okay to set a maximum? */
+	if (!arg || nr_args > 256)
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
+		if (res[i].opcode >= IORING_RESTRICTION_LAST) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		__set_bit(res[i].opcode, ctx->restrictions.restriction_op);
+
+		if (res[i].opcode == IORING_RESTRICTION_REGISTER_OP) {
+			if (res[i].register_op >= IORING_REGISTER_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].register_op,
+				  ctx->restrictions.register_op);
+		} else if (res[i].opcode == IORING_RESTRICTION_SQE_OP) {
+			if (res[i].sqe_op >= IORING_OP_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
+		}
+	}
+
+	ctx->restrictions.enabled = true;
+
+	ret = 0;
+out:
+	/* TODO: should we reset all restrictions if an error happened? */
+	kfree(res);
+	return ret;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -8125,6 +8205,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		if (ret) {
 			percpu_ref_resurrect(&ctx->refs);
 			ret = -EINTR;
+			goto out_quiesce;
+		}
+	}
+
+	if (ctx->restrictions.enabled) {
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
@@ -8188,15 +8280,19 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 2d18f1d0b5df..69f4684c988d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -264,6 +264,7 @@ enum {
 	IORING_REGISTER_PROBE,
 	IORING_REGISTER_PERSONALITY,
 	IORING_UNREGISTER_PERSONALITY,
+	IORING_REGISTER_RESTRICTIONS,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -292,4 +293,33 @@ struct io_uring_probe {
 	struct io_uring_probe_op ops[0];
 };
 
+struct io_uring_restriction {
+	__u16 opcode;
+	union {
+		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
+		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
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
+	/* Only allow fixed files */
+	IORING_RESTRICTION_FIXED_FILES_ONLY,
+
+	/* Only allow registered addresses and translate them */
+	//TODO: IORING_RESTRICTION_BUFFER_CHECK,
+
+	IORING_RESTRICTION_LAST
+};
+
 #endif
-- 
2.26.2

