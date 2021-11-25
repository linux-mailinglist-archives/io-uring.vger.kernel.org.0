Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F69645D71D
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 10:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354116AbhKYJ0V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 04:26:21 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:38334 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348005AbhKYJYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 04:24:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyFCEEt_1637832063;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyFCEEt_1637832063)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 17:21:08 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/2] io_uring: fix no lock protection for ctx->cq_extra
Date:   Thu, 25 Nov 2021 17:21:02 +0800
Message-Id: <20211125092103.224502-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211125092103.224502-1-haoxu@linux.alibaba.com>
References: <20211125092103.224502-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ctx->cq_extra should be protected by completion lock so that the
req_need_defer() does the right check.

Cc: stable@vger.kernel.org
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f666a0e7f5e8..ae9534382b26 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6537,12 +6537,15 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	u32 seq = io_get_sequence(req);
 
 	/* Still need defer if there is pending req in defer list. */
+	spin_lock(&ctx->completion_lock);
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list)) {
+		spin_unlock(&ctx->completion_lock);
 queue:
 		ctx->drain_active = false;
 		io_req_task_queue(req);
 		return;
 	}
+	spin_unlock(&ctx->completion_lock);
 
 	ret = io_req_prep_async(req);
 	if (ret) {
-- 
2.24.4

