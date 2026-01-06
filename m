Return-Path: <io-uring+bounces-11409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE30CF7B48
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AFAD03036C7D
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9FC3112A1;
	Tue,  6 Jan 2026 10:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjWv7ndm"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D117230FC2A
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694343; cv=none; b=nZWktT0sPJDcj9IAL2pivBbaelbKiSCvPWxLbMHW4JLTkFYS2h9z+zEzpF4A4kR0amkMUfSIyu5KMQooXIxSaG/PWictIqZue4SwU8Hr/tDwCLBRji2rus6qEvsGjb7/vu5sajleki3Tx2T+LrklaCt7LmuTU41WCDeOZwZF1UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694343; c=relaxed/simple;
	bh=R1AHrXguQkyqG1eM7aKDR65OgdQKn55WXZVDhTPGHoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbJsRyu+HBCHCrzHTrnro13P+RcvH9t4kpAlsEd4PrI37pkDrxi9FVRVOrLUJzCAiigYIJA91kQinKGC8v+rBy4MPlqisHUnWg0jA4BTD0La5Lkx4rsKx0JUM8+XjULcyveexmkEakh699kRt2h8d2SYEwce4r8NBxmjng+O72E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjWv7ndm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0izReGRJM4Ic7J76RxAYIN9M9Hn32qe/ayUARCX6pd4=;
	b=WjWv7ndmof0fa+bbf8/zd2SSXGhmpep3NNrpIEBVotDbxKWI+b6u9XR31tdxrtdIezH+lm
	Rd/C+nHFC8e+YHMjTNzM+JD9bSA/jAhIALc7zR4EfGQW9RkIonoCY3JD0pR/WTkZg3XHU2
	8PeOxyiHc4FPptO4LY7W4hc0bWtulI4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-ayYpyyMQPVi_e61W-nXA9g-1; Tue,
 06 Jan 2026 05:12:15 -0500
X-MC-Unique: ayYpyyMQPVi_e61W-nXA9g-1
X-Mimecast-MFC-AGG-ID: ayYpyyMQPVi_e61W-nXA9g_1767694334
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 171911956095;
	Tue,  6 Jan 2026 10:12:14 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0EB61180044F;
	Tue,  6 Jan 2026 10:12:12 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 09/13] selftests/io_uring: update mini liburing
Date: Tue,  6 Jan 2026 18:11:18 +0800
Message-ID: <20260106101126.4064990-10-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Pavel Begunkov <asml.silence@gmail.com>

Add a helper for creating a ring from parameters and add support for
IORING_SETUP_NO_SQARRAY.

Add io_uring_unregister_buffers().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tools/include/io_uring/mini_liburing.h | 67 ++++++++++++++++++++------
 1 file changed, 53 insertions(+), 14 deletions(-)

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
index 9ccb16074eb5..8070e63437d3 100644
--- a/tools/include/io_uring/mini_liburing.h
+++ b/tools/include/io_uring/mini_liburing.h
@@ -1,11 +1,13 @@
 /* SPDX-License-Identifier: MIT */
 
 #include <linux/io_uring.h>
+#include <signal.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
+#include <sys/uio.h>
 
 struct io_sq_ring {
 	unsigned int *head;
@@ -55,6 +57,7 @@ struct io_uring {
 	struct io_uring_sq sq;
 	struct io_uring_cq cq;
 	int ring_fd;
+	unsigned flags;
 };
 
 #if defined(__x86_64) || defined(__i386__)
@@ -72,7 +75,14 @@ static inline int io_uring_mmap(int fd, struct io_uring_params *p,
 	void *ptr;
 	int ret;
 
-	sq->ring_sz = p->sq_off.array + p->sq_entries * sizeof(unsigned int);
+	if (p->flags & IORING_SETUP_NO_SQARRAY) {
+		sq->ring_sz = p->cq_off.cqes;
+		sq->ring_sz += p->cq_entries * sizeof(struct io_uring_cqe);
+	} else {
+		sq->ring_sz = p->sq_off.array;
+		sq->ring_sz += p->sq_entries * sizeof(unsigned int);
+	}
+
 	ptr = mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
 		   MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQ_RING);
 	if (ptr == MAP_FAILED)
@@ -83,7 +93,8 @@ static inline int io_uring_mmap(int fd, struct io_uring_params *p,
 	sq->kring_entries = ptr + p->sq_off.ring_entries;
 	sq->kflags = ptr + p->sq_off.flags;
 	sq->kdropped = ptr + p->sq_off.dropped;
-	sq->array = ptr + p->sq_off.array;
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		sq->array = ptr + p->sq_off.array;
 
 	size = p->sq_entries * sizeof(struct io_uring_sqe);
 	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
@@ -126,28 +137,39 @@ static inline int io_uring_enter(int fd, unsigned int to_submit,
 		       flags, sig, _NSIG / 8);
 }
 
-static inline int io_uring_queue_init(unsigned int entries,
+static inline int io_uring_queue_init_params(unsigned int entries,
 				      struct io_uring *ring,
-				      unsigned int flags)
+				      struct io_uring_params *p)
 {
-	struct io_uring_params p;
 	int fd, ret;
 
 	memset(ring, 0, sizeof(*ring));
-	memset(&p, 0, sizeof(p));
-	p.flags = flags;
 
-	fd = io_uring_setup(entries, &p);
+	fd = io_uring_setup(entries, p);
 	if (fd < 0)
 		return fd;
-	ret = io_uring_mmap(fd, &p, &ring->sq, &ring->cq);
-	if (!ret)
+	ret = io_uring_mmap(fd, p, &ring->sq, &ring->cq);
+	if (!ret) {
 		ring->ring_fd = fd;
-	else
+		ring->flags = p->flags;
+	} else {
 		close(fd);
+	}
 	return ret;
 }
 
+static inline int io_uring_queue_init(unsigned int entries,
+				      struct io_uring *ring,
+				      unsigned int flags)
+{
+	struct io_uring_params p;
+
+	memset(&p, 0, sizeof(p));
+	p.flags = flags;
+
+	return io_uring_queue_init_params(entries, ring, &p);
+}
+
 /* Get a sqe */
 static inline struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
 {
@@ -199,10 +221,18 @@ static inline int io_uring_submit(struct io_uring *ring)
 
 	ktail = *sq->ktail;
 	to_submit = sq->sqe_tail - sq->sqe_head;
-	for (submitted = 0; submitted < to_submit; submitted++) {
-		read_barrier();
-		sq->array[ktail++ & mask] = sq->sqe_head++ & mask;
+
+	if (!(ring->flags & IORING_SETUP_NO_SQARRAY)) {
+		for (submitted = 0; submitted < to_submit; submitted++) {
+			read_barrier();
+			sq->array[ktail++ & mask] = sq->sqe_head++ & mask;
+		}
+	} else {
+		ktail += to_submit;
+		sq->sqe_head += to_submit;
+		submitted = to_submit;
 	}
+
 	if (!submitted)
 		return 0;
 
@@ -255,6 +285,15 @@ static inline int io_uring_register_buffers(struct io_uring *ring,
 	return (ret < 0) ? -errno : ret;
 }
 
+static inline int io_uring_unregister_buffers(struct io_uring *ring)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_register, ring->ring_fd,
+		      IORING_UNREGISTER_BUFFERS, NULL, 0);
+	return (ret < 0) ? -errno : ret;
+}
+
 static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
 				      const void *buf, size_t len, int flags)
 {
-- 
2.47.0


