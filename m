Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D947795D
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhLPQjH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbhLPQjH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:39:07 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5E2C06173E
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:39:06 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id 15so22548865ilq.2
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5IX74MWW+MmXrMtixah+OlhoboMuiSi2pn/mLZENDuU=;
        b=h+xv2L16XaQ7XBDfUh+cBCV9gZOt0jGlTL7hJlxewlVZdF/KeFEOAg7wqeIW1HM6ie
         jgXXOhESr35rI4HJ4X+Lu956zTOfva+wHc9X+OS+cHwQDYQQsiOlCjGGQNXxxxXL3I6Z
         KR8I0USQ0qocIEMrJdMij14zZSRyEl99f4ZwWWMeKgVe2FRjrLq7H62gvxYedEf7BfX8
         UmznztDNj7Rca2f7nqJ3qajucZsF2SZ9IXxANYRiCevLitEFfsZyIeWMZW6HlGpKh5mR
         rgjQnaQhIu5ogeO3wLn88mcMp1igflNUVn8bUtGxPxVpVFJhfl5cYUEJ6Hmk4t1EPSK5
         jZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5IX74MWW+MmXrMtixah+OlhoboMuiSi2pn/mLZENDuU=;
        b=VrTQf1gNN2Z8gt30Y+tJqTG5LQuxWTgqFxNXQBWpC6vbmiGIoeaCAbDmBm/cOtqtO0
         BUPClonQOA9UYzdAoWswbJBay09jmJUCnJrDUTmOJtU6zgEmcZxeJsGQTolh4vF+C3ZE
         bYHIpDrJF4HMRLsTcBcgtICujJPW3BzeMHw8niMwsv9Bn6R78Tjw+WKjrcXWuPzr88QZ
         SsLaaMntaDPN2CaMRKhqeMJ5yNXjr6yJsDLbhNnuNWBGEHYWxKlg8vQ7cgOWz6aBzn3f
         w2ZfY+MWfzb0rk8cuyDxs7+6Dpb818F7nJhUOr+hdSCZn+gjYFpHJlEwcgiJyyIK0b9g
         HUlA==
X-Gm-Message-State: AOAM533jFWPN1uvT1XVAZLKollyv6kH0TGFVizJIycHQWitpmoSQPKrn
        LOmrHcSFklyTo+7YdRGy8LCWfyIe/YD6AA==
X-Google-Smtp-Source: ABdhPJypT/FJAV4gbG5r+26xb+eg8kD4Wm9SRoUbE/cBV9XcOAGBXdJ3GFjTL1jOtWhomlwQk+8iqg==
X-Received: by 2002:a05:6e02:1528:: with SMTP id i8mr10122850ilu.312.1639672746003;
        Thu, 16 Dec 2021 08:39:06 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t17sm71816ilm.46.2021.12.16.08.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:39:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] nvme: separate command prep and issue
Date:   Thu, 16 Dec 2021 09:39:00 -0700
Message-Id: <20211216163901.81845-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211216163901.81845-1-axboe@kernel.dk>
References: <20211216163901.81845-1-axboe@kernel.dk>
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
 drivers/nvme/host/pci.c | 63 +++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 9d2a36de228a..7062128c8204 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -903,55 +903,32 @@ static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
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
-	spin_lock(&nvmeq->sq_lock);
-	nvme_sq_copy_cmd(nvmeq, &iod->cmd);
-	nvme_write_sq_db(nvmeq, bd->last);
-	spin_unlock(&nvmeq->sq_lock);
 	return BLK_STS_OK;
 out_unmap_data:
 	nvme_unmap_data(dev, req);
@@ -960,6 +937,38 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
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
+	spin_lock(&nvmeq->sq_lock);
+	nvme_sq_copy_cmd(nvmeq, &iod->cmd);
+	nvme_write_sq_db(nvmeq, bd->last);
+	spin_unlock(&nvmeq->sq_lock);
+	return BLK_STS_OK;
+}
+
 static __always_inline void nvme_pci_unmap_rq(struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-- 
2.34.1

