Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEE7312CA7
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 10:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhBHI7W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Feb 2021 03:59:22 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:41953 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230381AbhBHIxm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Feb 2021 03:53:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UO9kQj0_1612774374;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UO9kQj0_1612774374)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 16:52:55 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com, hch@lst.de,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: [PATCH v3 10/11] nvme/pci: don't wait for locked polling queue
Date:   Mon,  8 Feb 2021 16:52:42 +0800
Message-Id: <20210208085243.82367-11-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
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

