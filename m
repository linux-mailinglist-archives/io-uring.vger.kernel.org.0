Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2BD3E4E5E
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 23:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhHIVYf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 17:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbhHIVYd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 17:24:33 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F66CC061798
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 14:24:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q2so18025951plr.11
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 14:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5/20ck0XnHnMDNZglLbT8+iG6Jg9pQpAk9fG8nwb5/0=;
        b=viS7Rgv3M63OffnJNQ8/5rkvdk/yaJm0ueeRmIWPwuzMQe6YOB+AS3Vj3FjyK44r/U
         8mZnoMhh2r525e3QcDuKc55s7s07tPBdJfSGa1Yo1bjm5KWeFyySaOpFbzy14aYmtvt9
         fDBiNQ+lD46SuImFU02rP3/CSSdMcu3qW+YSaWc8+g7AHgQtF4W3GVS4tdrgbQbQDrT/
         NRa9WYYMPBcxe0tv5a0UldJeai9rOLiv6Tkuw3aoxWwqbwtkiYfXei6l1Fd+ungckhLS
         HU9bqr9UWqXobMMggmiQBwP6wohRB+78c2jcD2bUGxFuCXiQg4wL7+ZaA1mGpRp6uq+s
         IIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5/20ck0XnHnMDNZglLbT8+iG6Jg9pQpAk9fG8nwb5/0=;
        b=s1dAfnIBks7TR9ohJ5v/bbOWm5DpZmCNbPGXAtB6T1ejkz6bYZeAfULrjnKAYY8fIF
         v0X0gpz4/RtIV6vQN9XAxnVOR8nx7PZcwUWeBkqo16h4zmL3GDEQdprWThB1keZAJNE6
         QLbbeRjO+sGS0TZMWaOvD+oxR8q77Q1YP1WImzsdTELAzyos5d0mJ8TtoixaPM6+pqD8
         BtP57IUotmYp0whQxPwNk9Ade/LA54A+8N6htlH9D2bgYWCrjmDuLqo2QW2V8DZNV/zu
         bT5Ez1SQE2OKRpDD0Hdu3AK5LcWyVY69WrtCVsJEeRWZyNTOy733Wi5S1bf0QHzWCpGS
         goNg==
X-Gm-Message-State: AOAM531cWjTjxRwrzJcd/QOVUNNcg89Pj1jIazzZ1PRdI0kkO0TscQm3
        kFJLPiPwD5VK9u57pXlh8PnIS92DEzJpTpsH
X-Google-Smtp-Source: ABdhPJzbsh4KB8JIQ2bb5KBHUu2ulbvi6d22PFcHzZ1CKqSPxpxcowwM8m/XFMVhDV3N10PnSFoz8w==
X-Received: by 2002:a17:90b:250f:: with SMTP id ns15mr1140198pjb.26.1628544250587;
        Mon, 09 Aug 2021 14:24:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m16sm439885pjz.30.2021.08.09.14.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:24:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: wire up bio allocation cache
Date:   Mon,  9 Aug 2021 15:24:00 -0600
Message-Id: <20210809212401.19807-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809212401.19807-1-axboe@kernel.dk>
References: <20210809212401.19807-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Initialize a bio allocation cache, and mark it as being used for
IOPOLL. We could use it for non-polled IO as well, but it'd need some
locking and probably would negate much of the win in that case.

We start with IOPOLL, as completions are locked by the ctx lock anyway.
So no further locking is needed there.

This brings an IOPOLL gen2 Optane QD=128 workload from ~3.0M IOPS to
~3.25M IOPS.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 52 ++++++++++++++++++++++++++++++++++++++++
 include/linux/io_uring.h |  4 ++--
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91a301bb1644..1d94a434b348 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -474,6 +474,10 @@ struct io_uring_task {
 	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
+#ifdef CONFIG_BLOCK
+	struct bio_alloc_cache	bio_cache;
+#endif
+
 	spinlock_t		task_lock;
 	struct io_wq_work_list	task_list;
 	unsigned long		task_state;
@@ -2268,6 +2272,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
+			/* Don't use cache for async retry, not locking safe */
+			req->rw.kiocb.ki_flags &= ~IOCB_ALLOC_CACHE;
 			req_ref_get(req);
 			io_req_task_queue_reissue(req);
 			continue;
@@ -2675,6 +2681,29 @@ static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
 	return __io_file_supports_nowait(req->file, rw);
 }
 
+static void io_mark_alloc_cache(struct kiocb *kiocb)
+{
+#ifdef CONFIG_BLOCK
+	struct block_device *bdev = NULL;
+
+	if (S_ISBLK(file_inode(kiocb->ki_filp)->i_mode))
+		bdev = I_BDEV(kiocb->ki_filp->f_mapping->host);
+	else if (S_ISREG(file_inode(kiocb->ki_filp)->i_mode))
+		bdev = kiocb->ki_filp->f_inode->i_sb->s_bdev;
+
+	/*
+	 * If the lower level device doesn't support polled IO, then
+	 * we cannot safely use the alloc cache. This really should
+	 * be a failure case for polled IO...
+	 */
+	if (!bdev ||
+	    !test_bit(QUEUE_FLAG_POLL, &bdev_get_queue(bdev)->queue_flags))
+		return;
+
+	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
+#endif /* CONFIG_BLOCK */
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2717,6 +2746,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EOPNOTSUPP;
 
 		kiocb->ki_flags |= IOCB_HIPRI;
+		io_mark_alloc_cache(kiocb);
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 	} else {
@@ -2783,6 +2813,8 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
+			/* Don't use cache for async retry, not locking safe */
+			req->rw.kiocb.ki_flags &= ~IOCB_ALLOC_CACHE;
 			req_ref_get(req);
 			io_req_task_queue_reissue(req);
 		} else {
@@ -7966,10 +7998,17 @@ static int io_uring_alloc_task_context(struct task_struct *task,
 		return ret;
 	}
 
+#ifdef CONFIG_BLOCK
+	bio_alloc_cache_init(&tctx->bio_cache);
+#endif
+
 	tctx->io_wq = io_init_wq_offload(ctx, task);
 	if (IS_ERR(tctx->io_wq)) {
 		ret = PTR_ERR(tctx->io_wq);
 		percpu_counter_destroy(&tctx->inflight);
+#ifdef CONFIG_BLOCK
+		bio_alloc_cache_destroy(&tctx->bio_cache);
+#endif
 		kfree(tctx);
 		return ret;
 	}
@@ -7993,6 +8032,10 @@ void __io_uring_free(struct task_struct *tsk)
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 
+#ifdef CONFIG_BLOCK
+	bio_alloc_cache_destroy(&tctx->bio_cache);
+#endif
+
 	percpu_counter_destroy(&tctx->inflight);
 	kfree(tctx);
 	tsk->io_uring = NULL;
@@ -10247,6 +10290,15 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	return ret;
 }
 
+struct bio_alloc_cache *io_uring_bio_cache(void)
+{
+#ifdef CONFIG_BLOCK
+	if (current->io_uring)
+		return &current->io_uring->bio_cache;
+#endif
+	return NULL;
+}
+
 static int __init io_uring_init(void)
 {
 #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 2fb53047638e..a9bab9bd51d1 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -11,6 +11,7 @@ struct bio_alloc_cache;
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(struct files_struct *files);
 void __io_uring_free(struct task_struct *tsk);
+struct bio_alloc_cache *io_uring_bio_cache(void);
 
 static inline void io_uring_files_cancel(struct files_struct *files)
 {
@@ -40,11 +41,10 @@ static inline void io_uring_files_cancel(struct files_struct *files)
 static inline void io_uring_free(struct task_struct *tsk)
 {
 }
-#endif
-
 static inline struct bio_alloc_cache *io_uring_bio_cache(void)
 {
 	return NULL;
 }
+#endif
 
 #endif
-- 
2.32.0

