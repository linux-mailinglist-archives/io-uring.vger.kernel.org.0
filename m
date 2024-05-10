Return-Path: <io-uring+bounces-1853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF5F8C1D35
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 05:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5107F1F2238B
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 03:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDAA149DE7;
	Fri, 10 May 2024 03:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OkDlceWl"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C975149C51
	for <io-uring@vger.kernel.org>; Fri, 10 May 2024 03:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715313052; cv=none; b=GvwQzf93UggUOqhYQJEhK3PrRxeMXrk9Zv/muXvrHNfqadTwVLZjB90sKQC/bOpWlFZNhHNL0LENUOwsms8X+lneRfXECaNou7V1kyE8lTh16eMwAeHtlzC7kJ6Nq2ArlOc8WqX7FHjEXNldpextb0c/+1pI4nZlzJrsZlvavi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715313052; c=relaxed/simple;
	bh=xHaS8RuSm+RAvHD7FiV0lv2QmdmMiqn2V4R9zlmW7Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSv+bgiuDuUaS2A0M4DgX1yiAABopq/KGk32bWRYOf1RU8Tc1jqpPCOPHzEARA6OU2K2F1dcoke/qv2AYVPuAYpHSEQR6j7SxsEdd9Y+mnctgtQY3QOnjj6+b0XqKirrCMTs7zuReeht4F1AXsaEfrXgUg9Qi4NlsYF5a0d1VDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OkDlceWl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715313048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQxmNizpGxh8r0UMULNAz/Lp2TMmVrIxJyns9wH8C6U=;
	b=OkDlceWlsBSwTDJyy4OaNqKqe6W40PulkfkakZUpWD0cWvQLQSIbTmRwF5jTUIH90ErHx4
	Jn2Li9J+hyI5T/gJ4jHw5WKprPCJLseQNwPrD/DX2lbcspYge3bZWzS3IiK8+AO9+dJJ1A
	M/8xZIR5I+SEjXh/N++NHoyue0WbFiY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-153-UwXz_FKoOYWzrVuDPvjwiA-1; Thu,
 09 May 2024 23:50:45 -0400
X-MC-Unique: UwXz_FKoOYWzrVuDPvjwiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5D9B3C0BE3F;
	Fri, 10 May 2024 03:50:44 +0000 (UTC)
Received: from localhost (unknown [10.72.116.53])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 003887464;
	Fri, 10 May 2024 03:50:43 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/2] io_uring: support to inject result for NOP
Date: Fri, 10 May 2024 11:50:28 +0800
Message-ID: <20240510035031.78874-3-ming.lei@redhat.com>
In-Reply-To: <20240510035031.78874-1-ming.lei@redhat.com>
References: <20240510035031.78874-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Support to inject result for NOP so that we can inject failure from
userspace. It is very helpful for covering failure handling code in
io_uring core change.

With nop flags, it becomes possible to add more test features on NOP in
future.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/nop.c                | 26 +++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 922f29b07ccc..21e9cd604068 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -72,6 +72,7 @@ struct io_uring_sqe {
 		__u32		waitid_flags;
 		__u32		futex_flags;
 		__u32		install_fd_flags;
+		__u32		nop_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -413,6 +414,13 @@ enum io_uring_msg_ring_flags {
  */
 #define IORING_FIXED_FD_NO_CLOEXEC	(1U << 0)
 
+/*
+ * IORING_OP_NOP flags (sqe->nop_flags)
+ *
+ * IORING_NOP_INJECT_RESULT	Inject result from sqe->result
+ */
+#define IORING_NOP_INJECT_RESULT	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 1a4e312dfe51..a5bcf3d6984f 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -10,18 +10,34 @@
 #include "io_uring.h"
 #include "nop.h"
 
+struct io_nop {
+	/* NOTE: kiocb has the file as the first member, so don't do it here */
+	struct file     *file;
+	int             result;
+};
+
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (READ_ONCE(sqe->rw_flags))
+	unsigned int flags;
+	struct io_nop *nop = io_kiocb_to_cmd(req, struct io_nop);
+
+	flags = READ_ONCE(sqe->nop_flags);
+	if (flags & ~IORING_NOP_INJECT_RESULT)
 		return -EINVAL;
+
+	if (flags & IORING_NOP_INJECT_RESULT)
+		nop->result = READ_ONCE(sqe->len);
+	else
+		nop->result = 0;
 	return 0;
 }
 
-/*
- * IORING_OP_NOP just posts a completion event, nothing else.
- */
 int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
-	io_req_set_res(req, 0, 0);
+	struct io_nop *nop = io_kiocb_to_cmd(req, struct io_nop);
+
+	if (nop->result < 0)
+		req_set_fail(req);
+	io_req_set_res(req, nop->result, 0);
 	return IOU_OK;
 }
-- 
2.42.0


