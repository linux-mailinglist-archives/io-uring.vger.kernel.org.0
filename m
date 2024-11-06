Return-Path: <io-uring+bounces-4481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78FFF9BE8C5
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 13:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A92AC1C211EE
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 12:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B8E1DF995;
	Wed,  6 Nov 2024 12:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WEDX4P5Y"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE641DFD87
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896048; cv=none; b=JgozjeE21eHMBnJ0FqOTXEwUhKjP6yTl8Db8FFduY7dANF3h9QxpVfRPWA//kD9BEtuAwfzOjbDqIXU8vbffv0mzSoXzgcKLrkRNituOPeVnuth07g4/2d9VsvKfqoCJEYW7LTI+K1gcqhwLrVXg4tKNIR7f1eZ+BlFjKyjiOs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896048; c=relaxed/simple;
	bh=1QWulgHUvJkdOB0e5l3GzqDIh6AiXlQGyix1I1F/ZgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/cKPRD4BiwoWT6pgRdPU2tAjFcI9DGnjA8Y1y6dxqCJZiW4yL262iEGSN8RpFtDrlPLgn7vKSi++uS9TVlFcYtJqijEYgOo3gbKF1tPhlSQNjXQyK3nnO+qYs+4wHbz6r/+L7shnSVr6ULG7cWLgaeSzWwIjfAAlTRIRvaPNWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WEDX4P5Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730896044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lprUT577+Ss+DKbpmzYjj4MgCX45ZINOsjEQPPDWDG0=;
	b=WEDX4P5Ywo7DYGSwy8dMjCrXQgSn9RHFsaxYlL78Vod5+MIj0fqrzh/a0xaHti/WEGtD6h
	GC9fGygUw5H3ez/9URx2GZUbbuIl0r8ZQV+qae6y9CqWBH312D+I3lk+FTcZ3U80zhpouv
	ZK8mTYHFWaFzZnBtDNGzQDEOtNwTALA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-ZXJVmKGKOW2P9_HVR4spxA-1; Wed,
 06 Nov 2024 07:27:21 -0500
X-MC-Unique: ZXJVmKGKOW2P9_HVR4spxA-1
X-Mimecast-MFC-AGG-ID: ZXJVmKGKOW2P9_HVR4spxA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC031195FE03;
	Wed,  6 Nov 2024 12:27:19 +0000 (UTC)
Received: from localhost (unknown [10.72.116.107])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7E9C51955F40;
	Wed,  6 Nov 2024 12:27:18 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V9 2/7] io_uring: rename ubuf of io_mapped_buf as start
Date: Wed,  6 Nov 2024 20:26:51 +0800
Message-ID: <20241106122659.730712-3-ming.lei@redhat.com>
In-Reply-To: <20241106122659.730712-1-ming.lei@redhat.com>
References: <20241106122659.730712-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

->ubuf of `io_mapped_buf` stores the start address of userspace fixed
buffer. `io_mapped_buf` will be extended for covering kernel buffer,
so rename ->ubuf as ->start.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/fdinfo.c | 2 +-
 io_uring/rsrc.c   | 6 +++---
 io_uring/rsrc.h   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 9ca95f877312..9b39cb596136 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -223,7 +223,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		if (ctx->buf_table.nodes[i])
 			buf = ctx->buf_table.nodes[i]->buf;
 		if (buf)
-			seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
+			seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->start, buf->len);
 		else
 			seq_printf(m, "%5u: <none>\n", i);
 	}
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 70dba4a4de1d..9b8827c72230 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -765,7 +765,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 
 	size = iov->iov_len;
 	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
+	imu->start = (unsigned long) iov->iov_base;
 	imu->len = iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	imu->folio_shift = PAGE_SHIFT;
@@ -877,14 +877,14 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
-	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
+	if (unlikely(buf_addr < imu->start || buf_end > (imu->start + imu->len)))
 		return -EFAULT;
 
 	/*
 	 * Might not be a start of buffer, set size appropriately
 	 * and advance us to the beginning.
 	 */
-	offset = buf_addr - imu->ubuf;
+	offset = buf_addr - imu->start;
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
 
 	if (offset) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 9d55f9769c77..887699400e29 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -27,7 +27,7 @@ struct io_rsrc_node {
 };
 
 struct io_mapped_buf {
-	u64		ubuf;
+	u64		start;
 	unsigned int	len;
 	unsigned int	nr_bvecs;
 	unsigned int    folio_shift;
-- 
2.47.0


