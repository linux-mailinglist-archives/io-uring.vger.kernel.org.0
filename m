Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD7F3F7478
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbhHYLk5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 07:40:57 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:40129 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239971AbhHYLkz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 07:40:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UloPzj-_1629891603;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UloPzj-_1629891603)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 Aug 2021 19:40:09 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: don't free request to slab
Date:   Wed, 25 Aug 2021 19:40:03 +0800
Message-Id: <20210825114003.231641-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's not neccessary to free the request back to slab when we fail to
get sqe, just update state->free_reqs pointer.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74b606990d7e..ce66a9ce2b43 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6899,7 +6899,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		}
 		sqe = io_get_sqe(ctx);
 		if (unlikely(!sqe)) {
-			kmem_cache_free(req_cachep, req);
+			ctx->submit_state.free_reqs++;
 			break;
 		}
 		/* will complete beyond this point, count as submitted */
-- 
2.24.4

