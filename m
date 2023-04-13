Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA756E0BAA
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 12:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDMKrY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 06:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDMKrX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 06:47:23 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE3F12A
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 03:47:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Vg.Mcmi_1681382838;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Vg.Mcmi_1681382838)
          by smtp.aliyun-inc.com;
          Thu, 13 Apr 2023 18:47:18 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] t/io_uring: fix max_blocks calculation in nvme passthrough mode
Date:   Thu, 13 Apr 2023 18:47:14 +0800
Message-Id: <20230413104714.57703-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

nvme_id_ns's nsze has already been counted in logical blocks, so
there is no need to divide by bs.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 t/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/io_uring.c b/t/io_uring.c
index 504f8ce9..f9f4b840 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -704,7 +704,7 @@ static int get_file_size(struct file *f)
 					bs, lbs);
 			return -1;
 		}
-		f->max_blocks = nlba / bs;
+		f->max_blocks = nlba;
 		f->max_size = nlba;
 		f->lba_shift = ilog2(lbs);
 		return 0;
-- 
2.19.1.6.gb485710b

