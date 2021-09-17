Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875FC40FFE9
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 21:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbhIQTj5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 15:39:57 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:59870 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242348AbhIQTjt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 15:39:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoidwXr_1631907500;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoidwXr_1631907500)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 03:38:26 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/5] io_uring: return boolean value for io_alloc_async_data
Date:   Sat, 18 Sep 2021 03:38:16 +0800
Message-Id: <20210917193820.224671-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210917193820.224671-1-haoxu@linux.alibaba.com>
References: <20210917193820.224671-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

boolean value is good enough for io_alloc_async_data.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91e4c89abf78..05c449ea3fd3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3309,7 +3309,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	}
 }
 
-static inline int io_alloc_async_data(struct io_kiocb *req)
+static inline bool io_alloc_async_data(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
 	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
-- 
2.24.4

