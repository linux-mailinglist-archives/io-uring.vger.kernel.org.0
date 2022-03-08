Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290BA4D1161
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 08:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbiCHH6Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 02:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237428AbiCHH6Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 02:58:24 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8776BBF3;
        Mon,  7 Mar 2022 23:57:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V6dZ1Bq_1646726239;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V6dZ1Bq_1646726239)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 15:57:25 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] io_uring: Fix an unsigned subtraction which can never be negative.
Date:   Tue,  8 Mar 2022 15:57:17 +0800
Message-Id: <20220308075717.37734-1-jiapeng.chong@linux.alibaba.com>
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

Eliminate the follow smatch warnings:

fs/io_uring.c:10358 __do_sys_io_uring_enter() warn: unsigned 'fd' is
never less than zero.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23e7f93d3956..d970c94804db 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10355,7 +10355,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (!tctx)
 			return -EINVAL;
 		if (fd != tctx->last_reg_fd) {
-			if (fd < 0 || fd >= IO_RINGFD_REG_MAX || !tctx)
+			if (fd >= IO_RINGFD_REG_MAX || !tctx)
 				return -EINVAL;
 			tctx->last_reg_fd = array_index_nospec(fd,
 							IO_RINGFD_REG_MAX);
-- 
2.20.1.7.g153144c

