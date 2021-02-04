Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38A030F470
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbhBDOAB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 09:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236411AbhBDN5v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:57:51 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224D2C06178A
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:16 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m1so3073007wml.2
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5iusiVNNo46mk5QO7l8cs6XhgKo/Ze1+/uUnMIm+NGk=;
        b=pbTpivNbOCroW5A45Afbk3VCQTc+pco0caLiFRDoVnRW56rCQudNdAoQ3D/KWd4qbE
         1sn7+1w5X7sDCYXQnKWH5gdgqIu2eyc/MeNAmH0UnE9EwHV8iEPqd64BYmk49Nds/j5a
         XlqYOPUnsr7VVt40KOSmOvnOqBNVpO6JRFiGcozz0HPQV4JXJkBeacaWepFsuIF51C4g
         L0ppYJsEpPjGIyqYjOy/rgwvseQFHktFyV/9kmIRxigVKpw5djtFZ9GLw8sFrOQem5/f
         1EZiLQo6A016sbQ6Pqh/lkYcBib1oq1KM7aOjlJHks2uYglhwXcGfcwIGHowlAnLHM+z
         AJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5iusiVNNo46mk5QO7l8cs6XhgKo/Ze1+/uUnMIm+NGk=;
        b=CzRWDfN1NU5meG6XX9+HhCHF19C4PC8qUX4XyLJs0djqeDMXXwUybGQhJp1pz5bnWn
         qZepjnj0eHgT+bFsH64xK41SIM5px9/gGDcVDhyt6dNRydJyPaqzd1EsEUQZYMbZovX+
         9EFduB0vllcPVYCC0zDlJdkviyxgkhsy+UFNusmgCvooZTU1jz3zuo0VVmLWu4UCoD0O
         VmSHWxZa2uUzb4XOuEFNwuq8zFiy3VrZLIXpPsBzylpBWYvviE/w/eHNaARGg5hiO6ou
         /J+ZvCzpOihJQSCuwUmVhbrsJiwMIuSWbwddVD6U+tvXnODLZnq7IXlp8Ig69Gg16WTX
         Xk2Q==
X-Gm-Message-State: AOAM530w6KOqcoF05NLoDKmzek6wsWJvAOBX8EX6Yi2dlvkRBDoRPeu3
        4XkUCG0zb7FvRKGnXZ/hVCzzIvm/DsiAnA==
X-Google-Smtp-Source: ABdhPJyWZmYo72oDJVZL6gV2vWIRzr//sjUL/wyL16rFowxKyxYLT/3+P6GSm/vcwPpvuywJKFPMTg==
X-Received: by 2002:a1c:f001:: with SMTP id a1mr7610333wmb.21.1612446974914;
        Thu, 04 Feb 2021 05:56:14 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 13/13] io_uring/io-wq: return 2-step work swap scheme
Date:   Thu,  4 Feb 2021 13:52:08 +0000
Message-Id: <014eff28b71c8e5da5edaa4ad9d142916317c839.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Saving one lock/unlock for io-wq is not super important, but adds some
ugliness in the code. More important, atomic decs not turning it to zero
for some archs won't give the right ordering/barriers so the
io_steal_work() may pretty easily get subtly and completely broken.

Return back 2-step io-wq work exchange and clean it up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 16 ++++++----------
 fs/io-wq.h    |  4 ++--
 fs/io_uring.c | 26 ++++----------------------
 3 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2e2f14f42bf2..63ef195b1acb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -555,23 +555,21 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 		/* handle a whole dependent link */
 		do {
-			struct io_wq_work *old_work, *next_hashed, *linked;
+			struct io_wq_work *next_hashed, *linked;
 			unsigned int hash = io_get_work_hash(work);
 
 			next_hashed = wq_next_work(work);
 			io_impersonate_work(worker, work);
+			wq->do_work(work);
+			io_assign_current_work(worker, NULL);
 
-			old_work = work;
-			linked = wq->do_work(work);
-
+			linked = wq->free_work(work);
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
 				work = linked;
 				linked = NULL;
 			}
 			io_assign_current_work(worker, work);
-			wq->free_work(old_work);
-
 			if (linked)
 				io_wqe_enqueue(wqe, linked);
 
@@ -850,11 +848,9 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 	struct io_wq *wq = wqe->wq;
 
 	do {
-		struct io_wq_work *old_work = work;
-
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work = wq->do_work(work);
-		wq->free_work(old_work);
+		wq->do_work(work);
+		work = wq->free_work(work);
 	} while (work);
 }
 
diff --git a/fs/io-wq.h b/fs/io-wq.h
index e1ffb80a4a1d..e37a0f217cc8 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -106,8 +106,8 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 	return container_of(work->list.next, struct io_wq_work, list);
 }
 
-typedef void (free_work_fn)(struct io_wq_work *);
-typedef struct io_wq_work *(io_wq_work_fn)(struct io_wq_work *);
+typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
+typedef void (io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_data {
 	struct user_struct *user;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ee6a9273fca..b740a39110d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2379,22 +2379,6 @@ static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
 		io_free_req_deferred(req);
 }
 
-static struct io_wq_work *io_steal_work(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt;
-
-	/*
-	 * A ref is owned by io-wq in which context we're. So, if that's the
-	 * last one, it's safe to steal next work. False negatives are Ok,
-	 * it just will be re-punted async in io_put_work()
-	 */
-	if (refcount_read(&req->refs) != 1)
-		return NULL;
-
-	nxt = io_req_find_next(req);
-	return nxt ? &nxt->work : NULL;
-}
-
 static void io_double_put_req(struct io_kiocb *req)
 {
 	/* drop both submit and complete references */
@@ -6343,7 +6327,7 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
-static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
+static void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *timeout;
@@ -6394,8 +6378,6 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 		if (lock_ctx)
 			mutex_unlock(&lock_ctx->uring_lock);
 	}
-
-	return io_steal_work(req);
 }
 
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
@@ -8067,12 +8049,12 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	return __io_sqe_files_update(ctx, &up, nr_args);
 }
 
-static void io_free_work(struct io_wq_work *work)
+static struct io_wq_work *io_free_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
-	/* Consider that io_steal_work() relies on this ref */
-	io_put_req(req);
+	req = io_put_req_find_next(req);
+	return req ? &req->work : NULL;
 }
 
 static int io_init_wq_offload(struct io_ring_ctx *ctx,
-- 
2.24.0

