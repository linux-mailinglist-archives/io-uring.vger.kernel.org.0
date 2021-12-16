Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526CA4776A3
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhLPQFp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238789AbhLPQFp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:05:45 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE512C06173E
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:44 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id c3so35838826iob.6
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/PWmmDkqw4hfM6o+w9vrmK9zC/wyrsfBGmnpHNH1A4s=;
        b=cZQk8FmAyyc4dLcZnnc4aVaa72YqVCZRdQ7I9wkBxidqK2R84aK3YnNFoJkKWR26BL
         vTog6F1FcDQdAchOgFXsg5mNA+bSKdknh8fAeU22bmRev82PqjrmvE60YbMvp7BL0ADS
         7EFAvQN+Hb9Liti7xR+iQfSq4ALn+vam4aXlIaYvsIWSNsN5KROKocReO3KStx/hTwxY
         kbI92/9DCl8JYB4NzqA0IQRhF5gFVxAFoyR2GjAp+OFqkHh6+EOrn1+17rWsBKcaL5Mo
         moykKhDJzWtOEAoacgrLq5fqbVMQtF2VoGXy8smC3nGyq7YG7bFySrJI0cotKZwtHMLC
         CKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/PWmmDkqw4hfM6o+w9vrmK9zC/wyrsfBGmnpHNH1A4s=;
        b=oXIDYKxNhPtSmowyLn5t9MzOVtTN2vyerMydz1RUWnhqVp4f+Bdft3jypWOclrmQ3T
         NLFxefHKHKMDSEuRIor3vA4w122c08/4HuWdxWnrArJLwbLLG8h3iEbnCw0JhzE8EGDm
         Tek2EGbW1p+9/2uVY60UrOIns81d/wf/NahpKZeDFD7us6J3iKlI6h4WwWd7IR2+kwQv
         xbnsVoCoKl3jJ86HM3sofkcBsSu/xLrfeAEpH/CU1Bhv2r6kIHH3SwomU/1VtDm0EvT0
         /WoA7mAsLtqjezjJ7UaWk6Nb+pvBnt1HLvomxCLmojhFOqpduHsGW9P7tNSF5gkZDzCs
         oERg==
X-Gm-Message-State: AOAM533P6qMhzwvwr2PLJoxtEwOBons9e5/jcLkrA0LIZT2RAVtywTo7
        MxtW7D+QLWDC10+cmKzzwyIbCAKu7aAyZA==
X-Google-Smtp-Source: ABdhPJyw3+fT/a7gefxPigqVMegk1UxofIMMCBv+uVydXXF56pofuEw+FLJtbXuk0WLtOds7Jal1xQ==
X-Received: by 2002:a05:6638:389a:: with SMTP id b26mr9781380jav.197.1639670744180;
        Thu, 16 Dec 2021 08:05:44 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s9sm3237155ild.14.2021.12.16.08.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:05:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Date:   Thu, 16 Dec 2021 09:05:37 -0700
Message-Id: <20211216160537.73236-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211216160537.73236-1-axboe@kernel.dk>
References: <20211216160537.73236-1-axboe@kernel.dk>
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
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/pci.c | 58 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6be6b1ab4285..e34ad67c4c41 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -981,6 +981,63 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 }
 
+static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct request **rqlist)
+{
+	spin_lock(&nvmeq->sq_lock);
+	while (!rq_list_empty(*rqlist)) {
+		struct request *req = rq_list_pop(rqlist);
+		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+
+		nvme_sq_copy_cmd(nvmeq, &iod->cmd);
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
@@ -1678,6 +1735,7 @@ static const struct blk_mq_ops nvme_mq_admin_ops = {
 
 static const struct blk_mq_ops nvme_mq_ops = {
 	.queue_rq	= nvme_queue_rq,
+	.queue_rqs	= nvme_queue_rqs,
 	.complete	= nvme_pci_complete_rq,
 	.commit_rqs	= nvme_commit_rqs,
 	.init_hctx	= nvme_init_hctx,
-- 
2.34.1

