Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE917475D55
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 17:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244778AbhLOQY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 11:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbhLOQY0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 11:24:26 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ADDC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:26 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id w1so19768744ilh.9
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1DYcik58lGFYrKDca0iP2KkrzogN79aaEMRFw0vbHgE=;
        b=H92UQIh7lQDE/MqXfMwjpO8DpUoqUWzLi9IbMb8r4n/C7K74At2VzjQbDjReilxNYh
         wpqtVpMJ6ElZGj1HpVCZFng+Ah+BRxbFXsS0+svajfGlAvzk6swjPkIBkEDI5j4Mwd6q
         iAav4hGc3OEggO3Y1A93ZDcsgzCWgxxcNqtAFUcbJcLE9y/ve0z01u0R8lwvSQnRzK9P
         qVsi58BNwrt3nKKmLpfAMSON127XG0SbPa32MApUnm4ax9Bl9P3kWVmW3fGlSxdXyTfB
         w/xK0c7xJ0qr235TSH8dP0U7sCvjR6rLf1Yt46yggnfsxp4tQbltRGS54lVKn2R9zhuE
         p4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1DYcik58lGFYrKDca0iP2KkrzogN79aaEMRFw0vbHgE=;
        b=G2qPJ22q50F4VHNBTK5hX7Wq8oPLsRe0gJGQEZVmVUW6nYJQo1hW44XJWMSb1CkRzD
         Hl0ulsg5XqlFVefFsbbKDLb2NkZ00CpG+rhb+agQYfELr70DfjhWKp+oZ3CuluIebjyC
         PxNVKFJt+Qbpb8+k3RmqoPpLu4LbiGlXXMX/GIxFi/1AwyxsSGF/p0TaOXbHxv5ZJkhQ
         r8wTYf8eh12rS+74XQgBwzpDuxSsUn2hutmpd44FVzQG8M+m5ZqRWFEkxhYsafsDKtr/
         3UdaHlm5s8bRESdy7HrBGfnHzKbBM2I6YF92ebNmZVFTeX6z0Xy0+NqJVArzWV/lRcXw
         m8RA==
X-Gm-Message-State: AOAM530dvJYejarjIWLkxPXapCJ5RBD4gSIx+TcNU9rvZfpZ7o/htq+s
        NY6x2zI534UFqJdox5O933Gejwa5KrjuGQ==
X-Google-Smtp-Source: ABdhPJyGsBF/9EjBrDJAqNZG7AUFniv8cq1FJggtfuaKN8uVbXbVYM6OYUO/PXlTlJH9AKEbOKDauw==
X-Received: by 2002:a05:6e02:b45:: with SMTP id f5mr6671558ilu.283.1639585465244;
        Wed, 15 Dec 2021 08:24:25 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g1sm1153170ild.52.2021.12.15.08.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:24:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] nvme: separate command prep and issue
Date:   Wed, 15 Dec 2021 09:24:20 -0700
Message-Id: <20211215162421.14896-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215162421.14896-1-axboe@kernel.dk>
References: <20211215162421.14896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a nvme_prep_rq() helper to setup a command, and nvme_queue_rq() is
adapted to use this helper.

Reviewed-by: Hannes Reinecke <hare@suse.de>
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

