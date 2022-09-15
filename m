Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0FF5B9407
	for <lists+io-uring@lfdr.de>; Thu, 15 Sep 2022 07:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiIOFtV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Sep 2022 01:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIOFtU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Sep 2022 01:49:20 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F6F8E4EB;
        Wed, 14 Sep 2022 22:49:18 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VPrPP64_1663220952;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VPrPP64_1663220952)
          by smtp.aliyun-inc.com;
          Thu, 15 Sep 2022 13:49:15 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] io_uring: rw: Fix an unsigned comparison which can never be negative
Date:   Thu, 15 Sep 2022 13:49:09 +0800
Message-Id: <20220915054909.81394-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The parameter 'res' is defined as unsigned type, so the following if
statement is invalid, we can modify the type of res to long.
if (res < 0)
  	res = io->bytes_done;
else
  	res += io->bytes_done;

io_uring/rw.c:265 io_fixup_rw_res() warn: unsigned 'res' is never less than zero.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2184
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b777c35378b9..08d88481153c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -256,7 +256,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline unsigned io_fixup_rw_res(struct io_kiocb *req, long res)
 {
 	struct io_async_rw *io = req->async_data;
 
-- 
2.20.1.7.g153144c

