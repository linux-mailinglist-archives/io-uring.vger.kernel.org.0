Return-Path: <io-uring+bounces-5563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D3589F61C6
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 10:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5F5A16F277
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 09:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E930519CC02;
	Wed, 18 Dec 2024 09:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ohxVXwiS"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0EA19C55E;
	Wed, 18 Dec 2024 09:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734513952; cv=none; b=NzSR2LWci5XEkfduUqcd15Ek5kP2/+fahVpvQR6BnTotGJxyUoTcGuipXYbYtRvR4vzS5nDrtc56kTaD1ErRxpedkHEt31Sz9ow7dmLGtfbKGjVcg2vr6w4HZ0FysmADHGu99R3d3d1gKDUCyzXNZJnvamnnrZ6oLRxGfBaoBjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734513952; c=relaxed/simple;
	bh=wxtQ0TZ7j3ZY1hR9Eku6xzWcBCWgwW5EFBD+bahXas0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EnXFHKOd6ilSN4br2mfkDtOnQQLmAlTsccMLnyNerbi/BPlzt+voOyNRZov/vEQ2XtetBLVtN88kYZOoqs9OGZBWEgOCWyKDLqB9kCAG3Hgi97BapHBBItIfaSTKucHQtzzRGKqe2MDy5hWN02XujBcI6+ZnQD/swKttdDYWjRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ohxVXwiS; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734513942; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=c1EfSmJ9YbNZGNCvZnfavVBw0I455mOuEcxsYdW1oE8=;
	b=ohxVXwiSJ4BpcHKBY4eKEQbe2uUvjBdBdqNm9ieeBpJZbJS8rsbpFAFEIxd2R6ipxxeqr4Qbm3PlhiTg57AVtQk/qCys0Rbdfr6DKqBdhSNIgTRFKl8YPIj5NxWEB/B4KlKb8EJFr+uDXHtZag+s1bW3USsTEAgWQ3VMBv/2mww=
Received: from localhost(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WLmA.cP_1734513937 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Dec 2024 17:25:41 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	virtualization@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH v1 3/3] virtio-blk: add uring_cmd iopoll support.
Date: Wed, 18 Dec 2024 17:24:35 +0800
Message-Id: <20241218092435.21671-4-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20241218092435.21671-1-mengferry@linux.alibaba.com>
References: <20241218092435.21671-1-mengferry@linux.alibaba.com>
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
index cd88cf939144..cd4c74e06107 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1464,6 +1464,18 @@ static int virtblk_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue
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
@@ -1512,6 +1524,7 @@ static int virtblk_cdev_add(struct virtio_blk *vblk,
 static const struct file_operations virtblk_chr_fops = {
 	.owner		= THIS_MODULE,
 	.uring_cmd	= virtblk_chr_uring_cmd,
+	.uring_cmd_iopoll = virtblk_chr_uring_cmd_iopoll,
 };
 
 static unsigned int virtblk_queue_depth;
-- 
2.43.5


