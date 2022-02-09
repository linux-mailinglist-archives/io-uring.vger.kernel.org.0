Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A54A4AEF71
	for <lists+io-uring@lfdr.de>; Wed,  9 Feb 2022 11:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiBIKj7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Feb 2022 05:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBIKj6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Feb 2022 05:39:58 -0500
Received: from out199-2.us.a.mail.aliyun.com (out199-2.us.a.mail.aliyun.com [47.90.199.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592A1E09DDAC;
        Wed,  9 Feb 2022 02:26:48 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4.4LdI_1644402398;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V4.4LdI_1644402398)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 18:26:44 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] io_uring: Fix uninitialized use of ret in io_eventfd_register()
Date:   Wed,  9 Feb 2022 18:26:37 +0800
Message-Id: <20220209102637.34088-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In some scenarios, ret is not assigned in the whole process, so it
needs to be initialized at the beginning.

Clean up the following clang warning:

fs/io_uring.c:9373:13: note: initialize the variable 'ret' to silence
this warning.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5479f0607430..7f277890f1ec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9370,7 +9370,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 {
 	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
-	int fd, ret;
+	int fd, ret = 0;
 
 	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
 					lockdep_is_held(&ctx->uring_lock));
-- 
2.20.1.7.g153144c

