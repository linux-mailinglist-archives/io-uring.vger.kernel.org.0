Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBA425A905
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 11:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIBJ7m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 05:59:42 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:41377 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbgIBJ7l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 05:59:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0U7iSQNQ_1599040779;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U7iSQNQ_1599040779)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Sep 2020 17:59:40 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH] io_uring: set table->files[i] to NULL when io_sqe_file_register failed
Date:   Wed,  2 Sep 2020 17:59:39 +0800
Message-Id: <1599040779-41219-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While io_sqe_file_register() failed in __io_sqe_files_update(),
table->files[i] still point to the original file which may freed
soon, and that will trigger use-after-free problems.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce69bd9..0092418 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7353,6 +7353,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			table->files[index] = file;
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
+				table->files[index] = NULL;
 				fput(file);
 				break;
 			}
-- 
1.8.3.1

