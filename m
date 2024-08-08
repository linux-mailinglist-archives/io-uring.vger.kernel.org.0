Return-Path: <io-uring+bounces-2680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E3694C2B5
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 18:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9520A1F21750
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 16:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA9218DF70;
	Thu,  8 Aug 2024 16:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9S7rZ6m"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5D218E752
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 16:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723134346; cv=none; b=GtmgCyuASgXsHven/iSvgVQsnAU3G0GKFOt5JVKTygvpT4DeZ7b7bab9YEEOjPXpT5ZcQ2mwiK3NgfmKp7d95Y6Oc72WgyALpGpUe+uus404O0TfUMGb0rUarGJSUjqnLcfkwp0HvjRJN5UjxnYw0HXVFtvUN1n7RlsKzP5mT/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723134346; c=relaxed/simple;
	bh=+c1FmQfWdW73TY5LyZWi0Ey5EGrRVarHWOTuq7yB/Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrszfvmAwG25ZvvvpPycEreCmxyDb+Byg1Ds6FgYRr8rHC8NiHPaHWHi9wwqnaBmJTSAi/gNLlgifNvEMMZQH0HKYLWLBNy/PlQ+jVS4irXV6aIIXdBwFIF8saa/x0wgso3gHGjOgadfj0xKwFo2mvixlr2jelDV4RAlJwm/26I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h9S7rZ6m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723134343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n+DP4EgO4KGSM3yFXfCWlCv/+LQBPNGco9OUZ2fObO4=;
	b=h9S7rZ6mpfG5ZPunJm0q/TV8Wz+vONbFMarXIkp2ljWHIUjrx9YMZ4hVHxC3tlG9ZZhaEB
	K7D5vUT5+l9Xw8zVgI4eYlQhl5Hr4zW8bD4ihNBsAF4OEuy1GNTjgF37vmSsuK4wVa2t8P
	2jgZR83NL1kow++bOWc10PLrklFlBN4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-vzAi7eBnMHO09ZmS0Mf1Tw-1; Thu,
 08 Aug 2024 12:25:40 -0400
X-MC-Unique: vzAi7eBnMHO09ZmS0Mf1Tw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 953A9196CDFE;
	Thu,  8 Aug 2024 16:25:39 +0000 (UTC)
Received: from localhost (unknown [10.72.116.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A755319560A3;
	Thu,  8 Aug 2024 16:25:38 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 6/8] io_uring: support providing sqe group buffer
Date: Fri,  9 Aug 2024 00:24:55 +0800
Message-ID: <20240808162503.345913-7-ming.lei@redhat.com>
In-Reply-To: <20240808162503.345913-1-ming.lei@redhat.com>
References: <20240808162503.345913-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

SQE group with REQ_F_SQE_GROUP_DEP introduces one new mechanism to share
resource among one group of requests, and all member requests can consume
the resource provided by group leader efficiently in parallel.

This patch uses the added sqe group feature REQ_F_SQE_GROUP_DEP to share
kernel buffer in sqe group:

- the group leader provides kernel buffer to member requests

- member requests use the provided buffer to do FS or network IO, or more
operations in future

- this kernel buffer is returned back after member requests consume it

This way looks a bit similar with kernel's pipe/splice, but there are some
important differences:

- splice is for transferring data between two FDs via pipe, and fd_out can
only read data from pipe, but data can't be written to; this feature can
borrow buffer from group lead to members, so member request can write data
to this buffer if the provided buffer is allowed to write to.

- splice implements data transfer by moving pages between subsystem and
pipe, that means page ownership is transferred, and this way is one of the
most complicated thing of splice; this patch supports scenarios in which
the buffer can't be transferred, and buffer is only borrowed to member
requests, and is returned back after member requests consume the provided
buffer, so buffer lifetime is aligned with group leader lifetime, and
buffer lifetime is simplified a lot. Especially the buffer is guaranteed
to be returned back.

- splice can't run in async way basically

It can help to implement generic zero copy between device and related
operations, such as ublk, fuse, vdpa, even network receive or whatever.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 33 +++++++++++++++++++
 io_uring/io_uring.c            | 10 +++++-
 io_uring/io_uring.h            | 10 ++++++
 io_uring/kbuf.c                | 60 ++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h                | 13 ++++++++
 io_uring/net.c                 | 23 ++++++++++++-
 io_uring/opdef.c               |  4 +++
 io_uring/opdef.h               |  2 ++
 io_uring/rw.c                  | 20 +++++++++++-
 9 files changed, 172 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d0972e2a098f..78196f0d5437 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -6,6 +6,7 @@
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
 #include <linux/llist.h>
+#include <linux/bvec.h>
 #include <uapi/linux/io_uring.h>
 
 enum {
@@ -39,6 +40,26 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+struct io_uring_kernel_buf;
+typedef void (io_uring_buf_giveback_t) (const struct io_uring_kernel_buf *);
+
+/* buffer provided from kernel */
+struct io_uring_kernel_buf {
+	unsigned long		len;
+	unsigned short		nr_bvecs;
+	unsigned char		dir;	/* ITER_SOURCE or ITER_DEST */
+
+	/* offset in the 1st bvec */
+	unsigned int		offset;
+	const struct bio_vec	*bvec;
+
+	/* called when we are done with this buffer */
+	io_uring_buf_giveback_t	*grp_kbuf_ack;
+
+	/* private field, user don't touch it */
+	struct bio_vec		__bvec[];
+};
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -470,6 +491,7 @@ enum {
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_SQE_GROUP_LEADER_BIT,
 	REQ_F_SQE_GROUP_DEP_BIT,
+	REQ_F_GROUP_KBUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -554,6 +576,8 @@ enum {
 	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
 	/* sqe group with members depending on leader */
 	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
+	/* group lead provides kbuf for members, set for both lead and member */
+	REQ_F_GROUP_KBUF	= IO_REQ_FLAG(REQ_F_GROUP_KBUF_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -637,6 +661,15 @@ struct io_kiocb {
 		 * REQ_F_BUFFER_RING is set.
 		 */
 		struct io_buffer_list	*buf_list;
+
+		/*
+		 * store kernel buffer provided by sqe group lead, valid
+		 * IFF REQ_F_GROUP_KBUF
+		 *
+		 * The buffer meta is immutable since it is shared by
+		 * all member requests
+		 */
+		const struct io_uring_kernel_buf *grp_kbuf;
 	};
 
 	union {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b4f5dac85fa4..4b0ca320cde4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -116,7 +116,7 @@
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_ASYNC_DATA | REQ_F_GROUP_KBUF)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 REQ_F_SQE_GROUP | REQ_F_SQE_GROUP_LEADER | \
@@ -387,6 +387,11 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_clean_op(struct io_kiocb *req)
 {
+	/* GROUP_KBUF is only available for REQ_F_SQE_GROUP_DEP */
+	if ((req->flags & (REQ_F_GROUP_KBUF | REQ_F_SQE_GROUP_DEP)) ==
+			(REQ_F_GROUP_KBUF | REQ_F_SQE_GROUP_DEP))
+		io_group_kbuf_drop(req);
+
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		spin_lock(&req->ctx->completion_lock);
 		io_kbuf_drop(req);
@@ -914,9 +919,12 @@ static void io_queue_group_members(struct io_kiocb *req)
 
 	req->grp_link = NULL;
 	while (member) {
+		const struct io_issue_def *def = &io_issue_defs[member->opcode];
 		struct io_kiocb *next = member->grp_link;
 
 		member->grp_leader = req;
+		if ((req->flags & REQ_F_GROUP_KBUF) && def->accept_group_kbuf)
+			member->flags |= REQ_F_GROUP_KBUF;
 		if (unlikely(member->flags & REQ_F_FAIL)) {
 			io_req_task_queue_fail(member, member->cqe.res);
 		} else if (unlikely(req->flags & REQ_F_FAIL)) {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0125daa8dfe7..f399e7b0dfce 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -345,6 +345,16 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
 	return req->flags & REQ_F_SQE_GROUP_LEADER;
 }
 
+static inline bool req_is_group_member(struct io_kiocb *req)
+{
+	return !req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP);
+}
+
+static inline bool req_support_group_dep(struct io_kiocb *req)
+{
+	return req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP_DEP);
+}
+
 /*
  * Don't complete immediately but use deferred completion infrastructure.
  * Protected by ->uring_lock and can only be used either with
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c95dc1736dd9..24f09adf92d2 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -825,3 +825,63 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	io_put_bl(ctx, bl);
 	return ret;
 }
+
+int io_provide_group_kbuf(struct io_kiocb *req,
+		const struct io_uring_kernel_buf *grp_kbuf)
+{
+	if (unlikely(!req_support_group_dep(req)))
+		return -EINVAL;
+
+	/*
+	 * Borrow this buffer from one kernel subsystem, and return them
+	 * by calling `grp_kbuf_ack` when the group lead is freed.
+	 *
+	 * Not like pipe/splice, this kernel buffer is always owned by the
+	 * provider, and has to be returned back.
+	 */
+	req->grp_kbuf = grp_kbuf;
+	req->flags |= REQ_F_GROUP_KBUF;
+
+	return 0;
+}
+
+int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
+		unsigned int len, int dir, struct iov_iter *iter)
+{
+	struct io_kiocb *lead = req->grp_link;
+	const struct io_uring_kernel_buf *kbuf;
+	unsigned long offset;
+
+	WARN_ON_ONCE(!(req->flags & REQ_F_GROUP_KBUF));
+
+	if (!req_is_group_member(req))
+		return -EINVAL;
+
+	if (!lead || !req_support_group_dep(lead) || !lead->grp_kbuf)
+		return -EINVAL;
+
+	/* req->fused_cmd_kbuf is immutable */
+	kbuf = lead->grp_kbuf;
+	offset = kbuf->offset;
+
+	if (!kbuf->bvec)
+		return -EINVAL;
+
+	if (dir != kbuf->dir)
+		return -EINVAL;
+
+	if (unlikely(buf_off > kbuf->len))
+		return -EFAULT;
+
+	if (unlikely(len > kbuf->len - buf_off))
+		return -EFAULT;
+
+	/* don't use io_import_fixed which doesn't support multipage bvec */
+	offset += buf_off;
+	iov_iter_bvec(iter, dir, kbuf->bvec, kbuf->nr_bvecs, offset + len);
+
+	if (offset)
+		iov_iter_advance(iter, offset);
+
+	return 0;
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b90aca3a57fa..2e1b7f91efb6 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -82,6 +82,11 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
 
+int io_provide_group_kbuf(struct io_kiocb *req,
+		const struct io_uring_kernel_buf *grp_kbuf);
+int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
+		unsigned int len, int dir, struct iov_iter *iter);
+
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
 	/*
@@ -180,4 +185,12 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int nbufs,
 {
 	return __io_put_kbufs(req, nbufs, issue_flags);
 }
+
+static inline void io_group_kbuf_drop(struct io_kiocb *req)
+{
+	const struct io_uring_kernel_buf *gbuf = req->grp_kbuf;
+
+	if (gbuf && gbuf->grp_kbuf_ack)
+		gbuf->grp_kbuf_ack(gbuf);
+}
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 594490a1389b..313da5b0bb5d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -89,6 +89,13 @@ struct io_sr_msg {
  */
 #define MULTISHOT_MAX_RETRY	32
 
+#define user_ptr_to_u64(x) (		\
+{					\
+	typecheck(void __user *, (x));	\
+	(u64)(unsigned long)(x);	\
+}					\
+)
+
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -375,7 +382,7 @@ static int io_send_setup(struct io_kiocb *req)
 		kmsg->msg.msg_name = &kmsg->addr;
 		kmsg->msg.msg_namelen = sr->addr_len;
 	}
-	if (!io_do_buffer_select(req)) {
+	if (!io_do_buffer_select(req) && !(req->flags & REQ_F_GROUP_KBUF)) {
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
 				  &kmsg->msg.msg_iter);
 		if (unlikely(ret < 0))
@@ -595,6 +602,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 
+	if (req->flags & REQ_F_GROUP_KBUF) {
+		ret = io_import_group_kbuf(req,
+					user_ptr_to_u64(sr->buf),
+					sr->len, ITER_SOURCE,
+					&kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+	}
+
 retry_bundle:
 	if (io_do_buffer_select(req)) {
 		struct buf_sel_arg arg = {
@@ -1144,6 +1160,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			goto out_free;
 		}
 		sr->buf = NULL;
+	} else if (req->flags & REQ_F_GROUP_KBUF) {
+		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
+				sr->len, ITER_DEST, &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			goto out_free;
 	}
 
 	kmsg->msg.msg_flags = 0;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a2be3bbca5ff..c12f57619a33 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -246,6 +246,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.accept_group_kbuf	= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read,
 		.issue			= io_read,
@@ -260,6 +261,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.accept_group_kbuf	= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write,
 		.issue			= io_write,
@@ -282,6 +284,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.buffer_select		= 1,
+		.accept_group_kbuf	= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
@@ -297,6 +300,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.accept_group_kbuf	= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_recvmsg_prep,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 14456436ff74..328c8a3c4fa7 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -27,6 +27,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
 	unsigned		vectored : 1;
+	/* opcodes which accept provided group kbuf */
+	unsigned		accept_group_kbuf : 1;
 
 	/* size of async data needed, if any */
 	unsigned short		async_size;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c004d21e2f12..81ca22094e82 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -235,7 +235,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	if (io_rw_alloc_async(req))
 		return -ENOMEM;
 
-	if (!do_import || io_do_buffer_select(req))
+	if (!do_import || io_do_buffer_select(req) ||
+	    (req->flags & REQ_F_GROUP_KBUF))
 		return 0;
 
 	rw = req->async_data;
@@ -620,11 +621,16 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
  */
 static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 {
+	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 	struct kiocb *kiocb = &rw->kiocb;
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
 	loff_t *ppos;
 
+	/* group buffer is kernel buffer and doesn't have userspace addr */
+	if (req->flags & REQ_F_GROUP_KBUF)
+		return -EOPNOTSUPP;
+
 	/*
 	 * Don't support polled IO through this interface, and we can't
 	 * support non-blocking either. For the latter, this just causes
@@ -831,6 +837,11 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_import_iovec(ITER_DEST, req, io, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
+	} else if (req->flags & REQ_F_GROUP_KBUF) {
+		ret = io_import_group_kbuf(req, rw->addr, rw->len, ITER_DEST,
+				&io->iter);
+		if (unlikely(ret))
+			return ret;
 	}
 	ret = io_rw_init_file(req, FMODE_READ, READ);
 	if (unlikely(ret))
@@ -1012,6 +1023,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
+	if (req->flags & REQ_F_GROUP_KBUF) {
+		ret = io_import_group_kbuf(req, rw->addr, rw->len, ITER_SOURCE,
+				&io->iter);
+		if (unlikely(ret))
+			return ret;
+	}
+
 	ret = io_rw_init_file(req, FMODE_WRITE, WRITE);
 	if (unlikely(ret))
 		return ret;
-- 
2.42.0


