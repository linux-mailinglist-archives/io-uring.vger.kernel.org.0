Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B523065F8
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 22:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhA0V0y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 16:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbhA0V03 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 16:26:29 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD749C061756
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:49 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id e19so2154337pfh.6
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V02ZehrA+ZK/8VsVOnrBLpkoE4PfIb3EHfTTbJB2384=;
        b=U8+mZVp9LRFQx9Lx14ksvBOYhZYX5mdrsTsBkErPz2ZS6cZNVwqk1s87dTQi0OrCI8
         xVODLOS3xvdkrURMWBGUwVV/94eE02dKTUBVrOcpBMSH9dNL4WLac628lybN/5ukI9pD
         Kds5Y4lYqkqD4X6+1H1Q33uSPMCiUv9gdIV0YWB2VQhYMOi531AS8JCwSDyS0HLTFeqH
         /+qFY+tjzjSWXJ32L77yOF32cxUrdN9yvWDpn3bkMf4VU8mv0PXirzNdXlNJDJ8byMj0
         ZItXb5mY8Fq0kBX19TTJ+Q8EsMNGTl6J3dDE5RNv/dIdhlSYt8ibOHWZoPk+I9820wSt
         LTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V02ZehrA+ZK/8VsVOnrBLpkoE4PfIb3EHfTTbJB2384=;
        b=feyr0wEyfLr699VGGXXUEmJU6kM9+jOsaNuHonTwI5pseWiy0zgP0aox/MzIbPPulW
         +49hE0kyjXrqSsOa6U/F78rAXDFKSr3XbTuy1UAhjFp5plDx3FTmfr6lKKvf9l1DJn4Q
         8qLS9U8gCZTwu2u8tSjH+XmsqJC4v/nniJfZMM63HOJirKmf9ZZlX0YrbIYkQqEc2M8V
         2u7OdKq82v3Xxv42msaHimweMl8R0t4M0w8rBBIl8a/EDU5yChbw7ADF48G4OyYGNCAw
         j5METi/mvmIVHeRMz/nd7uoj2pyl80Rp/Q+FAihFlSpzFXlRIAtZW/LsP/2e65Hkselx
         VKFQ==
X-Gm-Message-State: AOAM530H38ODbTnsex+RKTppAaYPtmfvvo5xfY1AIKEsuLjpfCfDSFL3
        y+Kcqlpe/YgwkSrhJ9sdvIX5hnqNEoDL4g==
X-Google-Smtp-Source: ABdhPJyo1RULrElULMYZxLs/5frW73OHRM/7FY/6flsYC42o2cAQ00EaFIoSbHE0VevU1+8UVMTDmw==
X-Received: by 2002:a63:6686:: with SMTP id a128mr12996097pgc.109.1611782749115;
        Wed, 27 Jan 2021 13:25:49 -0800 (PST)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id mm4sm2794349pjb.1.2021.01.27.13.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:25:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] block: wire up support for file_operations->uring_cmd()
Date:   Wed, 27 Jan 2021 14:25:39 -0700
Message-Id: <20210127212541.88944-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210127212541.88944-1-axboe@kernel.dk>
References: <20210127212541.88944-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c         | 11 +++++++++++
 fs/block_dev.c         | 10 ++++++++++
 include/linux/blk-mq.h |  6 ++++++
 include/linux/blkdev.h |  1 +
 4 files changed, 28 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f285a9123a8b..00114f838ac2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3893,6 +3893,17 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 }
 EXPORT_SYMBOL_GPL(blk_poll);
 
+int blk_uring_cmd(struct block_device *bdev, struct io_uring_cmd *cmd,
+		  bool force_nonblock)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (!q->mq_ops || !q->mq_ops->uring_cmd)
+		return -EINVAL;
+
+	return q->mq_ops->uring_cmd(q, cmd, force_nonblock);
+}
+
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
 	return rq->mq_ctx->cpu;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3b8963e228a1..c837912c1d72 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -34,6 +34,7 @@
 #include <linux/part_stat.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
+#include <linux/io_uring.h>
 #include "internal.h"
 
 struct bdev_inode {
@@ -301,6 +302,14 @@ struct blkdev_dio {
 
 static struct bio_set blkdev_dio_pool;
 
+static int blkdev_uring_cmd(struct io_uring_cmd *cmd,
+			    enum io_uring_cmd_flags flags)
+{
+	struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
+
+	return blk_uring_cmd(bdev, cmd, flags);
+}
+
 static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
 {
 	struct block_device *bdev = I_BDEV(kiocb->ki_filp->f_mapping->host);
@@ -1825,6 +1834,7 @@ const struct file_operations def_blk_fops = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
+	.uring_cmd	= blkdev_uring_cmd,
 };
 
 /**
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d705b174d346..ddc0e1f07548 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -380,6 +380,12 @@ struct blk_mq_ops {
 	 */
 	int (*map_queues)(struct blk_mq_tag_set *set);
 
+	/**
+	 * @uring_cmd: queues requests through io_uring IORING_OP_URING_CMD
+	 */
+	int (*uring_cmd)(struct request_queue *q, struct io_uring_cmd *cmd,
+				bool force_nonblock);
+
 #ifdef CONFIG_BLK_DEBUG_FS
 	/**
 	 * @show_rq: Used by the debugfs implementation to show driver-specific
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94ee3089e01..d5af592d73fe 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -960,6 +960,7 @@ int blk_status_to_errno(blk_status_t status);
 blk_status_t errno_to_blk_status(int errno);
 
 int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
+int blk_uring_cmd(struct block_device *bdev, struct io_uring_cmd *cmd, bool force_nonblock);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
-- 
2.30.0

