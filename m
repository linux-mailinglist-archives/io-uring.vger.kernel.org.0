Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DC633FACB
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhCQWLA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhCQWKi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:38 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC684C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:37 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id n21so190572ioa.7
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KkKh5SY71C+FvwTcfh8mE1DhvpyfUkn9hUkYbs4O9uU=;
        b=nEyiuMdV54j/OgsEdoViDD+gQi+B9sV1e3zfAB3arkHDY7GA7Zeo6EF/FUiJreDWAo
         Q7bq786vic3McMUEWzdYRvTCdHZppXIrzx3wq9j9mKOADxNUI6kY8/F22keFh1vUaR2r
         IRPoA+jGceSwfF9vVUdZVkk3G8OGGTsb+4nxN3R+okKdNN0ZlSxqOIv7BBjn/HrqwG8m
         mP3vRxrE42ELmoanHkEo+KREb8u0jk/8N9Y6L0GPX28gZb4NbBNCnIOJDFHU99l2PzVS
         8gGdRk90EEDqI+1rOBEZazMNtwXfcz3UzntzW3VgVGwwiGKJ9oGHGHbdB/lAoXVTehos
         Ui4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KkKh5SY71C+FvwTcfh8mE1DhvpyfUkn9hUkYbs4O9uU=;
        b=P+Yq09WT+W1j9XUBoQEbK1w9ZMJOVSn7/ByppxZLlhQG4C9SaE+xOuJ8EzGMm9zGi3
         C4UDxdzJ/azkDPEyHX3OBCVJ6LDhZmNCQuGe8PpCA4KT6qihKdR6Jk2/apjBkpivij4R
         a0HNiBZKyDoXT0qJcuZnrjFuv8lqu8T2XzDgnbBo2xVEHSN7brdDEWONy7SMqY02KziV
         YeYisMH7WEZxglsiEpNG5hS5jf1LPpuzlc0S/nuQleqA+Gbae27odZCcE/G29awS+pr6
         wUlc2bW8hblkHOMq+P/1Xsq69l2OfBTCmUSmPIoIPi6oS/aey776j2imda/i0Xt1IIMP
         fXug==
X-Gm-Message-State: AOAM532cZxvPM5Kgo757Ldm2QG92nSiLyP7JgBeLjiQ+KI9EVO1p5Lyd
        SpgFmsJP8xeIkmis+vrhUmIsNbx6uGdZCw==
X-Google-Smtp-Source: ABdhPJz8fvnnw8RlLkr9wLoROMXmX9ahGpPVVL8curGupYjnD/cCG5gAjx0Qt0fqUKhBN4l1blBdhw==
X-Received: by 2002:a6b:b447:: with SMTP id d68mr8124145iof.87.1616019037237;
        Wed, 17 Mar 2021 15:10:37 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] block: add example ioctl
Date:   Wed, 17 Mar 2021 16:10:25 -0600
Message-Id: <20210317221027.366780-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317221027.366780-1-axboe@kernel.dk>
References: <20210317221027.366780-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Grab op == 1, BLOCK_URING_OP_IOCTL, and use it to implement basic
ioctl functionality.

Example code, to issue BLKBSZGET through IORING_OP_URING_CMD:

struct block_uring_cmd {
	__u32	ioctl_cmd;
	__u32	unused1;
	__u64	unused2[4];
};

static int get_bs(struct io_uring *ring, const char *dev)
{
	struct io_uring_cqe *cqe;
	struct io_uring_sqe *sqe;
        struct io_uring_cmd_sqe *csqe;
	struct block_uring_cmd *cmd;
	int ret, fd;

	fd = open(dev, O_RDONLY);

	sqe = io_uring_get_sqe(ring);
	csqe = (void *) sqe;
        memset(csqe, 0, sizeof(*csqe));
        csqe->hdr.opcode = IORING_OP_URING_CMD;
        csqe->hdr.fd = fd;
	csqe->user_data = 0x1234;
	csqe->op = BLOCK_URING_OP_IOCTL;

	io_uring_submit(ring);
	io_uring_wait_cqe(ring, &cqe);
	printf("bs=%d\n", cqe->res);
	io_uring_cqe_seen(ring, cqe);
	return 0;
err:
	return 1;
}

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/block_dev.c         | 20 ++++++++++++++++++++
 include/linux/blkdev.h | 11 +++++++++++
 2 files changed, 31 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index cbc403ad0330..9e44f63a0fe1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -318,11 +318,31 @@ struct blkdev_dio {
 
 static struct bio_set blkdev_dio_pool;
 
+static int blkdev_uring_ioctl(struct block_device *bdev,
+			      struct io_uring_cmd *cmd)
+{
+	struct block_uring_cmd *bcmd = (struct block_uring_cmd *) &cmd->pdu;
+
+	switch (bcmd->ioctl_cmd) {
+	case BLKBSZGET:
+		return block_size(bdev);
+	default:
+		return -ENOTTY;
+	}
+}
+
 static int blkdev_uring_cmd(struct io_uring_cmd *cmd,
 			    enum io_uring_cmd_flags flags)
 {
 	struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
 
+	switch (cmd->op) {
+	case BLOCK_URING_OP_IOCTL:
+		return blkdev_uring_ioctl(bdev, cmd);
+	default:
+		break;
+	}
+
 	return blk_uring_cmd(bdev, cmd, flags);
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7eb993e82783..fa895aa3b51a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -44,6 +44,17 @@ struct blk_queue_stats;
 struct blk_stat_callback;
 struct blk_keyslot_manager;
 
+enum {
+	BLOCK_URING_OP_IOCTL = 1,
+};
+
+/* This overlays struct io_uring_cmd pdu (40 bytes) */
+struct block_uring_cmd {
+	__u32	ioctl_cmd;
+	__u32	unused1;
+	__u64	unused2[4];
+};
+
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
 
-- 
2.31.0

