Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C9445EB11
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 11:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbhKZKNB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 05:13:01 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55694 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376610AbhKZKLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 05:11:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyM4V-6_1637921260;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyM4V-6_1637921260)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 18:07:46 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/6] io-wq: add helper to merge two wq_lists
Date:   Fri, 26 Nov 2021 18:07:35 +0800
Message-Id: <20211126100740.196550-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211126100740.196550-1-haoxu@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add a helper to merge two wq_lists, it will be useful in the next
patches.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 41bf37674a49..3709b7c5ec98 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -52,6 +52,28 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
 		list->last = node;
 }
 
+/**
+ * wq_list_merge - merge the second list to the first one.
+ * @list0: the first list
+ * @list1: the second list
+ * Return the first node after mergence.
+ */
+static inline struct io_wq_work_node *wq_list_merge(struct io_wq_work_list *list0,
+						    struct io_wq_work_list *list1)
+{
+	struct io_wq_work_node *ret;
+
+	if (!list0->first) {
+		ret = list1->first;
+	} else {
+		ret = list0->first;
+		list0->last->next = list1->first;
+	}
+	INIT_WQ_LIST(list0);
+	INIT_WQ_LIST(list1);
+	return ret;
+}
+
 static inline void wq_list_add_tail(struct io_wq_work_node *node,
 				    struct io_wq_work_list *list)
 {
-- 
2.24.4

