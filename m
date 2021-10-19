Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E872D433221
	for <lists+io-uring@lfdr.de>; Tue, 19 Oct 2021 11:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhJSJ0M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 05:26:12 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:54427 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231652AbhJSJ0M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 05:26:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UstKjiq_1634635432;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UstKjiq_1634635432)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Oct 2021 17:23:58 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH liburing] io-cancel: add check for -ECANCELED
Date:   Tue, 19 Oct 2021 17:23:52 +0800
Message-Id: <20211019092352.29782-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The req to be async cancelled will most likely return -ECANCELED after
cancellation with the new async bybrid optimization applied. And -EINTR
is impossible to be returned anymore since we won't be in INTERRUPTABLE
sleep when reading, so remove it.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 test/io-cancel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/io-cancel.c b/test/io-cancel.c
index b5b443dc467b..c761e126be0c 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -341,7 +341,7 @@ static int test_cancel_req_across_fork(void)
 				fprintf(stderr, "wait_cqe=%d\n", ret);
 				return 1;
 			}
-			if ((cqe->user_data == 1 && cqe->res != -EINTR) ||
+			if ((cqe->user_data == 1 && cqe->res != -ECANCELED) ||
 			    (cqe->user_data == 2 && cqe->res != -EALREADY && cqe->res)) {
 				fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
 				exit(1);
-- 
2.24.4

