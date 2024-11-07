Return-Path: <io-uring+bounces-4530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 381349C0333
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E0D3B2398E
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EC81F471F;
	Thu,  7 Nov 2024 11:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJKJiJ2e"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971831F4296
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977359; cv=none; b=uxOACIAl/G1PjOw+RFPGdjRzDZNsfTbCNzUA5qMWpVkgkamkTHKq9qs1ER7xXREbOnb7awfjrDmqJhEMqmhLh3LJaROS6tBu6lAGdnXqNKnBhUDb5RJeIlwMUj5LK61jbvfN+H4uaT2h8gAIw3FOhbWMzwpqJduGNOsyuj4zfSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977359; c=relaxed/simple;
	bh=tly5WzZ/x+5sr3uFZjmb1OElDgbLU/izgB/EE+LNdcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfjNs0e+mjBVgukfoHwe0HVpWvXKF00ur393VF7eRGvF0hTTDZ4McnlXp8PUCMh7VyyxoUeJek3IyViLCK7PVOgy99yoOvDd8UeyrOnJ+BHOsftQaTZgyRt0xgTL33LTZPyVjq4fo6Dsix0CKrHTcfurqo6ZpOm7i07YJaYVwPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJKJiJ2e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eXhq6YRcO+Qv5hJmRM0rhu2PFbttro6G4So3Dp8+hAE=;
	b=BJKJiJ2esDjGR8CE+Q0wXQuo877a1XPiwcYmHJpg5yUcOgxHXrWJ7Hr7iozCJbwDmchvNa
	3iAe6KAhvBHDYOlIHrfHVBPtWlYD+Dce0BZqgqpFtZHrVpkqerN0XI10xuS0Ysa3TPEgJM
	QbcpMjhoddcwmgzljOlVhdE/Q0WoIlU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-22-CXAvhZHPN5O82g83F8N1aA-1; Thu,
 07 Nov 2024 06:02:35 -0500
X-MC-Unique: CXAvhZHPN5O82g83F8N1aA-1
X-Mimecast-MFC-AGG-ID: CXAvhZHPN5O82g83F8N1aA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 201D51955F45;
	Thu,  7 Nov 2024 11:02:34 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E59F33003B78;
	Thu,  7 Nov 2024 11:02:32 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 08/12] io_uring: reuse io_mapped_buf for kernel buffer
Date: Thu,  7 Nov 2024 19:01:41 +0800
Message-ID: <20241107110149.890530-9-ming.lei@redhat.com>
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

Prepare for supporting kernel buffer in case of io group, in which group
leader leases kernel buffer to io_uring, and consumed by io_uring OPs.

So reuse io_mapped_buf for group kernel buffer, and unfortunately
io_import_fixed() can't be reused since userspace fixed buffer is
virt-contiguous, but it isn't true for kernel buffer.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 19 +++++++++++++++++++
 io_uring/kbuf.c                | 34 ++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h                |  3 +++
 io_uring/rsrc.c                |  1 +
 io_uring/rsrc.h                | 10 ----------
 5 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d060ce5e6145..03abaeef4a67 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -2,6 +2,7 @@
 #define IO_URING_TYPES_H
 
 #include <linux/blkdev.h>
+#include <linux/bvec.h>
 #include <linux/hashtable.h>
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
@@ -39,6 +40,24 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+struct io_mapped_buf {
+	u64		addr;
+	unsigned int	len;
+	unsigned int	nr_bvecs;
+	refcount_t	refs;
+	union {
+		/* for userspace buffer only */
+		unsigned int	acct_pages;
+		/* offset in the 1st bvec, for kbuf only */
+		unsigned int	offset;
+	};
+	const struct bio_vec	*pbvec; /* pbvec is only for kbuf */
+	unsigned int	folio_shift:6;
+	unsigned int	dir:1;		/* ITER_DEST or ITER_SOURCE */
+	unsigned int	kbuf:1;		/* kernel buffer or not */
+	struct bio_vec	bvec[] __counted_by(nr_bvecs);
+};
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d407576ddfb7..c4a776860cb4 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -838,3 +838,37 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	io_put_bl(ctx, bl);
 	return ret;
 }
+
+/*
+ * kernel buffer is built over generic bvec, and can't be always
+ * virt-contiguous, which is different with userspace fixed buffer,
+ * so we can't reuse io_import_fixed() here
+ *
+ * Also kernel buffer lifetime is bound with request, and we needn't
+ * to use rsrc_node to track its lifetime
+ */
+int io_import_kbuf(int ddir, struct iov_iter *iter,
+		    const struct io_mapped_buf *kbuf,
+		    u64 buf_off, size_t len)
+{
+	unsigned long offset = kbuf->offset;
+
+	WARN_ON_ONCE(!kbuf->kbuf);
+
+	if (ddir != kbuf->dir)
+		return -EINVAL;
+
+	if (unlikely(buf_off > kbuf->len))
+		return -EFAULT;
+
+	if (unlikely(len > kbuf->len - buf_off))
+		return -EFAULT;
+
+	offset += buf_off;
+	iov_iter_bvec(iter, ddir, kbuf->pbvec, kbuf->nr_bvecs, offset + len);
+
+	if (offset)
+		iov_iter_advance(iter, offset);
+
+	return 0;
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 36aadfe5ac00..04ccd52dd0ad 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -88,6 +88,9 @@ void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
 struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
+int io_import_kbuf(int ddir, struct iov_iter *iter,
+		    const struct io_mapped_buf *kbuf,
+		    u64 buf_off, size_t len);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 99ff2797e6ec..b0b60ae0456a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -771,6 +771,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->len = iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	imu->folio_shift = PAGE_SHIFT;
+	imu->kbuf = 0;
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index bf0824b4beb6..3bc3a484fbba 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -28,16 +28,6 @@ struct io_rsrc_node {
 	};
 };
 
-struct io_mapped_buf {
-	u64		addr;
-	unsigned int	len;
-	unsigned int	nr_bvecs;
-	refcount_t	refs;
-	unsigned int	acct_pages;
-	unsigned int	folio_shift:6;
-	struct bio_vec	bvec[] __counted_by(nr_bvecs);
-};
-
 struct io_imu_folio_data {
 	/* Head folio can be partially included in the fixed buf */
 	unsigned int	nr_pages_head;
-- 
2.47.0


