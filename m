Return-Path: <io-uring+bounces-4024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E199B0230
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21FC9283C65
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 12:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F4C1F80DB;
	Fri, 25 Oct 2024 12:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e7dWe+rd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703041E1A39
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 12:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729859009; cv=none; b=C44ht5So9Vz6vnJOZeH+WnvRfOpSU0k/RAq04IBOk0UnPpmeqJDRfKGlXtxnnpIeY94SDfTV8eEgELpDr2x0zRSDH8v+nXwHKRkmQhwsroy72fNKVFuaVw5VIU+yhdGKuqFD6N2sk0hfyrVBpPa7ITORnaGi7H/m10xIMUiZWGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729859009; c=relaxed/simple;
	bh=fSMWNn+ONn5dZNsGxSl5FveuCPKsZHGURPJCVH24JSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOT/H1kLciZBXpeOcUVMB+XgqCgn0kNd2uuNSLagPJoWuh1pr8069yhQeXvbVYxH4cKegABJwmWNUYXCjQFy6/jdQOisUCl2vl1Nd+17QdnqtpQqPPtCy0NcWcu/cSAeIIo0MqpMBExFsmlu8XmD2JHbWkcVIP3EeJgsGEfwPxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e7dWe+rd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729859005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XGKgZZzVBhXd6AA47MqISSpolRGetJmGOpxv7n5vAmQ=;
	b=e7dWe+rdnFyVGfu7kFpzkVVVTiollrjq4zswkT6ddefsaDTv+tGlBqg8OJnbLdHA1kT0MX
	9vl8yILiohUpxDfmBgnR+acjWQygXlKkcqTBLsho7fueTL+e0ySIDk+DpwNkSOXKPTo3jK
	qUWvU+pn/nDOVt5Seg+eCYnCo3NpNJ4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-wLMQAlM1PpeWlNv23d0WWA-1; Fri,
 25 Oct 2024 08:23:22 -0400
X-MC-Unique: wLMQAlM1PpeWlNv23d0WWA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 295D419560A1;
	Fri, 25 Oct 2024 12:23:21 +0000 (UTC)
Received: from localhost (unknown [10.72.116.106])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2398A196BB7E;
	Fri, 25 Oct 2024 12:23:19 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 5/7] io_uring: support leased group buffer with REQ_F_GROUP_KBUF
Date: Fri, 25 Oct 2024 20:22:42 +0800
Message-ID: <20241025122247.3709133-6-ming.lei@redhat.com>
In-Reply-To: <20241025122247.3709133-1-ming.lei@redhat.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

SQE group introduces one new mechanism to share resource among one
group of requests, and all member requests can consume the resource
leased by group leader efficiently in parallel.

This patch uses the added SQE group to lease kernel buffer from group
leader(driver) to members(io_uring) in sqe group:

- this kernel buffer is owned by kernel device(driver), and has very
  short lifetime, such as, it is often aligned with block IO lifetime

- group leader leases the kernel buffer from driver to member requests
  of io_uring subsystem

- member requests uses the leased buffer to do FS or network IO, or
  more operations in future; IOSQE_IO_DRAIN bit isn't used for group
  member IO, so it is mapped to GROUP_KBUF; the actual use becomes
  very similar with buffer select.

- this kernel buffer is returned back after all member requests consume it

io_uring builtin provide/register buffer isn't one good match for this
use case:

- complicated dependency on add/remove buffer
  this buffer has to be added/removed to one global table by add/remove OPs,
  and all consumer OPs have to sync with the add/remove OPs; either
  consumer OPs have to by issued one by one with IO_LINK; or two extra
  syscall are added for one time of buffer consumption, this way slows
  down ublk io handling, and may lose zero copy value

- application becomes more complicated

- application may panic and the kernel buffer is left in io_uring, which
  complicates io_uring shutdown handling since returning back buffer
  needs to cowork with buffer owner

- big change is needed in io_uring provide/register buffer

- the requirement is just to lease the kernel buffer to io_uring subsystem for
  very short time, not necessary to move it into io_uring and make it global

This way looks a bit similar with kernel's pipe/splice, but there are some
important differences:

- splice is for transferring data between two FDs via pipe, and fd_out can
only read data from pipe, but data can't be written to; this feature can
lease buffer from group leader(driver subsystem) to members(io_uring subsystem),
so member request can write data to this buffer if the buffer direction is
allowed to write to.

- splice implements data transfer by moving pages between subsystem and
pipe, that means page ownership is transferred, and this way is one of the
most complicated thing of splice; this patch supports scenarios in which
the buffer can't be transferred, and buffer is only borrowed to member
requests for consumption, and is returned back after member requests
consume the leased buffer, so buffer lifetime is aligned with group leader
lifetime, and buffer lifetime is simplified a lot. Especially the buffer
is guaranteed to be returned back.

- splice can't run in async way basically

It can help to implement generic zero copy between device and related
operations, such as ublk, fuse, vdpa.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 40 +++++++++++++++++++++++
 io_uring/io_uring.c            | 22 ++++++++++---
 io_uring/io_uring.h            |  5 +++
 io_uring/kbuf.c                | 58 ++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h                | 31 ++++++++++++++++++
 io_uring/net.c                 | 25 ++++++++++++++-
 io_uring/rw.c                  | 26 ++++++++++++++-
 7 files changed, 201 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d524be7f6b35..890bcb5d0c26 100644
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
+/* kernel owned buffer, leased to io_uring OPs */
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
@@ -469,6 +490,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_SQE_GROUP_LEADER_BIT,
+	REQ_F_GROUP_KBUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -549,6 +571,15 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* sqe group lead */
 	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
+	/*
+	 * Group leader leases kbuf to io_uring. Set for leader when the
+	 * leader starts to lease kbuf, and set for member in case that
+	 * the member needs to consume the group kbuf
+	 *
+	 * For group member, this flag is mapped from IOSQE_IO_DRAIN which
+	 * isn't used for group members
+	 */
+	REQ_F_GROUP_KBUF	= IO_REQ_FLAG(REQ_F_GROUP_KBUF_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -629,6 +660,15 @@ struct io_kiocb {
 		 * REQ_F_BUFFER_RING is set.
 		 */
 		struct io_buffer_list	*buf_list;
+
+		/*
+		 * store kernel buffer leased from sqe group lead, valid
+		 * IFF REQ_F_GROUP_KBUF is set
+		 *
+		 * The buffer meta is immutable since it is shared by
+		 * all member requests
+		 */
+		const struct io_uring_kernel_buf *grp_kbuf;
 	};
 
 	union {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 59e9a01319de..fcf58d5e698a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -117,7 +117,7 @@
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_ASYNC_DATA | REQ_F_GROUP_KBUF)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 REQ_F_SQE_GROUP | IO_REQ_CLEAN_FLAGS)
@@ -397,6 +397,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_clean_op(struct io_kiocb *req)
 {
+	if (req->flags & REQ_F_GROUP_KBUF)
+		io_drop_leased_grp_kbuf(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		spin_lock(&req->ctx->completion_lock);
 		io_kbuf_drop(req);
@@ -1022,6 +1024,12 @@ static enum group_mem io_prep_free_group_req(struct io_kiocb *req,
 			io_queue_group_members(req);
 		return GROUP_LEADER;
 	} else {
+		/*
+		 * Clear GROUP_KBUF since we are done with leased group
+		 * buffer
+		 */
+		if (req->flags & REQ_F_GROUP_KBUF)
+			req->flags &= ~REQ_F_GROUP_KBUF;
 		if (!req_is_last_group_member(req))
 			return GROUP_OTHER_MEMBER;
 
@@ -2223,9 +2231,15 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
-			if (ctx->drain_disabled)
-				return io_init_fail_req(req, -EOPNOTSUPP);
-			io_init_req_drain(req);
+			/* IO_DRAIN is mapped to GROUP_KBUF for group members */
+			if (ctx->submit_state.group.head) {
+				req->flags &= ~REQ_F_IO_DRAIN;
+				req->flags |= REQ_F_GROUP_KBUF;
+			} else {
+				if (ctx->drain_disabled)
+					return io_init_fail_req(req, -EOPNOTSUPP);
+				io_init_req_drain(req);
+			}
 		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ab84b09505fe..f83e7c13e679 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -349,6 +349,11 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
 	return req->flags & REQ_F_SQE_GROUP_LEADER;
 }
 
+static inline bool req_is_group_member(struct io_kiocb *req)
+{
+	return !req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP);
+}
+
 /*
  * Don't complete immediately but use deferred completion infrastructure.
  * Protected by ->uring_lock and can only be used either with
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d407576ddfb7..e86dacc7a822 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -838,3 +838,61 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	io_put_bl(ctx, bl);
 	return ret;
 }
+
+int io_lease_group_kbuf(struct io_kiocb *req,
+		const struct io_uring_kernel_buf *grp_kbuf)
+{
+	if (!(req->flags & REQ_F_SQE_GROUP_LEADER))
+		return -EINVAL;
+
+	if (req->flags & REQ_F_BUFFER_SELECT)
+		return -EINVAL;
+
+	if (!grp_kbuf->grp_kbuf_ack || !grp_kbuf->bvec)
+		return -EINVAL;
+
+	/*
+	 * Allow io_uring OPs to borrow this leased kbuf, which is returned
+	 * back by calling `grp_kbuf_ack` when the group leader is freed.
+	 *
+	 * Not like pipe/splice, this kernel buffer is always owned by the
+	 * provider, and has to be returned back.
+	 */
+	req->grp_kbuf = grp_kbuf;
+	req->flags |= REQ_F_GROUP_KBUF;
+	return 0;
+}
+
+int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
+		unsigned int len, int dir, struct iov_iter *iter)
+{
+	struct io_kiocb *lead = req->grp_leader;
+	const struct io_uring_kernel_buf *kbuf;
+	unsigned long offset;
+
+	if (!req_is_group_member(req))
+		return -EINVAL;
+
+	if (!lead || !(lead->flags & REQ_F_GROUP_KBUF))
+		return -EINVAL;
+
+	kbuf = lead->grp_kbuf;
+	offset = kbuf->offset;
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
+	offset += buf_off;
+	iov_iter_bvec(iter, dir, kbuf->bvec, kbuf->nr_bvecs, offset + len);
+
+	if (offset)
+		iov_iter_advance(iter, offset);
+
+	return 0;
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 36aadfe5ac00..d54cd4312db9 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -89,6 +89,11 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
 
+int io_lease_group_kbuf(struct io_kiocb *req,
+		const struct io_uring_kernel_buf *grp_kbuf);
+int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
+		unsigned int len, int dir, struct iov_iter *iter);
+
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
 	/*
@@ -220,4 +225,30 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
 {
 	return __io_put_kbufs(req, len, nbufs, issue_flags);
 }
+
+static inline bool io_use_leased_grp_kbuf(struct io_kiocb *req)
+{
+	/* can't use group kbuf in case of buffer select or fixed buffer */
+	if (req->flags & REQ_F_BUFFER_SELECT)
+		return false;
+
+	return req->flags & REQ_F_GROUP_KBUF;
+}
+
+static inline void io_drop_leased_grp_kbuf(struct io_kiocb *req)
+{
+	const struct io_uring_kernel_buf *gbuf = req->grp_kbuf;
+
+	if (gbuf)
+		gbuf->grp_kbuf_ack(gbuf);
+}
+
+/* zero remained bytes of kernel buffer for avoiding to leak daata */
+static inline void io_req_zero_remained(struct io_kiocb *req, struct iov_iter *iter)
+{
+	size_t left = iov_iter_count(iter);
+
+	if (iov_iter_rw(iter) == READ && left > 0)
+		iov_iter_zero(left, iter);
+}
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 2040195e33ab..c7d58a0c38c3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -88,6 +88,13 @@ struct io_sr_msg {
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
@@ -384,7 +391,7 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kmsg->msg.msg_name = &kmsg->addr;
 		kmsg->msg.msg_namelen = addr_len;
 	}
-	if (!io_do_buffer_select(req)) {
+	if (!io_do_buffer_select(req) && !io_use_leased_grp_kbuf(req)) {
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
 				  &kmsg->msg.msg_iter);
 		if (unlikely(ret < 0))
@@ -599,6 +606,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 
+	if (io_use_leased_grp_kbuf(req)) {
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
@@ -889,6 +905,8 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		*ret = IOU_STOP_MULTISHOT;
 	else
 		*ret = IOU_OK;
+	if (io_use_leased_grp_kbuf(req))
+		io_req_zero_remained(req, &kmsg->msg.msg_iter);
 	io_req_msg_cleanup(req, issue_flags);
 	return true;
 }
@@ -1161,6 +1179,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			goto out_free;
 		}
 		sr->buf = NULL;
+	} else if (io_use_leased_grp_kbuf(req)) {
+		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
+				sr->len, ITER_DEST, &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			goto out_free;
 	}
 
 	kmsg->msg.msg_flags = 0;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4bc0d762627d..5a2025d48804 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	if (io_rw_alloc_async(req))
 		return -ENOMEM;
 
-	if (!do_import || io_do_buffer_select(req))
+	if (!do_import || io_do_buffer_select(req) ||
+	    io_use_leased_grp_kbuf(req))
 		return 0;
 
 	rw = req->async_data;
@@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 		}
 		req_set_fail(req);
 		req->cqe.res = res;
+		if (io_use_leased_grp_kbuf(req)) {
+			struct io_async_rw *io = req->async_data;
+
+			io_req_zero_remained(req, &io->iter);
+		}
 	}
 	return false;
 }
@@ -630,11 +636,16 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
  */
 static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 {
+	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 	struct kiocb *kiocb = &rw->kiocb;
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
 	loff_t *ppos;
 
+	/* group buffer is kernel buffer and doesn't have userspace addr */
+	if (io_use_leased_grp_kbuf(req))
+		return -EOPNOTSUPP;
+
 	/*
 	 * Don't support polled IO through this interface, and we can't
 	 * support non-blocking either. For the latter, this just causes
@@ -841,6 +852,12 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_import_iovec(ITER_DEST, req, io, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
+	} else if (io_use_leased_grp_kbuf(req)) {
+		ret = io_import_group_kbuf(req, rw->addr, rw->len, ITER_DEST,
+				&io->iter);
+		if (unlikely(ret))
+			return ret;
+		iov_iter_save_state(&io->iter, &io->iter_state);
 	}
 	ret = io_rw_init_file(req, FMODE_READ, READ);
 	if (unlikely(ret))
@@ -1024,6 +1041,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
+	if (io_use_leased_grp_kbuf(req)) {
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
2.46.0


