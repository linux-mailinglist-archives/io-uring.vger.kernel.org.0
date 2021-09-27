Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54482419288
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhI0KxP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 06:53:15 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:47230 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233865AbhI0KxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 06:53:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Upn7J34_1632739883;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Upn7J34_1632739883)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 18:51:30 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/8] io-wq: code clean for io_wq_add_work_after()
Date:   Mon, 27 Sep 2021 18:51:16 +0800
Message-Id: <20210927105123.169301-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927105123.169301-1-haoxu@linux.alibaba.com>
References: <20210927105123.169301-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove a local variable.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index bf5c4c533760..8369a51b65c0 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -33,11 +33,9 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
 				     struct io_wq_work_node *pos,
 				     struct io_wq_work_list *list)
 {
-	struct io_wq_work_node *next = pos->next;
-
+	node->next = pos->next;
 	pos->next = node;
-	node->next = next;
-	if (!next)
+	if (!node->next)
 		list->last = node;
 }
 
-- 
2.24.4

