Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B495741928D
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 12:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhI0KxR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 06:53:17 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:38883 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233866AbhI0KxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 06:53:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Upn7J34_1632739883;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Upn7J34_1632739883)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 18:51:31 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/8] io-wq: add helper to merge two wq_lists
Date:   Mon, 27 Sep 2021 18:51:17 +0800
Message-Id: <20210927105123.169301-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927105123.169301-1-haoxu@linux.alibaba.com>
References: <20210927105123.169301-1-haoxu@linux.alibaba.com>
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
index 8369a51b65c0..f1d92cf4ee31 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -39,6 +39,27 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
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

