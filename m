Return-Path: <io-uring+bounces-1788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B35148BD29D
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D60E71C2229C
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855A6156646;
	Mon,  6 May 2024 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PS2kVD2h"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABE6156659
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012621; cv=none; b=V8XvGWy4vPmUaO1hKMLuf62oVtJM7W136dMvS7pJm8RMjtoK9MlSUMx1ngJP9T3jrF6ihvcvbSSe+mdGhhc7o3+8fDyVESBXOUWy7dcqkay0qkaARY6TmqvnD0d7wKBRbmgOrf8h090XSGz84r09sATHyQ/tUIKHKrbNa8jXuwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012621; c=relaxed/simple;
	bh=n3ImcslGevXJpGXkohCFfTk6pfrsLeNid1gdc9wvR7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsIRt8PeNtjJHxxNMM6qW9CFs8n6wi6RS3kFQ5ZwsjWJvfvmLWxKM1LFEerrmucuuufhQc/ArdpdR61FSkqGMUlhkBnB9PZlsv0k4LKXgXkM2XddqCIz8hSbjmwCuxbi9/oz0hC0eaZ1WF3U1GSdeL673Rwl2t1bjSCS+0cVY/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PS2kVD2h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715012618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gzh62txXLkKIIkcnQGj0lmnbqzekGmSN/Sg+GG5eNdk=;
	b=PS2kVD2h7yE6MaEiM0JDsRciMDmMen5LGaUL7UCLc8b2XGm054nM55TT1eVDpIMGMmNgbC
	uCiHFBfxU0kzWJvF+MFFKJyecj3iY1aFZaTWknuVROUZE0AWJm9p8nhv/YVxtpigMc1MSn
	zQC+ys1HQxUA54O1pzJM/A3DGkmAd4Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-yXCnInHMM0CsVzUYQwuD9A-1; Mon, 06 May 2024 12:23:33 -0400
X-MC-Unique: yXCnInHMM0CsVzUYQwuD9A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06CB980017B;
	Mon,  6 May 2024 16:23:33 +0000 (UTC)
Received: from localhost (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B55D149102;
	Mon,  6 May 2024 16:23:31 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH V2 5/9] io_uring: support SQE group
Date: Tue,  7 May 2024 00:22:41 +0800
Message-ID: <20240506162251.3853781-6-ming.lei@redhat.com>
In-Reply-To: <20240506162251.3853781-1-ming.lei@redhat.com>
References: <20240506162251.3853781-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

SQE group is defined as one chain of SQEs starting with the first SQE that
has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
doesn't have it set, and it is similar with chain of linked SQEs.

Not like linked SQEs, each sqe is issued after the previous one is completed.
All SQEs in one group are submitted in parallel, so there isn't any dependency
among SQEs in one group.

The 1st SQE is group leader, and the other SQEs are group member. The whole
group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
the two flags are ignored for group members.

When the group is in one link chain, this group isn't submitted until the
previous SQE or group is completed. And the following SQE or group can't
be started if this group isn't completed. Failure from any group member will
fail the group leader, then the link chain can be terminated.

When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
group leader only, we respect IO_DRAIN by always completing group leader as
the last one in the group.

Working together with IOSQE_IO_LINK, SQE group provides flexible way to
support N:M dependency, such as:

- group A is chained with group B together
- group A has N SQEs
- group B has M SQEs

then M SQEs in group B depend on N SQEs in group A.

N:M dependency can support some interesting use cases in efficient way:

1) read from multiple files, then write the read data into single file

2) read from single file, and write the read data into multiple files

3) write same data into multiple files, and read data from multiple files and
compare if correct data is written

Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
extend sqe->flags with one uring context flag, such as use __pad3 for
non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.

Suggested-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |  12 ++
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/io_uring.c            | 246 +++++++++++++++++++++++++++++++--
 io_uring/io_uring.h            |  21 ++-
 4 files changed, 270 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7a6b190c7da7..62311b0f0e0b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -202,6 +202,8 @@ struct io_submit_state {
 	/* batch completion logic */
 	struct io_wq_work_list	compl_reqs;
 	struct io_submit_link	link;
+	/* points to current group */
+	struct io_submit_link	group;
 
 	bool			plug_started;
 	bool			need_plug;
@@ -442,6 +444,7 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
+	REQ_F_SQE_GROUP_BIT	= IOSQE_SQE_GROUP_BIT,
 
 	/* first byte is taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 8,
@@ -473,6 +476,7 @@ enum {
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
+	REQ_F_SQE_GROUP_LEADER_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -496,6 +500,8 @@ enum {
 	REQ_F_BUFFER_SELECT	= IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		= IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
+	/* IOSQE_SQE_GROUP */
+	REQ_F_SQE_GROUP		= IO_REQ_FLAG(REQ_F_SQE_GROUP_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= IO_REQ_FLAG(REQ_F_FAIL_BIT),
@@ -553,6 +559,8 @@ enum {
 	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
 	/* buffer ring head needs incrementing on put */
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
+	/* sqe group lead */
+	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -666,6 +674,10 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+
+	/* all SQE group members linked here for group lead */
+	struct io_kiocb			*grp_link;
+	int				grp_refs;
 };
 
 struct io_overflow_cqe {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f093cb2300d9..f3d74a920dfe 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -123,6 +123,7 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_SQE_GROUP_BIT,
 };
 
 /*
@@ -142,6 +143,8 @@ enum io_uring_sqe_flags_bit {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/* defines sqe group */
+#define IOSQE_SQE_GROUP		(1U << IOSQE_SQE_GROUP_BIT)
 
 /*
  * io_uring_setup() flags
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c184c9a312df..465f4244fa0b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -109,7 +109,8 @@
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
-			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
+			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
+			IOSQE_SQE_GROUP)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
@@ -915,6 +916,13 @@ static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/*
+	 * For group leader, cqe has to be committed after all members are
+	 * committed, when the request becomes normal one.
+	 */
+	if (unlikely(req_is_group_leader(req)))
+		return;
+
 	if (unlikely(!io_fill_cqe_req(ctx, req))) {
 		if (lockless_cq) {
 			spin_lock(&ctx->completion_lock);
@@ -926,6 +934,116 @@ static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
 	}
 }
 
+static inline bool need_queue_group_members(struct io_kiocb *req)
+{
+	return req_is_group_leader(req) && !!req->grp_link;
+}
+
+/* Can only be called after this request is issued */
+static inline struct io_kiocb *get_group_leader(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_SQE_GROUP) {
+		if (req_is_group_leader(req))
+			return req;
+		return req->grp_link;
+	}
+	return NULL;
+}
+
+/* called from io_req_defer_failed() only */
+static void io_fail_group_members(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
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
+		io_req_defer_failed(member, -ECANCELED);
+		member = next;
+	}
+	req->grp_link = NULL;
+}
+
+static void io_queue_group_members(struct io_kiocb *req, bool async)
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
+		trace_io_uring_submit_req(member);
+		if (async)
+			member->flags |= REQ_F_FORCE_ASYNC;
+		if (member->flags & REQ_F_FORCE_ASYNC)
+			io_req_task_queue(member);
+		else
+			io_queue_sqe(member);
+		member = next;
+	}
+	req->grp_link = NULL;
+}
+
+static void io_commit_group_cqe(struct io_kiocb *lead)
+{
+	lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
+	if (!(lead->flags & REQ_F_CQE_SKIP))
+		io_req_commit_cqe(lead, lead->ctx->lockless_cq);
+}
+
+bool __io_complete_group_req(struct io_kiocb *req,
+			     struct io_kiocb *lead)
+{
+	WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP));
+
+	if (WARN_ON_ONCE(lead->grp_refs <= 0))
+		return false;
+	if (req != lead) {
+		req->flags &= ~REQ_F_SQE_GROUP;
+		/*
+		 * Set linked leader as failed if any member is failed, so
+		 * the remained link chain can be terminated
+		 */
+		if (unlikely((req->flags & REQ_F_FAIL) &&
+			     (lead->flags & IO_REQ_LINK_FLAGS)))
+			req_set_fail(lead);
+	}
+	return !--lead->grp_refs;
+}
+
+/* Complete group request and collect completed leader for freeing */
+static inline void io_complete_group_req(struct io_kiocb *req,
+		struct io_wq_work_list *grp_list)
+{
+	/*
+	 * If the leader is in completion list, its refcount has been
+	 * dropped before adding to list, since we need to avoid to deal
+	 * with two same leaders when iterating completion list
+	 */
+	if (req->flags & REQ_F_SQE_GROUP_LEADER) {
+		io_commit_group_cqe(req);
+	} else {
+		struct io_kiocb *lead = get_group_leader(req);
+
+		/*
+		 * Now this group is done, post its CQE out, and collect
+		 * it just for release
+		 */
+		if (__io_complete_group_req(req, lead)) {
+			io_commit_group_cqe(lead);
+			wq_list_add_head(&lead->comp_list, grp_list);
+		}
+	}
+}
+
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -970,6 +1088,10 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
 	if (def->fail)
 		def->fail(req);
+
+	if (req_is_group_leader(req))
+		io_fail_group_members(req);
+
 	io_req_complete_defer(req);
 }
 
@@ -1459,6 +1581,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
+	struct io_wq_work_list grp_list = {NULL};
 	struct io_wq_work_node *node;
 
 	__io_cq_lock(ctx);
@@ -1468,9 +1591,15 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 		if (!(req->flags & REQ_F_CQE_SKIP))
 			io_req_commit_cqe(req, ctx->lockless_cq);
+
+		if (req->flags & REQ_F_SQE_GROUP)
+			io_complete_group_req(req, &grp_list);
 	}
 	__io_cq_unlock_post(ctx);
 
+	if (!wq_list_empty(&grp_list))
+		__wq_list_splice(&grp_list, state->compl_reqs.first);
+
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
@@ -1677,8 +1806,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
 	struct io_kiocb *cur;
 
 	/* need original cached_sq_head, but it was increased for each req */
-	io_for_each_link(cur, req)
-		seq--;
+	io_for_each_link(cur, req) {
+		if (req_is_group_leader(cur))
+			seq -= cur->grp_refs;
+		else
+			seq--;
+	}
 	return seq;
 }
 
@@ -1793,11 +1926,20 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	struct io_kiocb *nxt = NULL;
 
 	if (req_ref_put_and_test(req)) {
-		if (req->flags & IO_REQ_LINK_FLAGS)
-			nxt = io_req_find_next(req);
+		/*
+		 * CQEs have been posted in io_req_complete_post() except
+		 * for group leader, and we can't advance the link for
+		 * group leader until its CQE is posted.
+		 *
+		 * TODO: try to avoid defer and complete leader in io_wq
+		 * context directly
+		 */
+		if (!req_is_group_leader(req)) {
+			req->flags |= REQ_F_CQE_SKIP;
+			if (req->flags & IO_REQ_LINK_FLAGS)
+				nxt = io_req_find_next(req);
+		}
 
-		/* we have posted CQEs in io_req_complete_post() */
-		req->flags |= REQ_F_CQE_SKIP;
 		io_free_req(req);
 	}
 	return nxt ? &nxt->work : NULL;
@@ -1863,6 +2005,8 @@ void io_wq_submit_work(struct io_wq_work *work)
 		}
 	}
 
+	if (need_queue_group_members(req))
+		io_queue_group_members(req, true);
 	do {
 		ret = io_issue_sqe(req, issue_flags);
 		if (ret != -EAGAIN)
@@ -1977,6 +2121,9 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	 */
 	if (unlikely(ret))
 		io_queue_async(req, ret);
+
+	if (need_queue_group_members(req))
+		io_queue_group_members(req, false);
 }
 
 static void io_queue_sqe_fallback(struct io_kiocb *req)
@@ -2142,6 +2289,56 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return def->prep(req, sqe);
 }
 
+static struct io_kiocb *io_group_sqe(struct io_submit_link *group,
+				     struct io_kiocb *req)
+{
+	/*
+	 * Group chain is similar with link chain: starts with 1st sqe with
+	 * REQ_F_SQE_GROUP, and ends with the 1st sqe without REQ_F_SQE_GROUP
+	 */
+	if (group->head) {
+		struct io_kiocb *lead = group->head;
+
+		/* members can't be in link chain, can't be drained */
+		req->flags &= ~(IO_REQ_LINK_FLAGS | REQ_F_IO_DRAIN);
+		lead->grp_refs += 1;
+		group->last->grp_link = req;
+		group->last = req;
+
+		if (req->flags & REQ_F_SQE_GROUP)
+			return NULL;
+
+		req->grp_link = NULL;
+		req->flags |= REQ_F_SQE_GROUP;
+		group->head = NULL;
+		return lead;
+	} else if (req->flags & REQ_F_SQE_GROUP) {
+		group->head = req;
+		group->last = req;
+		req->grp_refs = 1;
+		req->flags |= REQ_F_SQE_GROUP_LEADER;
+		return NULL;
+	} else {
+		return req;
+	}
+}
+
+static __cold struct io_kiocb *io_submit_fail_group(
+		struct io_submit_link *link, struct io_kiocb *req)
+{
+	struct io_kiocb *lead = link->head;
+
+	/*
+	 * Instead of failing eagerly, continue assembling the group link
+	 * if applicable and mark the leader with REQ_F_FAIL. The group
+	 * flushing code should find the flag and handle the rest
+	 */
+	if (lead && !(lead->flags & REQ_F_FAIL))
+		req_fail_link_node(lead, -ECANCELED);
+
+	return io_group_sqe(link, req);
+}
+
 static __cold int io_submit_fail_link(struct io_submit_link *link,
 				      struct io_kiocb *req, int ret)
 {
@@ -2180,11 +2377,18 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_submit_link *link = &ctx->submit_state.link;
+	struct io_submit_link *group = &ctx->submit_state.group;
 
 	trace_io_uring_req_failed(sqe, req, ret);
 
 	req_fail_link_node(req, ret);
 
+	if (group->head || (req->flags & REQ_F_SQE_GROUP)) {
+		req = io_submit_fail_group(group, req);
+		if (!req)
+			return 0;
+	}
+
 	/* cover both linked and non-linked request */
 	return io_submit_fail_link(link, req, ret);
 }
@@ -2232,7 +2436,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_submit_link *link = &ctx->submit_state.link;
+	struct io_submit_state *state = &ctx->submit_state;
 	int ret;
 
 	ret = io_init_req(ctx, req, sqe);
@@ -2241,9 +2445,17 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	trace_io_uring_submit_req(req);
 
-	if (unlikely(link->head || (req->flags & (IO_REQ_LINK_FLAGS |
-				    REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
-		req = io_link_sqe(link, req);
+	if (unlikely(state->group.head ||
+		     (req->flags & REQ_F_SQE_GROUP))) {
+		req = io_group_sqe(&state->group, req);
+		if (!req)
+			return 0;
+	}
+
+	if (unlikely(state->link.head ||
+		     (req->flags & (IO_REQ_LINK_FLAGS | REQ_F_FORCE_ASYNC |
+				    REQ_F_FAIL)))) {
+		req = io_link_sqe(&state->link, req);
 		if (!req)
 			return 0;
 	}
@@ -2258,6 +2470,17 @@ static void io_submit_state_end(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
+	/* the last member must set REQ_F_SQE_GROUP */
+	if (unlikely(state->group.head)) {
+		struct io_kiocb *lead = state->group.head;
+
+		state->group.last->grp_link = NULL;
+		if (lead->flags & IO_REQ_LINK_FLAGS)
+			io_link_sqe(&state->link, lead);
+		else
+			io_queue_sqe_fallback(lead);
+	}
+
 	if (unlikely(state->link.head))
 		io_queue_sqe_fallback(state->link.head);
 	/* flush only after queuing links as they can generate completions */
@@ -2277,6 +2500,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 	state->submit_nr = max_ios;
 	/* set only head, no need to init link_last in advance */
 	state->link.head = NULL;
+	state->group.head = NULL;
 }
 
 static void io_commit_sqring(struct io_ring_ctx *ctx)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 624ca9076a50..416c14c6f050 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -67,6 +67,8 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
+bool __io_complete_group_req(struct io_kiocb *req,
+			     struct io_kiocb *lead);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
@@ -342,6 +344,16 @@ static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
+static inline bool req_is_group_leader(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_SQE_GROUP_LEADER;
+}
+
+static inline bool req_is_group_member(struct io_kiocb *req)
+{
+	return !req_is_group_leader(req) && (req->flags & REQ_F_SQE_GROUP);
+}
+
 /*
  * Don't complete immediately but use deferred completion infrastructure.
  * Protected by ->uring_lock and can only be used either with
@@ -354,7 +366,14 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+	/*
+	 * Group leader won't be added to ->compl_reqs until the whole
+	 * group is completed. Either it is added here or inserted after
+	 * the last member is completed.
+	 */
+	if (likely(!req_is_group_leader(req)) ||
+	    __io_complete_group_req(req, req))
+		wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
-- 
2.42.0


