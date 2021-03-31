Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F39350AA3
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 01:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCaXW4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 19:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhCaXWr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 19:22:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A83FC061574
        for <io-uring@vger.kernel.org>; Wed, 31 Mar 2021 16:22:47 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z2so21248865wrl.5
        for <io-uring@vger.kernel.org>; Wed, 31 Mar 2021 16:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4wW2JcqEh97IdBeuUyJTZKK7yRDMpDHl41cu8XCfjuI=;
        b=d+bIwTYG1dXyN2IV/1d5JhjCxEMYHsbOyj47jIN1v7VWkNCC5ZWeFaz3FVFSpnVO4A
         l6LRBi+zCpg55LQrrY1HwYmkkteDhffb/l5dC0zqKda+8cC4DxYqQewVw/oTAnzmGlbm
         iJVnHx6aIXgZ2zf7icLbQyRZ6VfTXvx822lO9wv2fEMTrzWheNIXPYLb7D50f7GlXqsm
         LIb/AcdimyLAuU1TdXIB6siR8jCs04ykrYWJlc5lzH9sRRVPifmubfXJjli8reL15JGl
         PbBrCEHZsVL+5TibEIReVxODlGl+1txyoIc7DRywr6YmTHFT+9waI1a/ZjT0yEuzmn5U
         MbVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4wW2JcqEh97IdBeuUyJTZKK7yRDMpDHl41cu8XCfjuI=;
        b=ZLmLDPe82H+MfeN81Ra46/41P9WTdxk9ziUNBYE7TMpujqbdn/o2Xr5goCIEZzoiGs
         2Qmem9hOzZeVlPW2evXSF6/8yI6n99SgIDLjrffim8A+7+Jqc6JzifkTvMx2vmIzJNVZ
         8hkAPtmspBha0XIppNFoSmtbJFoBoTuDspmmd/FcnoxiaSFBck7o9/wcMkmSdjidQ8f8
         6SK+A6XmYlkvUlT3MJcYY+zGSn3pUpgiQ3sszVXoP8r4m+uwB7aL0bQ5l4l6nxzEuZ8x
         8ldj0t1/gijgq5ly+pcF41eYA2NPVoMRbVamk8jfWlQL1QcJPZb363xS3z8Eh27iPdn3
         NDPg==
X-Gm-Message-State: AOAM533DaAwVBZL6Nx5eFrKDaK7lnsACkiqeEN5qH/xON+n1v1uK6Joo
        oNc2/5a5BQLpJj/hT2Wf1uvYWI+Ji8Qf3A==
X-Google-Smtp-Source: ABdhPJyq7LMGmatNht3PbEx2Klfcnpq5u3vXeLSZT6V3FXER+W4rcpXSY/7DgqmQzyYD31wcfsJFaA==
X-Received: by 2002:a5d:564b:: with SMTP id j11mr6264456wrw.326.1617232966265;
        Wed, 31 Mar 2021 16:22:46 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id w22sm6236845wmi.22.2021.03.31.16.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 16:22:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] io-wq: forcefully cancel on io-wq destroy
Date:   Thu,  1 Apr 2021 00:18:34 +0100
Message-Id: <e8330d71aad136224b2f3a7f479121a32b496836.1617232645.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[  491.222908] INFO: task thread-exit:2490 blocked for more than 122 seconds.
[  491.222957] Call Trace:
[  491.222967]  __schedule+0x36b/0x950
[  491.222985]  schedule+0x68/0xe0
[  491.222994]  schedule_timeout+0x209/0x2a0
[  491.223003]  ? tlb_flush_mmu+0x28/0x140
[  491.223013]  wait_for_completion+0x8b/0xf0
[  491.223023]  io_wq_destroy_manager+0x24/0x60
[  491.223037]  io_wq_put_and_exit+0x18/0x30
[  491.223045]  io_uring_clean_tctx+0x76/0xa0
[  491.223061]  __io_uring_files_cancel+0x1b9/0x2e0
[  491.223068]  ? blk_finish_plug+0x26/0x40
[  491.223085]  do_exit+0xc0/0xb40
[  491.223099]  ? syscall_trace_enter.isra.0+0x1a1/0x1e0
[  491.223109]  __x64_sys_exit+0x1b/0x20
[  491.223117]  do_syscall_64+0x38/0x50
[  491.223131]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  491.223177] INFO: task iou-mgr-2490:2491 blocked for more than 122 seconds.
[  491.223194] Call Trace:
[  491.223198]  __schedule+0x36b/0x950
[  491.223206]  ? pick_next_task_fair+0xcf/0x3e0
[  491.223218]  schedule+0x68/0xe0
[  491.223225]  schedule_timeout+0x209/0x2a0
[  491.223236]  wait_for_completion+0x8b/0xf0
[  491.223246]  io_wq_manager+0xf1/0x1d0
[  491.223255]  ? recalc_sigpending+0x1c/0x60
[  491.223265]  ? io_wq_cpu_online+0x40/0x40
[  491.223272]  ret_from_fork+0x22/0x30

When io-wq worker exits and sees IO_WQ_BIT_EXIT it tries not cancel all
left requests but to execute them, hence we may wait for the exiting
task for long until someone pushes it, e.g. with SIGKILL. Actively
cancel pending work items on io-wq destruction.

note: io_run_cancel() moved up without any changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: fix broken last minute change

 fs/io-wq.c | 50 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 7434eb40ca8c..45771bc06651 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -342,6 +342,20 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	spin_unlock(&wq->hash->wait.lock);
 }
 
+static struct io_wq_work *io_get_work_all(struct io_wqe *wqe)
+	__must_hold(wqe->lock)
+{
+	struct io_wq_work_list *list = &wqe->work_list;
+	struct io_wq_work_node *node = list->first;
+	int i;
+
+	list->first = list->last = NULL;
+	for (i = 0; i < IO_WQ_NR_HASH_BUCKETS; i++)
+		wqe->hash_tail[i] = NULL;
+
+	return node ? container_of(node, struct io_wq_work, list) : NULL;
+}
+
 static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 	__must_hold(wqe->lock)
 {
@@ -410,6 +424,17 @@ static void io_assign_current_work(struct io_worker *worker,
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
+static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
+{
+	struct io_wq *wq = wqe->wq;
+
+	do {
+		work->flags |= IO_WQ_WORK_CANCEL;
+		wq->do_work(work);
+		work = wq->free_work(work);
+	} while (work);
+}
+
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
@@ -518,11 +543,17 @@ static int io_wqe_worker(void *data)
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
+		struct io_wq_work *work, *next;
+
 		raw_spin_lock_irq(&wqe->lock);
-		if (!wq_list_empty(&wqe->work_list))
-			io_worker_handle_work(worker);
-		else
-			raw_spin_unlock_irq(&wqe->lock);
+		work = io_get_work_all(wqe);
+		raw_spin_unlock_irq(&wqe->lock);
+
+		while (work) {
+			next = wq_next_work(work);
+			io_run_cancel(work, wqe);
+			work = next;
+		}
 	}
 
 	io_worker_exit(worker);
@@ -748,17 +779,6 @@ static int io_wq_manager(void *data)
 	do_exit(0);
 }
 
-static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
-{
-	struct io_wq *wq = wqe->wq;
-
-	do {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		wq->do_work(work);
-		work = wq->free_work(work);
-	} while (work);
-}
-
 static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	unsigned int hash;
-- 
2.24.0

