Return-Path: <io-uring+bounces-12676-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKp8LtV3tWln0wAAu9opvQ
	(envelope-from <io-uring+bounces-12676-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 15:59:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 314EC28D95A
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 15:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 74B703021D2A
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 14:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9E437B012;
	Sat, 14 Mar 2026 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AnV83Nye"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF7C261B71
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773500369; cv=none; b=Gu91PmtiV32y+328+Cd22AsMfMO4iYW61exw6ESYs+xoaXJKmgj4xLd94vMbFOVwDuSXyZZDDmzLpQUb55IyecLje4UtNtspQ+k+KcBkBAuEGvvufMeXgTTqx94T9VKN43GBja45+sUdfl18YpyG6KWRdP4sQ9CCjdr7Np9w//w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773500369; c=relaxed/simple;
	bh=njUlRjnmM+ENCtJ+Ue27eLmCkyhkE0oewqXquPLhgJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngGzMuJJg0IM6Q2+aC490ZLDIyhsGV6P0bZxEIdxT7qVDUgUhQMTO6bniPCEKFgUiju+E3MIwr3FgGckTjnEzZaE/UVnNMAuvCEdlYS/2NxLIzAsMeoQU8uvhurfjT7KDUMZlLUu1fPxV+Eg0b++V59DRyjSzjfyFFdHQx/Lxvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AnV83Nye; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-679b072ed3aso1606629eaf.1
        for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 07:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773500366; x=1774105166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bT+spBNm3ciD7udYKNENwLHg+9PMOcZS7GnJs94R+x8=;
        b=AnV83NyeZMCSij92YnKvw5Vn6evvhJFirXJk1pB5aij7IYGCdMkEvztybZ29/vG6Kl
         TXoWbZlIuQ/pNGVg1BVrB8X+TCQdzA/jGqsH9HRJvEjRZBNBv+Iy8C0vGOTn4nG89Pm2
         xvFiQ/ZED4UjXRbPvdpYQIE8Tg9R3/WRVY+j3KIDqmWn9vBt0B1BevVnYcvT97omlofm
         6kHJnCbkFOiTWxNs8CBruph13yWUgR58jlCdvJjtzqtN6KAauXgFTWPwwTK1eNOnj+F2
         L27ulyJfI1fp59ZVRcZwSw8stAlrXfvl0UYqASKpb2ozXa6wCgb9IXO+ND6MeU+OZecQ
         1cXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773500366; x=1774105166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bT+spBNm3ciD7udYKNENwLHg+9PMOcZS7GnJs94R+x8=;
        b=szOIEeUYfni8JB1NPWJ9seel6Fz6DddMFgCwT18cyFZcyD44sTsUG46e7UnmFVSoqw
         s09fR4IAb6XLBEe2fiHJNmp1StfHnHLyRicUL9JthCxQkllT/0meVTC6FwvDlbje/JIG
         JfccIraEWVeYipieyeyBHN0GfO4pstNh+GnKYUmsf+moyFHDaygQoYm3O+C6Iauko+6/
         9+cMYuzLgdervZMWbQww9WMgAf3Q39q/Ohp5AbcRNzdpvyWBJwotDCxbEopyzW7Jd7RN
         lNzTuz7CJSiVhp1xQWvGaVHfNS2wnOwVFKfLfTTt7KjxxubDogLFoY17Nj8Q1fCHs3zV
         +3+Q==
X-Gm-Message-State: AOJu0Yz3U20nOAsiGMtby2JLm1wu2q17wBwk9hwvzjpdvY1brpWPlVWM
	o/zV6LyOyBGdAwilMDE7fRRo044WujR1gNacvvie/dMi8vZ57xBYBcMhueDcyBA26y2Wbidx5v/
	HYxHewxo=
X-Gm-Gg: ATEYQzx/mmzHmtddMLbWLyXheKyCPcR7qgHAuLrT2N2aMLkreo8QJKMuTgPQmkFZ5+q
	tVgier1SM+r8ErQ4S62iqOQ3nVuKdR9NCTp19/D3rINhZNKLIXSke4heV24jTtizo75zW9aw9yq
	CAXOJCLWoNikORAnl/z6+0z6V6ttx1JZ8cMyZkPfcsy2iElqXf8F4GynyQXQK1G1hGivGMEfyFs
	4o/pFgMPt/QvSl9Kb1cE+vwr79imx4cSIvAb/RhBH5KZpj+cIWwnb8/Jp0b8h3scbGzWTsXn47J
	01xnnEJxo/cjXTiho0iPeUvZ7ZskL4TFz054WiWUbz+P75ROD8WwxTg+q6PhJ4jbxJmpvl2eFGa
	Baj6UBJw5s43ziFkbgKs165shJ8cn7uEqkRUmywe3GF7prGPwgVWRQ7EQ9gKF4o8JkhPF6eJrer
	7lBPWfObtuKuZi9/euUHBRoytijE6SDk7WEQGsknNq1aH6XPHJDK1it1BhsQ84sydJsTQi
X-Received: by 2002:a05:6820:f009:b0:67b:b790:f5d6 with SMTP id 006d021491bc7-67bda991fbdmr4314781eaf.15.1773500366078;
        Sat, 14 Mar 2026 07:59:26 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc93065e7sm7303137eaf.9.2026.03.14.07.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 07:59:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: switch struct io_ring_ctx internal bitfields to flags
Date: Sat, 14 Mar 2026 08:58:05 -0600
Message-ID: <20260314145920.86796-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260314145920.86796-1-axboe@kernel.dk>
References: <20260314145920.86796-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12676-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 314EC28D95A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Bitfields cannot be set and checked atomically, and this makes it more
clear that these are indeed in shared storage and must be checked and
set in a sane fashion. This is in preparation for annotating a few of
the known racy, but harmless, flags checking.

No intended functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 32 +++++++------
 io_uring/eventfd.c             |  4 +-
 io_uring/io_uring.c            | 82 +++++++++++++++++-----------------
 io_uring/io_uring.h            |  9 ++--
 io_uring/msg_ring.c            |  2 +-
 io_uring/register.c            |  8 ++--
 io_uring/rsrc.c                |  8 ++--
 io_uring/tctx.c                |  2 +-
 io_uring/timeout.c             |  4 +-
 io_uring/tw.c                  |  2 +-
 10 files changed, 80 insertions(+), 73 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dd1420bfcb73..b84576374c7b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -268,24 +268,28 @@ struct io_alloc_cache {
 	unsigned int		init_clear;
 };
 
+enum {
+	IO_RING_F_DRAIN_NEXT		= BIT(0),
+	IO_RING_F_OP_RESTRICTED		= BIT(1),
+	IO_RING_F_REG_RESTRICTED	= BIT(2),
+	IO_RING_F_OFF_TIMEOUT_USED	= BIT(3),
+	IO_RING_F_DRAIN_ACTIVE		= BIT(4),
+	IO_RING_F_HAS_EVFD		= BIT(5),
+	/* all CQEs should be posted only by the submitter task */
+	IO_RING_F_TASK_COMPLETE		= BIT(6),
+	IO_RING_F_LOCKLESS_CQ		= BIT(7),
+	IO_RING_F_SYSCALL_IOPOLL	= BIT(8),
+	IO_RING_F_POLL_ACTIVATED	= BIT(9),
+	IO_RING_F_DRAIN_DISABLED	= BIT(10),
+	IO_RING_F_COMPAT		= BIT(11),
+	IO_RING_F_IOWQ_LIMITS_SET	= BIT(12),
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
 		unsigned int		flags;
-		unsigned int		drain_next: 1;
-		unsigned int		op_restricted: 1;
-		unsigned int		reg_restricted: 1;
-		unsigned int		off_timeout_used: 1;
-		unsigned int		drain_active: 1;
-		unsigned int		has_evfd: 1;
-		/* all CQEs should be posted only by the submitter task */
-		unsigned int		task_complete: 1;
-		unsigned int		lockless_cq: 1;
-		unsigned int		syscall_iopoll: 1;
-		unsigned int		poll_activated: 1;
-		unsigned int		drain_disabled: 1;
-		unsigned int		compat: 1;
-		unsigned int		iowq_limits_set : 1;
+		unsigned int		int_flags;
 
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 7482a7dc6b38..3da028500f76 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -148,7 +148,7 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	spin_unlock(&ctx->completion_lock);
 
 	ev_fd->eventfd_async = eventfd_async;
-	ctx->has_evfd = true;
+	ctx->int_flags |= IO_RING_F_HAS_EVFD;
 	refcount_set(&ev_fd->refs, 1);
 	atomic_set(&ev_fd->ops, 0);
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
@@ -162,7 +162,7 @@ int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
 					lockdep_is_held(&ctx->uring_lock));
 	if (ev_fd) {
-		ctx->has_evfd = false;
+		ctx->int_flags &= ~IO_RING_F_HAS_EVFD;
 		rcu_assign_pointer(ctx->io_ev_fd, NULL);
 		io_eventfd_put(ev_fd);
 		return 0;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a37035e76c0..bfeb3bc3849d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -477,17 +477,17 @@ static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	if (ctx->poll_activated)
+	if (ctx->int_flags & IO_RING_F_POLL_ACTIVATED)
 		io_poll_wq_wake(ctx);
-	if (ctx->off_timeout_used)
+	if (ctx->int_flags & IO_RING_F_OFF_TIMEOUT_USED)
 		io_flush_timeouts(ctx);
-	if (ctx->has_evfd)
+	if (ctx->int_flags & IO_RING_F_HAS_EVFD)
 		io_eventfd_signal(ctx, true);
 }
 
 static inline void __io_cq_lock(struct io_ring_ctx *ctx)
 {
-	if (!ctx->lockless_cq)
+	if (!(ctx->int_flags & IO_RING_F_LOCKLESS_CQ))
 		spin_lock(&ctx->completion_lock);
 }
 
@@ -500,11 +500,11 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
-	if (!ctx->task_complete) {
-		if (!ctx->lockless_cq)
+	if (!(ctx->int_flags & IO_RING_F_TASK_COMPLETE)) {
+		if (!(ctx->int_flags & IO_RING_F_LOCKLESS_CQ))
 			spin_unlock(&ctx->completion_lock);
 		/* IOPOLL rings only need to wake up if it's also SQPOLL */
-		if (!ctx->syscall_iopoll)
+		if (!(ctx->int_flags & IO_RING_F_SYSCALL_IOPOLL))
 			io_cqring_wake(ctx);
 	}
 	io_commit_cqring_flush(ctx);
@@ -830,7 +830,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	lockdep_assert_held(&ctx->uring_lock);
-	lockdep_assert(ctx->lockless_cq);
+	lockdep_assert(ctx->int_flags & IO_RING_F_LOCKLESS_CQ);
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
@@ -860,7 +860,7 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (!ctx->lockless_cq) {
+	if (!(ctx->int_flags & IO_RING_F_LOCKLESS_CQ)) {
 		spin_lock(&ctx->completion_lock);
 		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
 		spin_unlock(&ctx->completion_lock);
@@ -885,7 +885,7 @@ bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe cqe[2])
 	lockdep_assert_held(&ctx->uring_lock);
 
 	cqe[0].user_data = req->cqe.user_data;
-	if (!ctx->lockless_cq) {
+	if (!(ctx->int_flags & IO_RING_F_LOCKLESS_CQ)) {
 		spin_lock(&ctx->completion_lock);
 		posted = io_fill_cqe_aux32(ctx, cqe);
 		spin_unlock(&ctx->completion_lock);
@@ -913,7 +913,7 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
 	 * the submitter task context, IOPOLL protects with uring_lock.
 	 */
-	if (ctx->lockless_cq || (req->flags & REQ_F_REISSUE)) {
+	if ((ctx->int_flags & IO_RING_F_LOCKLESS_CQ) || (req->flags & REQ_F_REISSUE)) {
 defer_complete:
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
@@ -1135,7 +1135,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		 */
 		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			if (ctx->lockless_cq)
+			if (ctx->int_flags & IO_RING_F_LOCKLESS_CQ)
 				io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
 			else
 				io_cqe_overflow_locked(ctx, &req->cqe, &req->big_cqe);
@@ -1148,7 +1148,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
 
-	if (unlikely(ctx->drain_active))
+	if (unlikely(ctx->int_flags & IO_RING_F_DRAIN_ACTIVE))
 		io_queue_deferred(ctx);
 
 	ctx->submit_state.cq_flush = false;
@@ -1344,7 +1344,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	list_add_tail(&de->list, &ctx->defer_list);
 	io_queue_deferred(ctx);
 	if (!drain && list_empty(&ctx->defer_list))
-		ctx->drain_active = false;
+		ctx->int_flags &= ~IO_RING_F_DRAIN_ACTIVE;
 }
 
 static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
@@ -1655,7 +1655,7 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 	} else {
 		/* can't fail with IO_URING_F_INLINE */
 		io_req_sqe_copy(req, IO_URING_F_INLINE);
-		if (unlikely(req->ctx->drain_active))
+		if (unlikely(req->ctx->int_flags & IO_RING_F_DRAIN_ACTIVE))
 			io_drain_req(req);
 		else
 			io_queue_iowq(req);
@@ -1671,7 +1671,7 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 					struct io_kiocb *req,
 					unsigned int sqe_flags)
 {
-	if (!ctx->op_restricted)
+	if (!(ctx->int_flags & IO_RING_F_OP_RESTRICTED))
 		return true;
 	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
 		return false;
@@ -1691,7 +1691,7 @@ static void io_init_drain(struct io_ring_ctx *ctx)
 {
 	struct io_kiocb *head = ctx->submit_state.link.head;
 
-	ctx->drain_active = true;
+	ctx->int_flags |= IO_RING_F_DRAIN_ACTIVE;
 	if (head) {
 		/*
 		 * If we need to drain a request in the middle of a link, drain
@@ -1701,7 +1701,7 @@ static void io_init_drain(struct io_ring_ctx *ctx)
 		 * link.
 		 */
 		head->flags |= REQ_F_IO_DRAIN | REQ_F_FORCE_ASYNC;
-		ctx->drain_next = true;
+		ctx->int_flags |= IO_RING_F_DRAIN_NEXT;
 	}
 }
 
@@ -1767,23 +1767,23 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			req->buf_index = READ_ONCE(sqe->buf_group);
 		}
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
-			ctx->drain_disabled = true;
+			ctx->int_flags |= IO_RING_F_DRAIN_DISABLED;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
-			if (ctx->drain_disabled)
+			if (ctx->int_flags & IO_RING_F_DRAIN_DISABLED)
 				return io_init_fail_req(req, -EOPNOTSUPP);
 			io_init_drain(ctx);
 		}
 	}
-	if (unlikely(ctx->op_restricted || ctx->drain_active || ctx->drain_next)) {
+	if (unlikely(ctx->int_flags & (IO_RING_F_OP_RESTRICTED | IO_RING_F_DRAIN_ACTIVE | IO_RING_F_DRAIN_NEXT))) {
 		if (!io_check_restriction(ctx, req, sqe_flags))
 			return io_init_fail_req(req, -EACCES);
 		/* knock it to the slow queue path, will be drained there */
-		if (ctx->drain_active)
+		if (ctx->int_flags & IO_RING_F_DRAIN_ACTIVE)
 			req->flags |= REQ_F_FORCE_ASYNC;
 		/* if there is no link, we're at "next" request and need to drain */
-		if (unlikely(ctx->drain_next) && !ctx->submit_state.link.head) {
-			ctx->drain_next = false;
-			ctx->drain_active = true;
+		if (unlikely(ctx->int_flags & IO_RING_F_DRAIN_NEXT) && !ctx->submit_state.link.head) {
+			ctx->int_flags &= ~IO_RING_F_DRAIN_NEXT;
+			ctx->int_flags |= IO_RING_F_DRAIN_ACTIVE;
 			req->flags |= REQ_F_IO_DRAIN | REQ_F_FORCE_ASYNC;
 		}
 	}
@@ -2204,7 +2204,7 @@ static __cold void io_activate_pollwq_cb(struct callback_head *cb)
 					       poll_wq_task_work);
 
 	mutex_lock(&ctx->uring_lock);
-	ctx->poll_activated = true;
+	ctx->int_flags |= IO_RING_F_POLL_ACTIVATED;
 	mutex_unlock(&ctx->uring_lock);
 
 	/*
@@ -2219,9 +2219,9 @@ __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
 {
 	spin_lock(&ctx->completion_lock);
 	/* already activated or in progress */
-	if (ctx->poll_activated || ctx->poll_wq_task_work.func)
+	if ((ctx->int_flags & IO_RING_F_POLL_ACTIVATED) || ctx->poll_wq_task_work.func)
 		goto out;
-	if (WARN_ON_ONCE(!ctx->task_complete))
+	if (WARN_ON_ONCE(!(ctx->int_flags & IO_RING_F_TASK_COMPLETE)))
 		goto out;
 	if (!ctx->submitter_task)
 		goto out;
@@ -2242,7 +2242,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	struct io_ring_ctx *ctx = file->private_data;
 	__poll_t mask = 0;
 
-	if (unlikely(!ctx->poll_activated))
+	if (unlikely(!(ctx->int_flags & IO_RING_F_POLL_ACTIVATED)))
 		io_activate_pollwq(ctx);
 	/*
 	 * provides mb() which pairs with barrier from wq_has_sleeper
@@ -2607,7 +2607,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			goto out;
 		}
 		if (flags & IORING_ENTER_GETEVENTS) {
-			if (ctx->syscall_iopoll)
+			if (ctx->int_flags & IO_RING_F_SYSCALL_IOPOLL)
 				goto iopoll_locked;
 			/*
 			 * Ignore errors, we'll soon call io_cqring_wait() and
@@ -2622,7 +2622,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (flags & IORING_ENTER_GETEVENTS) {
 		int ret2;
 
-		if (ctx->syscall_iopoll) {
+		if (ctx->int_flags & IO_RING_F_SYSCALL_IOPOLL) {
 			/*
 			 * We disallow the app entering submit/complete with
 			 * polling, but we still need to lock the ring to
@@ -2923,9 +2923,9 @@ static void io_ctx_restriction_clone(struct io_ring_ctx *ctx,
 	if (dst->bpf_filters)
 		WRITE_ONCE(ctx->bpf_filters, dst->bpf_filters->filters);
 	if (dst->op_registered)
-		ctx->op_restricted = 1;
+		ctx->int_flags |= IO_RING_F_OP_RESTRICTED;
 	if (dst->reg_registered)
-		ctx->reg_restricted = 1;
+		ctx->int_flags |= IO_RING_F_REG_RESTRICTED;
 }
 
 static __cold int io_uring_create(struct io_ctx_config *config)
@@ -2952,17 +2952,18 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL))
-		ctx->task_complete = true;
+		ctx->int_flags |= IO_RING_F_TASK_COMPLETE;
 
-	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL))
-		ctx->lockless_cq = true;
+	if ((ctx->int_flags & IO_RING_F_TASK_COMPLETE) ||
+	    (ctx->flags & IORING_SETUP_IOPOLL))
+		ctx->int_flags |= IO_RING_F_LOCKLESS_CQ;
 
 	/*
 	 * lazy poll_wq activation relies on ->task_complete for synchronisation
 	 * purposes, see io_activate_pollwq()
 	 */
-	if (!ctx->task_complete)
-		ctx->poll_activated = true;
+	if (!(ctx->int_flags & IO_RING_F_TASK_COMPLETE))
+		ctx->int_flags |= IO_RING_F_POLL_ACTIVATED;
 
 	/*
 	 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
@@ -2972,9 +2973,10 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	 */
 	if (ctx->flags & IORING_SETUP_IOPOLL &&
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
-		ctx->syscall_iopoll = 1;
+		ctx->int_flags |= IO_RING_F_SYSCALL_IOPOLL;
 
-	ctx->compat = in_compat_syscall();
+	if (in_compat_syscall())
+		ctx->int_flags |= IO_RING_F_COMPAT;
 	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
 		ctx->user = get_uid(current_user());
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0fa844faf287..5cb1983043cd 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -211,7 +211,7 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		lockdep_assert_held(&ctx->uring_lock);
-	} else if (!ctx->task_complete) {
+	} else if (!(ctx->int_flags & IO_RING_F_TASK_COMPLETE)) {
 		lockdep_assert_held(&ctx->completion_lock);
 	} else if (ctx->submitter_task) {
 		/*
@@ -228,7 +228,7 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 
 static inline bool io_is_compat(struct io_ring_ctx *ctx)
 {
-	return IS_ENABLED(CONFIG_COMPAT) && unlikely(ctx->compat);
+	return IS_ENABLED(CONFIG_COMPAT) && unlikely(ctx->int_flags & IO_RING_F_COMPAT);
 }
 
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -472,8 +472,9 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used ||
-		     ctx->has_evfd || ctx->poll_activated))
+	if (unlikely(ctx->int_flags & (IO_RING_F_OFF_TIMEOUT_USED |
+				       IO_RING_F_HAS_EVFD |
+				       IO_RING_F_POLL_ACTIVATED)))
 		__io_commit_cqring_flush(ctx);
 }
 
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 57ad0085869a..3ff9098573db 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -67,7 +67,7 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 
 static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 {
-	return target_ctx->task_complete;
+	return target_ctx->int_flags & IO_RING_F_TASK_COMPLETE;
 }
 
 static void io_msg_tw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
diff --git a/io_uring/register.c b/io_uring/register.c
index 0148735f7711..489a6feaf228 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -184,9 +184,9 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 		return ret;
 	}
 	if (ctx->restrictions.op_registered)
-		ctx->op_restricted = 1;
+		ctx->int_flags |= IO_RING_F_OP_RESTRICTED;
 	if (ctx->restrictions.reg_registered)
-		ctx->reg_restricted = 1;
+		ctx->int_flags |= IO_RING_F_REG_RESTRICTED;
 	return 0;
 }
 
@@ -384,7 +384,7 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	for (i = 0; i < ARRAY_SIZE(new_count); i++)
 		if (new_count[i])
 			ctx->iowq_limits[i] = new_count[i];
-	ctx->iowq_limits_set = true;
+	ctx->int_flags |= IO_RING_F_IOWQ_LIMITS_SET;
 
 	if (tctx && tctx->io_wq) {
 		ret = io_wq_max_workers(tctx->io_wq, new_count);
@@ -725,7 +725,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (ctx->submitter_task && ctx->submitter_task != current)
 		return -EEXIST;
 
-	if (ctx->reg_restricted && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
+	if ((ctx->int_flags & IO_RING_F_REG_RESTRICTED) && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4fa59bf89bba..52554ed89b11 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -295,7 +295,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		u64 tag = 0;
 
 		uvec = u64_to_user_ptr(user_data);
-		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
+		iov = iovec_from_user(uvec, 1, 1, &fast_iov, io_is_compat(ctx));
 		if (IS_ERR(iov)) {
 			err = PTR_ERR(iov);
 			break;
@@ -319,7 +319,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
 		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
 		ctx->buf_table.nodes[i] = node;
-		if (ctx->compat)
+		if (io_is_compat(ctx))
 			user_data += sizeof(struct compat_iovec);
 		else
 			user_data += sizeof(struct iovec);
@@ -883,12 +883,12 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 
 		if (arg) {
 			uvec = (struct iovec __user *) arg;
-			iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
+			iov = iovec_from_user(uvec, 1, 1, &fast_iov, io_is_compat(ctx));
 			if (IS_ERR(iov)) {
 				ret = PTR_ERR(iov);
 				break;
 			}
-			if (ctx->compat)
+			if (io_is_compat(ctx))
 				arg += sizeof(struct compat_iovec);
 			else
 				arg += sizeof(struct iovec);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 7cbcb82aedfb..143de8e990eb 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -121,7 +121,7 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 			return ret;
 
 		tctx = current->io_uring;
-		if (ctx->iowq_limits_set) {
+		if (ctx->int_flags & IO_RING_F_IOWQ_LIMITS_SET) {
 			unsigned int limits[2] = { ctx->iowq_limits[0],
 						   ctx->iowq_limits[1], };
 
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 8eddf8add7a2..579fdddac71a 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -566,8 +566,8 @@ static int __io_timeout_prep(struct io_kiocb *req,
 
 	INIT_LIST_HEAD(&timeout->list);
 	timeout->off = off;
-	if (unlikely(off && !req->ctx->off_timeout_used))
-		req->ctx->off_timeout_used = true;
+	if (unlikely(off && !(req->ctx->int_flags & IO_RING_F_OFF_TIMEOUT_USED)))
+		req->ctx->int_flags |= IO_RING_F_OFF_TIMEOUT_USED;
 	/*
 	 * for multishot reqs w/ fixed nr of repeats, repeats tracks the
 	 * remaining nr
diff --git a/io_uring/tw.c b/io_uring/tw.c
index 2f2b4ac4b126..022fe8753c19 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -222,7 +222,7 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 
 	if (!head) {
 		io_ctx_mark_taskrun(ctx);
-		if (ctx->has_evfd)
+		if (ctx->int_flags & IO_RING_F_HAS_EVFD)
 			io_eventfd_signal(ctx, false);
 	}
 
-- 
2.53.0


