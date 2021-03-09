Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E600F331F45
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 07:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCIGbL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 01:31:11 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:48090 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhCIGaq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 01:30:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UR1RzMj_1615271442;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UR1RzMj_1615271442)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Mar 2021 14:30:43 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] io_uring: remove unneeded variable 'ret'
Date:   Tue,  9 Mar 2021 14:30:41 +0800
Message-Id: <1615271441-33649-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix the following coccicheck warning:
./fs/io_uring.c:8984:5-8: Unneeded variable: "ret". Return "0" on line
8998

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92c25b5..387dbb7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8981,7 +8981,6 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 
 static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 {
-	int ret = 0;
 	DEFINE_WAIT(wait);
 
 	do {
@@ -8995,7 +8994,7 @@ static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	} while (!signal_pending(current));
 
 	finish_wait(&ctx->sqo_sq_wait, &wait);
-	return ret;
+	return 0;
 }
 
 static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
-- 
1.8.3.1

