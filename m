Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3462AFFEC
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 07:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgKLG4F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 01:56:05 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:33332 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgKLG4F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 01:56:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UF3.Ex0_1605164160;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UF3.Ex0_1605164160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Nov 2020 14:56:01 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH 5.11 1/2] io_uring: initialize 'timeout' properly in io_sq_thread()
Date:   Thu, 12 Nov 2020 14:55:59 +0800
Message-Id: <20201112065600.8710-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201112065600.8710-1-xiaoguang.wang@linux.alibaba.com>
References: <20201112065600.8710-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some static checker reports below warning:
    fs/io_uring.c:6939 io_sq_thread()
    error: uninitialized symbol 'timeout'.

Fix it.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c1dcb22e2b76..c9b743be5328 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6921,7 +6921,7 @@ static int io_sq_thread(void *data)
 	const struct cred *old_cred = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
-	unsigned long timeout;
+	unsigned long timeout = 0;
 	DEFINE_WAIT(wait);
 
 	task_lock(current);
-- 
2.17.2

