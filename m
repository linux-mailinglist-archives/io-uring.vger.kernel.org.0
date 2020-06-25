Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84E420A1CC
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 17:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405777AbgFYPXO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 11:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405760AbgFYPXM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 11:23:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B026AC08C5C1;
        Thu, 25 Jun 2020 08:23:11 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so6275617wrm.4;
        Thu, 25 Jun 2020 08:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=X8M6Z9iS/wBC6CKH2GRHd5qZp57FkKWtOwBt90Zk34A=;
        b=eGGX204qFkOgyfuDXmuEIHM3gp2j6rzf6EVhLDf2lT4vUGzyo4LoVxjk5IDG5T/HgV
         SHimEsv/KFvCv2upk6p5TQ390K8YusD35xhmdERCP8hevDc/3N7fiKYsyqlCpwxcJNTL
         fV2AObbJaTbEN8bxHJZRxk58LgI0PlNboQZh1Tn68esJ3FSkZGyoCkncLRRlkyrXbuld
         afGWQ1KWnI8r9P8z1Is4xIf+DBfjVP67ziRjXCxl5sKm+69jmK3PRHBmkvNbvB1T8Gd4
         M0eOcCgRCGXK9eQlZTvrfe9RlBulIJpxQjT6+5BxJ1PXQ9b17QFXLVLbtVQPYN/Gu4Vw
         6xxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X8M6Z9iS/wBC6CKH2GRHd5qZp57FkKWtOwBt90Zk34A=;
        b=brhjRVW/pdNcptaT0fbiOOh7hWyQ/bQ7ZfhpAM/dli7px/+GpTwukYovrIQcuVjY24
         LzeRpvi8eUxJ8vn28CYKUqx0ZpojmZUNComHb2vUzLcPkHVNo6/qyEbBEvmQPXv4fYf/
         2j8J8iUMA1DNBZwYlK5bkfd0i59CPp6FldR9mGT4WtFolbhIinSA6lZHeUncOtYg884a
         lgfR3PS3jpyXfDWzBbPh9AzAHOG8nub9mIhfQE6hSFi87+2yjvey0Gb4lZ9sWO8W7vUR
         YD10pM7++YW37h1P7gnFtjJDAK4eNZgSiV/boMAc3MUX4n/Tski5kuLCgLPZ3PMTwGwB
         vyMw==
X-Gm-Message-State: AOAM533GObuj7mYDEFYrrthBf4/Tvk09nSeZQC3896xS/izaxPUEfNVW
        lp2yeDCSN/AV8xhKEWj0/uEpQIz1
X-Google-Smtp-Source: ABdhPJzM93nI+H9Ck3LePOxdqtbGMfMU0BS4r+j7X5nPzR4AuPATmo/3bvl9L036VUGx/3t/0qsCeg==
X-Received: by 2002:adf:e8ce:: with SMTP id k14mr35021864wrn.93.1593098590375;
        Thu, 25 Jun 2020 08:23:10 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id r1sm31560403wrn.29.2020.06.25.08.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:23:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io-wq: return next work from ->do_work() directly
Date:   Thu, 25 Jun 2020 18:20:54 +0300
Message-Id: <e55e676995251f1269de6e69ac7ab42d3b04aff5.1593095572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593095572.git.asml.silence@gmail.com>
References: <cover.1593095572.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's easier to return next work from ->do_work() than
having an in-out argument. Looks nicer and easier to compile.
Also, merge io_wq_assign_next() into its only user.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    |  8 +++-----
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 53 ++++++++++++++++++++-------------------------------
 3 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 47c5f3aeb460..72f759e1d6eb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -523,9 +523,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 				work->flags |= IO_WQ_WORK_CANCEL;
 
 			hash = io_get_work_hash(work);
-			linked = old_work = work;
-			wq->do_work(&linked);
-			linked = (old_work == linked) ? NULL : linked;
+			old_work = work;
+			linked = wq->do_work(work);
 
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
@@ -781,8 +780,7 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 		struct io_wq_work *old_work = work;
 
 		work->flags |= IO_WQ_WORK_CANCEL;
-		wq->do_work(&work);
-		work = (work == old_work) ? NULL : work;
+		work = wq->do_work(work);
 		wq->free_work(old_work);
 	} while (work);
 }
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 04239dfb12b0..114f12ec2d65 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -101,7 +101,7 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 }
 
 typedef void (free_work_fn)(struct io_wq_work *);
-typedef void (io_wq_work_fn)(struct io_wq_work **);
+typedef struct io_wq_work *(io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_data {
 	struct user_struct *user;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e7b1e696fecd..62130dfbc0e7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -884,7 +884,6 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
-static void io_wq_submit_work(struct io_wq_work **workptr);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
@@ -1623,20 +1622,6 @@ static void io_free_req(struct io_kiocb *req)
 		io_queue_async_work(nxt);
 }
 
-static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
-{
-	struct io_kiocb *link;
-	const struct io_op_def *def = &io_op_defs[nxt->opcode];
-
-	if ((nxt->flags & REQ_F_ISREG) && def->hash_reg_file)
-		io_wq_hash_work(&nxt->work, file_inode(nxt->file));
-
-	*workptr = &nxt->work;
-	link = io_prep_linked_timeout(nxt);
-	if (link)
-		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
-}
-
 /*
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
@@ -1656,24 +1641,29 @@ static void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static void io_steal_work(struct io_kiocb *req,
-			  struct io_wq_work **workptr)
+static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 {
+	struct io_kiocb *link, *nxt = NULL;
+
 	/*
-	 * It's in an io-wq worker, so there always should be at least
-	 * one reference, which will be dropped in io_put_work() just
-	 * after the current handler returns.
-	 *
-	 * It also means, that if the counter dropped to 1, then there is
-	 * no asynchronous users left, so it's safe to steal the next work.
+	 * A ref is owned by io-wq in which context we're. So, if that's the
+	 * last one, it's safe to steal next work. False negatives are Ok,
+	 * it just will be re-punted async in io_put_work()
 	 */
-	if (refcount_read(&req->refs) == 1) {
-		struct io_kiocb *nxt = NULL;
+	if (refcount_read(&req->refs) != 1)
+		return NULL;
 
-		io_req_find_next(req, &nxt);
-		if (nxt)
-			io_wq_assign_next(workptr, nxt);
-	}
+	io_req_find_next(req, &nxt);
+	if (!nxt)
+		return NULL;
+
+	if ((nxt->flags & REQ_F_ISREG) && io_op_defs[nxt->opcode].hash_reg_file)
+		io_wq_hash_work(&nxt->work, file_inode(nxt->file));
+
+	link = io_prep_linked_timeout(nxt);
+	if (link)
+		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
+	return &nxt->work;
 }
 
 /*
@@ -5631,9 +5621,8 @@ static void io_arm_async_linked_timeout(struct io_kiocb *req)
 	io_queue_linked_timeout(link);
 }
 
-static void io_wq_submit_work(struct io_wq_work **workptr)
+static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 {
-	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	int ret = 0;
 
@@ -5665,7 +5654,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_put_req(req);
 	}
 
-	io_steal_work(req, workptr);
+	return io_steal_work(req);
 }
 
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
-- 
2.24.0

