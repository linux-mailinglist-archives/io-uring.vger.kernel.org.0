Return-Path: <io-uring+bounces-10599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4224CC57504
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B71294E64D2
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D6434F48D;
	Thu, 13 Nov 2025 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FtiRfdat"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E9A34DB6E
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035214; cv=none; b=nJ1N5wBeNa4Y5qd4bLhocgjHkcZe77nBZZ8wQfntI9uVF3v/jtZQWg3zF/mvRvVPYRqSkyMzOCeP00y3PPaOEfYrjdeQEt4cEddqLTI4F/j23cZmJFRQQRjCqdNs8Hdt/preZwiWiHWJVY+mi7mGn/40vI7znejl0vQrg23h8Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035214; c=relaxed/simple;
	bh=YDCd/kTM0m065Tg05DHLbst/Ihv/0nmLI4O98Xmj5r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxFvCCSooP8/Lg7o+1QTILq5iyH/gxbZ1gKYgcsCDXKh9DJiUS+qGx6DmLXO7NF4qQcFkw81ZAF/8Ovi1q9Q/BNmpOzGHWlZ16H/mEaEnufqpEAEOovqKZZQOvHN+q2Gl1+bbmbnmVlGXEayFL6Pna6TxFzeDq/FSvq1aL1cT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FtiRfdat; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b31c610fcso590871f8f.0
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035211; x=1763640011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6f1Zg+9xuzx/01G1fpL+txCgCqSaPidzFa8FIiPmpA=;
        b=FtiRfdatj4+KGCgE/3wGpwML+7jfS/wtLcE5zjJr+iXwWGAB/A6V8ERLe4a0bSf/xs
         dAC5YKJGOo8jbjai4oQU2bzpAh86hJhKkkDeYHcq9OCt/t0QFoliCkejKX9cxKM6Mory
         MQKHycELMn1WSxRLeYsTh1HpBYueEWFINXhGA6yPmSKm2sQKvJc6HhZCLJ8yj2L6fVBx
         PdAEz4qtGBXVj0QqzFdTlUWBnfQVDjNW50drDku/VZNQsSORZPR832Eav+xWiZZ6xTcg
         yyQKgUa8cHWHDWMZ6ftcr1iMvPB1gHiUb9zXGbJUYSFboV6nhvczHHy6YYXyzWA8i3Lw
         +3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035211; x=1763640011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n6f1Zg+9xuzx/01G1fpL+txCgCqSaPidzFa8FIiPmpA=;
        b=uWGmuGDcxN765NIDoZu7nocJe0KIw7gD2CAlNcrTR/7VQj0OX5QqHT4IeBsq0fURgK
         17TKjH8yumvM1ckc4kzKC7Tt1aW/CcVCd3m0QPMnUVG7yqRCLCrAU+Y5VUyTC8gKgAEY
         C3mqivGE0dk0S1UPqyW3mfB34mDybY+pLZ6lu4qgFVCI6YqxiB7yZ34kK2BZB/AZDDhk
         pwy1T8h4yKaCPJZLpTx5Fu8b9wCpy6fg2SR94x+A3l7JrcAWjC1yTri0+hkzI3Vat3gg
         qCicvNbCpm+ytsbs0uj+ZRxW1EeuVsqUqx9Oeqwb9U7TILVPkfi8U1hk1YfrzNIXn/xV
         O/fQ==
X-Gm-Message-State: AOJu0YzBRXVAzNmEdGgyLSLqOPajt6Opz4KsRYYies0gAzkG7C0rl55R
	BN4SeQpamIThXkIeJCH8V4UT4I8Rx22Jo6iBHwdxa/OeKV0CkCa9Y0X5PIcQ1A==
X-Gm-Gg: ASbGncuD2HBt2SVCZ7XysQfs6hMQcFAMsNdlc/chShHQZBDVRU/MzMPK3h8OuxnfecR
	ijIkDAnIrVMNjmycsNTwdyq8q/Bj3MZlfS4mKa5jjzUUYEe0/FbXqIPex7ZipldUXvwdE8JKosi
	N507C+rTdqSU0SXlj2C1HQYAKFKAqRoeyvX8FHRu4X4Gtj+/W+DczKn88J6yXKLD5yf3byp+Lm+
	zK4awYTUkadAZ81fIHJltDgrxGtQ7vB9afeLYTVLVP9KoiYHY8azpZ1I2jNeoiuanTDUo6hftR0
	QEXIkU+h6Mf9jMNZ1cbyrfdufxtVG6Sd5aas09kEkXgz16GxQctn9kHAhP+dIxt4YhbV3OiSE8f
	MA6kiIcCYLPq6VfnH9RIfZUjFRMTv09dl07zSRjW6V39CpZAyCpTuxIGju0o=
X-Google-Smtp-Source: AGHT+IGtkbjjRoywyk0I+BLoSL2kc/NbLYjiVVz7CVsJJjY0fNEeyudMrQtDQUaZxyZ80AmmXy8kTA==
X-Received: by 2002:a05:6000:18a3:b0:42b:2f59:6044 with SMTP id ffacd0b85a97d-42b4bb98120mr6175286f8f.17.1763035210923;
        Thu, 13 Nov 2025 04:00:10 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.04.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 09/10] selftests/io_uring: update mini liburing
Date: Thu, 13 Nov 2025 11:59:46 +0000
Message-ID: <f99cefe07a85d79fc8d6fa5129dbe285694ecb01.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763031077.git.asml.silence@gmail.com>
References: <cover.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper for creating a ring from parameters and add support for
IORING_SETUP_NO_SQARRAY.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/include/io_uring/mini_liburing.h | 57 +++++++++++++++++++-------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
index 9ccb16074eb5..a90b7fb85bbb 100644
--- a/tools/include/io_uring/mini_liburing.h
+++ b/tools/include/io_uring/mini_liburing.h
@@ -6,6 +6,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
+#include <sys/uio.h>
 
 struct io_sq_ring {
 	unsigned int *head;
@@ -55,6 +56,7 @@ struct io_uring {
 	struct io_uring_sq sq;
 	struct io_uring_cq cq;
 	int ring_fd;
+	unsigned flags;
 };
 
 #if defined(__x86_64) || defined(__i386__)
@@ -72,7 +74,14 @@ static inline int io_uring_mmap(int fd, struct io_uring_params *p,
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
@@ -83,7 +92,8 @@ static inline int io_uring_mmap(int fd, struct io_uring_params *p,
 	sq->kring_entries = ptr + p->sq_off.ring_entries;
 	sq->kflags = ptr + p->sq_off.flags;
 	sq->kdropped = ptr + p->sq_off.dropped;
-	sq->array = ptr + p->sq_off.array;
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		sq->array = ptr + p->sq_off.array;
 
 	size = p->sq_entries * sizeof(struct io_uring_sqe);
 	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
@@ -126,28 +136,39 @@ static inline int io_uring_enter(int fd, unsigned int to_submit,
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
@@ -199,10 +220,18 @@ static inline int io_uring_submit(struct io_uring *ring)
 
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
 
-- 
2.49.0


