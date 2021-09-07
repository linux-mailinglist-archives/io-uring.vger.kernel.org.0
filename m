Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8211E402274
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 05:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhIGDX7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 23:23:59 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:48694 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232553AbhIGDX5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 23:23:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnY7TBW_1630984963;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnY7TBW_1630984963)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Sep 2021 11:22:50 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2] io_uring: fix bug of wrong BUILD_BUG_ON check of __REQ_F_LAST_BIT
Date:   Tue,  7 Sep 2021 11:22:43 +0800
Message-Id: <20210907032243.114190-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Build check of __REQ_F_LAST_BIT should be large than not equal or large
than.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bde732a1183..d159d9204e07 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10643,7 +10643,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
-	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
-- 
2.24.4

