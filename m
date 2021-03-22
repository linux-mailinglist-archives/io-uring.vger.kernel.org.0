Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF16C343CE8
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 10:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhCVJcd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 05:32:33 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:60029 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhCVJcQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 05:32:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0USuX-9z_1616405531;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0USuX-9z_1616405531)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Mar 2021 17:32:14 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] io_uring: Remove redundant NULL check
Date:   Mon, 22 Mar 2021 17:31:59 +0800
Message-Id: <1616405519-81817-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix the following coccicheck warnings:

./fs/io_uring.c:5989:4-9: WARNING: NULL check before some freeing
functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 543551d..35e95ba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6001,8 +6001,7 @@ static void __io_clean_op(struct io_kiocb *req)
 		case IORING_OP_WRITE_FIXED:
 		case IORING_OP_WRITE: {
 			struct io_async_rw *io = req->async_data;
-			if (io->free_iovec)
-				kfree(io->free_iovec);
+			kfree(io->free_iovec);
 			break;
 			}
 		case IORING_OP_RECVMSG:
-- 
1.8.3.1

