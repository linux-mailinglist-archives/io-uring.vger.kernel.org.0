Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240D241945D
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 14:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhI0Mhr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 08:37:47 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:52255 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234278AbhI0Mhr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 08:37:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpooWsS_1632746160;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpooWsS_1632746160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 20:36:08 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/2] io_uring: fix concurrent poll interruption
Date:   Mon, 27 Sep 2021 20:35:59 +0800
Message-Id: <20210927123600.234405-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927123600.234405-1-haoxu@linux.alibaba.com>
References: <20210927123600.234405-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There may be concurrent poll interruptions:

async_wake()
->del wait entry
->add to tw list
                       async_wake()
                       ->del wait entry
                       ->add to tw list

This mess up the tw list, let's avoid it by adding a if check before
delete wait entry:
async_wake()
->if empty(wait entry)
    return
->del wait entry
->add to tw list
                       async_wake()
                       ->if empty(wait entry)
                           return <------------will return here
                       ->del wait entry
                       ->add to tw list

Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8317c360f7a4..d0b358b9b589 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5245,6 +5245,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
 
+	if (list_empty(&poll->wait.entry))
+		return 0;
 	list_del_init(&poll->wait.entry);
 
 	req->result = mask;
-- 
2.24.4

