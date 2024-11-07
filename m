Return-Path: <io-uring+bounces-4532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D1A9C0338
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:03:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F18BB286821
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9819F1F12F9;
	Thu,  7 Nov 2024 11:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dG1IyglK"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7341F130C
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977369; cv=none; b=uM+JJz4wKsDiaPj40tmdZr8OLA4ZQ4abOZkyRqcc6yWATUJf7GVghNXfrcSHWfX4VCBimPlMtMMZEWMZRWtfzj/DR1ZhzFBC2oIqkiyFSy7rq0wsIpWnG8Q2PdvpcoGbAFj7GE9L28GBTKw3PawtTBAtdSP66yHzgIk05dT71Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977369; c=relaxed/simple;
	bh=WLUXOs7MNWpkEgzEkLmfGnLAZ+OFhefO3mr3LpA6yjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrtziC8HOitgPY4dPLnfIzNJB6lPRtefS+kwi31dVKXknQ3m0kru0v4jJl1ezBj8bOdhkntFCo59iVO4+fkT9xVftRKR0slok6zlpsRgHvvonWhLRcO1jOwDTe2Pow8Fp1GJt2vBFCoWG8h/AGAiDYS9WpgYIaMTNiDnwDJvqUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dG1IyglK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVlqwA/Orn5NedMGzu2+4AFeFVHVMFMTnRQroUg9LgA=;
	b=dG1IyglKL203u5XP6XEAwR+JwspJXk6fFggQ9MryQB+yg+zPmqtQopU9bnfotQwelHaAf7
	z8+E3IEmEi/bRcDI2vWPplnqOTIThRMlhgD2BjXmRz/9KM+NX+CGwLsM+7QCIukKUPlp/r
	YgRZAYtEghouyBRyZymmYGXcgt11Z0g=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-185-zPNixEhHMcGwczNAxmkaGw-1; Thu,
 07 Nov 2024 06:02:43 -0500
X-MC-Unique: zPNixEhHMcGwczNAxmkaGw-1
X-Mimecast-MFC-AGG-ID: zPNixEhHMcGwczNAxmkaGw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50B74195419F;
	Thu,  7 Nov 2024 11:02:42 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C52D195E480;
	Thu,  7 Nov 2024 11:02:40 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 10/12] io_uring: support leased group buffer with REQ_F_GROUP_BUF
Date: Thu,  7 Nov 2024 19:01:43 +0800
Message-ID: <20241107110149.890530-11-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
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

- member requests uses the leased buffer to do FS or network IO,
  IOSQE_IO_DRAIN bit isn't used for group member IO, so it is mapped to
  GROUP_KBUF; the actual use becomes very similar with buffer select.

- this kernel buffer is returned back after all member requests are
  completed

io_uring builtin provide/register buffer isn't one good match for this
use case:

- complicated dependency on add/remove buffer
  this buffer has to be added/removed to one global table by add/remove OPs,
  and all consumer OPs have to sync with the add/remove OPs; either
  consumer OPs have to by issued one by one with IO_LINK; or two extra
  syscall are added for one time of buffer lease & consumption, this way
  slows down ublk io handling, and may lose zero copy value

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
operations, such as ublk, fuse.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |  6 ++++
 io_uring/io_uring.c            | 24 ++++++++++++---
 io_uring/io_uring.h            |  5 ++++
 io_uring/kbuf.c                | 54 ++++++++++++++++++++++++++++++++--
 io_uring/kbuf.h                | 30 +++++++++++++++++--
 io_uring/net.c                 | 27 ++++++++++++++++-
 io_uring/opdef.c               |  4 +++
 io_uring/opdef.h               |  2 ++
 io_uring/rsrc.h                |  7 +++++
 io_uring/rw.c                  | 37 +++++++++++++++++++----
 10 files changed, 180 insertions(+), 16 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7de0d4c0ed6b..b919ab62020c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -518,6 +518,8 @@ enum {
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_BUF_NODE_BIT,
 	REQ_F_GROUP_LEADER_BIT,
+	REQ_F_GROUP_BUF_BIT,
+	REQ_F_BUF_IMPORTED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -602,6 +604,10 @@ enum {
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* sqe group lead */
 	REQ_F_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_GROUP_LEADER_BIT),
+	/* Use group leader's buffer */
+	REQ_F_GROUP_BUF	= IO_REQ_FLAG(REQ_F_GROUP_BUF_BIT),
+	/* used in case buffer has to be imported from ->issue() once */
+	REQ_F_BUF_IMPORTED = IO_REQ_FLAG(REQ_F_BUF_IMPORTED_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 076171977d5e..c0d8b3c34d71 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -925,14 +925,21 @@ static void io_queue_group_members(struct io_kiocb *req)
 	req->grp_link = NULL;
 	while (member) {
 		struct io_kiocb *next = member->grp_link;
+		bool grp_buf = member->flags & REQ_F_GROUP_BUF;
 
 		member->grp_leader = req;
 		if (unlikely(member->flags & REQ_F_FAIL))
 			io_req_task_queue_fail(member, member->cqe.res);
+		else if (unlikely(grp_buf && !(req->flags & REQ_F_BUF_NODE &&
+				  io_issue_defs[member->opcode].group_buf)))
+			io_req_task_queue_fail(member, -EINVAL);
 		else if (unlikely(req->flags & REQ_F_FAIL))
 			io_req_task_queue_fail(member, -ECANCELED);
-		else
+		else {
+			if (grp_buf)
+				io_req_assign_buf_node(member, req->buf_node);
 			io_req_task_queue(member);
+		}
 		member = next;
 	}
 }
@@ -2196,9 +2203,18 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
-			if (ctx->drain_disabled)
-				return io_init_fail_req(req, -EOPNOTSUPP);
-			io_init_req_drain(req);
+			/* IO_DRAIN is mapped to GROUP_BUF for group members */
+			if (ctx->submit_state.group.head) {
+				/* can't do buffer select */
+				if (sqe_flags & IOSQE_BUFFER_SELECT)
+					return io_init_fail_req(req, -EINVAL);
+				req->flags &= ~REQ_F_IO_DRAIN;
+				req->flags |= REQ_F_GROUP_BUF;
+			} else {
+				if (ctx->drain_disabled)
+					return io_init_fail_req(req, -EOPNOTSUPP);
+				io_init_req_drain(req);
+			}
 		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index facd5c85ba8b..b14acb58b573 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -363,6 +363,11 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
 	return req->flags & REQ_F_GROUP_LEADER;
 }
 
+static inline bool req_is_group_member(struct io_kiocb *req)
+{
+	return (req->flags & REQ_F_GROUP) && !req_is_group_leader(req);
+}
+
 /*
  * Don't complete immediately but use deferred completion infrastructure.
  * Protected by ->uring_lock and can only be used either with
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c4a776860cb4..6b2f74daf135 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -847,9 +847,9 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
  * Also kernel buffer lifetime is bound with request, and we needn't
  * to use rsrc_node to track its lifetime
  */
-int io_import_kbuf(int ddir, struct iov_iter *iter,
-		    const struct io_mapped_buf *kbuf,
-		    u64 buf_off, size_t len)
+static int io_import_kbuf(int ddir, struct iov_iter *iter,
+			  const struct io_mapped_buf *kbuf,
+			  u64 buf_off, size_t len)
 {
 	unsigned long offset = kbuf->offset;
 
@@ -872,3 +872,51 @@ int io_import_kbuf(int ddir, struct iov_iter *iter,
 
 	return 0;
 }
+
+int io_import_group_buf(struct io_kiocb *req, int dir, struct iov_iter *iter,
+			unsigned long buf_off, unsigned int len)
+{
+	int ret;
+
+	if (!req_is_group_member(req))
+		return -EINVAL;
+
+	if (!(req->flags & REQ_F_BUF_NODE))
+		return -EINVAL;
+
+	if (req->flags & REQ_F_BUF_IMPORTED)
+		return 0;
+
+	ret = io_import_kbuf(dir, iter, req->buf_node->buf, buf_off, len);
+	if (!ret)
+		req->flags |= REQ_F_BUF_IMPORTED;
+	return ret;
+}
+
+int io_lease_group_kbuf(struct io_kiocb *req,
+			struct io_rsrc_node *node)
+{
+	const struct io_mapped_buf *buf = node->buf;
+
+	if (!(req->flags & REQ_F_GROUP_LEADER))
+		return -EINVAL;
+
+	if (req->flags & (REQ_F_BUFFER_SELECT | REQ_F_BUF_NODE))
+		return -EINVAL;
+
+	if (!buf || !buf->kbuf_ack || !buf->pbvec || !buf->kbuf)
+		return -EINVAL;
+
+	/*
+	 * Allow io_uring OPs to borrow this leased kbuf, which is returned
+	 * back by calling `kbuf_ack` when the group leader is freed.
+	 *
+	 * Not like pipe/splice, this kernel buffer is always owned by the
+	 * provider, and has to be returned back.
+	 */
+	io_rsrc_node_init(node, IORING_RSRC_BUFFER, IORING_RSRC_F_BUF_KERNEL);
+	req->buf_node = node;
+
+	req->flags |= REQ_F_GROUP_BUF | REQ_F_BUF_NODE;
+	return 0;
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 04ccd52dd0ad..2e47ac33aa60 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -3,6 +3,7 @@
 #define IOU_KBUF_H
 
 #include <uapi/linux/io_uring.h>
+#include "rsrc.h"
 
 enum {
 	/* ring mapped provided buffers */
@@ -88,9 +89,10 @@ void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
 struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
-int io_import_kbuf(int ddir, struct iov_iter *iter,
-		    const struct io_mapped_buf *kbuf,
-		    u64 buf_off, size_t len);
+
+int io_import_group_buf(struct io_kiocb *req, int dir, struct iov_iter *iter,
+			unsigned long buf_off, unsigned int len);
+int io_lease_group_kbuf(struct io_kiocb *req, struct io_rsrc_node *node);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
@@ -223,4 +225,26 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
 {
 	return __io_put_kbufs(req, len, nbufs, issue_flags);
 }
+
+static inline bool io_use_group_buf(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_GROUP_BUF;
+}
+
+static inline bool io_use_group_kbuf(struct io_kiocb *req)
+{
+	if (io_use_group_buf(req))
+		return io_req_use_kernel_buf(req);
+	return false;
+}
+
+/* zero remained bytes of kernel buffer for avoiding to leak data */
+static inline void io_req_zero_remained(struct io_kiocb *req, struct iov_iter *iter)
+{
+	size_t left = iov_iter_count(iter);
+
+	if (iov_iter_rw(iter) == READ && left > 0)
+		iov_iter_zero(left, iter);
+}
+
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index df1f7dc6f1c8..855bf101d54f 100644
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
+	if (!io_do_buffer_select(req) && !io_use_group_buf(req)) {
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
 				  &kmsg->msg.msg_iter);
 		if (unlikely(ret < 0))
@@ -599,6 +606,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 
+	if (io_use_group_buf(req)) {
+		ret = io_import_group_buf(req, ITER_SOURCE,
+					  &kmsg->msg.msg_iter,
+					  user_ptr_to_u64(sr->buf),
+					  sr->len);
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
+	if (io_use_group_kbuf(req))
+		io_req_zero_remained(req, &kmsg->msg.msg_iter);
 	io_req_msg_cleanup(req, issue_flags);
 	return true;
 }
@@ -1161,6 +1179,13 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			goto out_free;
 		}
 		sr->buf = NULL;
+	} else if (io_use_group_buf(req)) {
+		ret = io_import_group_buf(req, ITER_DEST,
+					  &kmsg->msg.msg_iter,
+					  user_ptr_to_u64(sr->buf),
+					  sr->len);
+		if (unlikely(ret))
+			goto out_free;
 	}
 
 	kmsg->msg.msg_flags = 0;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3de75eca1c92..4426e8e7a2f1 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -246,6 +246,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.group_buf		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read,
 		.issue			= io_read,
@@ -260,6 +261,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.group_buf		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write,
 		.issue			= io_write,
@@ -282,6 +284,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.buffer_select		= 1,
+		.group_buf		= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
@@ -297,6 +300,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.group_buf		= 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_recvmsg_prep,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 14456436ff74..44597d45d7c6 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -27,6 +27,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
 	unsigned		vectored : 1;
+	/* support group buffer */
+	unsigned		group_buf : 1;
 
 	/* size of async data needed, if any */
 	unsigned short		async_size;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f45a26c3b79d..9d001d72b65d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -110,6 +110,13 @@ static inline void io_req_assign_buf_node(struct io_kiocb *req,
 	req->flags |= REQ_F_BUF_NODE;
 }
 
+static inline bool io_req_use_kernel_buf(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_BUF_NODE)
+		return req->buf_node->flags & IORING_RSRC_F_BUF_KERNEL;
+	return false;
+}
+
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index b62cdb5fc936..f0a4e4524188 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -487,6 +487,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 		}
 		req_set_fail(req);
 		req->cqe.res = res;
+		if (io_use_group_kbuf(req)) {
+			struct io_async_rw *io = req->async_data;
+
+			io_req_zero_remained(req, &io->iter);
+		}
 	}
 	return false;
 }
@@ -628,11 +633,15 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
  */
 static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 {
+	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 	struct kiocb *kiocb = &rw->kiocb;
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
 	loff_t *ppos;
 
+	if (io_use_group_kbuf(req))
+		return -EOPNOTSUPP;
+
 	/*
 	 * Don't support polled IO through this interface, and we can't
 	 * support non-blocking either. For the latter, this just causes
@@ -831,20 +840,32 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	return 0;
 }
 
+static int rw_import_group_buf(struct io_kiocb *req, int dir,
+			       struct io_rw *rw, struct io_async_rw *io)
+{
+	int ret = io_import_group_buf(req, dir, &io->iter, rw->addr, rw->len);
+
+	if (!ret)
+		iov_iter_save_state(&io->iter, &io->iter_state);
+	return ret;
+}
+
 static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_async_rw *io = req->async_data;
 	struct kiocb *kiocb = &rw->kiocb;
-	ssize_t ret;
+	ssize_t ret = 0;
 	loff_t *ppos;
 
-	if (io_do_buffer_select(req)) {
+	if (io_do_buffer_select(req))
 		ret = io_import_iovec(ITER_DEST, req, io, issue_flags);
-		if (unlikely(ret < 0))
-			return ret;
-	}
+	else if (io_use_group_buf(req))
+		ret = rw_import_group_buf(req, ITER_DEST, rw, io);
+	if (unlikely(ret < 0))
+		return ret;
+
 	ret = io_rw_init_file(req, FMODE_READ, READ);
 	if (unlikely(ret))
 		return ret;
@@ -1027,6 +1048,12 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
+	if (io_use_group_buf(req)) {
+		ret = rw_import_group_buf(req, ITER_SOURCE, rw, io);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
 	ret = io_rw_init_file(req, FMODE_WRITE, WRITE);
 	if (unlikely(ret))
 		return ret;
-- 
2.47.0


