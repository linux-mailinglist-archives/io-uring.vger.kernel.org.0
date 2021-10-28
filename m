Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7521743E100
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 14:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhJ1MbT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 08:31:19 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:44851 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhJ1MbS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 08:31:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uu.wxKe_1635424130;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Uu.wxKe_1635424130)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 20:28:50 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [RFC v2 1/3] io_uring: remove req->apoll check in io_clean_op()
Date:   Thu, 28 Oct 2021 20:28:48 +0800
Message-Id: <20211028122850.13025-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Once REQ_F_POLLED is flagged, req->apoll must have a valid value,
so remove this check.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 736d456e7913..7361ae53cad3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6557,7 +6557,7 @@ static void io_clean_op(struct io_kiocb *req)
 			break;
 		}
 	}
-	if ((req->flags & REQ_F_POLLED) && req->apoll) {
+	if (req->flags & REQ_F_POLLED) {
 		kfree(req->apoll->double_poll);
 		kfree(req->apoll);
 		req->apoll = NULL;
-- 
2.14.4.44.g2045bb6

