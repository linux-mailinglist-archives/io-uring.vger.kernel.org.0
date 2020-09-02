Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC3B25AA63
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 13:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIBLdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 07:33:07 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:59677 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbgIBLdF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 07:33:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U7iYhku_1599046382;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U7iYhku_1599046382)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Sep 2020 19:33:02 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: don't hold fixed_file_data's lock when registering files
Date:   Wed,  2 Sep 2020 19:32:56 +0800
Message-Id: <20200902113256.6620-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While registering new files by IORING_REGISTER_FILES, there're not
valid fixed_file_ref_node at the moment, so it's unnecessary to hold
fixed_file_data's lock when registering files.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 186072861af9..75841f3cb2f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7257,9 +7257,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	ctx->file_data->cur_refs = &ref_node->refs;
-	spin_lock(&ctx->file_data->lock);
 	list_add(&ref_node->node, &ctx->file_data->ref_list);
-	spin_unlock(&ctx->file_data->lock);
 	percpu_ref_get(&ctx->file_data->refs);
 	return ret;
 }
-- 
2.17.2

