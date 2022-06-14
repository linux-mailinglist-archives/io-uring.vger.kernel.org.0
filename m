Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0D154AD07
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 11:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiFNJOZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 05:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239170AbiFNJOU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 05:14:20 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15723419BC;
        Tue, 14 Jun 2022 02:14:18 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 25E9E98v028497-25E9E990028497
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 14 Jun 2022 17:14:13 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     mudongliang <mudongliangabcd@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: io_uring: remove NULL check before kfree
Date:   Tue, 14 Jun 2022 17:13:58 +0800
Message-Id: <20220614091359.124571-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: mudongliang <mudongliangabcd@gmail.com>

kfree can handle NULL pointer as its argument.
According to coccinelle isnullfree check, remove NULL check
before kfree operation.

Signed-off-by: mudongliang <mudongliangabcd@gmail.com>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3aab4182fd89..bec47eae2a9b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3159,8 +3159,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 			if ((req->flags & REQ_F_POLLED) && req->apoll) {
 				struct async_poll *apoll = req->apoll;
 
-				if (apoll->double_poll)
-					kfree(apoll->double_poll);
+				kfree(apoll->double_poll);
 				list_add(&apoll->poll.wait.entry,
 						&ctx->apoll_cache);
 				req->flags &= ~REQ_F_POLLED;
@@ -4499,8 +4498,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	kiocb_done(req, ret, issue_flags);
 out_free:
 	/* it's faster to check here then delegate to kfree */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return 0;
 }
 
@@ -4602,8 +4600,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -6227,8 +6224,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	}
 	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
+	kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret >= 0)
 		ret += sr->done_io;
@@ -6481,8 +6477,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
+	kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret >= 0)
 		ret += sr->done_io;
-- 
2.35.1

