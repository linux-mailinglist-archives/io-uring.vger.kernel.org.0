Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7137A43FC3F
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhJ2MZR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 08:25:17 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50064 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231519AbhJ2MZP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 08:25:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uu9pzWg_1635510157;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uu9pzWg_1635510157)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 20:22:45 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/6] io-wq: add helper to merge two wq_lists
Date:   Fri, 29 Oct 2021 20:22:32 +0800
Message-Id: <20211029122237.164312-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211029122237.164312-1-haoxu@linux.alibaba.com>
References: <20211029122237.164312-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add a helper to merge two wq_lists, it will be useful in the next
patches.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 41bf37674a49..a7b0b505db9d 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -52,6 +52,27 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
 		list->last = node;
 }
 
+/**
+ * wq_list_merge - merge the second list to the first one.
+ * @list0: the first list
+ * @list1: the second list
+ * Return list0 if list1 is NULL, and vice versa.
+ * Otherwise after merge, list0 contains the merged list.
+ */
+static inline struct io_wq_work_list *wq_list_merge(struct io_wq_work_list *list0,
+						    struct io_wq_work_list *list1)
+{
+	if (!list1 || !list1->first)
+		return list0;
+
+	if (!list0 || !list0->first)
+		return list1;
+
+	list0->last->next = list1->first;
+	list0->last = list1->last;
+	return list0;
+}
+
 static inline void wq_list_add_tail(struct io_wq_work_node *node,
 				    struct io_wq_work_list *list)
 {
-- 
2.24.4

