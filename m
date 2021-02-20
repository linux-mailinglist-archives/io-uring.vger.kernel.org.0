Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF5D3204FD
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhBTLHq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:46 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:16394 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229828AbhBTLHj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:39 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP1O7pW_1613819207;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP1O7pW_1613819207)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:47 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 09/12] nvme/pci: don't wait for locked polling queue
Date:   Sat, 20 Feb 2021 19:06:34 +0800
Message-Id: <20210220110637.50305-10-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's no sense waiting for the hw queue when it currently has been
locked by another polling instance. The polling instance currently
occupying the hw queue will help reap the completion events.

It shall be safe to surrender the hw queue, as long as we could reapply
for polling later. For Synchronous polling, blk_poll() will reapply for
polling, since @spin is always True in this case. While For asynchronous
polling, i.e. io_uring itself will reapply for polling when the previous
polling returns 0.

Besides, it shall do no harm to the polling performance of mq devices.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/nvme/host/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 81e6389b2042..db164fcd04e2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1106,7 +1106,9 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx)
 	if (!nvme_cqe_pending(nvmeq))
 		return 0;
 
-	spin_lock(&nvmeq->cq_poll_lock);
+	if (!spin_trylock(&nvmeq->cq_poll_lock))
+		return 0;
+
 	found = nvme_process_cq(nvmeq);
 	spin_unlock(&nvmeq->cq_poll_lock);
 
-- 
2.27.0

