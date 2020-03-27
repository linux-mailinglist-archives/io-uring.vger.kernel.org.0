Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A864195227
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2020 08:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgC0Hhx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Mar 2020 03:37:53 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:49865 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgC0Hhw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Mar 2020 03:37:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ttl2y1K_1585294625;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Ttl2y1K_1585294625)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 27 Mar 2020 15:37:13 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: cleanup io_alloc_async_ctx()
Date:   Fri, 27 Mar 2020 15:36:52 +0800
Message-Id: <20200327073652.2301-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Cleanup io_alloc_async_ctx() a bit, add a new __io_alloc_async_ctx(),
so io_setup_async_rw() won't need to check whether async_ctx is true
or false again.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3affd96a98ba..a85659eae137 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2169,12 +2169,18 @@ static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 	}
 }
 
+static inline int __io_alloc_async_ctx(struct io_kiocb *req)
+{
+	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
+	return req->io == NULL;
+}
+
 static int io_alloc_async_ctx(struct io_kiocb *req)
 {
 	if (!io_op_defs[req->opcode].async_ctx)
 		return 0;
-	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
-	return req->io == NULL;
+
+	return  __io_alloc_async_ctx(req);
 }
 
 static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
@@ -2184,7 +2190,7 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 	if (!io_op_defs[req->opcode].async_ctx)
 		return 0;
 	if (!req->io) {
-		if (io_alloc_async_ctx(req))
+		if (__io_alloc_async_ctx(req))
 			return -ENOMEM;
 
 		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
-- 
2.17.2

