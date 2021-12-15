Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388E2475D56
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 17:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244772AbhLOQY2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 11:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244774AbhLOQY1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 11:24:27 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF196C06173F
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:26 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id c3so31082130iob.6
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHkkcCmXJJ1jda2AMq/ZSPcUATnxOYXoUdBw9f6zLfY=;
        b=ZU5IohPXpgO+xmewJ00YugTyjrXWG2ypQ1u/YFHFek4LZyWQaK9FcHSC4nBhBohYoS
         //ENtZQvHIjGqWI1dV5fOjf8thL+OU+4uyY0AyqEm05TrugfJK8HrDdhCDuMuoXKLLw1
         qtz6Nx6jlA3az/4vJLSCIjVOsnJuPvNe+RYNJndFfc1P6CEX2gVk23awe2mbWXcr5dvE
         RH5o0xTpXFgZVjJxJ0tFlPpUmvWzPyNCycV3dKJunV/UyFDRWhBbMF4fhLUi6lB3R4Ne
         AMjqqe68S5CtEKoDSDKTZNtDWEF8JmwGVjjPwCQ842WwonGZK0TKdJKf5blwSMBuY0wD
         re5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHkkcCmXJJ1jda2AMq/ZSPcUATnxOYXoUdBw9f6zLfY=;
        b=zb6oAy1s4qJMEWA8KeB5PBLUaZg8stedaCH+C+p+Z56/T8MOHsZCJ1CzdnWSQF08I0
         aFeU5uSAk7h+rZfGTN/crcPeJc6Qau+41zoj3ZY0iGIgixkzGFUh12d3ZN13pFfHIb8p
         WycaxQ2OosZAuxpsQoXFz/gXbmbXC/6O2Q8yX2/QxNp7eW3sKGcZPI0I8anubJeuVsJj
         gyTs5eqVaZqg9MskHBVhHqIVECUgwJBNG/oGNKTmnMnjpzJRr17X00XYfffOutUQnQb2
         keKuTg0T3EnhVXnIdlEUEZcs9c3tar4SBY4LXd28rCsYs0kJsHvt1CC7qloaNteWZ/Qn
         n7ZQ==
X-Gm-Message-State: AOAM530wc8it+oUR9k1U5xaIEDBFU/tuBDdC7F1CRvD/Aad8kkAyeDiC
        Lk+v/HNvB/cbyF3M7n/rotuoKSl5dZbdgA==
X-Google-Smtp-Source: ABdhPJxYvVA+7J1Pd0qP5bf3xStc+S/n90tNk1S8k2VdZDZFXVx3Fwt+2X3+hzrWnjkpMUulssb8bQ==
X-Received: by 2002:a02:b813:: with SMTP id o19mr5943810jam.130.1639585465929;
        Wed, 15 Dec 2021 08:24:25 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g1sm1153170ild.52.2021.12.15.08.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:24:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Date:   Wed, 15 Dec 2021 09:24:21 -0700
Message-Id: <20211215162421.14896-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215162421.14896-1-axboe@kernel.dk>
References: <20211215162421.14896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This enables the block layer to send us a full plug list of requests
that need submitting. The block layer guarantees that they all belong
to the same queue, but we do have to check the hardware queue mapping
for each request.

If errors are encountered, leave them in the passed in list. Then the
block layer will handle them individually.

This is good for about a 4% improvement in peak performance, taking us
from 9.6M to 10M IOPS/core.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/pci.c | 61 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6be6b1ab4285..197aa45ef7ef 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -981,6 +981,66 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 }
 
+static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct request **rqlist)
+{
+	spin_lock(&nvmeq->sq_lock);
+	while (!rq_list_empty(*rqlist)) {
+		struct request *req = rq_list_pop(rqlist);
+		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+
+		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
+				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
+		if (++nvmeq->sq_tail == nvmeq->q_depth)
+			nvmeq->sq_tail = 0;
+	}
+	nvme_write_sq_db(nvmeq, true);
+	spin_unlock(&nvmeq->sq_lock);
+}
+
+static bool nvme_prep_rq_batch(struct nvme_queue *nvmeq, struct request *req)
+{
+	/*
+	 * We should not need to do this, but we're still using this to
+	 * ensure we can drain requests on a dying queue.
+	 */
+	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
+		return false;
+	if (unlikely(!nvme_check_ready(&nvmeq->dev->ctrl, req, true)))
+		return false;
+
+	req->mq_hctx->tags->rqs[req->tag] = req;
+	return nvme_prep_rq(nvmeq->dev, req) == BLK_STS_OK;
+}
+
+static void nvme_queue_rqs(struct request **rqlist)
+{
+	struct request *req = rq_list_peek(rqlist), *prev = NULL;
+	struct request *requeue_list = NULL;
+
+	do {
+		struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
+
+		if (!nvme_prep_rq_batch(nvmeq, req)) {
+			/* detach 'req' and add to remainder list */
+			if (prev)
+				prev->rq_next = req->rq_next;
+			rq_list_add(&requeue_list, req);
+		} else {
+			prev = req;
+		}
+
+		req = rq_list_next(req);
+		if (!req || (prev && req->mq_hctx != prev->mq_hctx)) {
+			/* detach rest of list, and submit */
+			prev->rq_next = NULL;
+			nvme_submit_cmds(nvmeq, rqlist);
+			*rqlist = req;
+		}
+	} while (req);
+
+	*rqlist = requeue_list;
+}
+
 static __always_inline void nvme_pci_unmap_rq(struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
@@ -1678,6 +1738,7 @@ static const struct blk_mq_ops nvme_mq_admin_ops = {
 
 static const struct blk_mq_ops nvme_mq_ops = {
 	.queue_rq	= nvme_queue_rq,
+	.queue_rqs	= nvme_queue_rqs,
 	.complete	= nvme_pci_complete_rq,
 	.commit_rqs	= nvme_commit_rqs,
 	.init_hctx	= nvme_init_hctx,
-- 
2.34.1

