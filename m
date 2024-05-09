Return-Path: <io-uring+bounces-1836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B708C09D4
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 04:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 845B8B20A37
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 02:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558545D74C;
	Thu,  9 May 2024 02:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U0kx2v/m"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAC581745
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 02:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715222072; cv=none; b=NrbacdkvXAW6FHAxZwVcWcf+n3grYDZENC1N9wj8uzPeBpqgBvVgk+ZvbKulLIM3d/vYA3GSo1nHLek4LNWrXRhMqxoHCEN4uOoRfplUe4VF2C55CBS5UNVxQd0+lyFZe/hFAX4nSRPkrWfH2/A779L8X36VkHUAuoG1+yC1uuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715222072; c=relaxed/simple;
	bh=vGNoHyHJseiyhKnl3EWcZ/z41J2GY8esazGaZBnsPQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G012tAhPhefLciUwsRMMJB26i3mFLzIZVtochj7J3Zr5+mvz+ZdKNjpkKaDMAzDyYzvskRi+fmJn8utXO6BaW4XL2wHYtnqCZp+5AWQcNOf7GpOOm02xXF//Cp9e/G6l/LmS/v7sOu6/ZiWd7rudaAFv9WD7siRqG+8+jt1S+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U0kx2v/m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715222069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5O6je1yiZ59pdVq7gg7eVQ61QPBnyuz/RYvdiYxGIuM=;
	b=U0kx2v/mkfDtivENkYxadJ4gJfrNpcfihw5epluz5+ev7wxGcKee2L8QZTBeHiJA/R8SHA
	nkLvoYrXaZOnAzMaBARm8t2DfQT9Bvf9q4UTbxaAbnbcMNYyj79OIVoU4kRK4iDzV6+xbI
	WQs47pHGnzlFrAvYXBVIIZxaVuYvRkw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-nAfT9nPYNFG63WMWBK4Jcw-1; Wed,
 08 May 2024 22:34:25 -0400
X-MC-Unique: nAfT9nPYNFG63WMWBK4Jcw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A225F3C00097;
	Thu,  9 May 2024 02:34:24 +0000 (UTC)
Received: from localhost (unknown [10.72.116.32])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D2103C25;
	Thu,  9 May 2024 02:34:22 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] io_uring: add IORING_OP_NOP_FAIL
Date: Thu,  9 May 2024 10:34:13 +0800
Message-ID: <20240509023413.4124075-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Add IORING_OP_NOP_FAIL so that it is easy to inject failure from
userspace.

Like IORING_OP_NOP, the main use case is test, and it is very helpful
for covering failure handling code in io_uring core change.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/nop.c                | 27 +++++++++++++++++++++++++++
 io_uring/nop.h                |  3 +++
 io_uring/opdef.c              |  9 +++++++++
 4 files changed, 41 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 922f29b07ccc..18e58477e0f0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -72,6 +72,7 @@ struct io_uring_sqe {
 		__u32		waitid_flags;
 		__u32		futex_flags;
 		__u32		install_fd_flags;
+		__s32		nop_fail_res;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -259,6 +260,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAITV,
 	IORING_OP_FIXED_FD_INSTALL,
 	IORING_OP_FTRUNCATE,
+	IORING_OP_NOP_FAIL,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/nop.c b/io_uring/nop.c
index d956599a3c1b..c30547e53b5c 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -10,6 +10,12 @@
 #include "io_uring.h"
 #include "nop.h"
 
+struct io_nop_fail {
+	/* NOTE: kiocb has the file as the first member, so don't do it here */
+	struct file	*file;
+	int		res;
+};
+
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	return 0;
@@ -23,3 +29,24 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, 0, 0);
 	return IOU_OK;
 }
+
+int io_nop_fail_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_nop_fail *nf = io_kiocb_to_cmd(req, struct io_nop_fail);
+
+	nf->res = READ_ONCE(sqe->nop_fail_res);
+	return 0;
+}
+
+/*
+ * IORING_OP_NOP just posts a completion event, nothing else.
+ */
+int io_nop_fail(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_nop_fail *nf = io_kiocb_to_cmd(req, struct io_nop_fail);
+
+	if (nf->res < 0)
+		req_set_fail(req);
+	io_req_set_res(req, nf->res, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/nop.h b/io_uring/nop.h
index 97f1535c9dec..ef40d3b15899 100644
--- a/io_uring/nop.h
+++ b/io_uring/nop.h
@@ -2,3 +2,6 @@
 
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_nop(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_nop_fail_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_nop_fail(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 92b657a063a0..eadc5a12ee06 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -56,6 +56,12 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_nop_prep,
 		.issue			= io_nop,
 	},
+	[IORING_OP_NOP_FAIL] = {
+		.audit_skip		= 1,
+		.iopoll			= 1,
+		.prep			= io_nop_fail_prep,
+		.issue			= io_nop_fail,
+	},
 	[IORING_OP_READV] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
@@ -506,6 +512,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_NOP] = {
 		.name			= "NOP",
 	},
+	[IORING_OP_NOP_FAIL] = {
+		.name			= "NOP_FAIL",
+	},
 	[IORING_OP_READV] = {
 		.name			= "READV",
 		.cleanup		= io_readv_writev_cleanup,
-- 
2.44.0


