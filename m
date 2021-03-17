Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F6833FACC
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCQWLA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhCQWKh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:37 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B7EC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:37 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z3so191208ioc.8
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8W7+YYUKDmGyivm8spLtYU/+YJefZ0TTuK53JMdcwuc=;
        b=kJpn053CDGSDSFKkT+BuV67pbHLv+J3RjCdYZU8NrHGWb+A1JSkLWM7WTUD9FwMm9P
         rbP8YDN40/AEzZuerKFc0YSSlUvDr/VXpFPQyuuukUtgK5tdQrulT3802piNYEzVAcqc
         RMhYvZIL2TwX9zA+xkM1AAG6cVcXgq7hn6O/LzO1VBu7ODTEl6RHEBRkKYxJPjsAGXJA
         MIqxD0x3N6hK/bUt4LKuq9yqz5xIcbnNvnr4Fna/zQtx6mg3moV/SKG+3rRyIjOQqvlU
         /YodPoCjNMLI/pYZ5cDhMnxl0C5jV0W2Q3xz2FRyDJmmkQWiQjNjNIRJ5PGh05UA6Awe
         H0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8W7+YYUKDmGyivm8spLtYU/+YJefZ0TTuK53JMdcwuc=;
        b=L8jeVlRczExhEsb3LF1uhQcSJJ2HoMFssrCAl2iIGZ6nLL4YCBK6nW9kzTb8WJCx3W
         qxFkpsKzQD5YwYW+0klrhRgh7V8jfT0+bWC0GXLiYsHzOoEQ5ydjXHpBgYQLSRICIzrz
         fggGzBEq/xe1CmcBy7NAGv6WlPNR2fj2AsPjqSl8WH+2BjjgrHbcAKLCgsLFErwZcom5
         fbJYcsb8MeAAg8VlX7si9a3umkioV1f7JlB/nqjzDrLN7yaH/wZ24Rw1Qhm3RhbZEvBk
         H2n7LQxTiVlM+4/+RwqEWi2w7NU/dG45aHhZRYDc9eXf8Ki8de/ABPJouX2FuK46hzF+
         QsaA==
X-Gm-Message-State: AOAM5319q4t/2gRr43vFKh/4Axvr3nvUWWu4LkgYzr4lQMwaHm3zn2fN
        8VnEI+5Je2awLhw1c8NFRv9K0FK8XmiR7w==
X-Google-Smtp-Source: ABdhPJw5Ck1Am8737XlkTvQ8dG9m//Gff1fYra95vWECv4y5EfCwE/8akIC1dsAJSv+7yV4ooLZGFQ==
X-Received: by 2002:a5d:8b09:: with SMTP id k9mr8011584ion.185.1616019036485;
        Wed, 17 Mar 2021 15:10:36 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] block: wire up support for file_operations->uring_cmd()
Date:   Wed, 17 Mar 2021 16:10:24 -0600
Message-Id: <20210317221027.366780-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317221027.366780-1-axboe@kernel.dk>
References: <20210317221027.366780-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass it through the mq_ops->uring_cmd() handler, so we can plumb it
through all the way to the device driver.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c         | 11 +++++++++++
 fs/block_dev.c         | 10 ++++++++++
 include/linux/blk-mq.h |  6 ++++++
 include/linux/blkdev.h |  2 ++
 4 files changed, 29 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d4d7c1caa439..6c68540a89c0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3919,6 +3919,17 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 }
 EXPORT_SYMBOL_GPL(blk_poll);
 
+int blk_uring_cmd(struct block_device *bdev, struct io_uring_cmd *cmd,
+		  enum io_uring_cmd_flags issue_flags)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (!q->mq_ops || !q->mq_ops->uring_cmd)
+		return -EOPNOTSUPP;
+
+	return q->mq_ops->uring_cmd(q, cmd, issue_flags);
+}
+
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
 	return rq->mq_ctx->cpu;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 92ed7d5df677..cbc403ad0330 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -34,6 +34,7 @@
 #include <linux/part_stat.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
+#include <linux/io_uring.h>
 #include "internal.h"
 
 struct bdev_inode {
@@ -317,6 +318,14 @@ struct blkdev_dio {
 
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
@@ -1840,6 +1849,7 @@ const struct file_operations def_blk_fops = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
+	.uring_cmd	= blkdev_uring_cmd,
 };
 
 /**
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2c473c9b8990..70ee55c148c1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -376,6 +376,12 @@ struct blk_mq_ops {
 	 */
 	int (*map_queues)(struct blk_mq_tag_set *set);
 
+	/**
+	 * @uring_cmd: queues requests through io_uring IORING_OP_URING_CMD
+	 */
+	int (*uring_cmd)(struct request_queue *q, struct io_uring_cmd *cmd,
+				enum io_uring_cmd_flags issue_flags);
+
 #ifdef CONFIG_BLK_DEBUG_FS
 	/**
 	 * @show_rq: Used by the debugfs implementation to show driver-specific
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bc6bc8383b43..7eb993e82783 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -957,6 +957,8 @@ int blk_status_to_errno(blk_status_t status);
 blk_status_t errno_to_blk_status(int errno);
 
 int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
+int blk_uring_cmd(struct block_device *bdev, struct io_uring_cmd *cmd,
+			enum io_uring_cmd_flags issue_flags);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
-- 
2.31.0

