Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1B38DB7C
	for <lists+io-uring@lfdr.de>; Sun, 23 May 2021 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhEWOuY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 May 2021 10:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhEWOuY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 May 2021 10:50:24 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127FFC061574
        for <io-uring@vger.kernel.org>; Sun, 23 May 2021 07:48:58 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a4so25876985wrr.2
        for <io-uring@vger.kernel.org>; Sun, 23 May 2021 07:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dlIGxBYz17m7cP1q2vfdu7B99m2ABtitQo/i2MJv9XI=;
        b=PPOh/+Vec5/tY/HtVu4Cg6Fwn39omgIb0Dg49Q3JIuXFFvqibg9woOAeBGWa53ZZo1
         PDUo2CkyZdfd/djvCC+m60nI0ln7Ea8BrM+7uoEOO95Fap1QXsK98sMvj38LvmqPaw80
         GzMf/m57S6o8O0Xufj2OypqI07Dff9Lx8JIT5FSAbbvTy/UTAEWXv47yqHjVKRkk1sLc
         JIt0NCrwUJ0eJYdVxZGF1RxJf+Ubitt9xqsepIzmyQlWrA3N1VwGVrQA7osP0Qu4MDnz
         M37eOm9VskdQE7nMNbppbms+cCqKvwjQGjhAP4NZOK+AvwMMxKMBGhE1VZCx1x1GCkWf
         +pSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dlIGxBYz17m7cP1q2vfdu7B99m2ABtitQo/i2MJv9XI=;
        b=sPMrI3Sf6P77GL1xRsRZ9kDzuD4P9cUKURvr94xhEuuu/C8cdO75mD1fnxueA+aQD1
         /YoFQwYp1DhKFDfutbEegko0RX4OLTsLVhNEvpG8QZfvBQ9ZJiIajFbTfwlFIzoVBIeP
         b2r3ZvR97qmSm0La/NgQCOCkRTLQvxHI0zOJUKDP7KFdHvqvuWOhXkILQvd9EeMTPxx0
         +6Dh1bqdvlaMe/OolObR9YW3e0cuTm98nyj+ctQ9tnrovtLqMrk4w/ZnWVDX2zBrm3zm
         UqA9ccz1pjK0yrK+ce2So7V4WI6sQnVoLrmQXKeP+GKmnNvoEqzsZxvL4g9LEWR6Yq/U
         /uhw==
X-Gm-Message-State: AOAM532+kd+UzsWuLVd5m5TINRr4CO8J/3QN/m2zMEMLsX8ucW7YCdh3
        c1b8xERW2LS87aBOERvBNWzFpog7WLQzeE3l
X-Google-Smtp-Source: ABdhPJywLMptwCN/7PE122kpzncCO3wHr0cip3QMJxMgvVg++fXfyb7+zxOGDASRNQMV1TS+6gkKfQ==
X-Received: by 2002:adf:edc8:: with SMTP id v8mr6309729wro.77.1621781336682;
        Sun, 23 May 2021 07:48:56 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.65])
        by smtp.gmail.com with ESMTPSA id h14sm10984036wrq.45.2021.05.23.07.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 07:48:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/io-wq: close io-wq full-stop gap
Date:   Sun, 23 May 2021 15:48:39 +0100
Message-Id: <abfcf8c54cb9e8f7bfbad7e9a0cc5433cc70bdc2.1621781238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is an old problem with io-wq cancellation where requests should be
killed and are in io-wq but are not discoverable, e.g. in @next_hashed
or @linked vars of io_worker_handle_work(). It adds some unreliability
to individual request canellation, but also may potentially get
__io_uring_cancel() stuck. For instance:

1) An __io_uring_cancel()'s cancellation round have not found any
   request but there are some as desribed.
2) __io_uring_cancel() goes to sleep
3) Then workers wake up and try to execute those hidden requests
   that happen to be unbound.

As we already cancel all requests of io-wq there, set IO_WQ_BIT_EXIT
in advance, so preventing 3) from executing unbound requests. The
workers will initially break looping because of getting a signal as they
are threads of the dying/exec()'ing user task.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

p.s. hard to tell the exact commit to blame due to all the changes
in cancellation schemes

 fs/io-wq.c    | 20 +++++++++-----------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c |  6 ++++++
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5361a9b4b47b..de9b7ba3ba01 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -979,13 +979,16 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
 	return cwd->wqe->wq == data;
 }
 
+void io_wq_exit_start(struct io_wq *wq)
+{
+	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+}
+
 static void io_wq_exit_workers(struct io_wq *wq)
 {
 	struct callback_head *cb;
 	int node;
 
-	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-
 	if (!wq->task)
 		return;
 
@@ -1020,8 +1023,6 @@ static void io_wq_destroy(struct io_wq *wq)
 
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
-	io_wq_exit_workers(wq);
-
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 		struct io_cb_cancel_data match = {
@@ -1036,16 +1037,13 @@ static void io_wq_destroy(struct io_wq *wq)
 	kfree(wq);
 }
 
-void io_wq_put(struct io_wq *wq)
-{
-	if (refcount_dec_and_test(&wq->refs))
-		io_wq_destroy(wq);
-}
-
 void io_wq_put_and_exit(struct io_wq *wq)
 {
+	WARN_ON_ONCE(!test_bit(IO_WQ_BIT_EXIT, &wq->state));
+
 	io_wq_exit_workers(wq);
-	io_wq_put(wq);
+	if (refcount_dec_and_test(&wq->refs))
+		io_wq_destroy(wq);
 }
 
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 0e6d310999e8..af2df0680ee2 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -122,7 +122,7 @@ struct io_wq_data {
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
-void io_wq_put(struct io_wq *wq);
+void io_wq_exit_start(struct io_wq *wq);
 void io_wq_put_and_exit(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f82954004f6..6af8ca0cb01c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9078,6 +9078,9 @@ static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 
 	if (!current->io_uring)
 		return;
+	if (tctx->io_wq)
+		io_wq_exit_start(tctx->io_wq);
+
 	WARN_ON_ONCE(!sqd || sqd->thread != current);
 
 	atomic_inc(&tctx->in_idle);
@@ -9112,6 +9115,9 @@ void __io_uring_cancel(struct files_struct *files)
 	DEFINE_WAIT(wait);
 	s64 inflight;
 
+	if (tctx->io_wq)
+		io_wq_exit_start(tctx->io_wq);
+
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 	do {
-- 
2.31.1

