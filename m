Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625FD5366A3
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 19:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349787AbiE0RjW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 13:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354325AbiE0RjV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 13:39:21 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B83BFD37E
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 10:39:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VEY.BsC_1653673154;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEY.BsC_1653673154)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 May 2022 01:39:15 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH v2] io_uring: defer alloc_hint update to io_file_bitmap_set()
Date:   Sat, 28 May 2022 01:39:14 +0800
Message-Id: <20220527173914.50320-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.14.4.44.g2045bb6
In-Reply-To: <dce4572c-fecf-bb84-241e-2ea7b4093fef@kernel.dk>
References: <dce4572c-fecf-bb84-241e-2ea7b4093fef@kernel.dk>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_file_bitmap_get() returns a free bitmap slot, but if it isn't
used later, such as io_queue_rsrc_removal() returns error, in this
case, we should not update alloc_hint at all, which still should
be considered as a valid candidate for next io_file_bitmap_get()
calls.

To fix this issue, only update alloc_hint in io_file_bitmap_set().

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
V2:
  Delete unnecessary check against to alloc_hint.
---
 fs/io_uring.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff50e5f1753d..212d6ae88114 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5419,15 +5419,11 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 	unsigned long nr = ctx->nr_user_files;
 	int ret;
 
-	if (table->alloc_hint >= nr)
-		table->alloc_hint = 0;
-
 	do {
 		ret = find_next_zero_bit(table->bitmap, nr, table->alloc_hint);
-		if (ret != nr) {
-			table->alloc_hint = ret + 1;
+		if (ret != nr)
 			return ret;
-		}
+
 		if (!table->alloc_hint)
 			break;
 
@@ -9650,12 +9646,13 @@ static void io_free_file_tables(struct io_file_table *table)
 	table->bitmap = NULL;
 }
 
-static inline void io_file_bitmap_set(struct io_file_table *table, int bit)
+static inline void io_file_bitmap_set(struct io_ring_ctx *ctx, int bit)
 {
+	struct io_file_table *table = &ctx->file_table;
+
 	WARN_ON_ONCE(test_bit(bit, table->bitmap));
 	__set_bit(bit, table->bitmap);
-	if (bit == table->alloc_hint)
-		table->alloc_hint++;
+	table->alloc_hint = bit + 1;
 }
 
 static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
@@ -10080,7 +10077,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		}
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 		io_fixed_file_set(file_slot, file);
-		io_file_bitmap_set(&ctx->file_table, i);
+		io_file_bitmap_set(ctx, i);
 	}
 
 	io_rsrc_node_switch(ctx, NULL);
@@ -10161,7 +10158,7 @@ static int io_install_fixed_file(struct io_kiocb *req, unsigned int issue_flags,
 	if (!ret) {
 		*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 		io_fixed_file_set(file_slot, file);
-		io_file_bitmap_set(&ctx->file_table, slot_index);
+		io_file_bitmap_set(ctx, slot_index);
 	}
 err:
 	if (needs_switch)
@@ -10284,7 +10281,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			}
 			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
-			io_file_bitmap_set(&ctx->file_table, i);
+			io_file_bitmap_set(ctx, i);
 		}
 	}
 
-- 
2.14.4.44.g2045bb6

