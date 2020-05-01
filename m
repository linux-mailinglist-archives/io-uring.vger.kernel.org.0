Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168C81C0B63
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 02:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEAAxL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Apr 2020 20:53:11 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:45618 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbgEAAxL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Apr 2020 20:53:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01358;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Tx8Jj0b_1588294378;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tx8Jj0b_1588294378)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 01 May 2020 08:53:08 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: use cond_resched() in io_ring_ctx_wait_and_kill()
Date:   Fri,  1 May 2020 08:52:56 +0800
Message-Id: <20200501005256.17310-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While working on to make io_uring sqpoll mode support syscalls that need
struct files_struct, I got cpu soft lockup in io_ring_ctx_wait_and_kill(),
    while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
        cpu_relax();
above loop never has an chance to exit, it's because preempt isn't enabled
in the kernel, and the context calling io_ring_ctx_wait_and_kill() and
io_sq_thread() run in the same cpu, if io_sq_thread calls a cond_resched()
yield cpu and another context enters above loop, then io_sq_thread() will
always in runqueue and never exit.

Use cond_resched() can fix this issue.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0c5d25ae51b9..2bc4dad1aacd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7340,7 +7340,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	 * it could cause shutdown to hang.
 	 */
 	while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
-		cpu_relax();
+		cond_resched();
 
 	io_kill_timeouts(ctx);
 	io_poll_remove_all(ctx);
-- 
2.17.2

