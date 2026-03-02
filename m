Return-Path: <io-uring+bounces-12522-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KG77Hf/IpWnEFgAAu9opvQ
	(envelope-from <io-uring+bounces-12522-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DB31DDCEB
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3C3013004D2E
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 17:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD6B42EECA;
	Mon,  2 Mar 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="a3Mt3AH7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f101.google.com (mail-qv1-f101.google.com [209.85.219.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D5E426EBF
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472564; cv=none; b=qWOF2TABjNrxOgLZh0K7rz/igqT0KVa0wrInZ26esXZl56FJmJbYiCo+O4CO0P7Rvd10KLQufOs79kIOAQ7jbDDB0lpdFrFgWD+unkFNWKmHQ42mZ+CFE/LgR3EgzZSshDRfpI/qfzJ38iCL2mxGL7hYBsPtgalwfkDtOTZBdU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472564; c=relaxed/simple;
	bh=uxTyPfsI/g87msoy9eUMmN8qbKp3Wpg2CUlMnqYjrOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmqhXFmC3aawMNrhYQ3s4Jbtczvz6kd1MStJq06lriHHD8J2cc9qDUdSXpwaWaEw70LPC3cvZso33E7QQKTuP9/bTlj8PoX6Y65tF7qHhgDsgu+nKZqUdpckfmDSL1sMFYg81WM22zh+VMfr4BILfHCghogJlZA1EwP7JjWihqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=a3Mt3AH7; arc=none smtp.client-ip=209.85.219.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qv1-f101.google.com with SMTP id 6a1803df08f44-899e69df1b7so3346636d6.2
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 09:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772472562; x=1773077362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KD/WfRuGbaSn+6cq0PfA2+nK80LzEXM/LyfAsAFa1e0=;
        b=a3Mt3AH7mpCI8ZCxeh7fP3kVPnUOG3r4oxGgMSl0M1b0r7KrrXZmk90izESZ1e32Lp
         9pbitYA2AIah4Po2eGawo7W1+GAizmI1xnnk9p9VE2nVvoShwA2ixsP/DOVcFns4VXYt
         nGlo3ElYGEyK4/SaNtSXWMoHWPh0Rh4Q+qG8OUYYUhtxUHv5lelxeczilvJRAaJDoXad
         OwnXVSyloLsSpZoPrA85PwYKkooJBRR9xazW4ZsHJduEAUwtulkEg5ur+HrySM+aHArI
         iYjljgJ9rThSiKqyYihobbm4E0cpEdMPjt9vQQ3Y+/1qsPWieRBe/vA1RDucYhSGn8pE
         ysaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772472562; x=1773077362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KD/WfRuGbaSn+6cq0PfA2+nK80LzEXM/LyfAsAFa1e0=;
        b=fOlBj1SfR7V2hRwTfQKdjJPsASuwEu/vpKHiUQtRa03erEO6tio5GjXEdg/D5MoGXr
         G3xuMWVzbfekY/xkgRAuImUAaW955nY+j9YFVP1mERBs2BX7Y1OxbsHKMHArkkKN3PMT
         1d0GPN0mNtLcTCL4ZM9ttPLMCn9oSwnM86PP52YWOkOUW7RrRaOJUcMpYekW5GnY5xXF
         IEXeBbliBOPhULK5X/oESZXuHOQou0QudhZo606/brJheQ66xJi8nc6fK+gUNGCCbOy2
         GLjcpNrxS2BcpdcaybK9GtoV9Rqz8GVqx5DVwgAg+k1wd3Q1myu0zhQ1m+a1vUnJojst
         fvzQ==
X-Gm-Message-State: AOJu0Yxhq0eJG2WSZ1cIbfS3xaIqX7/eJnMOzLJdzNJdMp7JY6vCVTY9
	vjYVqFHRrHRJH2nbzq6LrHK6BFuW3W4T3wLAPxFkZ6K9UirFPKbRxt1n+i4oePUYFkCKyTIjp74
	Vrv7DyBi8Mg2355RGrbAsC7I0jle3KN83wdEC
X-Gm-Gg: ATEYQzyPwOfnhh6r5lajOIQDF1XROz4eWQ5W4i6LmB+n1znqyTA9wCgbL+EqqH9bhCf
	NFHrVL4DMlZjJmLTH+vuDbsR6upvX5887M+LkhxiungKIvcH/rnQXaWibeMXTmtOr38eHH2fe+Z
	zwP7NjKDulNhJc9ayafs6ZOZ6qCvvh0dh18yxk+YpQOO1gMNxoTbb5X8PimqSMBrEQ36a5hlIHs
	4FmligNn+REck7gQVGvCgeM0+lOxPi5Wnvw//E587tBIKzBO93n3UxEfEh4IDklzp/Opa3VoCtf
	rWJ5mqd8muu6kzaSJisbxd32eKWqGjF/GcTy3OmpZuKo+rB80tatXxJf0mPjVytfs8kxLNTteYQ
	JGeGWmRGm2Jw4x55EgJRZVL/NLc55AT9DW6nsLFAIOwqjjD+rSi9Iow==
X-Received: by 2002:a0c:e006:0:b0:89a:591:15a9 with SMTP id 6a1803df08f44-89a05911899mr16836046d6.6.1772472562007;
        Mon, 02 Mar 2026 09:29:22 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-899eda739e2sm6897186d6.21.2026.03.02.09.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:29:22 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 6A64F340316;
	Mon,  2 Mar 2026 10:29:21 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 63FE1E41FBD; Mon,  2 Mar 2026 10:29:21 -0700 (MST)
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
Subject: [PATCH v5 1/5] io_uring: add REQ_F_IOPOLL
Date: Mon,  2 Mar 2026 10:29:10 -0700
Message-ID: <20260302172914.2488599-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260302172914.2488599-1-csander@purestorage.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77DB31DDCEB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12522-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:dkim,purestorage.com:email,purestorage.com:mid,samsung.com:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

A subsequent commit will allow uring_cmds to files that don't implement
->uring_cmd_iopoll() to be issued to IORING_SETUP_IOPOLL io_urings. This
means the ctx's IORING_SETUP_IOPOLL flag isn't sufficient to determine
whether a given request needs to be iopolled.

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


