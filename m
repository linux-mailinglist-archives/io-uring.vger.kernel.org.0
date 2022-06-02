Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D9A53B487
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 09:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiFBHpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 03:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbiFBHpL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 03:45:11 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835231A8E2A
        for <io-uring@vger.kernel.org>; Thu,  2 Jun 2022 00:45:09 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h5so5364906wrb.0
        for <io-uring@vger.kernel.org>; Thu, 02 Jun 2022 00:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=CQ4DR4qoksJapQc76E5fltstCgzI4x6QdfojYpTDhuQ=;
        b=Tbl2nLbEvm35PUjFRPLZRpr+kpyggfsjo/V3ndV5tkqKTG9jrEu5eXGjh4c+IPvhiR
         Fc19GL3xtu2msZHxIN5AuogrHyXdOrRZpyCZrxmelwVbVa4oR5shih2tJQ4o7a8tj+Dd
         0zcMGzfnLcm0hAP5fN9slFzwzCPOICzAsfBUhSOwHfao2QUe8wfHHs9HnK/JKWOwTj4B
         OzLjDyAARP3VhM7mhK1IpceVEeUeq9qyuLMn0Kn2jWkyR+A+j88WY1Rk7l119jpJCMTi
         i9l70AM0MpHhG9x1fGI40D8e3jbs9X00EK3ZdWB8VsktUEEtEXxHBtAkN+FAHvcrGk+n
         zmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=CQ4DR4qoksJapQc76E5fltstCgzI4x6QdfojYpTDhuQ=;
        b=I0WQRbKfZBYM7D3KNipXezhcRUnO052wxaoR3tODP/NX6ipinwGOupcj2oclatqYKL
         oT3O7HmW+mn5iRvpS8csh0QEHzz8Kwwu2MXbH7jJfyAniqKxoEgR7DGKpQxNpUE9Kb2c
         OMgjxDJ4ERUj/pJQeHoEhQ9KSbyEdb0GXVydv1Z+u1MmfTwN32afYEsbzQmZ3m/FLclC
         grKZ3o8uURGwbEOiuW+SMYHDWtYVVvq0jljq/hI7gSArPDRWPgPwavsyAs60uMzaQUS+
         nhc924EJ0T3YvkhkLFSZidaQCo0pZHazjlsnwcaA7NiMZzht4S2jDpKWVnDGRo3lr6rw
         K0Pw==
X-Gm-Message-State: AOAM531I814DuuUB+wgb+qXKvhPrzKhg+ICy08hndJY9raqAifofvgmQ
        SLXXB11Smmixza12wUqQZrCB6JF1lBKoaIwR
X-Google-Smtp-Source: ABdhPJwoYwZTuzOmPB0a/0IJfJcqR1jwNPGYUsCyC5g/HxkYosFmtQxRJOYJsD8B3DAsjW9PcVdlEw==
X-Received: by 2002:a05:6000:1f85:b0:210:155b:1e19 with SMTP id bw5-20020a0560001f8500b00210155b1e19mr1091513wrb.162.1654155907643;
        Thu, 02 Jun 2022 00:45:07 -0700 (PDT)
Received: from [10.40.36.78] ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id x8-20020adff0c8000000b00210a6bd8019sm3333100wro.8.2022.06.02.00.45.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 00:45:07 -0700 (PDT)
Message-ID: <0e413af8-f8b9-ef1a-6c27-58e964495f49@kernel.dk>
Date:   Thu, 2 Jun 2022 01:45:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: reinstate the inflight tracking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After some debugging, it was realized that we really do still need the
old inflight tracking for any file type that has io_uring_fops assigned.
If we don't, then trivial circular references will mean that we never get
the ctx cleaned up and hence it'll leak.

Just bring back the inflight tracking, which then also means we can
eliminate the conditional dropping of the file when task_work is queued.

Fixes: d5361233e9ab ("io_uring: drop the old style inflight file tracking")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 495353437228..2a9b9a24fc22 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -112,7 +112,8 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
+				REQ_F_ASYNC_DATA)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
@@ -540,6 +541,7 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
+	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1356,8 +1358,6 @@ static void io_clean_op(struct io_kiocb *req);
 static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 					     unsigned issue_flags);
 static struct file *io_file_get_normal(struct io_kiocb *req, int fd);
-static void io_drop_inflight_file(struct io_kiocb *req);
-static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags);
 static void io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1760,9 +1760,29 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
 	__must_hold(&req->ctx->timeout_lock)
 {
+	struct io_kiocb *req;
+
 	if (task && head->task != task)
 		return false;
-	return cancel_all;
+	if (cancel_all)
+		return true;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
 }
 
 /*
@@ -1772,9 +1792,24 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			       bool cancel_all)
 {
+	bool matched;
+
 	if (task && head->task != task)
 		return false;
-	return cancel_all;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
 }
 
 static inline bool req_has_async_data(struct io_kiocb *req)
@@ -1930,6 +1965,14 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
+static inline void io_req_track_inflight(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_INFLIGHT)) {
+		req->flags |= REQ_F_INFLIGHT;
+		atomic_inc(&current->io_uring->inflight_tracked);
+	}
+}
+
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -2991,8 +3034,6 @@ static void __io_req_task_work_add(struct io_kiocb *req,
 	unsigned long flags;
 	bool running;
 
-	io_drop_inflight_file(req);
-
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	wq_list_add_tail(&req->io_task_work.node, list);
 	running = tctx->task_running;
@@ -6914,10 +6955,6 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 
 		if (!req->cqe.res) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
-			unsigned flags = locked ? 0 : IO_URING_F_UNLOCKED;
-
-			if (unlikely(!io_assign_file(req, flags)))
-				return -EBADF;
 			req->cqe.res = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
@@ -8325,6 +8362,11 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_uring_task *tctx = req->task->io_uring;
+
+		atomic_dec(&tctx->inflight_tracked);
+	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
 	if (req->flags & REQ_F_ASYNC_DATA) {
@@ -8631,19 +8673,6 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	return file;
 }
 
-/*
- * Drop the file for requeue operations. Only used of req->file is the
- * io_uring descriptor itself.
- */
-static void io_drop_inflight_file(struct io_kiocb *req)
-{
-	if (unlikely(req->flags & REQ_F_INFLIGHT)) {
-		fput(req->file);
-		req->file = NULL;
-		req->flags &= ~REQ_F_INFLIGHT;
-	}
-}
-
 static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
 	struct file *file = fget(fd);
@@ -8652,7 +8681,7 @@ static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 
 	/* we don't allow fixed io_uring files */
 	if (file && file->f_op == &io_uring_fops)
-		req->flags |= REQ_F_INFLIGHT;
+		io_req_track_inflight(req);
 	return file;
 }
 
@@ -10416,6 +10445,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -11647,7 +11677,7 @@ static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return 0;
+		return atomic_read(&tctx->inflight_tracked);
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-- 
Jens Axboe

