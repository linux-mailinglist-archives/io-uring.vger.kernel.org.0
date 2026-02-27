Return-Path: <io-uring+bounces-12481-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SCf4M0QcomnzzQQAu9opvQ
	(envelope-from <io-uring+bounces-12481-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DB03A1BEBA8
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5896231402B8
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F1B47B425;
	Fri, 27 Feb 2026 22:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Wwd7h+dc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f230.google.com (mail-vk1-f230.google.com [209.85.221.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771FD478858
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231711; cv=none; b=irnx6WZAYnTIFUeddzsaa3/J7BWm0dGlDgQBjezVYjnzVBVinOwUE/tFGjTUt1WBjn7UzfmYBhCBYs7DMlExvGgkdKNbUiZzyOmNpSYADmkq17K1ENc5t9xX8UdQTzEp46ZljGS0ojN9TNNWCGgg0Nd+IYIA4o3n+HfgPpNQur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231711; c=relaxed/simple;
	bh=jitPk8dZO7gURW0hp4tgB7XQfWHqvV5p0qzZsigRrzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSMxoe+17U2wrIQpifnJsbA0GpZ7FtmbO9r0A29kUAB2TmWnhPl430wHgbu1NM8Ah/QDxgmEr5WbkiLTW4glMpU+JIclYJJJ+2mgCRtN3NdD9r0Zkh97zn0JQ7pFRHkLp8SgsNc0wHFFRiFZNL9BUYySpipXgzpyO2rq7WBeBPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Wwd7h+dc; arc=none smtp.client-ip=209.85.221.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-vk1-f230.google.com with SMTP id 71dfb90a1353d-5675c6dc64cso128603e0c.0
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772231708; x=1772836508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOsPp0sNuMqBvgksLLC7w2ENUHuNEhH517t3YeRJRmc=;
        b=Wwd7h+dcR3SndiU9NtECqJXQH7Ii2M2V8rpOQdeLln8zwaKKyUfTK0wy6fDvstLCcg
         lzjNaUglnhHRcCOpVYmeUqd7hc+DcLt/M88K1C4B6uexIsZ9izKApoyS65Yzz8Uv9d7l
         Vs/bjQeNqtDOGd5gsCMbJMCZs5AwR1b9OPCdpqbpveOTQ4U20V/tNVF3kGwRUwOCSq6k
         EQFsPOMNM89Hp8ypUWnQWHCKotm53BEY/qtNLh1Z9abAR3WKgGf85KOU6RLcnbsltLO4
         K7y7RLUsVM9tEr/mL+4tvb++UgZ3klYEVUGhewFe5H5gYFKQ0UU74ZonHYUOJUCblZ+s
         Fawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231708; x=1772836508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FOsPp0sNuMqBvgksLLC7w2ENUHuNEhH517t3YeRJRmc=;
        b=P52bCZCk5k5fhaE8vHrSvJEqy2dCLIWFAOey6Oykgk6q9qgDp4SR16TO4PUA/F00Kb
         iOUfgUi6wT0T3Y4is1mQp9BtYvJ6mRAlD/Pbacaf613GuSL7M+bg5FzHyMM/03GffHIm
         7veZ3mlIz6QDlBvSMFgEn1bXQaVl/MRUEfmPGaTHdoL+g2c1jyOwdsGg8RHg+uXxrCh1
         1p4OnPU9itSW0FIdZjXIPXDWGB5bMilDq+FOqWEF73YJx9efTfZFubrDC8J6v38pIudF
         yj3YyIsZSRMEbB/gE1Dx50JVIMtrUlL0JnMCvqMGExhxaEXpP0lyhJI9fKoiAQ/Cz8nw
         uPIg==
X-Gm-Message-State: AOJu0Yw3xXlu9ah/OtfoTmGgNLW2Tx5S4IvxKdgbro95ha/52LhmHVX9
	AMG1nCMPLWPhf45A4q/RCzfFwGSND0Y59f3D8uvpI3wnkmcm8gJ71jYd7Ke+XQfn2oA4OLfRHaI
	g+4Towgx/1DDt7olrqVENXE5ITQwwVtqd8osGnTjVfPGgAf+N60+F
X-Gm-Gg: ATEYQzzKXA/NDIHYeWZ4KsTYVXQCBpH3w3CKtAwdYXqGmf7icD9dKID+okIRxRIRlQJ
	mUbtzZo4YwIIUtMHn3Rw/owZPmqnospO56Fbx/1vcE5FWz99bNGdaoxjdUt6Nl93pVsWUSSXQdq
	7JxKpavSksb/xRA+FNtgjcyy2cwdAnjzxhJDgFhZ89pP01/ubXSJ2zVgj8WSXdNbMV0v7pWuStu
	8gsQiUEoD47NW+eXzFUzDVHwh4m0urdgfFQaJ3ib3osGtdhPpgiETow02CBlyzbC4030Qw7i7JN
	XB8FyBig8cGtKNLjW2jFIVDmcbUOdfUEThSkfRvk30I+3aTUlELX21DIQTj/6+ahpZf69iKxPFN
	GL3qrAAAW76reh//AE11/i/U4YgOPkNIprmjckPw=
X-Received: by 2002:a05:6122:6217:b0:566:3608:f8db with SMTP id 71dfb90a1353d-56aa0a96612mr1226798e0c.2.1772231708429;
        Fri, 27 Feb 2026 14:35:08 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-56a91e287fbsm859123e0c.3.2026.02.27.14.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 14:35:08 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id B6F3C340B96;
	Fri, 27 Feb 2026 15:35:06 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id B285EE420D8; Fri, 27 Feb 2026 15:35:06 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 1/5] io_uring: add REQ_F_IOPOLL
Date: Fri, 27 Feb 2026 15:34:59 -0700
Message-ID: <20260227223504.1162421-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260227223504.1162421-1-csander@purestorage.com>
References: <20260227223504.1162421-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12481-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,purestorage.com:mid,purestorage.com:dkim,purestorage.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: DB03A1BEBA8
X-Rspamd-Action: no action

A subsequent commit will allow uring_cmds to commands that don't
implement ->uring_cmd_iopoll() to be issued to IORING_SETUP_IOPOLL
io_urings. This means the ctx's IORING_SETUP_IOPOLL flag isn't
sufficient to determine whether a given request needs to be iopolled.
Introduce a request flag REQ_F_IOPOLL set in ->issue() if a request
needs to be iopolled to completion. Set the flag in io_rw_init_file()
and io_uring_cmd() for requests issued to IORING_SETUP_IOPOLL ctxs. Use
the request flag instead of IORING_SETUP_IOPOLL in places dealing with a
specific request.

A future possibility would be to add an option to enable/disable iopoll
in the io_uring SQE instead of determining it from IORING_SETUP_IOPOLL.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            |  9 ++++-----
 io_uring/rw.c                  | 11 ++++++-----
 io_uring/uring_cmd.c           |  5 +++--
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3e4a82a6f817..d74b2a8c7305 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -541,10 +541,11 @@ enum {
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_BUF_NODE_BIT,
 	REQ_F_HAS_METADATA_BIT,
 	REQ_F_IMPORT_BUFFER_BIT,
 	REQ_F_SQE_COPIED_BIT,
+	REQ_F_IOPOLL_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
 };
 
@@ -632,10 +633,12 @@ enum {
 	 * For SEND_ZC, whether to import buffers (i.e. the first issue).
 	 */
 	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
 	/* ->sqe_copy() has been called, if necessary */
 	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
+	/* request must be iopolled to completion (set in ->issue()) */
+	REQ_F_IOPOLL		= IO_REQ_FLAG(REQ_F_IOPOLL_BIT),
 };
 
 struct io_tw_req {
 	struct io_kiocb *req;
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index aa95703165f1..e7f392e962bd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -354,11 +354,10 @@ static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 }
 
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
-	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!(req->flags & REQ_F_CREDS)) {
 		req->flags |= REQ_F_CREDS;
 		req->creds = get_current_cred();
 	}
@@ -376,11 +375,11 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 		/* don't serialize this request if the fs doesn't need it */
 		if (should_hash && (req->file->f_flags & O_DIRECT) &&
 		    (req->file->f_op->fop_flags & FOP_DIO_PARALLEL_WRITE))
 			should_hash = false;
-		if (should_hash || (ctx->flags & IORING_SETUP_IOPOLL))
+		if (should_hash || (req->flags & REQ_F_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
 	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
 		if (def->unbound_nonreg_file)
 			atomic_or(IO_WQ_WORK_UNBOUND, &req->work.flags);
 	}
@@ -1417,11 +1416,11 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret == IOU_ISSUE_SKIP_COMPLETE) {
 		ret = 0;
 
 		/* If the op doesn't have a file, we're not polling for it */
-		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
+		if ((req->flags & REQ_F_IOPOLL) && def->iopoll_queue)
 			io_iopoll_req_issued(req, issue_flags);
 	}
 	return ret;
 }
 
@@ -1433,11 +1432,11 @@ int io_poll_issue(struct io_kiocb *req, io_tw_token_t tw)
 	int ret;
 
 	io_tw_lock(req->ctx, tw);
 
 	WARN_ON_ONCE(!req->file);
-	if (WARN_ON_ONCE(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (WARN_ON_ONCE(req->flags & REQ_F_IOPOLL))
 		return -EFAULT;
 
 	ret = __io_issue_sqe(req, issue_flags, &io_issue_defs[req->opcode]);
 
 	WARN_ON_ONCE(ret == IOU_ISSUE_SKIP_COMPLETE);
@@ -1531,11 +1530,11 @@ void io_wq_submit_work(struct io_wq_work *work)
 		 * We can get EAGAIN for iopolled IO even though we're
 		 * forcing a sync submission from here, since we can't
 		 * wait for request slots on the block side.
 		 */
 		if (!needs_poll) {
-			if (!(req->ctx->flags & IORING_SETUP_IOPOLL))
+			if (!(req->flags & REQ_F_IOPOLL))
 				break;
 			if (io_wq_worker_stopped())
 				break;
 			cond_resched();
 			continue;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1a5f262734e8..3bdb9914e673 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -502,11 +502,11 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!S_ISBLK(mode) && !S_ISREG(mode))
 		return false;
 	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
-	    !(ctx->flags & IORING_SETUP_IOPOLL)))
+	    !(req->flags & REQ_F_IOPOLL)))
 		return false;
 	/*
 	 * If ref is dying, we might be running poll reap from the exit work.
 	 * Don't attempt to reissue from that path, just let it fail with
 	 * -EAGAIN.
@@ -638,11 +638,11 @@ static inline void io_rw_done(struct io_kiocb *req, ssize_t ret)
 			ret = -EINTR;
 			break;
 		}
 	}
 
-	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+	if (req->flags & REQ_F_IOPOLL)
 		io_complete_rw_iopoll(&rw->kiocb, ret);
 	else
 		io_complete_rw(&rw->kiocb, ret);
 }
 
@@ -652,11 +652,11 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned final_ret = io_fixup_rw_res(req, ret);
 
 	if (ret >= 0 && req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
-	if (ret >= 0 && !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
+	if (ret >= 0 && !(req->flags & REQ_F_IOPOLL)) {
 		u32 cflags = 0;
 
 		__io_complete_rw_common(req, ret);
 		/*
 		 * Safe to call io_end from here as we're inline
@@ -874,10 +874,11 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		req->flags |= REQ_F_NOWAIT;
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
 			return -EOPNOTSUPP;
+		req->flags |= REQ_F_IOPOLL;
 		kiocb->private = NULL;
 		kiocb->ki_flags |= IOCB_HIPRI;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once*/
@@ -961,11 +962,11 @@ static int __io_read(struct io_kiocb *req, struct io_br_sel *sel,
 	if (ret == -EAGAIN) {
 		/* If we can poll, just do that. */
 		if (io_file_can_poll(req))
 			return -EAGAIN;
 		/* IOPOLL retry should happen for io-wq threads */
-		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
+		if (!force_nonblock && !(req->flags & REQ_F_IOPOLL))
 			goto done;
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
 			goto done;
 		ret = 0;
@@ -1186,11 +1187,11 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	/* no retry on NONBLOCK nor RWF_NOWAIT */
 	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
 		goto done;
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
-		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
+		if (ret2 == -EAGAIN && (req->flags & REQ_F_IOPOLL))
 			goto ret_eagain;
 
 		if (ret2 != req->cqe.res && ret2 >= 0 && need_complete_io(req)) {
 			trace_io_uring_short_write(req->ctx, kiocb->ki_pos - ret2,
 						req->cqe.res, ret2);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ee7b49f47cb5..b651c63f6e20 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -108,11 +108,11 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 	 * Doing cancelations on IOPOLL requests are not supported. Both
 	 * because they can't get canceled in the block stack, but also
 	 * because iopoll completion data overlaps with the hash_node used
 	 * for tracking.
 	 */
-	if (ctx->flags & IORING_SETUP_IOPOLL)
+	if (req->flags & REQ_F_IOPOLL)
 		return;
 
 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
 		cmd->flags |= IORING_URING_CMD_CANCELABLE;
 		io_ring_submit_lock(ctx, issue_flags);
@@ -165,11 +165,11 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
 			req->cqe.flags |= IORING_CQE_F_32;
 		io_req_set_cqe32_extra(req, res2, 0);
 	}
 	io_req_uring_cleanup(req, issue_flags);
-	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+	if (req->flags & REQ_F_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
 	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
 		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
 			return;
@@ -258,10 +258,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!file->f_op->uring_cmd_iopoll)
 			return -EOPNOTSUPP;
+		req->flags |= REQ_F_IOPOLL;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once */
 			req->flags &= ~REQ_F_IOPOLL_STATE;
-- 
2.45.2


