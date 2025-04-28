Return-Path: <io-uring+bounces-7744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA290A9ED1D
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 11:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33E39162F37
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 09:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4591F8AC5;
	Mon, 28 Apr 2025 09:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0UEoD/z"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E65726562C
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 09:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833490; cv=none; b=OfsDytGL+FFRy5rtY9GlZhOQ0rHENGGAzhLgXuZI5N8bI1Dcb9ZxDsCmV+g/YeaeVpI9AIx0l+wXIsRVU6OSLX0FY8oKV/2hcZc/9E4jGfoAY+ibvGKDbnw05RYJzTZbEptPMjEXiiKcW8AKrS30DcE6AAG1Ow0m9DgotqVHO9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833490; c=relaxed/simple;
	bh=QmLXCrgjIAPTluNt5Iv+thbn7KFN2Pj/ddwaKF+EDdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdT92fmCGeBRsYnFQARrHjs8oOxQcLhP2RuQkzELf2YUSZJUVPITvMArud7ZWcqt/fE2c4usH2Zq+ItuRlLddfiOwWqcFXXMKHPOEWJgKtSZpA6odRLahFQqv6SqmzvuWoR5ZES/gLaUeTFHPfO/DWW+d3hB9cRdXAtHnltKYMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M0UEoD/z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745833487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGkVcIPcxaJSNcYNV3fG5cntcxywxXvXZ+bM1Dn/T6U=;
	b=M0UEoD/zyjJzFbwbgV2F7zxws2AopuKhlGNZjon6FGFYGio0/fh8Y0J6y+G7Hi20gOqxfu
	SZxxk4ZXmi6bZVqNWAjKYZy+p3xmCPvdoSWEHr8qp4lNYbU+TwZixGQFLBDsEMsgf0CMYJ
	nI69g/Gs1Y7IgL3wlnsFAuqghAJ8460=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-eDEN9TMFPGGWyAOdLh_w2g-1; Mon,
 28 Apr 2025 05:44:44 -0400
X-MC-Unique: eDEN9TMFPGGWyAOdLh_w2g-1
X-Mimecast-MFC-AGG-ID: eDEN9TMFPGGWyAOdLh_w2g_1745833482
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F03419560A7;
	Mon, 28 Apr 2025 09:44:42 +0000 (UTC)
Received: from localhost (unknown [10.72.116.134])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4DDA5180045C;
	Mon, 28 Apr 2025 09:44:40 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 2/7] io_uring: add helper __io_buffer_[un]register_bvec
Date: Mon, 28 Apr 2025 17:44:13 +0800
Message-ID: <20250428094420.1584420-3-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-1-ming.lei@redhat.com>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Add helper __io_buffer_[un]register_bvec and prepare for supporting to
register bvec buffer into specified io_uring and buffer index.

No functional change.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 88 ++++++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 42 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 66d2c11e2f46..5f8ab130a573 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -918,11 +918,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-int io_buffer_register_bvec(struct io_uring_cmd *cmd,
-			    struct io_buf_data *buf,
-			    unsigned int issue_flags)
+static int __io_buffer_register_bvec(struct io_ring_ctx *ctx,
+				     struct io_buf_data *buf)
 {
-	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
 	unsigned int index = buf->index;
 	struct request *rq = buf->rq;
@@ -931,32 +929,23 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,
 	struct io_rsrc_node *node;
 	struct bio_vec bv, *bvec;
 	u16 nr_bvecs;
-	int ret = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
-	if (index >= data->nr) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-	index = array_index_nospec(index, data->nr);
+	if (index >= data->nr)
+		return -EINVAL;
 
-	if (data->nodes[index]) {
-		ret = -EBUSY;
-		goto unlock;
-	}
+	index = array_index_nospec(index, data->nr);
+	if (data->nodes[index])
+		return -EBUSY;
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
-	if (!node) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+	if (!node)
+		return -ENOMEM;
 
 	nr_bvecs = blk_rq_nr_phys_segments(rq);
 	imu = io_alloc_imu(ctx, nr_bvecs);
 	if (!imu) {
 		kfree(node);
-		ret = -ENOMEM;
-		goto unlock;
+		return -ENOMEM;
 	}
 
 	imu->ubuf = 0;
@@ -976,43 +965,58 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,
 
 	node->buf = imu;
 	data->nodes[index] = node;
-unlock:
+
+	return 0;
+}
+
+int io_buffer_register_bvec(struct io_uring_cmd *cmd,
+			    struct io_buf_data *buf,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	int ret;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	ret = __io_buffer_register_bvec(ctx, buf);
 	io_ring_submit_unlock(ctx, issue_flags);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
 
-int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
-			      struct io_buf_data *buf,
-			      unsigned int issue_flags)
+static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
+				       struct io_buf_data *buf)
 {
-	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
 	unsigned index = buf->index;
 	struct io_rsrc_node *node;
-	int ret = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
-	if (index >= data->nr) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-	index = array_index_nospec(index, data->nr);
+	if (index >= data->nr)
+		return -EINVAL;
 
+	index = array_index_nospec(index, data->nr);
 	node = data->nodes[index];
-	if (!node) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-	if (!node->buf->is_kbuf) {
-		ret = -EBUSY;
-		goto unlock;
-	}
+	if (!node)
+		return -EINVAL;
+	if (!node->buf->is_kbuf)
+		return -EBUSY;
 
 	io_put_rsrc_node(ctx, node);
 	data->nodes[index] = NULL;
-unlock:
+	return 0;
+}
+
+int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
+			      struct io_buf_data *buf,
+			      unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	int ret;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	ret = __io_buffer_unregister_bvec(ctx, buf);
 	io_ring_submit_unlock(ctx, issue_flags);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
-- 
2.47.0


