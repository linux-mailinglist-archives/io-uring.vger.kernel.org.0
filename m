Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904E152B556
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 11:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiERIk2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 04:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbiERIk0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 04:40:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EF4C8BE0
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 01:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vSVwa3ZNe0YJsyTijBcRUJbZ86ohZvBBmKLNw22MzNs=; b=4XO4gTtG8O6xAdYGlMgKVU/ckW
        MBjYMjraLmG9GOfqvkS38+xwNBJNzHJOKGRux963cHzps0Vf3EUFFQX7yYsi09rJDaxt9tGsPGKWb
        fWz5AUQq1cmAE7a5I1QrjZBmRFO1hSPs4JHOoDB56rtk9nSoxnjT1rGXPF+rKlb0DqMmDNI6hQkrf
        DkwPp2z6c6EdwWyCsbM/THMQyyiRkz/PgIx2q8KLnvHNCXtsSRkEkr+oAx2XB6EeGr/PLBr0hpVLh
        q/muxsLIGkhjGmcIQw1stj8/7/XDiYMS0rQ/w+XW0LG2/Nwv0AT5FPnMXwpEgEc6DQrYsbIgMjKal
        xVURU0Kg==;
Received: from [2001:4bb8:19a:7bdf:8143:492c:c3b:39b6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrFEG-000dVd-Ni; Wed, 18 May 2022 08:40:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH 5/6] io_uring: consistently use the EPOLL* defines
Date:   Wed, 18 May 2022 10:40:04 +0200
Message-Id: <20220518084005.3255380-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518084005.3255380-1-hch@lst.de>
References: <20220518084005.3255380-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

POLL* are unannotated values for the userspace ABI, while everything
in-kernel should use EPOLL* and the __poll_t type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1b46c3e9df33a..c9596d551bd67 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7012,7 +7012,7 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 
 #define wqe_to_req(wait)	((void *)((unsigned long) (wait)->private & ~1))
 #define wqe_is_double(wait)	((unsigned long) (wait)->private & 1)
-#define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | POLLPRI)
+#define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | EPOLLPRI)
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
@@ -7217,14 +7217,14 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		mask |= EPOLLONESHOT;
 
 	if (def->pollin) {
-		mask |= POLLIN | POLLRDNORM;
+		mask |= EPOLLIN | EPOLLRDNORM;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
 		if ((req->opcode == IORING_OP_RECVMSG) &&
 		    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
-			mask &= ~POLLIN;
+			mask &= ~EPOLLIN;
 	} else {
-		mask |= POLLOUT | POLLWRNORM;
+		mask |= EPOLLOUT | EPOLLWRNORM;
 	}
 	if (def->poll_exclusive)
 		mask |= EPOLLEXCLUSIVE;
-- 
2.30.2

