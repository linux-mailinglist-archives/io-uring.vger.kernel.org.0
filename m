Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AC01F1EB7
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 20:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgFHSJ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 14:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgFHSJz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 14:09:55 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5904DC08C5C4;
        Mon,  8 Jun 2020 11:09:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id k8so14206759edq.4;
        Mon, 08 Jun 2020 11:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=egrr6PTch3v8cncSJtFi2bP6BgWEfZPz43Zfda3r4QU=;
        b=GULwThv8DfdRtDiNhdL0oVaHQ1+uKVuxReQpzOUfVNn7vVUpwHXNbsK6i+6GirfEx2
         NIPfiyx+mB96CsanfD8RJYNH/6aGh//KmHwtiKE25lxpS/SRTzEx0fDjY1Co4/fryFgA
         ylrnFN0iFgrxw262ZSd0xJ6eMfgjf4Jd0qlE4zfrfq8HPrukq4j3kMZrvb6HblwhFUxu
         W57lvTSLxLixxOTDmwxrmePcwy2sbtj5eErx46XBijGsxnK5CHHP66EM8rJHmG7Ssf2z
         2JijqRoaInnhSsgspOjysSyM/k5/zvvR7m7QtjdTsGh1ETA2WLzPn3MqBHM6dyqeuLJp
         9weg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=egrr6PTch3v8cncSJtFi2bP6BgWEfZPz43Zfda3r4QU=;
        b=kqyryZ0xGJDK5i74xUnURc4/WOYYOc9fCBv0/LoH6kcPOyRA0bFL9MHmZ32+iM1mff
         d0l7VwBDxHbtt5BPoDkuE9keB0aH0nx/pvy7itT0R7yAMgrhqfJK0VtMezN2tMHh/Bzz
         ffO71VdWy9HAsm8Sipu8J2uogwpGLcX1N/0fCIFC6Bgfv5oYT/80u2AaZ5fM+3D3Bbef
         gK20uaiHTFnRe12LL3aF5D+3T6TmspJU5wwZmsGTt04NXJQTzWiyomAV+n4ZWELzM33b
         cmzWUTpohjRqKSgnDGvFaMpUPgHb/6fDmO94U+5pSoPo/U+q9uWbgBQ/J2d8h0hMTJ+5
         co5w==
X-Gm-Message-State: AOAM533YxeSWw1iSFaoo3IG+MOd/QECI9Bho1C/PJFOJD8ueb8kLU1rH
        N+x8reNI/g6C1x7FpCpPcKzk1Vmm
X-Google-Smtp-Source: ABdhPJxbStuRrWCjwifwUx/Z4Ul0ylCP0F0WnYotPea51KbavH8Rhu2X63Xv4OFa+H7iqTFS6MTPyA==
X-Received: by 2002:a50:a0e5:: with SMTP id 92mr23641540edo.313.1591639793688;
        Mon, 08 Jun 2020 11:09:53 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id ok21sm10515029ejb.82.2020.06.08.11.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 11:09:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, xiaoguang.wang@linux.alibaba.com
Subject: [PATCH 4/4] io_wq: add per-wq work handler instead of per work
Date:   Mon,  8 Jun 2020 21:08:20 +0300
Message-Id: <531ae5365ab0093d7b599027e0a5536bc52d35f8.1591637070.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591637070.git.asml.silence@gmail.com>
References: <cover.1591637070.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring is the only user of io-wq, and now it uses only io-wq callback
for all its requests, namely io_wq_submit_work(). Instead of storing
work->runner callback in each instance of io_wq_work, keep it in io-wq
itself.

pros:
- reduces io_wq_work size
- more robust -- ->func won't be invalidated with mem{cpy,set}(req)
- helps other work

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 10 ++++++----
 fs/io-wq.h    |  7 ++++---
 fs/io_uring.c |  3 ++-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2bfa9117bc28..a44ad3b98886 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -112,6 +112,7 @@ struct io_wq {
 	unsigned long state;
 
 	free_work_fn *free_work;
+	io_wq_work_fn *do_work;
 
 	struct task_struct *manager;
 	struct user_struct *user;
@@ -528,7 +529,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 			hash = io_get_work_hash(work);
 			linked = old_work = work;
-			linked->func(&linked);
+			wq->do_work(&linked);
 			linked = (old_work == linked) ? NULL : linked;
 
 			work = next_hashed;
@@ -785,7 +786,7 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 		struct io_wq_work *old_work = work;
 
 		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		wq->do_work(&work);
 		work = (work == old_work) ? NULL : work;
 		wq->free_work(old_work);
 	} while (work);
@@ -1027,7 +1028,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	int ret = -ENOMEM, node;
 	struct io_wq *wq;
 
-	if (WARN_ON_ONCE(!data->free_work))
+	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
@@ -1041,6 +1042,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	}
 
 	wq->free_work = data->free_work;
+	wq->do_work = data->do_work;
 
 	/* caller must already hold a reference to this */
 	wq->user = data->user;
@@ -1097,7 +1099,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
 {
-	if (data->free_work != wq->free_work)
+	if (data->free_work != wq->free_work || data->do_work != wq->do_work)
 		return false;
 
 	return refcount_inc_not_zero(&wq->use_refs);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index df8a4cd3236d..f3bb596f5a3f 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -85,7 +85,6 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	void (*func)(struct io_wq_work **);
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
@@ -94,9 +93,9 @@ struct io_wq_work {
 	pid_t task_pid;
 };
 
-#define INIT_IO_WORK(work, _func)				\
+#define INIT_IO_WORK(work)					\
 	do {							\
-		*(work) = (struct io_wq_work){ .func = _func };	\
+		*(work) = (struct io_wq_work){};		\
 	} while (0)						\
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
@@ -108,10 +107,12 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 }
 
 typedef void (free_work_fn)(struct io_wq_work *);
+typedef void (io_wq_work_fn)(struct io_wq_work **);
 
 struct io_wq_data {
 	struct user_struct *user;
 
+	io_wq_work_fn *do_work;
 	free_work_fn *free_work;
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index adf18ff9fdb9..b4ca6026269c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5880,7 +5880,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
 	req->result = 0;
-	INIT_IO_WORK(&req->work, io_wq_submit_work);
+	INIT_IO_WORK(&req->work);
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
@@ -6896,6 +6896,7 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 
 	data.user = ctx->user;
 	data.free_work = io_free_work;
+	data.do_work = io_wq_submit_work;
 
 	if (!(p->flags & IORING_SETUP_ATTACH_WQ)) {
 		/* Do QD, or 4 * CPUS, whatever is smallest */
-- 
2.24.0

