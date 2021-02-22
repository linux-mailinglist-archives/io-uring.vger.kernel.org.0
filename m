Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2161F32110C
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 07:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhBVGzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 01:55:46 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:53291 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229908AbhBVGzh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 01:55:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UPA9rZC_1613976893;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPA9rZC_1613976893)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Feb 2021 14:54:53 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
Subject: [PATCH] block: fix potential IO hang when turning off io_poll
Date:   Mon, 22 Feb 2021 14:54:52 +0800
Message-Id: <20210222065452.21897-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

QUEUE_FLAG_POLL flag will be cleared when turning off 'io_poll', while
at that moment there may be IOs stuck in hw queue uncompleted. The
following polling routine won't help reap these IOs, since blk_poll()
will return immediately because of cleared QUEUE_FLAG_POLL flag. Thus
these IOs will hang until they finnaly time out. The hang out can be
observed by 'fio --engine=io_uring iodepth=1', while turning off
'io_poll' at the same time.

To fix this, freeze and flush the request queue first when turning off
'io_poll'.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b513f1683af0..10d74741c002 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -430,8 +430,11 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 
 	if (poll_on)
 		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
-	else
+	else {
+		blk_mq_freeze_queue(q);
 		blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
+		blk_mq_unfreeze_queue(q);
+	}
 
 	return ret;
 }
-- 
2.27.0

