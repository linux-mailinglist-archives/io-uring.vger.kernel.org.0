Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CB233AE10
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 09:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhCOI5I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 04:57:08 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:48824 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229658AbhCOI5G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 04:57:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0URxYpOC_1615798614;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0URxYpOC_1615798614)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 15 Mar 2021 16:57:04 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: don't iterate ctx list to update sq_thread_idle
Date:   Mon, 15 Mar 2021 16:56:54 +0800
Message-Id: <1615798614-1044-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sqd->sq_thread_idle can be updated by a simple max(), rather than
iterating the whole ctx list to get the max one.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4bce17af506..17697b9890e3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7871,7 +7871,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			ret = -ENXIO;
 		} else {
 			list_add(&ctx->sqd_list, &sqd->ctx_list);
-			io_sqd_update_thread_idle(sqd);
+			sqd->sq_thread_idle = max(sqd->sq_thread_idle, ctx->sq_thread_idle);
 		}
 		io_sq_thread_unpark(sqd);
 
-- 
1.8.3.1

