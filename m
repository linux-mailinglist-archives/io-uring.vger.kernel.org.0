Return-Path: <io-uring+bounces-11377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE95CF59BD
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 22:06:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1275330CDCAE
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 21:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941082DF706;
	Mon,  5 Jan 2026 21:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HbuWoRsz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f228.google.com (mail-lj1-f228.google.com [209.85.208.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4B32DC782
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 21:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647155; cv=none; b=gHD4lMkYgRGrXhoHhcTGyfzRGGNQChpEIIK6nzwDQIiu/rsl+K2fjJmBptJpNfZIo6mTknjdv0RHLetqlJ+/ILu5OXurrRJbusS6JtdBpv6ILLpkcTBUEIGDkf4KQ8GHD53+0RspNs3+WeQ7uwVWz57lO5nfy1XCwPtuf0kLBgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647155; c=relaxed/simple;
	bh=viSjjzfK+LuCMgJk4GB2ln1Ib+FEY2Yal2i0Mc2zreo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPwMtoaAeaeKtpIZwisRtnlLduRqo8v8HtSA5qvkAElqz1UKsZV8NjuxFheRHKKkm0vngf68fCS3ogmLwsm6uKvLlWozei8HnrNcjWtrmi71oP8tJaQyEGsczV5GqTtYhx2J3qaWV3W7XfbuIWoKYsJJO85GS8id9u3TINVTvx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HbuWoRsz; arc=none smtp.client-ip=209.85.208.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lj1-f228.google.com with SMTP id 38308e7fff4ca-37feb5965ebso350651fa.3
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 13:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767647151; x=1768251951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwMUEMHMzWqjRsw9Dq1TO0aqVGzfagUbxeaLhQQuCYE=;
        b=HbuWoRszVnJvkyOC1DfO99GQ0fw4CPTt9p/VIFiF0usbnaIir61cxy7yI/tOI8O2JO
         ABXz/CDYr7UgOCWpJpxxJSF4jqaQs7De1zfjN/erafvoQcfZSq4VIA1wlPL61Yqdu1Am
         cHk1nUYwRvILTrd7SV5QYXiIs6SfL4rRmeaOol+WtWyCBw8r0Afq4q97o1tk2LPetqml
         magBshXSCrrSQE3M6OybOpS3EkRXYQo+m4MA1Yw7NZtWtrBnek+TlppDJq2eJuagPNMn
         FLCj3RKKnvcB1Wns9UmSypg4RXy1gDLS8dN3Xtzz6sGxzREInweKin1QL6kv4bls0AE3
         le+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647151; x=1768251951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hwMUEMHMzWqjRsw9Dq1TO0aqVGzfagUbxeaLhQQuCYE=;
        b=NyQnBPj5YuCXTvg5+miwu1D0ZILTRQpw211KDGroJ53wiP/qWbL71piZsT9Elo+P7N
         O59ZhX/Y7IdvJhxHxk0yDRD/zlLXEqkTtjE8CPs/w2zW1kLuSTIu/faHauifo8TI2Dt6
         g1QcXPdMw7UoqrFS6rfhvV3QxqRrp0tmcOFH1dcY3fdjsdZmFkHhvYgawf3mbo5MZad5
         lZNCdLIN7nQv5IRyzzXZdEjZfrorjfP1XgFETzNayPnnioi6nJPcy0IWixc+H2useqPR
         6IPCN8K2EWSvy8loDvuL9xnw9SY8BDIZlKHF2iEka/OFBZMem3SURlV+eOzTmOaUzQWn
         S7/Q==
X-Forwarded-Encrypted: i=1; AJvYcCW1jChF8uaJxzdnBZ2Ct1Z516AHGbiRNygr+QAJwQazrGB4u4g9hsO5fvG+vdVHQU5FRGDGk9Xayw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRKWzAlIiJyFGnvFCYlhqOW0c29Uv6lufhC2sg9W9RI2ZxCFkn
	GbJOo/9qaz8cN1gJyqw5YG7hL/s2brfDB9VoPUZySCqsJQJ1BESJifq8piK2SfKuvLCAISA/na1
	U9A/to+p7qav3pZm7gffiGTAOzKjut4jEAKqG
X-Gm-Gg: AY/fxX4d+wEB9+LI/3iSuVxwNIjkyu0Y2kMIZEujMUeiULiC1LTgfSiXysfuc+aWfaB
	oodU/0r3KrG/pUD7hMUkVSPJDIe8FN8IqR0z+BqhXo0JfFwwPOJHiPgmhV4vmggQGxu51X/b5yD
	s8ZuxNQV4JdHvMsTXMtNK+Vm0zmppeHO4wFJ14iBC0s1rguOPAbmBvHEtI3NJvSJ5s0xrmpjcue
	bIjeq07oA+oRsJKZnVW+Z5JHLbkmnHSKcHW2oLwLwmC/p8XpqKPbymIkGCgoTAIGpMUQoyQSwMS
	+kPct2RtY0uWcvgRfNuapLoMhEsOGiUwZzoAhiWy9OKXjlwXVYfIgFdnAPqR1FUhq8GzfADirl5
	TKrrmMtHkhmD0TZ8Otibph9eK08kMnYVtAWM8IzQLNw==
X-Google-Smtp-Source: AGHT+IHq9xfUdD56ExprIKveYN6ABXutsP6x2ol6BJKZfSOWzDgQrOrFr+EvNDNHvpDTb78tIl0MqfgDkOUQ
X-Received: by 2002:a05:6512:158b:b0:597:d7d6:eae1 with SMTP id 2adb3069b0e04-59b6527a359mr167691e87.2.1767647151230;
        Mon, 05 Jan 2026 13:05:51 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-59b65d91980sm22466e87.41.2026.01.05.13.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:05:51 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.49.34.222])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 5ECA5341BBA;
	Mon,  5 Jan 2026 14:05:49 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 5B270E41BCB; Mon,  5 Jan 2026 14:05:49 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v7 2/3] io_uring/msg_ring: drop unnecessary submitter_task checks
Date: Mon,  5 Jan 2026 14:05:41 -0700
Message-ID: <20260105210543.3471082-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260105210543.3471082-1-csander@purestorage.com>
References: <20260105210543.3471082-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__io_msg_ring_data() checks that the target_ctx isn't
IORING_SETUP_R_DISABLED before calling io_msg_data_remote(), which calls
io_msg_remote_post(). So submitter_task can't be modified concurrently
with the read in io_msg_remote_post(). Additionally, submitter_task must
exist, as io_msg_data_remote() is only called for io_msg_need_remote(),
i.e. task_complete is set, which requires IORING_SETUP_DEFER_TASKRUN,
which in turn requires IORING_SETUP_SINGLE_ISSUER. And submitter_task is
assigned in io_uring_create() or io_register_enable_rings() before
enabling any IORING_SETUP_SINGLE_ISSUER io_ring_ctx.
Similarly, io_msg_send_fd() checks IORING_SETUP_R_DISABLED and
io_msg_need_remote() before calling io_msg_fd_remote(). submitter_task
therefore can't be modified concurrently with the read in
io_msg_fd_remote() and must be non-null.
io_register_enable_rings() can't run concurrently because it's called
from io_uring_register() -> __io_uring_register() with uring_lock held.
Thus, replace the READ_ONCE() and WRITE_ONCE() of submitter_task with
plain loads and stores. And remove the NULL checks of submitter_task in
io_msg_remote_post() and io_msg_fd_remote().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c |  7 +------
 io_uring/msg_ring.c | 18 +++++-------------
 io_uring/register.c |  2 +-
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec27fafcb213..b31d88295297 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3663,17 +3663,12 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 		ret = -EFAULT;
 		goto err;
 	}
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
-	    && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
-		/*
-		 * Unlike io_register_enable_rings(), don't need WRITE_ONCE()
-		 * since ctx isn't yet accessible from other tasks
-		 */
+	    && !(ctx->flags & IORING_SETUP_R_DISABLED))
 		ctx->submitter_task = get_task_struct(current);
-	}
 
 	file = io_uring_get_file(ctx);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto err;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 87b4d306cf1b..57ad0085869a 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -78,26 +78,21 @@ static void io_msg_tw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
 	kfree_rcu(req, rcu_head);
 	percpu_ref_put(&ctx->refs);
 }
 
-static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
+static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			      int res, u32 cflags, u64 user_data)
 {
-	if (!READ_ONCE(ctx->submitter_task)) {
-		kfree_rcu(req, rcu_head);
-		return -EOWNERDEAD;
-	}
 	req->opcode = IORING_OP_NOP;
 	req->cqe.user_data = user_data;
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
 	req->ctx = ctx;
 	req->tctx = NULL;
 	req->io_task_work.func = io_msg_tw_complete;
 	io_req_task_work_add_remote(req, IOU_F_TWQ_LAZY_WAKE);
-	return 0;
 }
 
 static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
 			      struct io_msg *msg)
 {
@@ -109,12 +104,12 @@ static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
 		return -ENOMEM;
 
 	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
 		flags = msg->cqe_flags;
 
-	return io_msg_remote_post(target_ctx, target, msg->len, flags,
-					msg->user_data);
+	io_msg_remote_post(target_ctx, target, msg->len, flags, msg->user_data);
+	return 0;
 }
 
 static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 			      struct io_msg *msg, unsigned int issue_flags)
 {
@@ -125,11 +120,11 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 		return -EINVAL;
 	if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
 		return -EINVAL;
 	/*
 	 * Keep IORING_SETUP_R_DISABLED check before submitter_task load
-	 * in io_msg_data_remote() -> io_msg_remote_post()
+	 * in io_msg_data_remote() -> io_req_task_work_add_remote()
 	 */
 	if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
@@ -225,14 +220,11 @@ static void io_msg_tw_fd_complete(struct callback_head *head)
 
 static int io_msg_fd_remote(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct task_struct *task = READ_ONCE(ctx->submitter_task);
-
-	if (unlikely(!task))
-		return -EOWNERDEAD;
+	struct task_struct *task = ctx->submitter_task;
 
 	init_task_work(&msg->tw, io_msg_tw_fd_complete);
 	if (task_work_add(task, &msg->tw, TWA_SIGNAL))
 		return -EOWNERDEAD;
 
diff --git a/io_uring/register.c b/io_uring/register.c
index 12318c276068..8104728af294 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -179,11 +179,11 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
 		return -EBADFD;
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task) {
-		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
+		ctx->submitter_task = get_task_struct(current);
 		/*
 		 * Lazy activation attempts would fail if it was polled before
 		 * submitter_task is set.
 		 */
 		if (wq_has_sleeper(&ctx->poll_wq))
-- 
2.45.2


