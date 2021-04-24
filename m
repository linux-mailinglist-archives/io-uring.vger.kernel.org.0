Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C740C36A396
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 01:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhDXX1a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 19:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhDXX1a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 19:27:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B75DC061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 16:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=3RQmT9cGsYXHI0U50badnL4vLyUqo0bN5smLDc6RNfA=; b=xH+b34tuUetQY+nLcP7kXygksa
        EGd65qnoX/ZOgzzOIRgOY9WNzJdDt3cO5+FaJ/N7hn6w1WTY8vgrfHYujhq2OFdnggdZ+cprkUeRH
        0L6N5Dz27ApyxDOLUKK2LTP3XlmU/FGTMZ/syEBjJvS5YR+7WesD4utbtAjnj3v8xrPZ3LE+BF6N9
        ZGewOO8ugXl+cFi3qLYdcMk6lBWq7+D0OTJ64bi0xsmrKAtipvsvjj9zyyiQoMK260dRAucd21f/P
        yBRr6wtfsxVEIeMeELix/RP4K1/NIE3kXKDIuFUTjOD63YjfG1JpSHyYJ8xZOapW/NhmtrHDmPRqr
        oai7joycb+u/4ekD3OLscbQ3u/ShJ5vOgKKL60nQq2aPF0FA1sePT5J+wOuwyGbkc/EeArHOayXOw
        w/MgrMAtl26O7W/oYf7YWKyH3T5M0tcL1Kr0IZBSeJGggo2pzE4PmuxeXRjDKi9ETIsBeaUTY7L43
        oEEzaoPyWzWd3ZP8T4bd76GG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1laRfk-0007Wd-5e; Sat, 24 Apr 2021 23:26:48 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 3/6] io-wq: call set_task_comm() before wake_up_new_task()
Date:   Sun, 25 Apr 2021 01:26:05 +0200
Message-Id: <5e3b45a5faa1926422e32efa6ef38dfb254ce664.1619306115.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619306115.git.metze@samba.org>
References: <cover.1619306115.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io-wq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 49def8714083..cd1af924c3d1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -528,13 +528,9 @@ static int io_wqe_worker(void *data)
 	struct io_worker *worker = data;
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 
-	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
-	set_task_comm(current, buf);
-
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
@@ -620,6 +616,7 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
+	char tsk_comm[TASK_COMM_LEN];
 	struct task_struct *tsk;
 
 	__set_current_state(TASK_RUNNING);
@@ -643,6 +640,9 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		return;
 	}
 
+	snprintf(tsk_comm, sizeof(tsk_comm), "iou-wrk-%d", wq->task->pid);
+	set_task_comm(tsk, tsk_comm);
+
 	tsk->pf_io_worker = worker;
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, cpumask_of_node(wqe->node));
-- 
2.25.1

