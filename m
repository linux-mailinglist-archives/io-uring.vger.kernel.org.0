Return-Path: <io-uring+bounces-1848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B428C1BF2
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 03:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 881831F22827
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 01:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92311C01;
	Fri, 10 May 2024 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WvY9wOIc"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA7D17C8
	for <io-uring@vger.kernel.org>; Fri, 10 May 2024 01:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715303673; cv=none; b=JjysdmYHKf95o7yZAf+UXQbwK/p2qeVgEeSXc3DxybkEWlTaKhsPXQay38iwyadtp0tFIUtTCeLFwulFbYXuqtDNXNn4BRXQoL0LpW+mXVymraUCGyA/KIeh/Hygo6lGxOtYMe7E11Q8gZ+EYtL5jpF3AZGuCrNfa3IrMD81j7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715303673; c=relaxed/simple;
	bh=mKd0x+5/9pD7i5E28997syvXYDubM4XDZwH3RKWGSIc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tsJUY+p8BAn/NqpAc6Yv4qBk1bP1WvQ4yDCYyWwLppaVn+KJdMqvttCwaLUX6HJcFPYBRRfNpJjim7aBDbgZlNizHg28pjkw8A9iY1vrBRc0xHe9kr5CsXv2lTQ2+99Z0HsJfYbzuf9U5RcR6ZUBSMs4FqRF5ojRH7MgAE9e5k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WvY9wOIc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715303670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ufWheIZaQ1NqwcG793dsDp+JZ2JCilRK8ZK6JJGT0CQ=;
	b=WvY9wOIc47Mj9Ds1BEwe2s5d00zM7qvsSkLpnBjXnh/yvDVux0CwQ0Dfz/vNAxvxp3l0nK
	naYeS5ctCAlkvtJ97PetBjd9sU81rQGtIyAM9xMrtbPiiifaYqYwweKJRbcfhJ0ck0LC0p
	pOFyMkYGX9q7X/oaqY7db4CiBeiAp1I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-paD-aU27ONmoU6SNJoDcIg-1; Thu, 09 May 2024 21:14:27 -0400
X-MC-Unique: paD-aU27ONmoU6SNJoDcIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF995101A525;
	Fri, 10 May 2024 01:14:26 +0000 (UTC)
Received: from localhost (unknown [10.72.116.53])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 088E420AF03C;
	Fri, 10 May 2024 01:14:25 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] io_uring: support to inject result for NOP
Date: Fri, 10 May 2024 09:14:21 +0800
Message-ID: <20240510011421.55139-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Support to inject result for NOP so that we can inject failure from
userspace. It is very helpful for covering failure handling code in
io_uring core change.

With nop flags, it could be possible to add more test feature for NOP in
future, but the NOP behavior of direct completion has to be kept.

Cleared NOP SQE is required, look both liburing and Rust io-uring crate
clears SQE, and it shouldn't be one big deal for raw, especially it is
just NOP.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/uapi/linux/io_uring.h | 13 ++++++++++++-
 io_uring/nop.c                | 28 ++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 922f29b07ccc..5db3a209b302 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -48,7 +48,10 @@ struct io_uring_sqe {
 			__u32	optname;
 		};
 	};
-	__u32	len;		/* buffer size or number of iovecs */
+	union {
+		__u32	len;		/* buffer size or number of iovecs */
+		__s32	result;		/* for NOP to inject result only */
+	};
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
@@ -72,6 +75,7 @@ struct io_uring_sqe {
 		__u32		waitid_flags;
 		__u32		futex_flags;
 		__u32		install_fd_flags;
+		__u32		nop_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -413,6 +417,13 @@ enum io_uring_msg_ring_flags {
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
index d956599a3c1b..c002b8ef2d5f 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -10,16 +10,36 @@
 #include "io_uring.h"
 #include "nop.h"
 
+struct io_nop {
+	/* NOTE: kiocb has the file as the first member, so don't do it here */
+	struct file     *file;
+	unsigned int	flags;
+	int             result;
+};
+
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct io_nop *nop = io_kiocb_to_cmd(req, struct io_nop);
+	unsigned int flags;
+
+	flags = READ_ONCE(sqe->nop_flags);
+	if (flags & ~IORING_NOP_INJECT_RESULT)
+		return -EINVAL;
+
+	nop->flags = flags;
+	if (nop->flags & IORING_NOP_INJECT_RESULT)
+		nop->result = READ_ONCE(sqe->result);
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
2.44.0


