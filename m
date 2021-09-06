Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25981401D6E
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 17:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhIFPN2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 11:13:28 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:30146 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229748AbhIFPN1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 11:13:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnVYeLW_1630941128;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnVYeLW_1630941128)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 06 Sep 2021 23:12:14 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: fix bug of wrong BUILD_BUG_ON check
Date:   Mon,  6 Sep 2021 23:12:08 +0800
Message-Id: <20210906151208.206851-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some check should be large than not equal or large than.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bde732a1183..3a833037af43 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10637,13 +10637,13 @@ static int __init io_uring_init(void)
 		     sizeof(struct io_uring_rsrc_update2));
 
 	/* ->buf_index is u16 */
-	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
+	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS > (1u << 16));
 
 	/* should fit into one byte */
-	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
+	BUILD_BUG_ON(SQE_VALID_FLAGS > (1 << 8));
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
-	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
-- 
2.24.4

