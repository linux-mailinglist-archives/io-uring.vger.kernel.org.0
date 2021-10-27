Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B4743C76F
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 12:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbhJ0KRL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 06:17:11 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:37923 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235484AbhJ0KRK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 06:17:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UtsK7dQ_1635329676;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtsK7dQ_1635329676)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 18:14:44 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: fix warning in io_try_cancel_userdata()
Date:   Wed, 27 Oct 2021 18:14:36 +0800
Message-Id: <20211027101436.130908-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

task work can run in system-wq, so enhance the warnning in
io_try_cancel_userdata() to reflect it.

Cc: stable@vger.kernel.org
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0099decac71d..a2a4b9d04404 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6294,7 +6294,8 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
+	WARN_ON_ONCE(!io_wq_current_is_worker() &&
+		     !(current->flags & PF_WQ_WORKER) && req->task != current);
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
 	if (ret != -ENOENT)
-- 
2.24.4

