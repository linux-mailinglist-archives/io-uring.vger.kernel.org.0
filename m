Return-Path: <io-uring+bounces-4484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4EF9BE8D0
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 13:27:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EF651C2087E
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 12:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDFE1D2784;
	Wed,  6 Nov 2024 12:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NzHQ1tjB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D38B1DF995
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 12:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896062; cv=none; b=leBpGZPFOwy1/uEIV0zz6IvGeqm+uqJREsGJHhQYX0JYBGu4+/EDQM1E4AdSE2sIZOd6/B0KypxPW8c0D0muIvSto+VpsGnmOv2HknCUe7snaSahV+0vGW9MZr1NL9vbW4ZRo91cXvkqHR91bs+x3RSfgXrgDtmpUtpr/Pu1W60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896062; c=relaxed/simple;
	bh=Sa4Gnl9J/SnoJIEA4GJcjY48+pimkSxJKcj3R9Jjx6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2qlulf5dXWxVJfBHkS1vrPHRMNaXaGnKofnEx8DjfMgu5evzr7ST3nla+EckJGIZgloDNJBtf3grkaiJBZQ3FIBUoxykP2smEwjeyMazJXpMsxKy5unXAbyaZigbNsJNQXu2IuBWh+67cvs2Wz4yDvpW7n2o6ZDPTvFtje4Ugk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NzHQ1tjB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730896057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=whxH4SPRWv0Hdf9zeWiFlnJwp/WHJ7cyfCorPtQzbjg=;
	b=NzHQ1tjBqXPJ6JMsG7HO+ZrgdQDW8YD+ZBJTDzDBH4R50uA3IebFu0bmq9jV225nlzHM8c
	xc+sBdrIvLHTbtznRsHdpWlxCH8DQm5E/+qEnoWQCYdSQyQLTVextRAIj+TFWvhZQs3dB+
	EXI3mvzE48ptlZ8w4CCb0IwMK6MKhtI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-thiCYAPVP2-iuInWaWcFmQ-1; Wed,
 06 Nov 2024 07:27:34 -0500
X-MC-Unique: thiCYAPVP2-iuInWaWcFmQ-1
X-Mimecast-MFC-AGG-ID: thiCYAPVP2-iuInWaWcFmQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC176195608B;
	Wed,  6 Nov 2024 12:27:32 +0000 (UTC)
Received: from localhost (unknown [10.72.116.107])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D64C319560AA;
	Wed,  6 Nov 2024 12:27:31 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V9 5/7] io_uring: support leased group buffer with REQ_F_GROUP_BUF
Date: Wed,  6 Nov 2024 20:26:54 +0800
Message-ID: <20241106122659.730712-6-ming.lei@redhat.com>
In-Reply-To: <20241106122659.730712-1-ming.lei@redhat.com>
References: <20241106122659.730712-1-ming.lei@redhat.com>
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
 include/linux/io_uring_types.h | 29 +++++++++++++++++-
 io_uring/io_uring.c            | 32 ++++++++++++++++----
 io_uring/io_uring.h            |  5 ++++
 io_uring/kbuf.c                | 55 ++++++++++++++++++++++++++++++++--
 io_uring/kbuf.h                | 49 ++++++++++++++++++++++++++++--
 io_uring/net.c                 | 27 ++++++++++++++++-
 io_uring/rw.c                  | 37 +++++++++++++++++++----
 7 files changed, 216 insertions(+), 18 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9af83cf214c2..f3d891fded55 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -40,8 +40,16 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+struct io_mapped_buf;
+typedef void (io_uring_kbuf_ack_t) (const struct io_mapped_buf *);
+
 struct io_mapped_buf {
-	u64		start;
+	/* start is always 0 for kernel buffer */
+	union {
+		u64			start;
+		/* called for returning back the kernel buffer */
+		io_uring_kbuf_ack_t	*kbuf_ack;
+	};
 	unsigned int	len;
 	unsigned int	nr_bvecs;
 
@@ -504,6 +512,7 @@ enum {
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_GROUP_LEADER_BIT,
 	REQ_F_BUF_NODE_BIT,
+	REQ_F_GROUP_BUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -588,6 +597,16 @@ enum {
 	REQ_F_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_GROUP_LEADER_BIT),
 	/* buf node is valid */
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
+	/*
+	 * Use group leader's buffer
+	 *
+	 * For group member, this flag is mapped from IOSQE_IO_DRAIN which
+	 * isn't used for group member
+	 *
+	 * Group buffer has to be imported in ->issue() since it depends on
+	 * group leader.
+	 */
+	REQ_F_GROUP_BUF	= IO_REQ_FLAG(REQ_F_GROUP_BUF_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -670,6 +689,14 @@ struct io_kiocb {
 		struct io_buffer_list	*buf_list;
 
 		struct io_rsrc_node	*buf_node;
+
+		/* valid IFF REQ_F_GROUP_BUF is set */
+		union {
+			/* store group buffer for group leader */
+			const struct io_mapped_buf *grp_buf;
+			/* for group member */
+			bool	grp_buf_imported;
+		};
 	};
 
 	union {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 076171977d5e..0a87312083bd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -114,7 +114,7 @@
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_ASYNC_DATA | REQ_F_GROUP_BUF)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 REQ_F_GROUP | IO_REQ_CLEAN_FLAGS)
@@ -391,6 +391,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_clean_op(struct io_kiocb *req)
 {
+	if (req->flags & REQ_F_GROUP_BUF)
+		io_drop_group_buf(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		spin_lock(&req->ctx->completion_lock);
 		io_kbuf_drop(req);
@@ -925,14 +927,20 @@ static void io_queue_group_members(struct io_kiocb *req)
 	req->grp_link = NULL;
 	while (member) {
 		struct io_kiocb *next = member->grp_link;
+		bool grp_buf = member->flags & REQ_F_GROUP_BUF;
 
 		member->grp_leader = req;
 		if (unlikely(member->flags & REQ_F_FAIL))
 			io_req_task_queue_fail(member, member->cqe.res);
+		else if (unlikely(grp_buf && member->flags & REQ_F_BUF_NODE))
+			io_req_task_queue_fail(member, -EINVAL);
 		else if (unlikely(req->flags & REQ_F_FAIL))
 			io_req_task_queue_fail(member, -ECANCELED);
-		else
+		else {
+			if (grp_buf)
+				io_req_mark_group_buf(member, false);
 			io_req_task_queue(member);
+		}
 		member = next;
 	}
 }
@@ -997,6 +1005,11 @@ static enum group_mem io_prep_free_group_req(struct io_kiocb *req,
 			io_queue_group_members(req);
 		return GROUP_LEADER;
 	}
+
+	/* we are done with leased group buffer */
+	if (req->flags & REQ_F_GROUP_BUF)
+		req->flags &= ~REQ_F_GROUP_BUF;
+
 	if (!req_is_last_group_member(req))
 		return GROUP_OTHER_MEMBER;
 
@@ -2196,9 +2209,18 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
index 57b0d0209097..dd61529cd382 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -364,6 +364,11 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
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
index c4a776860cb4..1a8ed35d4d6c 100644
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
 
@@ -872,3 +872,52 @@ int io_import_kbuf(int ddir, struct iov_iter *iter,
 
 	return 0;
 }
+
+int io_import_group_buf(struct io_kiocb *req, int dir, struct iov_iter *iter,
+			unsigned long buf_off, unsigned int len)
+{
+	struct io_kiocb *lead = req->grp_leader;
+	int ret;
+
+	if (!req_is_group_member(req))
+		return -EINVAL;
+
+	if (!lead || !(lead->flags & REQ_F_GROUP_BUF))
+		return -EINVAL;
+
+	/* buffer node may be assigned just before importing */
+	if (req->flags & REQ_F_BUF_NODE)
+		return -EINVAL;
+
+	if (io_req_group_buf_imported(req))
+		return 0;
+
+	ret = io_import_kbuf(dir, iter, lead->grp_buf, buf_off, len);
+	if (!ret)
+		io_req_mark_group_buf(req, true);
+	return ret;
+}
+
+int io_lease_group_kbuf(struct io_kiocb *req,
+			const struct io_mapped_buf *grp_buf)
+{
+	if (!(req->flags & REQ_F_GROUP_LEADER))
+		return -EINVAL;
+
+	if (req->flags & (REQ_F_BUFFER_SELECT | REQ_F_BUF_NODE))
+		return -EINVAL;
+
+	if (!grp_buf->kbuf_ack || !grp_buf->pbvec || !grp_buf->kbuf)
+		return -EINVAL;
+
+	/*
+	 * Allow io_uring OPs to borrow this leased kbuf, which is returned
+	 * back by calling `kbuf_ack` when the group leader is freed.
+	 *
+	 * Not like pipe/splice, this kernel buffer is always owned by the
+	 * provider, and has to be returned back.
+	 */
+	req->grp_buf = grp_buf;
+	req->flags |= REQ_F_GROUP_BUF;
+	return 0;
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 04ccd52dd0ad..f98e2d8dc48c 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -88,9 +88,11 @@ void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
 struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
-int io_import_kbuf(int ddir, struct iov_iter *iter,
-		    const struct io_mapped_buf *kbuf,
-		    u64 buf_off, size_t len);
+
+int io_import_group_buf(struct io_kiocb *req, int dir, struct iov_iter *iter,
+			unsigned long buf_off, unsigned int len);
+int io_lease_group_kbuf(struct io_kiocb *req,
+			const struct io_mapped_buf *grp_buf);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
@@ -223,4 +225,45 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
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
+		return req->grp_leader && req->grp_leader->grp_buf->kbuf;
+	return false;
+}
+
+static inline void io_drop_group_buf(struct io_kiocb *req)
+{
+	const struct io_mapped_buf *gbuf = req->grp_buf;
+
+	if (gbuf && gbuf->kbuf)
+		gbuf->kbuf_ack(gbuf);
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
+/* For group member only */
+static inline void io_req_mark_group_buf(struct io_kiocb *req, bool imported)
+{
+	req->grp_buf_imported = imported;
+}
+
+/* For group member only */
+static inline bool io_req_group_buf_imported(struct io_kiocb *req)
+{
+	return req->grp_buf_imported;
+}
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 2ccc2b409431..e87b67498733 100644
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
diff --git a/io_uring/rw.c b/io_uring/rw.c
index e368b9afde03..c5ab464dd51d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -488,6 +488,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
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
@@ -629,11 +634,15 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
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
@@ -832,20 +841,32 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
@@ -1028,6 +1049,12 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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


