Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B1C34F128
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 20:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhC3SnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 14:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhC3Smv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 14:42:51 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEF1C061574
        for <io-uring@vger.kernel.org>; Tue, 30 Mar 2021 11:42:51 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o16so17262205wrn.0
        for <io-uring@vger.kernel.org>; Tue, 30 Mar 2021 11:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KpawMTqFvyHSByTzXNTfN2vYVD0vzvue+YbeF3dKsKM=;
        b=mTou7u5VmtC+5P4ru/rhrsXdQV/cLJR67mrmkZozPtle8O9G9AVl68LXtvN9cIbKeW
         nXyndNdSfm2CMpk2RYz0diQi8/ljdibpIyaIZGKYxagID1p8a9xFqJqcV5vzHWPDrXNO
         SiQTUUlv04+hzWqBZXEoJgwpxd2cE/W2S8Yus7agfxntgSQEymCl4412ZA0pFmtcJhhT
         Tb/XgJudxbAZYBMAfzuX0foMko7L5+9D0RiWF51Pu6AEI/j3sWOhbBTKPP07fRGGHlwd
         57nUab0kTcetjBRYXriWMhzohU2+/Y+KXuyk0LMDwWx1+Iw2DEbgMcX//3/NY+0cdoX6
         iQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KpawMTqFvyHSByTzXNTfN2vYVD0vzvue+YbeF3dKsKM=;
        b=uf7VJAeQEHm4kWhfaNHph1D/SmG+VOoLCHxGuk9Twz8j8fSY8iXn1F+t8unJTJyUir
         rj4MThXs99DXSa9MwQAQjSur3jTp3mqVhhVNUOPcUPs78hFa1xFwOeWt0p2ZvpgoglqQ
         5uVND1j0yDEVXeqiDNKq69XIyoE8KIM0/0zVqm0KzpZOt9UdAosCvJ+hhtVcJETybsA5
         EixjsUfk44GjoOx4TzObueaNarAIqlUP+tWw4fgSzq51Zthe/6tuVRQ/naYM0CWq4ZxI
         9mwuGlcldk7v+7TXLQe/C9ttwdKHy/OIasSJj8k5CEc03cdphcxcxDPoFz5V8R5OtfT0
         6pAQ==
X-Gm-Message-State: AOAM530hcJCQRuqrD7tFfrmSP5miebU2uBkzPzuBFmgF5N6O6CCKwe4/
        iK4pRnZirRBGEhU69X5JdAU=
X-Google-Smtp-Source: ABdhPJwO6bpp5672Kfj5x5jFPuUhC89qIOJiU4AUYS+7aZZoStZAfCJMcp1K3fRuKLR5pACWD0qCcw==
X-Received: by 2002:a5d:670f:: with SMTP id o15mr27748939wru.349.1617129769732;
        Tue, 30 Mar 2021 11:42:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.174])
        by smtp.gmail.com with ESMTPSA id x23sm4887608wmi.33.2021.03.30.11.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 11:42:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io-wq: forcefully cancel on io-wq destroy
Date:   Tue, 30 Mar 2021 19:38:40 +0100
Message-Id: <822eeb713e57efe8960a7f3a7c11dbef1fcbf4e4.1617129472.git.asml.silence@gmail.com>
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
 fs/io-wq.c | 50 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 7434eb40ca8c..5fa5e0fd40d6 100644
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
+		work = io_get_all_items(wqe);
+		raw_spin_unlock_irq(&wqe->lock);
+
+		while (work) {
+			next = wq_next_work(work);
+			io_get_work_all(work, wqe);
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

