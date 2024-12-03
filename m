Return-Path: <io-uring+bounces-5179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2F09E1BE3
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6CE328314C
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF58C1E7664;
	Tue,  3 Dec 2024 12:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rAAKCrdO"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1391EF0A7;
	Tue,  3 Dec 2024 12:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228086; cv=none; b=FeobCaoGLsp/oOErCg7J0p4tnjiO1YwsaQgFynoTicOybvA+z1ggKKHUcyIlXAGwYiCM3v1UHTHs4VNW+l8XaV7hSP3Ye8p8wjMKsMulbHH+vFaOyHKjh9sxlVUMJUAqs5lQs5fadyUi1NegNZdhgQJQFXumf9cCH+VE6D+4m1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228086; c=relaxed/simple;
	bh=hmgTYvyKwTUsLw4N96/c501UhYL9t4E16VnIBneOYok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hfLtqAL4UxhaQwgTy+We+Pwwkp9wTACCWrg9Uo+O8Ss7JNq7HRIB2nWLEEgcKCAOKBQGqzz0u7QdwBhIm2jkCMwQLcjmVy628ks76e0wU9rjpqlLEmqEfelcBkvyKgnCIpFUqkJyqUQYVLXjH/PrIuVBoPBW2upvTBMYW8vWaV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rAAKCrdO; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733228075; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=7qI5Tpti/q7G+Vv+zck9DF1myBpIVdZteXJ2iz09tI4=;
	b=rAAKCrdOe5Pq504FkpldHyMq8folfVOrypXM4urq8NKC5RYzCArQXzTZ6+k3sTvVw2xNHkTEljQb6nszjJkRYCWJyGgjETCKU1luoe/HqKAinIihpfDHYffBHp2OPARN9qvuV253Vv4G4MSA0pf2NBmHojHQ5OTxXfjj5f4tPI0=
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WKmboUw_1733228074 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Dec 2024 20:14:34 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	virtualization@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH 3/3] virtio-blk: add uring_cmd iopoll support.
Date: Tue,  3 Dec 2024 20:14:24 +0800
Message-Id: <20241203121424.19887-4-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20241203121424.19887-1-mengferry@linux.alibaba.com>
References: <20241203121424.19887-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add polling support for uring_cmd polling support for virtblk, which
will be called during completion-polling.

Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
---
 drivers/block/virtio_blk.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 1a4bac3dc044..7888789a3eb8 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1469,6 +1469,18 @@ static int virtblk_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue
 	return virtblk_uring_cmd(vblk, ioucmd, issue_flags);
 }
 
+static int virtblk_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags)
+{
+	struct virtblk_uring_cmd_pdu *pdu = virtblk_get_uring_cmd_pdu(ioucmd);
+	struct request *req = pdu->req;
+
+	if (req && blk_rq_is_poll(req))
+		return blk_rq_poll(req, iob, poll_flags);
+	return 0;
+}
+
 static void virtblk_cdev_rel(struct device *dev)
 {
 	ida_free(&vd_chr_minor_ida, MINOR(dev->devt));
@@ -1517,6 +1529,7 @@ static int virtblk_cdev_add(struct virtio_blk *vblk,
 static const struct file_operations virtblk_chr_fops = {
 	.owner		= THIS_MODULE,
 	.uring_cmd	= virtblk_chr_uring_cmd,
+	.uring_cmd_iopoll = virtblk_chr_uring_cmd_iopoll,
 };
 
 static unsigned int virtblk_queue_depth;
-- 
2.43.5


