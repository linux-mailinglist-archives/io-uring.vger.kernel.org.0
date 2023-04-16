Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAB06E34FD
	for <lists+io-uring@lfdr.de>; Sun, 16 Apr 2023 06:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDPEiJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Apr 2023 00:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDPEiI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Apr 2023 00:38:08 -0400
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC4C10E6
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 21:38:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Vg8tl84_1681619882;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Vg8tl84_1681619882)
          by smtp.aliyun-inc.com;
          Sun, 16 Apr 2023 12:38:03 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
Subject: [PATCH] t/io_uring: fix max_blocks calculation in pt mode again
Date:   Sun, 16 Apr 2023 12:38:02 +0800
Message-Id: <20230416043802.46269-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

max_blocks indeed should be counted in the block size of bs, not
nvme's logical block size, otherwise we'll get "LBA Out of Range"
error while bs is greater than nvme's logical block size.

Fixes: e2a4a77e483e ("t/io_uring: fix max_blocks calculation in nvme passthrough mode")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 t/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index f9f4b840..9f014c4b 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -704,7 +704,7 @@ static int get_file_size(struct file *f)
 					bs, lbs);
 			return -1;
 		}
-		f->max_blocks = nlba;
+		f->max_blocks = nlba * lbs / bs;
 		f->max_size = nlba;
 		f->lba_shift = ilog2(lbs);
 		return 0;
-- 
2.37.1

