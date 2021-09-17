Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691AB40FFEC
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 21:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242538AbhIQTkX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 15:40:23 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:55980 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242348AbhIQTkU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 15:40:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoidwXr_1631907500;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoidwXr_1631907500)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 03:38:26 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 4/5] io_uring: fix lacking of EPOLLONESHOT
Date:   Sat, 18 Sep 2021 03:38:19 +0800
Message-Id: <20210917193820.224671-5-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210917193820.224671-1-haoxu@linux.alibaba.com>
References: <20210917193820.224671-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should set EPOLLONESHOT if cqring_fill_event() returns false since
io_poll_add() decides to put req or not by it.

Fixes: 5082620fb2ca ("io_uring: terminate multishot poll for CQ ring overflow")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 02425022c3b0..b1d6c3a1d3cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5340,8 +5340,10 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags))
+	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
+		req->poll.events |= EPOLLONESHOT;
 		flags = 0;
+	}
 	if (flags & IORING_CQE_F_MORE)
 		ctx->cq_extra++;
 
-- 
2.24.4

