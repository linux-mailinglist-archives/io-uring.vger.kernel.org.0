Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788DE40FFEB
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 21:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhIQTj7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 15:39:59 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:40019 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242538AbhIQTju (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 15:39:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoidwXr_1631907500;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoidwXr_1631907500)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 03:38:26 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/5] io_uring: code clean for io_poll_complete()
Date:   Sat, 18 Sep 2021 03:38:17 +0800
Message-Id: <20210917193820.224671-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210917193820.224671-1-haoxu@linux.alibaba.com>
References: <20210917193820.224671-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No need to return boolean value, since no callers consume it.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05c449ea3fd3..6ea7d4003499 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5350,14 +5350,14 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return !(flags & IORING_CQE_F_MORE);
 }
 
-static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
+static inline void io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	__must_hold(&req->ctx->completion_lock)
 {
 	bool done;
 
 	done = __io_poll_complete(req, mask);
 	io_commit_cqring(req->ctx);
-	return done;
+	return;
 }
 
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
-- 
2.24.4

