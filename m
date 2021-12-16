Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D5E4776A0
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbhLPQFo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238785AbhLPQFo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:05:44 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC51C06173E
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:44 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id y16so35830644ioc.8
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JCw+S8MiRnjhm6Un4sTvVrQkhG8i170ZABgo8Q4BBso=;
        b=NkcbH8mZTCgYOSB2aFWY8GOOMtrhf9xV8eOfa4N5jDew+OFiLEvGEPti7SXdNShxvr
         1maa4XtP5vVq/ChUxmmQsZ2ulmFCHwe/QYA+AdDQigyxivBncO/p1XEDAQAgOLBVgJ5V
         YCY16xYo7UjQoTrqw9TnYBHow6kxGTzfgyNBrK8hfch+ETpTg882tWdTFo0S6leO1GKH
         T1LfT+UENDhltpm/lK46aH0ARilQEBU1Hh1qKNmqOLRfFsjhIUoItx6lRSxLLo4Pk4RO
         Y+6abOKfcmkllsf8muRmySKKmZp2YBQgZU1euOX6/m904BiqDqoljPaXr/aw5nyndYi/
         SYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JCw+S8MiRnjhm6Un4sTvVrQkhG8i170ZABgo8Q4BBso=;
        b=PwqomoUi4TWyLlim5bSdZxa42MYIvg7IBTqFxN4sRMAIOoYBQr3zm2rvuWTBSPXH+e
         FIepWTJpE2CZUv9MtfKYfK6PWN0XCWpsIVztDLOaOpSc1UR9Nvi4Q8hmFY7050mXwFrm
         NGq6qU2ZjiPAworDrwI4bBvRHVlBu0m3w3FZFqg5zewTmG9hpHFbQb7QxzlLPJPUyqDo
         M+WxE3KwvBCSFsddVQGR7wo68XjJpcLMPgLfBWN4bu0qRWrcz82gfujyvmUW55TN+ORO
         VaOcWZCzfMvrgyUswSqFfcw4jI//nVKnAoVbHxxuuudzDf5yS7gnXQxzcTXuk9gNpxeW
         m2YQ==
X-Gm-Message-State: AOAM530ZWJxbaFmFMrqtGpL3CmDqGjLpZd67VFYVk1LeeT8gI4ea3TZe
        EhevP3q5ghi+OL4iXnCxYXeDQh+T+aBw3w==
X-Google-Smtp-Source: ABdhPJzYVUiNQvpOOg/ChWSy3WurmZn+VAg7Kx8Ahru1rOdFB2u10I4Slb8DQn/We9TEzwUaeUPVjQ==
X-Received: by 2002:a5d:9e04:: with SMTP id h4mr9632236ioh.192.1639670743239;
        Thu, 16 Dec 2021 08:05:43 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s9sm3237155ild.14.2021.12.16.08.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:05:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] nvme: separate command prep and issue
Date:   Thu, 16 Dec 2021 09:05:36 -0700
Message-Id: <20211216160537.73236-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211216160537.73236-1-axboe@kernel.dk>
References: <20211216160537.73236-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a nvme_prep_rq() helper to setup a command, and nvme_queue_rq() is
adapted to use this helper.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/pci.c | 57 ++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 09ea21f75439..6be6b1ab4285 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -918,52 +918,32 @@ static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
 	return BLK_STS_OK;
 }
 
-/*
- * NOTE: ns is NULL when called on the admin queue.
- */
-static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
-			 const struct blk_mq_queue_data *bd)
+static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 {
-	struct nvme_ns *ns = hctx->queue->queuedata;
-	struct nvme_queue *nvmeq = hctx->driver_data;
-	struct nvme_dev *dev = nvmeq->dev;
-	struct request *req = bd->rq;
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct nvme_command *cmnd = &iod->cmd;
 	blk_status_t ret;
 
 	iod->aborted = 0;
 	iod->npages = -1;
 	iod->nents = 0;
 
-	/*
-	 * We should not need to do this, but we're still using this to
-	 * ensure we can drain requests on a dying queue.
-	 */
-	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
-		return BLK_STS_IOERR;
-
-	if (!nvme_check_ready(&dev->ctrl, req, true))
-		return nvme_fail_nonready_command(&dev->ctrl, req);
-
-	ret = nvme_setup_cmd(ns, req);
+	ret = nvme_setup_cmd(req->q->queuedata, req);
 	if (ret)
 		return ret;
 
 	if (blk_rq_nr_phys_segments(req)) {
-		ret = nvme_map_data(dev, req, cmnd);
+		ret = nvme_map_data(dev, req, &iod->cmd);
 		if (ret)
 			goto out_free_cmd;
 	}
 
 	if (blk_integrity_rq(req)) {
-		ret = nvme_map_metadata(dev, req, cmnd);
+		ret = nvme_map_metadata(dev, req, &iod->cmd);
 		if (ret)
 			goto out_unmap_data;
 	}
 
 	blk_mq_start_request(req);
-	nvme_submit_cmd(nvmeq, cmnd, bd->last);
 	return BLK_STS_OK;
 out_unmap_data:
 	nvme_unmap_data(dev, req);
@@ -972,6 +952,35 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return ret;
 }
 
+/*
+ * NOTE: ns is NULL when called on the admin queue.
+ */
+static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
+			 const struct blk_mq_queue_data *bd)
+{
+	struct nvme_queue *nvmeq = hctx->driver_data;
+	struct nvme_dev *dev = nvmeq->dev;
+	struct request *req = bd->rq;
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	blk_status_t ret;
+
+	/*
+	 * We should not need to do this, but we're still using this to
+	 * ensure we can drain requests on a dying queue.
+	 */
+	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
+		return BLK_STS_IOERR;
+
+	if (unlikely(!nvme_check_ready(&dev->ctrl, req, true)))
+		return nvme_fail_nonready_command(&dev->ctrl, req);
+
+	ret = nvme_prep_rq(dev, req);
+	if (unlikely(ret))
+		return ret;
+	nvme_submit_cmd(nvmeq, &iod->cmd, bd->last);
+	return BLK_STS_OK;
+}
+
 static __always_inline void nvme_pci_unmap_rq(struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-- 
2.34.1

