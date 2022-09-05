Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD315AC8AF
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 04:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiIECE7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Sep 2022 22:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235658AbiIECEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Sep 2022 22:04:50 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152EA11469;
        Sun,  4 Sep 2022 19:04:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VOJMWGV_1662343477;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VOJMWGV_1662343477)
          by smtp.aliyun-inc.com;
          Mon, 05 Sep 2022 10:04:44 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] io_uring/notif: Remove the unused function io_notif_complete()
Date:   Mon,  5 Sep 2022 10:04:36 +0800
Message-Id: <20220905020436.51894-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The function io_notif_complete() is defined in the notif.c file, but not
called elsewhere, so delete this unused function.

io_uring/notif.c:24:20: warning: unused function 'io_notif_complete' [-Wunused-function].

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2047
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 io_uring/notif.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 96f076b175e0..1a7abd7e5ca5 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -21,14 +21,6 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
 	io_req_task_complete(notif, locked);
 }
 
-static inline void io_notif_complete(struct io_kiocb *notif)
-	__must_hold(&notif->ctx->uring_lock)
-{
-	bool locked = true;
-
-	__io_notif_complete_tw(notif, &locked);
-}
-
 static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 					  struct ubuf_info *uarg,
 					  bool success)
-- 
2.20.1.7.g153144c

