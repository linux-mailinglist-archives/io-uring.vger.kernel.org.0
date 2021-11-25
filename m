Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F10645D720
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 10:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354123AbhKYJ0W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 04:26:22 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:39887 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351173AbhKYJYW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 04:24:22 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyFCEEt_1637832063;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyFCEEt_1637832063)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 17:21:09 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: better to use REQ_F_IO_DRAIN for req->flags
Date:   Thu, 25 Nov 2021 17:21:03 +0800
Message-Id: <20211125092103.224502-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211125092103.224502-1-haoxu@linux.alibaba.com>
References: <20211125092103.224502-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's better to use REQ_F_IO_DRAIN for req->flags rather than
IOSQE_IO_DRAIN though they have same value.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae9534382b26..08b1b3de9b3f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7095,10 +7095,10 @@ static void io_init_req_drain(struct io_kiocb *req)
 		 * If we need to drain a request in the middle of a link, drain
 		 * the head request and the next request/link after the current
 		 * link. Considering sequential execution of links,
-		 * IOSQE_IO_DRAIN will be maintained for every request of our
+		 * REQ_F_IO_DRAIN will be maintained for every request of our
 		 * link.
 		 */
-		head->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
+		head->flags |= REQ_F_IO_DRAIN | REQ_F_FORCE_ASYNC;
 		ctx->drain_next = true;
 	}
 }
@@ -7149,7 +7149,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (unlikely(ctx->drain_next) && !ctx->submit_state.link.head) {
 			ctx->drain_next = false;
 			ctx->drain_active = true;
-			req->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
+			req->flags |= REQ_F_IO_DRAIN | REQ_F_FORCE_ASYNC;
 		}
 	}
 
-- 
2.24.4

