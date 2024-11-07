Return-Path: <io-uring+bounces-4531-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FCB9C033A
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C4DFB23CC1
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578DA1F12EA;
	Thu,  7 Nov 2024 11:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="beaos4aI"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1111F4FB8
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977365; cv=none; b=PCyyzGihaYsvSvqtKcSH5lL8jtLTvCH5lz0ptZ9ULMBjV2nxhLXXiaVWWUoPrf4b1/s8NEiZUfghWo26bi/RUCz21q2eNiAA2eyrxBfN6Qu9Jr5iDJvhdLWYwNDp55bEOE5IxGcKXJ9qOGTt0u4Q7FHoiKWW2eWVi/9EBvr+tZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977365; c=relaxed/simple;
	bh=SlVDir5D6UeaNDe+jsuQbh685ORFlAHHlttDEDq1XPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiChwV7FHu6pI5kf2WzJStXHrqIY8BmeL76MAqt3CRSsUfOcbqdeWJe6/neMTAa4C+IesWAg8dL6cf6wrrdWO/1OsxsWqF106Ee9hY7uLumD5wVCnDI0tNSUMsG0qVVNEwiODHTX7DkicAwxIqBYeC7r1PmyT9DzAgB65nfzGh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=beaos4aI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dkSqkK/E8i2PqF8EQ4nFg2slbPvUmDf+ZN1S2KY4Ymo=;
	b=beaos4aIRxoGAk8Ni/xH78YxZYMn3KAZBYuEmJ+XxcWd4ZzfCuYaVcQ8pHER5inyIN2Y1N
	sm4TsG5O4LXcuZk0i6o7I34RUl/lONitLZ9j/E3Y5hFPOUFi/FQpnunaMXKt0bQgqg7mp7
	GPg/4Y3l+OhSxZhlkzW2Irsp7Y3g/ac=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-s0ETgjZnPu2Oqx6nllwKxg-1; Thu,
 07 Nov 2024 06:02:39 -0500
X-MC-Unique: s0ETgjZnPu2Oqx6nllwKxg-1
X-Mimecast-MFC-AGG-ID: s0ETgjZnPu2Oqx6nllwKxg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A6371955F69;
	Thu,  7 Nov 2024 11:02:38 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2D24A3003B78;
	Thu,  7 Nov 2024 11:02:36 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 09/12] io_uring: add callback to 'io_mapped_buffer' for giving back kernel buffer
Date: Thu,  7 Nov 2024 19:01:42 +0800
Message-ID: <20241107110149.890530-10-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Add one callback to 'io_mapped_buffer' for giving back kernel buffer
after the buffer is used.

Meantime move 'io_rsrc_node' into public header, and it will become
part of kernel buffer API.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 20 +++++++++++++++++++-
 io_uring/rsrc.c                | 14 +++++++++++++-
 io_uring/rsrc.h                | 13 +------------
 3 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 03abaeef4a67..7de0d4c0ed6b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -40,8 +40,26 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+struct io_rsrc_node {
+	unsigned char			type;
+	unsigned char			flags;
+	int				refs;
+
+	u64 tag;
+	union {
+		unsigned long file_ptr;
+		struct io_mapped_buf *buf;
+	};
+};
+
+typedef void (io_uring_kbuf_ack_t) (struct io_rsrc_node *);
+
 struct io_mapped_buf {
-	u64		addr;
+	/* 'addr' is always 0 for kernel buffer */
+	union {
+		u64			addr;
+		io_uring_kbuf_ack_t	*kbuf_ack;
+	};
 	unsigned int	len;
 	unsigned int	nr_bvecs;
 	refcount_t	refs;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b0b60ae0456a..327bc1a83e4b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -441,6 +441,18 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static void __io_free_buf_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
+{
+	struct io_mapped_buf *buf = node->buf;
+
+	if (node->flags & IORING_RSRC_F_BUF_KERNEL) {
+		if (buf->kbuf_ack)
+			buf->kbuf_ack(node);
+	} else {
+		io_buffer_unmap(ctx, node);
+	}
+}
+
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	bool need_free = node->flags & IORING_RSRC_F_NEED_FREE;
@@ -457,7 +469,7 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 		break;
 	case IORING_RSRC_BUFFER:
 		if (node->buf)
-			io_buffer_unmap(ctx, node);
+			__io_free_buf_node(ctx, node);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 3bc3a484fbba..f45a26c3b79d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -14,18 +14,7 @@ enum {
 	__IORING_RSRC_LAST_TYPE,
 
 	IORING_RSRC_F_NEED_FREE		= 1 << 0,
-};
-
-struct io_rsrc_node {
-	unsigned char			type;
-	unsigned char			flags;
-	int				refs;
-
-	u64 tag;
-	union {
-		unsigned long file_ptr;
-		struct io_mapped_buf *buf;
-	};
+	IORING_RSRC_F_BUF_KERNEL	= 1 << 1,
 };
 
 struct io_imu_folio_data {
-- 
2.47.0


