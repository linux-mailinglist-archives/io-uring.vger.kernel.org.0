Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD0532C9AA
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhCDBKA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390879AbhCDAci (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:32:38 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8BAC0613BF
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:18 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o10so17649274pgg.4
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OfyTT6Xqnf9D6Pxl5x8VUYDk3wXwC2KBSjn6ryVznuI=;
        b=Ao4PYEK8pI2mW5SxwjsIxlHXzlYIcH6fE0OsaTw6y/HCsllT4RIJX8splJ73XHY79u
         wA9A7sIni7vAPHUkngQPJrnVDYlwKAeHYY8s4W4LTOp5lhAGnt+s3p8n0p8x0CF7SiFd
         mJtTDLdH6pZ9yI07a5d3DfwBPl8Jr+K2q3PTTHZ7svfYtzduzikOcWseq6+vG1xEuYu+
         BD3PpQ3QHJf0D6UU2mIpFJ1OClWcaUPb8qi0uo5e2sScqd7vid9QYPYnWcdX1c1Ex9my
         RsHTre3Vq7ey8Dt0VXl02YyWghBdMpAgRsJGauwj03LI/bksHX3epJRfwwa/ADq8qLL9
         qLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OfyTT6Xqnf9D6Pxl5x8VUYDk3wXwC2KBSjn6ryVznuI=;
        b=Tm0zT4+ADpSV5+NtGQaPQodZZI5LIIv35HUqm0wtHv00rAgTqnKEnJeyzJIXvWdWUo
         Q8NBlfnqi1i7cdrUsCY2KciNcYHbg++C3DXzj/cXJbQgD+wLwgRcT7Ob8mQlr6fZe1Hn
         yqS6Wh2LmdFr4I5eE87GyHTAcWsBZSrH/F3Za0Rnj9NaL4JTEfW3Z4Q1WGDKuo7GjwHI
         U1jgXt/yY8+DJqSopf1leui8CJGl0aDggI8CdOyAjnCXxDisGaa8xRVPUjhvkB4+86v0
         C5hIKBj644ScDo4Yyf7CfwnFoOESc0AEtE2hjehNKn7DiTt9xl0AAWYpxmbvI5tiilpx
         TWiw==
X-Gm-Message-State: AOAM533W3U4W6eFT0BImqKhMSGBbRzjqPxV/pcMVizDLckXIATuGG462
        XBUDD8k6FEANhEaCZ5Jtd5GiUWBFa89wzkQJ
X-Google-Smtp-Source: ABdhPJwqszvFhHNRBVe8BYaaMky2yitHmgDBBaQQtCi9L/sestCUWFDsh+62sOC+cNCvZuIstNHTzw==
X-Received: by 2002:a65:4141:: with SMTP id x1mr1267569pgp.421.1614817637311;
        Wed, 03 Mar 2021 16:27:17 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:16 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/33] io-wq: provide an io_wq_put_and_exit() helper
Date:   Wed,  3 Mar 2021 17:26:37 -0700
Message-Id: <20210304002700.374417-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we put the io-wq from io_uring, we really want it to exit. Provide
a helper that does that for us. Couple that with not having the manager
hold a reference to the 'wq' and the normal SQPOLL exit will tear down
the io-wq context appropriate.

On the io-wq side, our wq context is per task, so only the task itself
is manipulating ->manager and hence it's safe to check and clear without
any extra locking. We just need to ensure that the manager task stays
around, in case it exits.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 29 +++++++++++++++++++----------
 fs/io-wq.h    |  1 +
 fs/io_uring.c |  2 +-
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 23f431747cd2..65ae35ca8dba 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -748,7 +748,7 @@ static int io_wq_manager(void *data)
 	sprintf(buf, "iou-mgr-%d", wq->task_pid);
 	set_task_comm(current, buf);
 	current->flags |= PF_IO_WORKER;
-	wq->manager = current;
+	wq->manager = get_task_struct(current);
 
 	complete(&wq->started);
 
@@ -764,9 +764,7 @@ static int io_wq_manager(void *data)
 	/* we might not ever have created any workers */
 	if (atomic_read(&wq->worker_refs))
 		wait_for_completion(&wq->worker_done);
-	wq->manager = NULL;
 	complete(&wq->exited);
-	io_wq_put(wq);
 	do_exit(0);
 }
 
@@ -809,8 +807,6 @@ static int io_wq_fork_manager(struct io_wq *wq)
 		return 0;
 
 	reinit_completion(&wq->worker_done);
-	clear_bit(IO_WQ_BIT_EXIT, &wq->state);
-	refcount_inc(&wq->refs);
 	current->flags |= PF_IO_WORKER;
 	ret = io_wq_fork_thread(io_wq_manager, wq);
 	current->flags &= ~PF_IO_WORKER;
@@ -1082,6 +1078,16 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	return ERR_PTR(ret);
 }
 
+static void io_wq_destroy_manager(struct io_wq *wq)
+{
+	if (wq->manager) {
+		wake_up_process(wq->manager);
+		wait_for_completion(&wq->exited);
+		put_task_struct(wq->manager);
+		wq->manager = NULL;
+	}
+}
+
 static void io_wq_destroy(struct io_wq *wq)
 {
 	int node;
@@ -1089,10 +1095,7 @@ static void io_wq_destroy(struct io_wq *wq)
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-	if (wq->manager) {
-		wake_up_process(wq->manager);
-		wait_for_completion(&wq->exited);
-	}
+	io_wq_destroy_manager(wq);
 
 	rcu_read_lock();
 	for_each_node(node)
@@ -1110,7 +1113,6 @@ static void io_wq_destroy(struct io_wq *wq)
 	io_wq_put_hash(wq->hash);
 	kfree(wq->wqes);
 	kfree(wq);
-
 }
 
 void io_wq_put(struct io_wq *wq)
@@ -1119,6 +1121,13 @@ void io_wq_put(struct io_wq *wq)
 		io_wq_destroy(wq);
 }
 
+void io_wq_put_and_exit(struct io_wq *wq)
+{
+	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+	io_wq_destroy_manager(wq);
+	io_wq_put(wq);
+}
+
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
 {
 	struct task_struct *task = worker->task;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index b6ca12b60c35..f6ef433df8a8 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -114,6 +114,7 @@ struct io_wq_data {
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
 void io_wq_put(struct io_wq *wq);
+void io_wq_put_and_exit(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 904bf0fecc36..cb65e54c1b09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8857,7 +8857,7 @@ void __io_uring_files_cancel(struct files_struct *files)
 	if (files) {
 		io_uring_remove_task_files(tctx);
 		if (tctx->io_wq) {
-			io_wq_put(tctx->io_wq);
+			io_wq_put_and_exit(tctx->io_wq);
 			tctx->io_wq = NULL;
 		}
 	}
-- 
2.30.1

