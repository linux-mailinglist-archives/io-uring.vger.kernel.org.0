Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D14475D54
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 17:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244769AbhLOQY0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 11:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244772AbhLOQYZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 11:24:25 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3F6C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:25 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e128so31062945iof.1
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZzPVTfgisDXhr5KSCCKdMaU8KCMcU6kyZCK6gX9Tpbw=;
        b=FUYh99cWyVn5DKtPS1l684xkvLXgyleEJaHJ047Gp+GwB+Ci1iK7mvEuNqqGGADSuT
         yLrUTTIqDH8rSCnUTAOrdoHw1nmBbcOxEcUiZGWpbaxkwjc1ZMArtWrS2BLxLQUs/v7X
         fOa14msslBo9VytcB3y9kHRu/nPmtyeTs2QFIHDQ5KtU+wg4amT860tT1b/SaNZIXOkG
         tvt7BqImsVoEXe6B7W3jA79Zwy/PBPtYQHEn1Eklv3EK44t5vHx/iUcykIu/KcmpHVAA
         vS9lFWztEcJhWEedOmuQNb0xvL73L9sqvMPXgcmQ1Ulmhiv/5bkXOK+Hrjd8HzX3b7Dr
         OKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZzPVTfgisDXhr5KSCCKdMaU8KCMcU6kyZCK6gX9Tpbw=;
        b=ORtd3pvfU4Ndb9dW0p5S5eRvgr/evvx5x+THjpsiiZsddPpBayniZBXcT+kdPcPogC
         J1vvHwwL+QHjVKhLA715vBzFWcL67OcABbIRD2wBDltVP/cm1lJAZah+hAB9Kyb7o5l3
         Pqz/rYSZCz2i08biguu5jB21GOqMr3LjiyzPRCqYY6hu29179x/pYzZDiPyKTAL8pDsx
         7UTIfxBnYckwqX9e+VCnb95zfhUCR0+v/zqWVZ4JK01gBd/K5exHO7OuogmPoJWaEsDm
         J9/ZFJMQrgHSKLXcwmxFypUZTwf8qCXPpPhJ99ciWAZNK8tRoSIngabGu79mdq9S1TD8
         /yxA==
X-Gm-Message-State: AOAM531G0++VUY6TYZBGnWQLKaAxLXxDcFLXt5vTR/E9DOeuYutx6F/O
        Pqc4OIqHRN7nqHeIC1ala+TV6RtVigwhFQ==
X-Google-Smtp-Source: ABdhPJw4R0XiVxp960OKfbwFzL+UQKbLRFWzaJigp4wFZsWhXzum7JVsqEg1TZG193tAMa11ph5hag==
X-Received: by 2002:a05:6638:3049:: with SMTP id u9mr6447426jak.132.1639585464597;
        Wed, 15 Dec 2021 08:24:24 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g1sm1153170ild.52.2021.12.15.08.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:24:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>, Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] nvme: split command copy into a helper
Date:   Wed, 15 Dec 2021 09:24:19 -0700
Message-Id: <20211215162421.14896-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215162421.14896-1-axboe@kernel.dk>
References: <20211215162421.14896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We'll need it for batched submit as well.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/pci.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8637538f3fd5..09ea21f75439 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -500,6 +500,15 @@ static inline void nvme_write_sq_db(struct nvme_queue *nvmeq, bool write_sq)
 	nvmeq->last_sq_tail = nvmeq->sq_tail;
 }
 
+static inline void nvme_sq_copy_cmd(struct nvme_queue *nvmeq,
+				    struct nvme_command *cmd)
+{
+	memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes), cmd,
+		sizeof(*cmd));
+	if (++nvmeq->sq_tail == nvmeq->q_depth)
+		nvmeq->sq_tail = 0;
+}
+
 /**
  * nvme_submit_cmd() - Copy a command into a queue and ring the doorbell
  * @nvmeq: The queue to use
@@ -510,10 +519,7 @@ static void nvme_submit_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
 			    bool write_sq)
 {
 	spin_lock(&nvmeq->sq_lock);
-	memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
-	       cmd, sizeof(*cmd));
-	if (++nvmeq->sq_tail == nvmeq->q_depth)
-		nvmeq->sq_tail = 0;
+	nvme_sq_copy_cmd(nvmeq, cmd);
 	nvme_write_sq_db(nvmeq, write_sq);
 	spin_unlock(&nvmeq->sq_lock);
 }
-- 
2.34.1

