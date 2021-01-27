Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A043065F9
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 22:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhA0V05 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 16:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbhA0V0b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 16:26:31 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262ACC0613D6
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:51 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id q2so1814791plk.4
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qLr97P+UidBQuPdYIPY/zrFSADzh9MRW845nXhMa79M=;
        b=yPYLGP/EhvRJCe8C1JNTou5RuMlRjZcLNf9JUTjLfI5ZqRNxvH8p7rb0K0OslZzBmN
         QlDLoYcGib+usqvJkzUCTWMasWvmo4WMqEWQ7B4qw5U11OeM5siRBYr9UjdJWZBnyIu4
         QnnylGc3Ay+2O15FilO3+Y6YlEHyV3xD09Gn5L0tCSBI2izFThlT1kSmUiyTDt3imar7
         VL4LQb3AQDHGuINnPFG52IdCEPB9IViJLlsxV9hF6AykeYQ1WneBgCVVLWKfhuoa7X/m
         lrHXTXl18F42EcR8rE8FwGFVajPiWrHsmh8fRd4+Stx4Mgr85DErfC8PPMa4S+z1v1LK
         WHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qLr97P+UidBQuPdYIPY/zrFSADzh9MRW845nXhMa79M=;
        b=FKspmoU00xhxiIcKaVzDIYRfCArOnsVk8KsQYKiTn7zQPX/AMNBcuS34OzqSgzrCFO
         ZxTfQ3iIdGueTOMd4+K1Pj4O+LrSgL9aN+Ervlc4CPT+94kG6otqmjwB0bA5PcQBqrJa
         Rp+5R0nMdDZumakjdFGKsthJoHKILciw2ejDDu5WDbyu+pFiZkBZdX++xIJxITmQbazE
         U79Ygvb7ILZ4DPbOh3Cu71ou0jm4zaDbpi/s2q6K8kPcrZId3tPFqGOUwk9q7aq/P4nX
         RGst8QH8r470SisOR5dNSeKmg+vuuRxPzjE5F1Iis91UIBAAa0AGePRL8lVkAdloK4K0
         WIeA==
X-Gm-Message-State: AOAM533p7jxt3mYpf+1+NH66OgALiNNV6IFJqsIeJYhkub0/psll7Ce7
        bGtSkisgcfmrorfSj7E4fAqsE7s2FpoV+g==
X-Google-Smtp-Source: ABdhPJxzGN+lS8/18YYkMF/csBKeLNtXRkK6Dvn3othlZiNdPoHsd6vStuLtFNCZpv1DpDm4q5Lh8w==
X-Received: by 2002:a17:90a:c003:: with SMTP id p3mr7775287pjt.176.1611782750358;
        Wed, 27 Jan 2021 13:25:50 -0800 (PST)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id mm4sm2794349pjb.1.2021.01.27.13.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:25:49 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] block: add example ioctl
Date:   Wed, 27 Jan 2021 14:25:40 -0700
Message-Id: <20210127212541.88944-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210127212541.88944-1-axboe@kernel.dk>
References: <20210127212541.88944-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Example code, to issue BLKBSZGET through IORING_OP_URING_CMD:

struct block_uring_cmd {
	__u16 	op;
	__u16	pad;
	union {
		__u32	size;
		__u32	ioctl_cmd;
	};
	__u64	addr;
	__u64	unused[2];
	__u64	reserved;	/* can never be used */
	__u64	unused2;
};

static int get_bs(struct io_uring *ring, const char *dev)
{
	struct io_uring_cqe *cqe;
	struct io_uring_sqe *sqe;
	struct block_uring_cmd *cmd;
	int ret, fd;

	fd = open(dev, O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	sqe = io_uring_get_sqe(ring);
	if (!sqe) {
		fprintf(stderr, "get sqe failed\n");
		goto err;
	}

	memset(sqe, 0, sizeof(*sqe));
	sqe->opcode = IORING_OP_URING_CMD;
	sqe->fd = fd;
	cmd = (void *) &sqe->off;
	cmd->op = BLOCK_URING_OP_IOCTL;
	cmd->ioctl_cmd = BLKBSZGET;
	sqe->user_data = 0x1234;

	ret = io_uring_submit(ring);
	if (ret <= 0) {
		fprintf(stderr, "sqe submit failed: %d\n", ret);
		goto err;
	}

	ret = io_uring_wait_cqe(ring, &cqe);
	if (ret < 0) {
		fprintf(stderr, "wait completion %d\n", ret);
		goto err;
	}
	printf("bs=%d\n", cqe->res);
	io_uring_cqe_seen(ring, cqe);
	return 0;
err:
	return 1;
}

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/block_dev.c         | 19 +++++++++++++++++++
 include/linux/blkdev.h | 17 +++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c837912c1d72..7cb1b24ebbb5 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -302,10 +302,29 @@ struct blkdev_dio {
 
 static struct bio_set blkdev_dio_pool;
 
+static int blkdev_uring_ioctl(struct block_device *bdev,
+			      struct block_uring_cmd *bcmd)
+{
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
+	struct block_uring_cmd *bcmd = (struct block_uring_cmd *) &cmd->pdu;
+
+	switch (bcmd->op) {
+	case BLOCK_URING_OP_IOCTL:
+		return blkdev_uring_ioctl(bdev, bcmd);
+	default:
+		break;
+	}
 
 	return blk_uring_cmd(bdev, cmd, flags);
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d5af592d73fe..48ac8ccbffe2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -44,6 +44,23 @@ struct blk_queue_stats;
 struct blk_stat_callback;
 struct blk_keyslot_manager;
 
+enum {
+	BLOCK_URING_OP_IOCTL = 1,
+};
+
+struct block_uring_cmd {
+	__u16 	op;
+	__u16	pad;
+	union {
+		__u32	size;
+		__u32	ioctl_cmd;
+	};
+	__u64	addr;
+	__u64	unused[2];
+	__u64	reserved;	/* can never be used */
+	__u64	unused2;
+};
+
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
 
-- 
2.30.0

