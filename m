Return-Path: <io-uring+bounces-12638-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNZRA5FqsWnsugIAu9opvQ
	(envelope-from <io-uring+bounces-12638-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:13:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A564D26439C
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EB54E3018C36
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 13:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8373016FA;
	Wed, 11 Mar 2026 13:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ndKwhqse"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564773016FB
	for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 13:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234825; cv=none; b=lNhH0x1YJbrP0QBF//Rq9v9YRHgj5QL59QhI8ES9Al7CLzxLVtsKreQU67KEoAoglyFG2qLGozoX3Z2Zl46FtoSEMcGiqSIiMI/jW39pAv/fcZ/r39KJ7JyhfJIWmIWuiFk7IPa4h6HAVGrbgMxdrhhCWYXY7T7erxEOlUFZKU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234825; c=relaxed/simple;
	bh=/gRvdwFsueP4KDXlFTGJUrGoHx6ib/Ha7C5vNfnjzL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBqbPsmBqBJd5J1OHfgUjcsdbYnbSbffQjv2HDH2h+XBrvttZYHF6EMhG2NIUOj/BHrBwhc9ijPPvES63WatoOJ9Wa4CtlfcVLMgdZg/WAHeXf0yjx2wL5GiDFplM+CeK0ql1Il5iQEjygUIvXvrU36bF8tJ9ojvqRADgKzdNPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ndKwhqse; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d7439f8837so490687a34.1
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 06:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773234823; x=1773839623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yhviBqIRh/9iFlrPxeHeHh9ik2w1XcH2i8WbdYRMfM=;
        b=ndKwhqseHhlO5HGHRAfhbNrX88xf37hrGqQQvf11dPtJSX1SKUjR9h8Ifz3ZHDb9bp
         Vp3T6nHh+aJlYcHG9pRojsII5R3RgEI6ZpMSK1xCmho3k7ry6d0+7gtJuqHz3+1CBwcO
         LQvHt6J/NQ4h7b6DFMPuvcowFbj72wh1f/c+3qD72MFYH1LSnjiExuA8tTWJGpWPyDGj
         VAhxiVGiAxctuM260wdR32ehIWLoIwMyHXutG0AEdcuKLbTIneHAzvlqdfU0TFEHel4M
         GvOY7xjBqA9RsF03kWxO4/I0/U+ScO5Kb213d+NiwKq/sotESP1adtVQbNIhBlHHyVh2
         aWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773234823; x=1773839623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0yhviBqIRh/9iFlrPxeHeHh9ik2w1XcH2i8WbdYRMfM=;
        b=L3A1zi98iEEDN5ndvDg4I/NzfIncrz0qNcvzY9O9RReAvch7optfNFcXJnP+x2QFlz
         k/wMc7mMNb+AOXL1QhcWoEkJIcueL3h+WSY3dCZXzX9UwLcsQcyV+Gg71EDz1y1G66Tm
         wQ/Cu82rtCxL2iCET9nKDEBBXH10jcGU3r2mVj4zzu8F3fdK8CEoMRimv0rXflAC19YG
         XqYhFwGE7YIyRySugT9wohBz9OLBBlmt9yCzxRZfHrD8bVE5UhjxzsI7H0QNo49LFxqg
         Wc73IGpqa1AUOesz/xeOkt/M25oRKEYHC1SLZ7h1Gs1HdxrPsut2kIulo8kvU/APb9Lj
         ltkQ==
X-Gm-Message-State: AOJu0YztMn3gn91ddmjoJ/MxFVmhEFUottcZ9gDEKCJArTdLmjGTcBTk
	KIJ6btvxvgfVe9FXeNL+xBxtvhA43PJMk2VNd8Ub/y1VXaM8zM1bxc2AYgDmMNz3Yp9eZMsmd33
	s4KloWo8=
X-Gm-Gg: ATEYQzzjpVnb7lTniO+BONce3bvO9+ZmGAVtyrVqkK/afwwuR84KM2y+YND+SsoyNrz
	XolQY/6mp6FwyfvaYeGdZ2uPzrHXpwq+gYFGu3BOSyRE8wz0JcJc14X/+7YQElM3USMM8FupWxy
	2d4rj2lpWThpwE0wcNZc8zi782xIlELTLR+E1/N26hZWJp9wt36+tgNiesLMWjDgpGOWk5zWPSL
	vTytr+GeqFVeg1sLMutN+ac8f7AMaBMj1BH/GKhqND943LbXFLPOVbea6ARIVTM0jr9dqmsl2pi
	FSWpunHV6vN6F0VPp8qDVRJY7hH4uQRvQW7CF92LjZttrSg13Lx/E+rMZWgKhn2KYSsc1K/COr5
	H7utbirBSeycmY/KLoTWIOAoowax7SFz2a5b65sKxTOkmZcCzWQH/aCnn34klgvTuGQ1EQanErZ
	PAI/IjzA1lUKUUOZDn5yJli0YC7srtCPDZmUDg3x28OXSz+wBBZOEnmc6CLMbGv9B5lHge
X-Received: by 2002:a05:6820:3092:b0:67b:b411:47fd with SMTP id 006d021491bc7-67bc9150691mr1086399eaf.35.1773234823043;
        Wed, 11 Mar 2026 06:13:43 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e5e8185sm2286127fac.12.2026.03.11.06.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 06:13:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	naup96721@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: ensure ctx->rings is stable for task work flags manipulation
Date: Wed, 11 Mar 2026 07:11:55 -0600
Message-ID: <20260311131336.197028-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311131336.197028-1-axboe@kernel.dk>
References: <20260311131336.197028-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A564D26439C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12638-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Action: no action

If DEFER_TASKRUN | SETUP_TASKRUN is used and task work is added while
the ring is being resized, it's possible for the OR'ing of
IORING_SQ_TASKRUN to happen in the small window of swapping into the
new rings and the old rings being freed.

Prevent this by adding a 2nd ->rings pointer, ->rings_rcu, which is
protected by RCU. The task work flags manipulation is inside RCU
already, and if the resize ring freeing is done post an RCU synchronize,
then there's no need to add locking to the fast path of task work
additions.

Note: this is only done for DEFER_TASKRUN, as that's the only setup mode
that supports ring resizing. If this ever changes, then they too need to
use the io_ctx_mark_taskrun() helper.

Link: https://lore.kernel.org/io-uring/20260309062759.482210-1-naup96721@gmail.com/
Cc: stable@vger.kernel.org
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Reported-by: Hao-Yu Yang <naup96721@gmail.com>
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            |  2 ++
 io_uring/register.c            | 11 +++++++++++
 io_uring/tw.c                  | 21 +++++++++++++++++++--
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3e4a82a6f817..dd1420bfcb73 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -388,6 +388,7 @@ struct io_ring_ctx {
 	 * regularly bounce b/w CPUs.
 	 */
 	struct {
+		struct io_rings	__rcu	*rings_rcu;
 		struct llist_head	work_llist;
 		struct llist_head	retry_llist;
 		unsigned long		check_cq;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ccab8562d273..20fdc442e014 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2066,6 +2066,7 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	io_free_region(ctx->user, &ctx->sq_region);
 	io_free_region(ctx->user, &ctx->ring_region);
 	ctx->rings = NULL;
+	RCU_INIT_POINTER(ctx->rings_rcu, NULL);
 	ctx->sq_sqes = NULL;
 }
 
@@ -2703,6 +2704,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	if (ret)
 		return ret;
 	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
+	rcu_assign_pointer(ctx->rings_rcu, rings);
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		ctx->sq_array = (u32 *)((char *)rings + rl->sq_array_offset);
 
diff --git a/io_uring/register.c b/io_uring/register.c
index a839b22fd392..6d3e65b17514 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -633,7 +633,15 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
+	/*
+	 * Just mark any flag we may have missed and that the application
+	 * should act on unconditionally. Worst case it'll be an extra
+	 * syscall.
+	 */
+	atomic_or(IORING_SQ_TASKRUN | IORING_SQ_NEED_WAKEUP, &n.rings->sq_flags);
 	ctx->rings = n.rings;
+	rcu_assign_pointer(ctx->rings_rcu, n.rings);
+
 	ctx->sq_sqes = n.sq_sqes;
 	swap_old(ctx, o, n, ring_region);
 	swap_old(ctx, o, n, sq_region);
@@ -642,6 +650,9 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 out:
 	spin_unlock(&ctx->completion_lock);
 	mutex_unlock(&ctx->mmap_lock);
+	/* Wait for concurrent io_ctx_mark_taskrun() */
+	if (to_free == &o)
+		synchronize_rcu();
 	io_register_free_rings(ctx, to_free);
 
 	if (ctx->sq_data)
diff --git a/io_uring/tw.c b/io_uring/tw.c
index 1ee2b8ab07c8..0c860a7e6c61 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -152,6 +152,20 @@ void tctx_task_work(struct callback_head *cb)
 	WARN_ON_ONCE(ret);
 }
 
+/*
+ * Sets IORING_SQ_TASKRUN in the sq_flags shared with userspace, using the
+ * RCU protected rings pointer to be safe against concurrent ring resizing.
+ * Must be called inside an RCU read-side critical section.
+ */
+static void io_ctx_mark_taskrun(struct io_ring_ctx *ctx)
+{
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG) {
+		struct io_rings *rings = rcu_dereference(ctx->rings_rcu);
+
+		atomic_or(IORING_SQ_TASKRUN, &rings->sq_flags);
+	}
+}
+
 void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -206,8 +220,7 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	 */
 
 	if (!head) {
-		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+		io_ctx_mark_taskrun(ctx);
 		if (ctx->has_evfd)
 			io_eventfd_signal(ctx, false);
 	}
@@ -231,6 +244,10 @@ void io_req_normal_work_add(struct io_kiocb *req)
 	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
 
+	/*
+	 * Doesn't need to use ->rings_rcu, as resizing isn't supported for
+	 * !DEFER_TASKRUN.
+	 */
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 
-- 
2.53.0


