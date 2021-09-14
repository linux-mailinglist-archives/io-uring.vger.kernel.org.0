Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DFC40A97C
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 10:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhINInK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 04:43:10 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:50538 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhINInJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 04:43:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoMADDU_1631608901;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UoMADDU_1631608901)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Sep 2021 16:41:41 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: add missing sigmask restore in io_cqring_wait()
Date:   Tue, 14 Sep 2021 16:41:39 +0800
Message-Id: <20210914084139.8827-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Found this by learning codes.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 30d959416eba..d7b0aeda1d84 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7326,8 +7326,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	if (uts) {
 		struct timespec64 ts;
 
-		if (get_timespec64(&ts, uts))
+		if (get_timespec64(&ts, uts)) {
+			restore_saved_sigmask_unless(false);
 			return -EFAULT;
+		}
 		timeout = timespec64_to_jiffies(&ts);
 	}
 
-- 
2.14.4.44.g2045bb6

