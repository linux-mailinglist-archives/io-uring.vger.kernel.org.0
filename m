Return-Path: <io-uring+bounces-2452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC02392902D
	for <lists+io-uring@lfdr.de>; Sat,  6 Jul 2024 05:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7209D283274
	for <lists+io-uring@lfdr.de>; Sat,  6 Jul 2024 03:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D8AC8F6;
	Sat,  6 Jul 2024 03:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QCH8/R54"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A398C156
	for <io-uring@vger.kernel.org>; Sat,  6 Jul 2024 03:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720235440; cv=none; b=Hklx01TTrwMuhGdkaislLxNdqxhJToWmMFkhuHRkbXh3BZywfVaFFe6nbsFLHRvfn3/OwwU7OTbDWb/2nhSFzFDhURt/9sQdhD2vBwVvBeC6YvB16j++/TETNA+mfMptPeY4HpAvAkrbMEPxC67IhEqJTTdyYqFaoqW2E8kOLfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720235440; c=relaxed/simple;
	bh=kBaugSVfl3JUU5RBHZJoYjxHJEutFLmLBMvfSvGK7Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdNs2oKHmD6FHzdQcgtikzNce/hW65L9GkCei674D4Ua7QqNq84KoKooU94MNY1zwb8D6zoxjYZb3ZXeEmuH74HVX6jALREioBeBr/b1l233orrsZza1VP3r8V8Uv4Qqu6R8/Gts8eSx+TToou0tr72TxHAsG/hp1qXAi56XnVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QCH8/R54; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720235436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xoxMzhvoZJm16dvuFoPrlQMx7nutm8nZ4xy/+XVkUvE=;
	b=QCH8/R54HxsAqVKWaRs6QxvDMtnVL1evkhdJWTn0vDWFtjjxsw9kl+vKZvbFssczV2QebO
	JE4Ft9TkNmHh3LE6Kl+wo3RhN5Pi1jxLRmergQKmu2N4HrLwoVGgm02OLz5JMJWe0vsf/y
	FHtcQ78xQYxccO7oDMUIZid7GXpCcyo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-uvuiaMHLM2qWmLw5KTN2SQ-1; Fri,
 05 Jul 2024 23:10:32 -0400
X-MC-Unique: uvuiaMHLM2qWmLw5KTN2SQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44928195609E;
	Sat,  6 Jul 2024 03:10:31 +0000 (UTC)
Received: from localhost (unknown [10.72.112.32])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99FFA3000184;
	Sat,  6 Jul 2024 03:10:26 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH V4 4/8] io_uring: support SQE group
Date: Sat,  6 Jul 2024 11:09:54 +0800
Message-ID: <20240706031000.310430-5-ming.lei@redhat.com>
In-Reply-To: <20240706031000.310430-1-ming.lei@redhat.com>
References: <20240706031000.310430-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

One simple sqe group based copy example[1] shows that:
1) buffered copy:
- perf is improved by 5%

2) direct IO mode
- perf is improved by 27%

3) sqe group copy, which keeps QD not changed, just re-organize IOs in the
following ways:

- each group have 4 READ IOs, linked by one single write IO for writing
  the read data in sqe group to destination file

- the 1st 12 groups have (4 + 1) IOs, and the last group have (3 + 1)
  IOs

- test code:
	https://github.com/ming1/liburing/commits/sqe_group_v2/

Suggested-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h |  18 ++
 include/uapi/linux/io_uring.h  |   4 +
 io_uring/io_uring.c            | 304 ++++++++++++++++++++++++++++++---
 io_uring/io_uring.h            |  16 ++
 io_uring/timeout.c             |   2 +
 5 files changed, 324 insertions(+), 20 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ede42dce1506..b5cc3dee8fa2 100644
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
@@ -436,6 +438,7 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
+	REQ_F_SQE_GROUP_BIT	= IOSQE_SQE_GROUP_BIT,
 
 	/* first byte is taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 8,
@@ -467,6 +470,7 @@ enum {
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
+	REQ_F_SQE_GROUP_LEADER_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -490,6 +494,8 @@ enum {
 	REQ_F_BUFFER_SELECT	= IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		= IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
+	/* IOSQE_SQE_GROUP */
+	REQ_F_SQE_GROUP		= IO_REQ_FLAG(REQ_F_SQE_GROUP_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= IO_REQ_FLAG(REQ_F_FAIL_BIT),
@@ -547,6 +553,8 @@ enum {
 	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
 	/* buffer ring head needs incrementing on put */
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
+	/* sqe group lead */
+	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -652,6 +660,8 @@ struct io_kiocb {
 	void				*async_data;
 	/* linked requests, IFF REQ_F_HARDLINK or REQ_F_LINK are set */
 	atomic_t			poll_refs;
+	/* reference for group leader requests */
+	int				grp_refs;
 	struct io_kiocb			*link;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
@@ -661,6 +671,14 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+
+	union {
+		/* links all group members for leader */
+		struct io_kiocb			*grp_link;
+
+		/* points to group leader for member */
+		struct io_kiocb			*grp_leader;
+	};
 };
 
 struct io_overflow_cqe {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2aaf7ee256ac..e6d321b3add7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -124,6 +124,7 @@ enum io_uring_sqe_flags_bit {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_SQE_GROUP_BIT,
 };
 
 /*
@@ -143,6 +144,8 @@ enum io_uring_sqe_flags_bit {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/* defines sqe group */
+#define IOSQE_SQE_GROUP		(1U << IOSQE_SQE_GROUP_BIT)
 
 /*
  * io_uring_setup() flags
@@ -542,6 +545,7 @@ struct io_uring_params {
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
+#define IORING_FEAT_SQE_GROUP		(1U << 15)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7597344a6440..b5415f0774e5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -111,14 +111,15 @@
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
-			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
+			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
+			IOSQE_SQE_GROUP)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
 				REQ_F_ASYNC_DATA)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
-				 IO_REQ_CLEAN_FLAGS)
+				 REQ_F_SQE_GROUP | IO_REQ_CLEAN_FLAGS)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -421,6 +422,10 @@ static inline void io_req_track_inflight(struct io_kiocb *req)
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
 		atomic_inc(&req->task->io_uring->inflight_tracked);
+
+		/* make members' REQ_F_INFLIGHT discoverable via leader's */
+		if (req_is_group_member(req))
+			io_req_track_inflight(req->grp_leader);
 	}
 }
 
@@ -875,6 +880,117 @@ static __always_inline void io_req_commit_cqe(struct io_ring_ctx *ctx,
 	}
 }
 
+static inline bool need_queue_group_members(io_req_flags_t flags)
+{
+	return flags & REQ_F_SQE_GROUP_LEADER;
+}
+
+/* Can only be called after this request is issued */
+static inline struct io_kiocb *get_group_leader(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_SQE_GROUP) {
+		if (req_is_group_leader(req))
+			return req;
+		return req->grp_leader;
+	}
+	return NULL;
+}
+
+void io_cancel_group_members(struct io_kiocb *req, bool ignore_cqes)
+{
+	struct io_kiocb *member = req->grp_link;
+
+	while (member) {
+		struct io_kiocb *next = member->grp_link;
+
+		if (ignore_cqes)
+			member->flags |= REQ_F_CQE_SKIP;
+		if (!(member->flags & REQ_F_FAIL)) {
+			req_set_fail(member);
+			io_req_set_res(member, -ECANCELED, 0);
+		}
+		member = next;
+	}
+}
+
+void io_queue_group_members(struct io_kiocb *req, bool async)
+{
+	struct io_kiocb *member = req->grp_link;
+
+	if (!member)
+		return;
+
+	req->grp_link = NULL;
+	while (member) {
+		struct io_kiocb *next = member->grp_link;
+
+		member->grp_leader = req;
+		if (async)
+			member->flags |= REQ_F_FORCE_ASYNC;
+
+		if (unlikely(member->flags & REQ_F_FAIL)) {
+			io_req_task_queue_fail(member, member->cqe.res);
+		} else if (member->flags & REQ_F_FORCE_ASYNC) {
+			io_req_task_queue(member);
+		} else {
+			io_queue_sqe(member);
+		}
+		member = next;
+	}
+}
+
+static inline bool __io_complete_group_req(struct io_kiocb *req,
+			     struct io_kiocb *lead)
+{
+	WARN_ON_ONCE(!(req->flags & REQ_F_SQE_GROUP));
+
+	if (WARN_ON_ONCE(lead->grp_refs <= 0))
+		return false;
+
+	/*
+	 * Set linked leader as failed if any member is failed, so
+	 * the remained link chain can be terminated
+	 */
+	if (unlikely((req->flags & REQ_F_FAIL) &&
+		     ((lead->flags & IO_REQ_LINK_FLAGS) && lead->link)))
+		req_set_fail(lead);
+	return !--lead->grp_refs;
+}
+
+/* Complete group request and collect completed leader for freeing */
+static void io_complete_group_req(struct io_kiocb *req,
+		struct io_wq_work_list *grp_list)
+{
+	struct io_kiocb *lead = get_group_leader(req);
+
+	if (__io_complete_group_req(req, lead)) {
+		req->flags &= ~REQ_F_SQE_GROUP;
+		lead->flags &= ~REQ_F_SQE_GROUP_LEADER;
+
+		if (!(lead->flags & REQ_F_CQE_SKIP))
+			io_req_commit_cqe(lead->ctx, lead);
+
+		if (req != lead) {
+			/*
+			 * Add leader to free list if it isn't there
+			 * otherwise clearing group flag for freeing it
+			 * in current batch
+			 */
+			if (!(lead->flags & REQ_F_SQE_GROUP))
+				wq_list_add_tail(&lead->comp_list, grp_list);
+			else
+				lead->flags &= ~REQ_F_SQE_GROUP;
+		}
+	} else if (req != lead) {
+		req->flags &= ~REQ_F_SQE_GROUP;
+	} else {
+		/*
+		 * Leader's group flag clearing is delayed until it is
+		 * removed from free list
+		 */
+	}
+}
+
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -897,7 +1013,7 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	}
 
 	io_cq_lock(ctx);
-	if (!(req->flags & REQ_F_CQE_SKIP)) {
+	if (!(req->flags & REQ_F_CQE_SKIP) && !req_is_group_leader(req)) {
 		if (!io_fill_cqe_req(ctx, req))
 			io_req_cqe_overflow(req);
 	}
@@ -974,16 +1090,22 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	return true;
 }
 
-__cold void io_free_req(struct io_kiocb *req)
+static void __io_free_req(struct io_kiocb *req, bool cqe_skip)
 {
 	/* refs were already put, restore them for io_req_task_complete() */
 	req->flags &= ~REQ_F_REFCOUNT;
 	/* we only want to free it, don't post CQEs */
-	req->flags |= REQ_F_CQE_SKIP;
+	if (cqe_skip)
+		req->flags |= REQ_F_CQE_SKIP;
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 }
 
+__cold void io_free_req(struct io_kiocb *req)
+{
+	__io_free_req(req, true);
+}
+
 static void __io_req_find_next_prep(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1388,6 +1510,17 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 						    comp_list);
 
 		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
+			/*
+			 * Group leader may be removed twice, don't free it
+			 * if group flag isn't cleared, when some members
+			 * aren't completed yet
+			 */
+			if (req->flags & REQ_F_SQE_GROUP) {
+				node = req->comp_list.next;
+				req->flags &= ~REQ_F_SQE_GROUP;
+				continue;
+			}
+
 			if (req->flags & REQ_F_REFCOUNT) {
 				node = req->comp_list.next;
 				if (!req_ref_put_and_test(req))
@@ -1420,6 +1553,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
+	struct io_wq_work_list grp_list = {NULL};
 	struct io_wq_work_node *node;
 
 	__io_cq_lock(ctx);
@@ -1427,11 +1561,22 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
-		if (!(req->flags & REQ_F_CQE_SKIP))
+		/*
+		 * For group leader, cqe has to be committed after all
+		 * members are committed, when the group leader flag is
+		 * cleared
+		 */
+		if (!(req->flags & REQ_F_CQE_SKIP) &&
+				likely(!req_is_group_leader(req)))
 			io_req_commit_cqe(ctx, req);
+		if (req->flags & REQ_F_SQE_GROUP)
+			io_complete_group_req(req, &grp_list);
 	}
 	__io_cq_unlock_post(ctx);
 
+	if (!wq_list_empty(&grp_list))
+		__wq_list_splice(&grp_list, state->compl_reqs.first);
+
 	if (!wq_list_empty(&state->compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
@@ -1638,8 +1783,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
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
 
@@ -1754,9 +1903,18 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	struct io_kiocb *nxt = NULL;
 
 	if (req_ref_put_and_test(req)) {
-		if (req->flags & IO_REQ_LINK_FLAGS)
-			nxt = io_req_find_next(req);
-		io_free_req(req);
+		/*
+		 * CQEs have been posted in io_req_complete_post() except
+		 * for group leader, and we can't advance the link for
+		 * group leader until its CQE is posted.
+		 */
+		if (!req_is_group_leader(req)) {
+			if (req->flags & IO_REQ_LINK_FLAGS)
+				nxt = io_req_find_next(req);
+			io_free_req(req);
+		} else {
+			__io_free_req(req, false);
+		}
 	}
 	return nxt ? &nxt->work : NULL;
 }
@@ -1821,6 +1979,8 @@ void io_wq_submit_work(struct io_wq_work *work)
 		}
 	}
 
+	if (need_queue_group_members(req->flags))
+		io_queue_group_members(req, true);
 	do {
 		ret = io_issue_sqe(req, issue_flags);
 		if (ret != -EAGAIN)
@@ -1932,9 +2092,17 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
+	 *
+	 * Request is always freed after returning from io_queue_sqe(), so
+	 * it is fine to check its flags after it is issued
+	 *
+	 * For group leader, members holds leader references, so it is safe
+	 * to touch the leader after leader is issued
 	 */
 	if (unlikely(ret))
 		io_queue_async(req, ret);
+	else if (need_queue_group_members(req->flags))
+		io_queue_group_members(req, false);
 }
 
 static void io_queue_sqe_fallback(struct io_kiocb *req)
@@ -2101,6 +2269,56 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
+	if (lead && (lead->flags & IO_REQ_LINK_FLAGS) && !(lead->flags & REQ_F_FAIL))
+		req_fail_link_node(lead, -ECANCELED);
+
+	return io_group_sqe(link, req);
+}
+
 static __cold int io_submit_fail_link(struct io_submit_link *link,
 				      struct io_kiocb *req, int ret)
 {
@@ -2139,11 +2357,18 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
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
@@ -2187,11 +2412,28 @@ static struct io_kiocb *io_link_sqe(struct io_submit_link *link,
 	return req;
 }
 
+static inline bool io_group_assembling(const struct io_submit_state *state,
+				       const struct io_kiocb *req)
+{
+	if (state->group.head || req->flags & REQ_F_SQE_GROUP)
+		return true;
+	return false;
+}
+
+static inline bool io_link_assembling(const struct io_submit_state *state,
+				      const struct io_kiocb *req)
+{
+	if (state->link.head || (req->flags & (IO_REQ_LINK_FLAGS |
+				 REQ_F_FORCE_ASYNC | REQ_F_FAIL)))
+		return true;
+	return false;
+}
+
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_submit_link *link = &ctx->submit_state.link;
+	struct io_submit_state *state = &ctx->submit_state;
 	int ret;
 
 	ret = io_init_req(ctx, req, sqe);
@@ -2200,11 +2442,18 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	trace_io_uring_submit_req(req);
 
-	if (unlikely(link->head || (req->flags & (IO_REQ_LINK_FLAGS |
-				    REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
-		req = io_link_sqe(link, req);
-		if (!req)
-			return 0;
+	if (unlikely(io_link_assembling(state, req) ||
+		     io_group_assembling(state, req))) {
+		if (io_group_assembling(state, req)) {
+			req = io_group_sqe(&state->group, req);
+			if (!req)
+				return 0;
+		}
+		if (io_link_assembling(state, req)) {
+			req = io_link_sqe(&state->link, req);
+			if (!req)
+				return 0;
+		}
 	}
 	io_queue_sqe(req);
 	return 0;
@@ -2217,8 +2466,22 @@ static void io_submit_state_end(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
-	if (unlikely(state->link.head))
-		io_queue_sqe_fallback(state->link.head);
+	if (unlikely(state->group.head || state->link.head)) {
+		/* the last member must set REQ_F_SQE_GROUP */
+		if (state->group.head) {
+			struct io_kiocb *lead = state->group.head;
+
+			state->group.last->grp_link = NULL;
+			if (lead->flags & IO_REQ_LINK_FLAGS)
+				io_link_sqe(&state->link, lead);
+			else
+				io_queue_sqe_fallback(lead);
+		}
+
+		if (unlikely(state->link.head))
+			io_queue_sqe_fallback(state->link.head);
+	}
+
 	/* flush only after queuing links as they can generate completions */
 	io_submit_flush_completions(ctx);
 	if (state->plug_started)
@@ -2236,6 +2499,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 	state->submit_nr = max_ios;
 	/* set only head, no need to init link_last in advance */
 	state->link.head = NULL;
+	state->group.head = NULL;
 }
 
 static void io_commit_sqring(struct io_ring_ctx *ctx)
@@ -3559,7 +3823,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_SQE_GROUP;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e1ce908f0679..8cc347959f7e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -68,6 +68,8 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
+void io_queue_group_members(struct io_kiocb *req, bool async);
+void io_cancel_group_members(struct io_kiocb *req, bool ignore_cqes);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
@@ -339,6 +341,16 @@ static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
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
@@ -352,6 +364,10 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+
+	/* members may not be issued when leader is completed */
+	if (unlikely(req_is_group_leader(req) && req->grp_link))
+		io_queue_group_members(req, false);
 }
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 1c9bf07499b1..4e5eaf4054c3 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -168,6 +168,8 @@ static void io_fail_links(struct io_kiocb *req)
 			link->flags |= REQ_F_CQE_SKIP;
 		else
 			link->flags &= ~REQ_F_CQE_SKIP;
+		if (req_is_group_leader(link))
+			io_cancel_group_members(link, ignore_cqes);
 		trace_io_uring_fail_link(req, link);
 		link = link->link;
 	}
-- 
2.42.0


