Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65ABB407A50
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 21:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhIKTmN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 15:42:13 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47751 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231415AbhIKTmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 15:42:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uo.lhDo_1631389252;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo.lhDo_1631389252)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 12 Sep 2021 03:40:59 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/4] io-wq: tweak return value of io_wqe_create_worker()
Date:   Sun, 12 Sep 2021 03:40:49 +0800
Message-Id: <20210911194052.28063-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210911194052.28063-1-haoxu@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The return value of io_wqe_create_worker() should be false if we cannot
create a new worker according to the name of this function.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 382efca4812b..1b102494e970 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -267,7 +267,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 		return create_io_worker(wqe->wq, wqe, acct->index);
 	}
 
-	return true;
+	return false;
 }
 
 static void io_wqe_inc_running(struct io_worker *worker)
-- 
2.24.4

