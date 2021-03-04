Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9A32C9B1
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241789AbhCDBKW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451123AbhCDAfy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:35:54 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C96C05BD43
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:45 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id l7so13327750pfd.3
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rtW84DVCjingAdj27X/KaLsRWoHRR+chXSLB7a3hB3o=;
        b=qyR5hi0dAQmiMamTgKkWPoHE2xv6SHteDMb3/DI9Y2EXq0jeqomqGBYzySoaqZBVcn
         9HqGujFDzM5yEjLWouj38NCOcOiKok71xzdoO+c5LrIUVQMsK8p48MUY8WFyuF9EypxD
         ikq6PzPvD5M13glmtFvlLdYTh/Xq1EPLIXzLeYRtCf/EfoV0Qd046Qbp1//y8v0AifDd
         al9D6pyyOfS3bfIshS85sMjSlTtNvnO413IymkBavga2t3Oumws7VTvpQj6fenpcd3lp
         tIsAEFNsKzB6BXK/zHZSCP7ptxKVfAQ3m1b5929N5Ac2cBJ+RWQBLO4Nlq8kn2FunAfl
         T9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rtW84DVCjingAdj27X/KaLsRWoHRR+chXSLB7a3hB3o=;
        b=CSB2oEgorQLUhZrjKVF0SCChDxEZRheVMmGXQfvtfOz3FGQyZ2L3H2V0LCbLKUp/Sp
         JpCAKCAzdDS20+3I43vb9K5p92MpEASZqvA83qJPB3IQc19J1w5ZOX0pTtxRyDkNXf+f
         XxJoLnZYLclZQosAyW3axUPi/RKyeDeYKVASC4G7wlEArbeZ/L9KnNYypYkCx/v+Gbs2
         j4qyIoMnWJoNL1Biq3HLEEMzAGgbP01W6DeXxnb9P6L+cq2k/uDGG2tqHenGU6XRRCz5
         iGFVxZLnOnqWn9s5e5pxV2utxBFkOLTfLRpMN9ols+TqvrkFXDtFkaTEARwyX+g/eeJP
         UVGA==
X-Gm-Message-State: AOAM5325t5G1NmhxkSOHCTl9aJq+H06CM+VWTYkKHctMZ8AiCWQb4F82
        rwAjQ17oFAGMsNSlmPzFZJ6jl6wtezi6BKzI
X-Google-Smtp-Source: ABdhPJwXUcGdIllkPh2LqWB6QQwWQI9ov4N2VhzdvHbMembSzvLYyihQPX2NeVKPbnmeooEarKdzSg==
X-Received: by 2002:a05:6a00:894:b029:1dc:2f68:5f0 with SMTP id q20-20020a056a000894b02901dc2f6805f0mr1234290pfj.23.1614817665090;
        Wed, 03 Mar 2021 16:27:45 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+91b4b56ead187d35c9d3@syzkaller.appspotmail.com
Subject: [PATCH 33/33] io-wq: ensure all pending work is canceled on exit
Date:   Wed,  3 Mar 2021 17:27:00 -0700
Message-Id: <20210304002700.374417-34-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we race on shutting down the io-wq, then we should ensure that any
work that was queued after workers shutdown is canceled. Harden the
add work check a bit too, checking for IO_WQ_BIT_EXIT and cancel if
it's set.

Add a WARN_ON() for having any work before we kill the io-wq context.

Reported-by: syzbot+91b4b56ead187d35c9d3@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a44bd22c045e..6d57f9b80213 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -129,6 +129,17 @@ struct io_wq {
 
 static enum cpuhp_state io_wq_online;
 
+struct io_cb_cancel_data {
+	work_cancel_fn *fn;
+	void *data;
+	int nr_running;
+	int nr_pending;
+	bool cancel_all;
+};
+
+static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match);
+
 static bool io_worker_get(struct io_worker *worker)
 {
 	return refcount_inc_not_zero(&worker->ref);
@@ -713,6 +724,23 @@ static void io_wq_check_workers(struct io_wq *wq)
 	}
 }
 
+static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
+{
+	return true;
+}
+
+static void io_wq_cancel_pending(struct io_wq *wq)
+{
+	struct io_cb_cancel_data match = {
+		.fn		= io_wq_work_match_all,
+		.cancel_all	= true,
+	};
+	int node;
+
+	for_each_node(node)
+		io_wqe_cancel_pending_work(wq->wqes[node], &match);
+}
+
 /*
  * Manager thread. Tasked with creating new workers, if we need them.
  */
@@ -748,6 +776,8 @@ static int io_wq_manager(void *data)
 	/* we might not ever have created any workers */
 	if (atomic_read(&wq->worker_refs))
 		wait_for_completion(&wq->worker_done);
+
+	io_wq_cancel_pending(wq);
 	complete(&wq->exited);
 	do_exit(0);
 }
@@ -809,7 +839,8 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	unsigned long flags;
 
 	/* Can only happen if manager creation fails after exec */
-	if (unlikely(io_wq_fork_manager(wqe->wq))) {
+	if (io_wq_fork_manager(wqe->wq) ||
+	    test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state)) {
 		work->flags |= IO_WQ_WORK_CANCEL;
 		wqe->wq->do_work(work);
 		return;
@@ -845,14 +876,6 @@ void io_wq_hash_work(struct io_wq_work *work, void *val)
 	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
 }
 
-struct io_cb_cancel_data {
-	work_cancel_fn *fn;
-	void *data;
-	int nr_running;
-	int nr_pending;
-	bool cancel_all;
-};
-
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
@@ -1086,6 +1109,7 @@ static void io_wq_destroy(struct io_wq *wq)
 		struct io_wqe *wqe = wq->wqes[node];
 
 		list_del_init(&wqe->wait.entry);
+		WARN_ON_ONCE(!wq_list_empty(&wqe->work_list));
 		kfree(wqe);
 	}
 	spin_unlock_irq(&wq->hash->wait.lock);
-- 
2.30.1

