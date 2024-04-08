Return-Path: <io-uring+bounces-1453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A48189B50F
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 03:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D7AB1F213F9
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43157F8;
	Mon,  8 Apr 2024 01:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bs19CbBH"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5DABE4A
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 01:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712538289; cv=none; b=kyW8c1NpKcik8DzHPl80CGWfL+AysPgctnGOLzPpGJmwwJk826jyIDMrEXBXbwKS+4MGbyfXev/AA4e96BjS38DQQpkC5k2xdu0hHNkyYKJsWaStj0IRRbQ8t0hHnXpd8b/02Z5LWnHReMS3lcoF0fKkmihP7FguU1ro589+pXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712538289; c=relaxed/simple;
	bh=guSN1HQo6pnNdn98fyI12+qKFruRdwZES/QQ9bH7k9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS7dJ/4yN53AFNYqVcLP4TAmTSbwcrdkEr3IYSDgXh12QByFd00uVTIv5JP74GgkbUfX9INdZnG90iyUuGPQI91qWvU+OrODWtyf/GzLevjDPw4mcM7A1LJ0ei5UAW5DXcIJNOndcN360ufVgvANamIyGi1Z7XymCio8qONDl2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bs19CbBH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712538286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FRszjCsOSQdBH4b2T0C/YjzJh80frntnMrhRjjQPemw=;
	b=bs19CbBHTkY1cJ93fAmmYUuSzK8nILmvpGdNzGIlrtlQpIHexFMgyC3EfNyTvPF+IDLSdi
	YaEbt6fTAbkBWgEl17mB1iPQD0OwUYxp4xAODdHPpsy/q4SwChTnkJ3E9pMvwIr99G2VGN
	Y3SO7okzhZ6E3KKo51YTLNW9Gs5gFLU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-NTP9nq8mO0uSxI5wVBcbxQ-1; Sun, 07 Apr 2024 21:04:42 -0400
X-MC-Unique: NTP9nq8mO0uSxI5wVBcbxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BE9C888080;
	Mon,  8 Apr 2024 01:04:42 +0000 (UTC)
Received: from localhost (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C086E40AE782;
	Mon,  8 Apr 2024 01:04:40 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 6/9] io_uring: support providing sqe group buffer
Date: Mon,  8 Apr 2024 09:03:19 +0800
Message-ID: <20240408010322.4104395-7-ming.lei@redhat.com>
In-Reply-To: <20240408010322.4104395-1-ming.lei@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

SQE group introduces one new mechanism to share resource among one group of
requests, and all member requests can consume the resource provided by
group lead efficiently and concurrently.

This patch uses the added sqe group feature to share kernel buffer in sqe
group:

- the group lead provides kernel buffer to member requests

- member requests use the provided buffer to do FS or network IO, or more
operations in future

- this kernel buffer is returned back after member requests use it up

This way looks a bit similar with kernel's pipe/splice, but there are some
important differences:

- splice is for transferring data between two FDs via pipe, and fd_out can
only read data from pipe; this feature can borrow buffer from group lead to
members, so member request can write data to this buffer if the provided
buffer is allowed to write to.

- splice implements data transfer by moving pages between subsystem and
pipe, that means page ownership is transferred, and this way is one of the
most complicated thing of splice; this patch supports scenarios in which
the buffer can't be transferred, and buffer is only borrowed to member
requests, and is returned back after member requests consume the provided
buffer, so buffer lifetime is simplified a lot. Especially the buffer is
guaranteed to be returned back.

- splice can't run in async way basically

It can help to implement generic zero copy between device and related
operations, such as ublk, fuse, vdpa, even network receive or whatever.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 30 ++++++++++++++++
 io_uring/io_uring.c            | 10 +++++-
 io_uring/kbuf.c                | 62 ++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h                | 12 +++++++
 io_uring/net.c                 | 29 ++++++++++++++++
 io_uring/opdef.c               |  5 +++
 io_uring/opdef.h               |  2 ++
 io_uring/rw.c                  | 20 ++++++++++-
 8 files changed, 168 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7ce4a2d4a8b8..e632c3584800 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -6,6 +6,7 @@
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
 #include <linux/llist.h>
+#include <linux/bvec.h>
 #include <uapi/linux/io_uring.h>
 
 enum {
@@ -39,6 +40,22 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+/* buffer provided from kernel */
+struct io_uring_kernel_buf {
+	unsigned long	len;
+	unsigned short	nr_bvecs;
+	unsigned short	dir;	/* ITER_SOURCE or ITER_DEST */
+
+	/* offset in the 1st bvec */
+	unsigned int		offset;
+	const struct bio_vec	*bvec;
+
+	/* private field, user don't touch it */
+	struct bio_vec		__bvec[];
+};
+
+typedef void (io_uring_buf_giveback_t) (const struct io_uring_kernel_buf *);
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -476,6 +493,7 @@ enum {
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_SQE_GROUP_LEAD_BIT,
+	REQ_F_GROUP_KBUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -558,6 +576,8 @@ enum {
 	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
 	/* sqe group lead */
 	REQ_F_SQE_GROUP_LEAD	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEAD_BIT),
+	/* group lead provides kbuf for members, set for both lead and member */
+	REQ_F_GROUP_KBUF	= IO_REQ_FLAG(REQ_F_GROUP_KBUF_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -641,6 +661,15 @@ struct io_kiocb {
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
@@ -675,6 +704,7 @@ struct io_kiocb {
 	/* all SQE group members linked here for group lead */
 	struct io_kiocb			*grp_link;
 	atomic_t			grp_refs;
+	io_uring_buf_giveback_t		*grp_kbuf_ack;
 };
 
 struct io_overflow_cqe {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0f41b26723a8..596c4442c3c6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -114,7 +114,7 @@
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_ASYNC_DATA | REQ_F_GROUP_KBUF)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
@@ -384,6 +384,9 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_clean_op(struct io_kiocb *req)
 {
+	if (req->flags & REQ_F_GROUP_KBUF)
+		io_group_kbuf_drop(req);
+
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		spin_lock(&req->ctx->completion_lock);
 		io_kbuf_drop(req);
@@ -989,8 +992,13 @@ void io_complete_group_lead(struct io_kiocb *req, unsigned issue_flags)
 
 	while (member) {
 		struct io_kiocb *next = member->grp_link;
+		const struct io_issue_def *def = &io_issue_defs[member->opcode];
 
 		member->grp_link = req;
+		if ((req->flags & REQ_F_GROUP_KBUF) && def->accept_group_kbuf) {
+			member->flags |= REQ_F_GROUP_KBUF;
+			member->grp_kbuf_ack = NULL;
+		}
 		if (unlikely(req->flags & REQ_F_FAIL)) {
 			/*
 			 * Now group lead is failed, so simply fail members
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3846a055df44..ab175fa6d57c 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -672,3 +672,65 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	io_put_bl(ctx, bl);
 	return ret;
 }
+
+int io_provide_group_kbuf(struct io_kiocb *req,
+		const struct io_uring_kernel_buf *grp_kbuf,
+		io_uring_buf_giveback_t grp_kbuf_ack)
+{
+	if (unlikely(!req_is_group_lead(req)))
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
+	req->grp_kbuf_ack = grp_kbuf_ack;
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
+	if (!lead || !req_is_group_lead(lead) || !lead->grp_kbuf)
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
index 5a9635ee0217..5d731ed52a28 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -64,6 +64,12 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
 
+int io_provide_group_kbuf(struct io_kiocb *req,
+		const struct io_uring_kernel_buf *grp_kbuf,
+		io_uring_buf_giveback_t grp_kbuf_ack);
+int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
+		unsigned int len, int dir, struct iov_iter *iter);
+
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
 	/*
@@ -145,4 +151,10 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 		__io_put_kbuf(req, issue_flags);
 	return ret;
 }
+
+static inline void io_group_kbuf_drop(struct io_kiocb *req)
+{
+	if (req->grp_kbuf_ack)
+		req->grp_kbuf_ack(req->grp_kbuf);
+}
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 9c0567892945..5371f0f2c0d8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -78,6 +78,13 @@ struct io_sr_msg {
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
@@ -479,6 +486,14 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
+	if (req->flags & REQ_F_GROUP_KBUF) {
+		ret = io_import_group_kbuf(req,
+					user_ptr_to_u64(sr->buf),
+					sr->len, ITER_SOURCE,
+					&kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+	}
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
@@ -927,6 +942,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 				  &kmsg->msg.msg_iter);
 		if (unlikely(ret))
 			goto out_free;
+	} else if (req->flags & REQ_F_GROUP_KBUF) {
+		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
+				sr->len, ITER_DEST, &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			goto out_free;
 	}
 
 	kmsg->msg.msg_inq = -1;
@@ -1125,8 +1145,17 @@ static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
 		if (unlikely(ret))
 			return ret;
 		kmsg->msg.sg_from_iter = io_sg_from_iter;
+	} else if (req->flags & REQ_F_GROUP_KBUF) {
+		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+
+		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
+				sr->len, ITER_SOURCE, &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+		kmsg->msg.sg_from_iter = io_sg_from_iter;
 	} else {
 		io_notif_set_extended(sr->notif);
+
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 		if (unlikely(ret))
 			return ret;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a16f73938ebb..705f0333f9e0 100644
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
@@ -281,6 +283,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.accept_group_kbuf	= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
@@ -296,6 +299,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.accept_group_kbuf	= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_recvmsg_prep,
@@ -423,6 +427,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.accept_group_kbuf	= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_send_zc_prep,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 7ee6f5aa90aa..a53970655c82 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -29,6 +29,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
 	unsigned		vectored : 1;
+	/* opcodes which accept provided group kbuf */
+	unsigned		accept_group_kbuf : 1;
 
 	/* size of async data needed, if any */
 	unsigned short		async_size;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3134a6ece1be..f1052af40563 100644
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
@@ -603,11 +604,16 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
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
@@ -813,6 +819,11 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_import_iovec(ITER_DEST, req, io, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
+	} else if (req->flags & REQ_F_GROUP_KBUF) {
+		ret = io_import_group_kbuf(req, rw->addr, rw->len, ITER_DEST,
+				&io->iter);
+		if (unlikely(ret))
+			return ret;
 	}
 
 	ret = io_rw_init_file(req, FMODE_READ);
@@ -995,6 +1006,13 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
+	if (req->flags & REQ_F_GROUP_KBUF) {
+		ret = io_import_group_kbuf(req, rw->addr, rw->len, ITER_SOURCE,
+				&io->iter);
+		if (unlikely(ret))
+			return ret;
+	}
+
 	ret = io_rw_init_file(req, FMODE_WRITE);
 	if (unlikely(ret))
 		return ret;
-- 
2.42.0


