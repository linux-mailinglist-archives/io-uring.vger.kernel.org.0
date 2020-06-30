Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F9A20F4DF
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgF3MlS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:41:18 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:37254 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727878AbgF3MlR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:41:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U1B.3uQ_1593520874;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0U1B.3uQ_1593520874)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 30 Jun 2020 20:41:14 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     io-uring <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     Dust.li@linux.alibaba.com
Subject: [PATCH] io_uring: fix req cannot arm poll after polled
Date:   Tue, 30 Jun 2020 20:41:14 +0800
Message-Id: <2ebb186ebbef9c5a01e27317aae664e9011acf86.1593520864.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For example, there are multiple sqes recv with the same connection.
When there is no data in the connection, the reqs of these sqes will
be armed poll. Then if only a little data is received, only one req
receives the data, and the other reqs get EAGAIN again. However,
due to this flags REQ_F_POLLED, these reqs cannot enter the
io_arm_poll_handler function. These reqs will be put into wq by
io_queue_async_work, and the flags passed by io_wqe_worker when recv
is called are BLOCK, which may make io_wqe_worker enter schedule in the
network protocol stack. When the main process of io_uring exits,
these io_wqe_workers still cannot exit. The connection will not be
actively released until the connection is closed by the peer.

So we should allow req to arm poll again.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e507737..a309832 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4406,7 +4406,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
-	if (req->flags & (REQ_F_MUST_PUNT | REQ_F_POLLED))
+	if (req->flags & REQ_F_MUST_PUNT)
 		return false;
 	if (!def->pollin && !def->pollout)
 		return false;
-- 
1.8.3.1

