Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DAE258781
	for <lists+io-uring@lfdr.de>; Tue,  1 Sep 2020 07:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgIAFfO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 01:35:14 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:17934 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbgIAFfO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 01:35:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0U7VDje-_1598938502;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U7VDje-_1598938502)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Sep 2020 13:35:02 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH] io_uring: fix removing the wrong file in __io_sqe_files_update()
Date:   Tue,  1 Sep 2020 13:35:02 +0800
Message-Id: <1598938502-109415-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Index here is already the position of the file in fixed_file_table, we
should not use io_file_from_index() again to get it. Otherwise, the
wrong file which still in use may be released unexpectedly.

Cc: stable@vger.kernel.org # v5.6
Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce69bd9..cf601f8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7324,7 +7324,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
 		if (table->files[index]) {
-			file = io_file_from_index(ctx, index);
+			file = table->files[index];
 			err = io_queue_file_removal(data, file);
 			if (err)
 				break;
-- 
1.8.3.1

