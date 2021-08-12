Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2284E3E9D3B
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 06:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhHLEPN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 00:15:13 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:49763 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhHLEPM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 00:15:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UikT1XN_1628741676;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UikT1XN_1628741676)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Aug 2021 12:14:46 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/3] io_uring: extract io_uring_files_cancel() in io_uring_task_cancel()
Date:   Thu, 12 Aug 2021 12:14:34 +0800
Message-Id: <20210812041436.101503-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210812041436.101503-1-haoxu@linux.alibaba.com>
References: <20210812041436.101503-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract io_uring_files_cancel() call in io_uring_task_cancel() to make
io_uring_files_cancel() and io_uring_task_cancel() coherent and easy to
read.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 include/linux/io_uring.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 04b650bcbbe5..ed13304e764c 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -17,7 +17,8 @@ static inline void io_uring_files_cancel(struct files_struct *files)
 }
 static inline void io_uring_task_cancel(void)
 {
-	return io_uring_files_cancel(NULL);
+	if (current->io_uring)
+		__io_uring_cancel(NULL);
 }
 static inline void io_uring_free(struct task_struct *tsk)
 {
-- 
2.24.4

