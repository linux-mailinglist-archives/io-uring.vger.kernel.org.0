Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E968407A51
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 21:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhIKTmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 15:42:14 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:50734 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233742AbhIKTmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 15:42:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uo.lhDo_1631389252;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo.lhDo_1631389252)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 12 Sep 2021 03:40:59 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/4] io-wq: fix worker->refcount when creating worker in work exit
Date:   Sun, 12 Sep 2021 03:40:51 +0800
Message-Id: <20210911194052.28063-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210911194052.28063-1-haoxu@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We may enter the worker creation path from io_worker_exit(), and
refcount is already zero, which causes definite failure of worker
creation.
io_worker_exit
                              ref = 0
->io_wqe_dec_running
  ->io_queue_worker_create
    ->io_worker_get           failure since ref is 0

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0e1288a549eb..75e79571bdfd 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -188,7 +188,9 @@ static void io_worker_exit(struct io_worker *worker)
 	list_del_rcu(&worker->all_list);
 	acct->nr_workers--;
 	preempt_disable();
+	refcount_set(&worker->ref, 1);
 	io_wqe_dec_running(worker);
+	refcount_set(&worker->ref, 0);
 	worker->flags = 0;
 	current->flags &= ~PF_IO_WORKER;
 	preempt_enable();
-- 
2.24.4

