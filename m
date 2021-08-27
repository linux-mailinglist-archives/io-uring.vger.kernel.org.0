Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E033F97A1
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 11:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244933AbhH0Jrn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 05:47:43 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:39162 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245119AbhH0JrR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 05:47:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UmFsqUh_1630057569;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmFsqUh_1630057569)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 27 Aug 2021 17:46:27 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/2] io_uring: remove redundant req_set_fail()
Date:   Fri, 27 Aug 2021 17:46:08 +0800
Message-Id: <20210827094609.36052-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210827094609.36052-1-haoxu@linux.alibaba.com>
References: <20210827094609.36052-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req_set_fail() in io_submit_sqe() is redundant, remove it.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9534c72dc4b..3598319b1340 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6631,7 +6631,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 fail_req:
 		if (link->head) {
 			/* fail even hard links since we don't submit */
-			req_set_fail(link->head);
 			io_req_complete_failed(link->head, -ECANCELED);
 			link->head = NULL;
 		}
-- 
2.24.4

