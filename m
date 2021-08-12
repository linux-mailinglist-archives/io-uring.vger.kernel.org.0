Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087C83E9FB9
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 09:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhHLHrg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 03:47:36 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:51510 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233780AbhHLHre (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 03:47:34 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UiluQlo_1628754422;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UiluQlo_1628754422)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Aug 2021 15:47:08 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2] io_uring: code clean for completion_lock in io_arm_poll_handler()
Date:   Thu, 12 Aug 2021 15:47:02 +0800
Message-Id: <20210812074702.205875-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210812041436.101503-4-haoxu@linux.alibaba.com>
References: <20210812041436.101503-4-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can merge two spin_unlock() operations to one since we removed some
code not long ago.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b29774aa1f09..7f56394e6c40 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5231,13 +5231,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
-	if (ret || ipt.error) {
-		spin_unlock(&ctx->completion_lock);
-		if (ret)
-			return IO_APOLL_READY;
-		return IO_APOLL_ABORTED;
-	}
 	spin_unlock(&ctx->completion_lock);
+	if (ret || ipt.error)
+		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
+
 	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
 				mask, apoll->poll.events);
 	return IO_APOLL_OK;
-- 
2.24.4

