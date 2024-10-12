Return-Path: <io-uring+bounces-3622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D333499B250
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 10:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F998B2275B
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 08:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC99149C41;
	Sat, 12 Oct 2024 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BC+7u8LZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96BF145B0F
	for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 08:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723249; cv=none; b=GbKUgiedreArUoNpjHkUZwwgDJfgPRH8HyIHVR5XqVkaNQ8jUzHBkBjP+DDHSBrXkXal2765DHaV3qbf+15jVp78VWuHOyJLB5erHhVle4QbfdkLAI+tjYgZPKJ7WEkBnxtyJzaZIEwMyX4ZG80CXfehTPGQgWPminnD7zylhAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723249; c=relaxed/simple;
	bh=zCVH7kuwKdMD5tdt+5JRiH979d6PiQfgrmsK4ucZ1fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWZP4MfXTO+MHV2YUnajzOTL2t2nzhouOm8zXsoaXP0DrVPtqrg0H16ngZeaPVTyXXk1SLfneTczQIhia1LjYUNPbCLSj/fZMFaSUNjFBYXCIr0VtXyvB9nedAOgVU67fzhx5no77IyMdYrsn2eG5NxXerWKiKR6QFEo7QjguRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BC+7u8LZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728723246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgzQJTEc1/xh0CE6GdkIFXNEJ9LjIZa7VWkNCMAt6no=;
	b=BC+7u8LZCatRwcgcQuP1me3LWNJbaec+YXUdrHY6JYDg8DS9NWqdvavcs+Q+SCIMD85/qM
	C6EYuTUJcrd3Z8yelPbnEFa/4edRJ29rdnLeHhVedaMOWk6TQPmQW8nq8iKk6iPW0V/5Ge
	bcLAjvgyZ0nkc70f1jZBuYJfgR3MGhA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-1moiK2ynPHOPZqNg3PWrRA-1; Sat,
 12 Oct 2024 04:54:02 -0400
X-MC-Unique: 1moiK2ynPHOPZqNg3PWrRA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BAEE19560BE;
	Sat, 12 Oct 2024 08:53:59 +0000 (UTC)
Received: from localhost (unknown [10.72.116.121])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4C96419560A2;
	Sat, 12 Oct 2024 08:53:57 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V7 5/7] io_uring: support leased group buffer with REQ_F_GROUP_KBUF
Date: Sat, 12 Oct 2024 16:53:25 +0800
Message-ID: <20241012085330.2540955-6-ming.lei@redhat.com>
In-Reply-To: <20241012085330.2540955-1-ming.lei@redhat.com>
References: <20241012085330.2540955-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
 io_uring/io_uring.c            | 25 +++++++++++----
 io_uring/io_uring.h            |  5 +++
 io_uring/kbuf.c                | 58 ++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h                | 22 +++++++++++++
 io_uring/net.c                 | 23 +++++++++++++-
 io_uring/rw.c                  | 21 +++++++++++-
 7 files changed, 186 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 11c6726abbb9..9de77bc21d67 100644
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
@@ -472,6 +493,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_SQE_GROUP_LEADER_BIT,
+	REQ_F_GROUP_KBUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -554,6 +576,15 @@ enum {
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
@@ -637,6 +668,15 @@ struct io_kiocb {
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
index 1ada7d110641..e63eb89b0a18 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -116,7 +116,7 @@
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_ASYNC_DATA | REQ_F_GROUP_KBUF)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 REQ_F_SQE_GROUP | REQ_F_SQE_GROUP_LEADER | \
@@ -387,6 +387,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_clean_op(struct io_kiocb *req)
 {
+	if (req->flags & REQ_F_GROUP_KBUF)
+		io_drop_leased_grp_kbuf(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		spin_lock(&req->ctx->completion_lock);
 		io_kbuf_drop(req);
@@ -981,8 +983,13 @@ static void io_complete_group_member(struct io_kiocb *req)
 	if (!(req->flags & REQ_F_CQE_SKIP))
 		io_req_commit_cqe(req->ctx, req);
 
-	/* clear it so it can be reused for marking last member */
-	req->flags &= ~REQ_F_SQE_GROUP;
+	/*
+	 * Clear GROUP so it can be reused for marking last member
+	 *
+	 * Clear GROUP_KBUF since we are done with provided group
+	 * buffer now if there is
+	 */
+	req->flags &= ~(REQ_F_SQE_GROUP | REQ_F_GROUP_KBUF);
 
 	/* Set leader as failed in case of any member failed */
 	if (unlikely((req->flags & REQ_F_FAIL)))
@@ -2222,9 +2229,15 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
index 313829cff3d0..7db916961b73 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -350,6 +350,11 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
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
index d407576ddfb7..5796eb9f6f28 100644
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
+	struct io_kiocb *lead = req->grp_link;
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
index 36aadfe5ac00..d72a6bbbbd12 100644
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
@@ -220,4 +225,21 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
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
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index f10f5a22d66a..6c32be92646f 100644
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
+	if (!io_do_buffer_select(req) && !io_use_leased_grp_kbuf(req)) {
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
 				  &kmsg->msg.msg_iter);
 		if (unlikely(ret < 0))
@@ -593,6 +600,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1154,6 +1170,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
index f023ff49c688..76a443fa593c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -235,7 +235,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	if (io_rw_alloc_async(req))
 		return -ENOMEM;
 
-	if (!do_import || io_do_buffer_select(req))
+	if (!do_import || io_do_buffer_select(req) ||
+	    io_use_leased_grp_kbuf(req))
 		return 0;
 
 	rw = req->async_data;
@@ -619,11 +620,16 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
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
@@ -830,6 +836,12 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1019,6 +1031,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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


