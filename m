Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9331647769E
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhLPQFn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238786AbhLPQFn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:05:43 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A31AC06173F
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:43 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id c3so35838714iob.6
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mrsB3UCm4bmi73wguDQBqQCr2m0pev3vraLfK00rcq4=;
        b=NASmxMQXOzlzQl2P97eko9egq2Ee1UYORkMMfIMKOdwKqjMhjXLDTv/9JYPlKBgGCr
         oYeCIdjtUfNRkeKpro/j7f8I9AC7YQ0f6tSQUYAppLrQW5NSx2adWPwop+FeVVvPMwZf
         hMX8tXRXS3IJ8x86apPVybcmoWRw1Z2knYpIGBBBQUXUrDGaRZx5bl1rSsx0h2pZQEFB
         STbDmk7bPjwm2NWSA2mf6VHl2AUdvkGw+UN6veCxGHs8D5dUpLXg+hs6p8WvgR+vSz5j
         JJLipSh854HDnsQdrDVbPWzmviIyo/gLLA4+x4MDcBYeHq/0Ij1UZ6uSDBO0o9/DHqpd
         UdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrsB3UCm4bmi73wguDQBqQCr2m0pev3vraLfK00rcq4=;
        b=Xc6mVbtdIIz/JrhdB4NDTH62uJIck0RGDgcQ3kNUEW7zNcXjeap1id/0x1Jtq4zTKe
         ft+0SBkau7H03Xj8p1fMLP0qodX8ZutobeG9HAszNrzSlqwCcvpxaiAfFr08fyQ6Yg7q
         u859I2qMXovnjTMKQi1JJiUnJIoB10K2TCUy1C8CR03cV3WXxV7FOdL2fmyWyvoSn2wu
         Og6wUEbGKDKT12tQjb7Z1RgBIMyYhzENuRaGCwVsKODiTDkOhrrHQzDuiot4+y7icM6t
         MfGpYAfT7JUk6OVE2m9v2tfq4Y0EL+pkKa4TOox9vyFndmIyEshMyaF6svegZmhb7wo0
         hLvA==
X-Gm-Message-State: AOAM53253ma//VokjlVwgitk26XCC8/kD7aGqU3R4XkceSBHlmgROvnn
        7mXuxsjRpRnJ0poCG3MdM+XpRPZAdV8IGw==
X-Google-Smtp-Source: ABdhPJzr/bFJjYd6Il7Y+kIQ7ggNza0pgizMOaeK51YYrulffnpxoSLrnypU+JIpE8iPqtsuB2JQEQ==
X-Received: by 2002:a05:6638:4089:: with SMTP id m9mr9928722jam.187.1639670742320;
        Thu, 16 Dec 2021 08:05:42 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s9sm3237155ild.14.2021.12.16.08.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:05:41 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org
Cc:     Jens Axboe <axboe@kernel.dk>, Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 2/4] nvme: split command copy into a helper
Date:   Thu, 16 Dec 2021 09:05:35 -0700
Message-Id: <20211216160537.73236-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211216160537.73236-1-axboe@kernel.dk>
References: <20211216160537.73236-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We'll need it for batched submit as well.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
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

