Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9CF267FB3
	for <lists+io-uring@lfdr.de>; Sun, 13 Sep 2020 15:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgIMNof (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Sep 2020 09:44:35 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:44552 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgIMNod (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Sep 2020 09:44:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U8mcNph_1600004669;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U8mcNph_1600004669)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 13 Sep 2020 21:44:29 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [RFC PATCH for-next] io_uring: clear IORING_SQ_NEED_WAKEUP for all ctxes accordingly when waken up
Date:   Sun, 13 Sep 2020 21:44:27 +0800
Message-Id: <20200913134427.1592-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When poll thread is waken up, should clear all ctxes' IORING_SQ_NEED_WAKEUP
flag, otherwise apps will always enter kernel to submit reqs.

Fixes: df033a30aaee ("io_uring: set ctx need-wakeup flag when SQPOLL thread is going idle")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae83d887c24d..9491f2040a93 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6849,12 +6849,14 @@ static int io_sq_thread(void *data)
 			io_run_task_work();
 			cond_resched();
 		} else if (ret == SQT_IDLE) {
-			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				io_ring_set_wakeup_flag(ctx);
 			if (kthread_should_park())
 				continue;
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+				io_ring_set_wakeup_flag(ctx);
 			schedule();
 			start_jiffies = jiffies;
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+				io_ring_clear_wakeup_flag(ctx);
 		}
 	}
 
-- 
2.17.2

