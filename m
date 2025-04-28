Return-Path: <io-uring+bounces-7743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73F92A9ED1C
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 11:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 101D716AAD7
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 09:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3638F49;
	Mon, 28 Apr 2025 09:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I9mZsVyo"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B751F8AC5
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 09:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833486; cv=none; b=tJZvFUoWeRAu6EMoM2Tht4Yl5pzE8MFUH9IgDIyVSN7NIlNIm9vJZLY7yLg0TgttwAWbDk4KRgQACp0DMFjtEzbw42G5FoZLg1Ik3mAVpUkXpd+umau5pKvzuDsOBwgeiQgAndqrQ0RG6WNlsshcBA+eFSjOk2bUjsy7RyxkfPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833486; c=relaxed/simple;
	bh=GKu6HfbWo/iYRACaHTELvQwBv2yjhwSEVQMhSyUEMK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+MfFKkxUGY8xs7JJQJuK6IDE+ktKXyk7XPE82I2hf7jept83OTee8STmO/uB1Q4LVAkp1ecTcRxCbx+kpVsxyENR3YOXFOtZ5XOY/lEYBADm8sV4IHQv13gGYpZx6J1XvBClNNXC1221/s5vne/Wsxg2xmMA1HdBiaLhJed8ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I9mZsVyo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745833483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3zQjPrQ1mZAXlHntbXMWHt4W036K+IKSRWb3VmbW9Jk=;
	b=I9mZsVyo/jkqD9SvG8h+4fawoenmQBllK0JYqyfwWHtz1ls9UhlfDulKywHvBTjHeF8fnv
	+nmB6o9G7Q9tl0KPj5HCR1DYIR8bOuqHQMeHIbgH1h+5qkYVMUOYJT1CuqG8EqepX11ftu
	SMi/IYW6sgx84XDrMKbhTfRhIBu4eZI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-NYIfzPKrNUemxBDnhY-ozg-1; Mon,
 28 Apr 2025 05:44:39 -0400
X-MC-Unique: NYIfzPKrNUemxBDnhY-ozg-1
X-Mimecast-MFC-AGG-ID: NYIfzPKrNUemxBDnhY-ozg_1745833478
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2E3F1800373;
	Mon, 28 Apr 2025 09:44:37 +0000 (UTC)
Received: from localhost (unknown [10.72.116.134])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF5C01956094;
	Mon, 28 Apr 2025 09:44:36 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 1/7] io_uring: add 'struct io_buf_data' for register/unregister bvec buffer
Date: Mon, 28 Apr 2025 17:44:12 +0800
Message-ID: <20250428094420.1584420-2-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-1-ming.lei@redhat.com>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Add 'struct io_buf_data' for register/unregister bvec buffer, and
prepare for supporting to register buffer into one specified io_uring
context by its FD.

No functional change.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c     | 13 ++++++++++---
 include/linux/io_uring/cmd.h | 11 ++++++++---
 io_uring/rsrc.c              | 12 ++++++++----
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0d82014679f8..ac56482b55f5 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1925,6 +1925,10 @@ static int ublk_register_io_buf(struct io_uring_cmd *cmd,
 {
 	struct ublk_device *ub = cmd->file->private_data;
 	const struct ublk_io *io = &ubq->ios[tag];
+	struct io_buf_data data = {
+		.index = index,
+		.release = ublk_io_release,
+	};
 	struct request *req;
 	int ret;
 
@@ -1938,8 +1942,8 @@ static int ublk_register_io_buf(struct io_uring_cmd *cmd,
 	if (!req)
 		return -EINVAL;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release, index,
-				      issue_flags);
+	data.rq = req;
+	ret = io_buffer_register_bvec(cmd, &data, issue_flags);
 	if (ret) {
 		ublk_put_req_ref(ubq, req);
 		return ret;
@@ -1953,6 +1957,9 @@ static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
 				  unsigned int index, unsigned int issue_flags)
 {
 	const struct ublk_io *io = &ubq->ios[tag];
+	struct io_buf_data data = {
+		.index = index,
+	};
 
 	if (!ublk_support_zero_copy(ubq))
 		return -EINVAL;
@@ -1960,7 +1967,7 @@ static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
 	if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
 		return -EINVAL;
 
-	return io_buffer_unregister_bvec(cmd, index, issue_flags);
+	return io_buffer_unregister_bvec(cmd, &data, issue_flags);
 }
 
 static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_queue *ubq,
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 0634a3de1782..78fa336a284b 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -23,6 +23,12 @@ struct io_uring_cmd_data {
 	void			*op_data;
 };
 
+struct io_buf_data {
+	unsigned short index;
+	struct request *rq;
+	void (*release)(void *);
+};
+
 static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 {
 	return sqe->cmd;
@@ -140,10 +146,9 @@ static inline struct io_uring_cmd_data *io_uring_cmd_get_async_data(struct io_ur
 	return cmd_to_io_kiocb(cmd)->async_data;
 }
 
-int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
-			    void (*release)(void *), unsigned int index,
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct io_buf_data *data,
 			    unsigned int issue_flags);
-int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
+int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, struct io_buf_data *data,
 			      unsigned int issue_flags);
 
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b4c5f3ee8855..66d2c11e2f46 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -918,12 +918,14 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
-			    void (*release)(void *), unsigned int index,
+int io_buffer_register_bvec(struct io_uring_cmd *cmd,
+			    struct io_buf_data *buf,
 			    unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
+	unsigned int index = buf->index;
+	struct request *rq = buf->rq;
 	struct req_iterator rq_iter;
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
@@ -963,7 +965,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	imu->folio_shift = PAGE_SHIFT;
 	imu->nr_bvecs = nr_bvecs;
 	refcount_set(&imu->refs, 1);
-	imu->release = release;
+	imu->release = buf->release;
 	imu->priv = rq;
 	imu->is_kbuf = true;
 	imu->dir = 1 << rq_data_dir(rq);
@@ -980,11 +982,13 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
 
-int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
+int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
+			      struct io_buf_data *buf,
 			      unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
+	unsigned index = buf->index;
 	struct io_rsrc_node *node;
 	int ret = 0;
 
-- 
2.47.0


