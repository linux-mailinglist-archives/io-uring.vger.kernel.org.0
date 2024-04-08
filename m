Return-Path: <io-uring+bounces-1452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C765489B50D
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 03:05:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D55B28142F
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAFC1C0DEA;
	Mon,  8 Apr 2024 01:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ik6rQtDM"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0475B17F7
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 01:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712538265; cv=none; b=CU0RU/VnsjcuuAq+ym0w+u1o4doeqJJoZsLeF2NUfu5nzNxEse/WXYE/5MGyAwCQB6Uph7zoVHMProQJPEGlNNJsl3u6TkWwQzg9tOhDYzf2Gwrg0CsJGojcOPsyztaEUTdLODTlMWMj3+SQ+ehdx4llck3sRwiCDPwSDng0LH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712538265; c=relaxed/simple;
	bh=TgRa41j6isTfJsPNxy7+hMO1MyLUepmrgPPzTtLksrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myF+T4JRaLGQvWVElQeUs2IopkpvGfTuVCa9/6fCFhQtsvIgQH7td3/N17odQzZokLwGdEljkH9Xx57WZbjwewzaj1T3zwaIl+XRwEX1ueyHel42teAgkHUCAS9GBGx18yC/xhg5EL71Lt0RmOu0OVZI+QvZOpKu/U5M/eza5+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ik6rQtDM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712538262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gAWK8uGMA1FmyCYD/3aI7hQBXaYJIwKm7EJ5DymaJ1o=;
	b=Ik6rQtDMHnlwnAwMX7t5JhyukjrkJhEyHt8lHxZPstsUFMnpnfKiyJEO9V71VNjIPMe1qN
	7D6WvLt5hQevGd5ycwnSP/JsqT4wbd5SV8rXcnwcyusnPn2PFZ4AGTDj488Ggmy1pPk393
	+H3Op7Ef/jX121uLgHKKqOEAJkHwLLg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647--cLVtox9PmS_vZoeNL-_kg-1; Sun, 07 Apr 2024 21:04:18 -0400
X-MC-Unique: -cLVtox9PmS_vZoeNL-_kg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54B1C8DEF78;
	Mon,  8 Apr 2024 01:04:18 +0000 (UTC)
Received: from localhost (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 154BCC0157C;
	Mon,  8 Apr 2024 01:04:16 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5/9] io_uring: support SQE group
Date: Mon,  8 Apr 2024 09:03:18 +0800
Message-ID: <20240408010322.4104395-6-ming.lei@redhat.com>
In-Reply-To: <20240408010322.4104395-1-ming.lei@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

SQE group is defined as one chain of SQEs starting with the first sqe that
has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
doesn't have it set, and it is similar with chain of linked sqes.

The 1st SQE is group leader, and the other SQEs are group member. The group
leader is always freed after all members are completed. Group members
aren't submitted until the group leader is completed, and there isn't any
dependency among group members, and IOSQE_IO_LINK can't be set for group
members, same with IOSQE_IO_DRAIN.

Typically the group leader provides or makes resource, and the other members
consume the resource, such as scenario of multiple backup, the 1st SQE is to
read data from source file into fixed buffer, the other SQEs write data from
the same buffer into other destination files. SQE group provides very
efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
submitted in single syscall, no need to submit fs read SQE first, and wait
until read SQE is completed, 2) no need to link all write SQEs together, then
write SQEs can be submitted to files concurrently. Meantime application is
simplified a lot in this way.

Another use case is to for supporting generic device zero copy:

- the lead SQE is for providing device buffer, which is owned by device or
  kernel, can't be cross userspace, otherwise easy to cause leak for devil
  application or panic

- member SQEs reads or writes concurrently against the buffer provided by lead
  SQE

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |  10 ++
 include/uapi/linux/io_uring.h  |   4 +
 io_uring/io_uring.c            | 218 ++++++++++++++++++++++++++++++---
 io_uring/io_uring.h            |  17 ++-
 4 files changed, 231 insertions(+), 18 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 67347e5d06ec..7ce4a2d4a8b8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -444,6 +444,7 @@ enum {
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
 	REQ_F_SQE_EXT_FLAGS_BIT	= IOSQE_HAS_EXT_FLAGS_BIT,
+	REQ_F_SQE_GROUP_BIT	= 8 + IOSQE_EXT_SQE_GROUP_BIT,
 
 	/* first 2 bytes are taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 16,
@@ -474,6 +475,7 @@ enum {
 	REQ_F_CAN_POLL_BIT,
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
+	REQ_F_SQE_GROUP_LEAD_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -497,6 +499,8 @@ enum {
 	REQ_F_BUFFER_SELECT	= IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		= IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
+	/* IOSQE_EXT_SQE_GROUP */
+	REQ_F_SQE_GROUP		= IO_REQ_FLAG(REQ_F_SQE_GROUP_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= IO_REQ_FLAG(REQ_F_FAIL_BIT),
@@ -552,6 +556,8 @@ enum {
 	REQ_F_BL_EMPTY		= IO_REQ_FLAG(REQ_F_BL_EMPTY_BIT),
 	/* don't recycle provided buffers for this request */
 	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
+	/* sqe group lead */
+	REQ_F_SQE_GROUP_LEAD	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEAD_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -665,6 +671,10 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+
+	/* all SQE group members linked here for group lead */
+	struct io_kiocb			*grp_link;
+	atomic_t			grp_refs;
 };
 
 struct io_overflow_cqe {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4847d7cf1ac9..c0d34f2a2c17 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -128,6 +128,8 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
 	IOSQE_HAS_EXT_FLAGS_BIT,
+
+	IOSQE_EXT_SQE_GROUP_BIT = 0,
 };
 
 /*
@@ -152,6 +154,8 @@ enum io_uring_sqe_flags_bit {
  * sqe->uring_cmd_flags for IORING_URING_CMD.
  */
 #define IOSQE_HAS_EXT_FLAGS	(1U << IOSQE_HAS_EXT_FLAGS_BIT)
+/* defines sqe group */
+#define IOSQE_EXT_SQE_GROUP	(1U << IOSQE_EXT_SQE_GROUP_BIT)
 
 /*
  * io_uring_setup() flags
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4969d21ea2f8..0f41b26723a8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -147,6 +147,10 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all);
 
 static void io_queue_sqe(struct io_kiocb *req);
+static bool io_get_sqe(struct io_ring_ctx *ctx,
+		const struct io_uring_sqe **sqe);
+static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		       const struct io_uring_sqe *sqe);
 
 struct kmem_cache *req_cachep;
 static struct workqueue_struct *iou_wq __ro_after_init;
@@ -925,10 +929,189 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
+static void __io_req_failed(struct io_kiocb *req, s32 res, bool skip_cqe)
+{
+	const struct io_cold_def *def = &io_cold_defs[req->opcode];
+
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	if (skip_cqe)
+		req->flags |= REQ_F_FAIL | REQ_F_CQE_SKIP;
+	else
+		req_set_fail(req);
+	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
+	if (def->fail)
+		def->fail(req);
+}
+
+void io_req_defer_failed(struct io_kiocb *req, s32 res)
+	__must_hold(&ctx->uring_lock)
+{
+	__io_req_failed(req, res, false);
+	io_req_complete_defer(req);
+}
+
+static void io_req_defer_failed_sliently(struct io_kiocb *req, s32 res)
+	__must_hold(&ctx->uring_lock)
+{
+	__io_req_failed(req, res, true);
+	io_req_complete_defer(req);
+}
+
+/*
+ * Called after member req is completed, and return the lead request for
+ * caller to fill cqe & free it really
+ */
+static inline struct io_kiocb *io_complete_group_member(struct io_kiocb *req)
+{
+	struct io_kiocb *lead = req->grp_link;
+
+	req->grp_link = NULL;
+	if (lead && atomic_dec_and_test(&lead->grp_refs)) {
+		req->grp_link = NULL;
+		lead->flags &= ~REQ_F_SQE_GROUP_LEAD;
+		return lead;
+	}
+
+	return NULL;
+}
+
+/*
+ * Called after lead req is completed and before posting cqe and freeing,
+ * for issuing member requests
+ */
+void io_complete_group_lead(struct io_kiocb *req, unsigned issue_flags)
+{
+	struct io_kiocb *member = req->grp_link;
+
+	if (!member)
+		return;
+
+	while (member) {
+		struct io_kiocb *next = member->grp_link;
+
+		member->grp_link = req;
+		if (unlikely(req->flags & REQ_F_FAIL)) {
+			/*
+			 * Now group lead is failed, so simply fail members
+			 * with -EIO, and the application can figure out
+			 * the reason from lead's cqe->res
+			 */
+			__io_req_failed(member, -EIO, false);
+
+			if (issue_flags & IO_URING_F_COMPLETE_DEFER)
+				io_req_complete_defer(member);
+			else {
+				member->io_task_work.func = io_req_task_complete;
+				io_req_task_work_add(member);
+			}
+		} else {
+			trace_io_uring_submit_req(member);
+			if ((issue_flags & IO_URING_F_COMPLETE_DEFER) &&
+					!(member->flags & REQ_F_FORCE_ASYNC))
+				io_queue_sqe(member);
+			else
+				io_req_task_queue(member);
+		}
+		member = next;
+	}
+	req->grp_link = NULL;
+}
+
+static bool sqe_is_group_member(const struct io_uring_sqe *sqe)
+{
+	return (READ_ONCE(sqe->flags) & IOSQE_HAS_EXT_FLAGS) &&
+		(READ_ONCE(sqe->ext_flags) & IOSQE_EXT_SQE_GROUP);
+}
+
+/*
+ * Initialize the whole SQE group.
+ *
+ * Walk every member in this group even though failure happens. If the lead
+ * request is failed, CQE is only posted for lead, otherwise, CQE is posted
+ * for every member request. Member requests aren't issued until the lead
+ * is completed, and the lead request won't be freed until all member
+ * requests are completed.
+ *
+ * The whole group shares the link flag in group lead, and other members
+ * aren't allowed to set any LINK flag. And only the lead request may
+ * appear in the submission link list.
+ */
+static int io_init_req_group(struct io_ring_ctx *ctx, struct io_kiocb *lead,
+		int *nr, int lead_ret)
+	__must_hold(&ctx->uring_lock)
+{
+	bool more = true;
+	int cnt = 0;
+
+	lead->grp_link = NULL;
+	do {
+		const struct io_uring_sqe *sqe;
+		struct io_kiocb *req = NULL;
+		int ret = -ENOMEM;
+
+		io_alloc_req(ctx, &req);
+
+		if (unlikely(!io_get_sqe(ctx, &sqe))) {
+			if (req)
+				io_req_add_to_cache(req, ctx);
+			break;
+		}
+
+		/* one group ends with !IOSQE_EXT_SQE_GROUP */
+		if (!sqe_is_group_member(sqe))
+			more = false;
+
+		if (req) {
+			ret = io_init_req(ctx, req, sqe);
+			/*
+			 * Both IO_LINK and IO_DRAIN aren't allowed for
+			 * group member, and the boundary has to be in
+			 * the lead sqe, so the whole group shares
+			 * same IO_LINK and IO_DRAIN.
+			 */
+			if (!ret && (req->flags & (IO_REQ_LINK_FLAGS |
+							REQ_F_IO_DRAIN)))
+				ret = -EINVAL;
+			if (!more)
+				req->flags |= REQ_F_SQE_GROUP;
+			if (unlikely(ret)) {
+				/*
+				 * The lead will be failed, so don't post
+				 * CQE for any member
+				 */
+				io_req_defer_failed_sliently(req, ret);
+			} else {
+				req->grp_link = lead->grp_link;
+				lead->grp_link = req;
+			}
+		}
+		cnt += 1;
+		if (ret)
+			lead_ret = ret;
+	} while (more);
+
+	/* Mark lead if we get members, otherwise degrade it to normal req */
+	if (cnt > 0) {
+		lead->flags |= REQ_F_SQE_GROUP_LEAD;
+		atomic_set(&lead->grp_refs, cnt);
+		*nr += cnt;
+	} else {
+		lead->flags &= ~REQ_F_SQE_GROUP;
+	}
+
+	return lead_ret;
+}
+
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (req_is_group_lead(req)) {
+		io_complete_group_lead(req, issue_flags);
+		return;
+	}
+
 	/*
 	 * All execution paths but io-wq use the deferred completions by
 	 * passing IO_URING_F_COMPLETE_DEFER and thus should not end up here.
@@ -960,20 +1143,6 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	req_ref_put(req);
 }
 
-void io_req_defer_failed(struct io_kiocb *req, s32 res)
-	__must_hold(&ctx->uring_lock)
-{
-	const struct io_cold_def *def = &io_cold_defs[req->opcode];
-
-	lockdep_assert_held(&req->ctx->uring_lock);
-
-	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
-	if (def->fail)
-		def->fail(req);
-	io_req_complete_defer(req);
-}
-
 /*
  * Don't initialise the fields below on every allocation, but do that in
  * advance and keep them valid across allocations.
@@ -1459,7 +1628,8 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 }
 
 static inline void io_fill_cqe_lists(struct io_ring_ctx *ctx,
-				     struct io_wq_work_list *list)
+				     struct io_wq_work_list *list,
+				     struct io_wq_work_list *grp)
 {
 	struct io_wq_work_node *node;
 
@@ -1477,6 +1647,13 @@ static inline void io_fill_cqe_lists(struct io_ring_ctx *ctx,
 				io_req_cqe_overflow(req);
 			}
 		}
+
+		if (grp && req_is_group_member(req)) {
+			struct io_kiocb *lead = io_complete_group_member(req);
+
+			if (lead)
+				wq_list_add_head(&lead->comp_list, grp);
+		}
 	}
 }
 
@@ -1484,14 +1661,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
+	struct io_wq_work_list list = {NULL, NULL};
 
 	__io_cq_lock(ctx);
-	io_fill_cqe_lists(ctx, &state->compl_reqs);
+	io_fill_cqe_lists(ctx, &state->compl_reqs, &list);
+	if (!wq_list_empty(&list))
+		io_fill_cqe_lists(ctx, &list, NULL);
 	__io_cq_unlock_post(ctx);
 
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
+	if (!wq_list_empty(&state->compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
+		if (!wq_list_empty(&list))
+			io_free_batch_list(ctx, list.first);
 	}
 	ctx->submit_state.cq_flush = false;
 }
@@ -2212,6 +2394,8 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	*nr = 1;
 	ret = io_init_req(ctx, req, sqe);
+	if (req->flags & REQ_F_SQE_GROUP)
+		ret = io_init_req_group(ctx, req, nr, ret);
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 1eb65324792a..99eeb4eee219 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -104,6 +104,7 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
+void io_complete_group_lead(struct io_kiocb *req, unsigned int issue_flags);
 
 enum {
 	IO_EVENTFD_OP_SIGNAL_BIT,
@@ -113,6 +114,16 @@ enum {
 void io_eventfd_ops(struct rcu_head *rcu);
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
+static inline bool req_is_group_lead(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_SQE_GROUP_LEAD;
+}
+
+static inline bool req_is_group_member(struct io_kiocb *req)
+{
+	return !req_is_group_lead(req) && (req->flags & REQ_F_SQE_GROUP);
+}
+
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
 #if defined(CONFIG_PROVE_LOCKING)
@@ -355,7 +366,11 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+	if (unlikely(req_is_group_lead(req)))
+		io_complete_group_lead(req, IO_URING_F_COMPLETE_DEFER |
+				IO_URING_F_NONBLOCK);
+	else
+		wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
-- 
2.42.0


