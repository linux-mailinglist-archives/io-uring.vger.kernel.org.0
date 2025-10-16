Return-Path: <io-uring+bounces-10027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 14094BE30A7
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C63B34E1715
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 11:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F98F3064AF;
	Thu, 16 Oct 2025 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GyCNtkZc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C4F7263B
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 11:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760613700; cv=none; b=NEB8FhcIH0OrLR5UG93TGeU9VqHNO7ETjNkhzqeLkYP2b5398ENfLJ8MD3xw+3y9yyJpRMSqQHm86gAq3iK4E9hVQUpQTfwH7S3INtjPbs5GdoaM4YXoYjvu+V37jA+7HLNrI1uum76ps96SscoCONSF0pX2rtsuads9f1fxuDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760613700; c=relaxed/simple;
	bh=mytrVW8wGbJAjLzlOXR9x+HenA1R21NNEolVlWlXlWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1cgJ3qVmrVjWjLHCV24EV3f8f0wzBWe6JYhHjH6DJijjE5QzM1Jc7PrtOccf0HhFMGqd//r0GDCgy7HBSq3T0m1nWqU43JKYsSa6XiXjtNhg6Aux84zVtUja9pg82JMMECkGyTmbC3LL0UgYIRXh9o21Sg7BOp5xs2xh59JZvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GyCNtkZc; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e2826d5c6so5558955e9.1
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 04:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760613696; x=1761218496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9P90WOnTuXVty7/rP/10RHqyQuWpOWNa4PvN7wyGdSs=;
        b=GyCNtkZc9mRpZV0w7h+FMhi+zarm/VHhkbOEk2KKEaNVvTNh268QvA3NwATj9Xz59e
         CWCZ4Ltq4ebaDKIUPtVn2AJB0d0DcT9VlOo52hfwWUsW9K8+yrvqEI7zLW1IPPKB9Grp
         /wl5owX9icQDB9lCo8Wfa/SsAq0lWvpJ+AJGwFI3RNCH8Ags3he9//tJFd2lqDhnv1ci
         zGBKYtiPMuq/YNVD2KyrnGVUj89PcTdD1Tq84XwFxewM55GHC0nmIHUSX2vMxLrCBUmA
         SxMfRSbgwizlQLO+nX7ZtWL5/ho/Kj9SALZ8VPEXerpR0+eaufAH9ipwwsmsZz7KJ2Mh
         jSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760613696; x=1761218496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9P90WOnTuXVty7/rP/10RHqyQuWpOWNa4PvN7wyGdSs=;
        b=PHDVTboNCm4vaUQDbgE2vNzOdLG1KmBzqWcCAWHWidhrmGrHcdP9l0a3WsNULvvxa4
         XmnC7U4CkUCthEHRnPAyH69939XCwVjLu3N5r03tZh4n3N7Hlc/vjC1gDiQPX5aVsDzH
         n7s/CBCNDBtrheAcBQ6G45ups9vE3lUmBrb8TacH6x7KkT6lE+c72JDp/BN/76eewH1Q
         DBEKO7zb3gxi8Wm/bhspzkYiSrC1m8D3CjMk4xhkKTXm5VLCxWChD665r3hhmgV0/EtQ
         J25LxGJo1qvg1fIsqX7Vj8SlyOIzQP4Vyv+1kqmWjsQIs4bah+7UoqyIgV99H2gcmdZh
         48IA==
X-Gm-Message-State: AOJu0Yyc++SxUtf7U7hAWPMwU/7kz+1qBubKRbPEuSWp6lMMCcLC2v67
	1HP7XtTl4Q2lOXyilMhpZgMYee+9nTDEn/TOlNeUAQDBufgjnp6jysLib+AjWg==
X-Gm-Gg: ASbGncuYtZHcMg8Y7XqW620TTe1M351xFGRILw+ENmdCxUyU6pY7wpCHlh57Q+ANfB8
	wStamldxbpBWjmgsSbhdnxykMjOE4EqYJP5GHg9hLP3lDco5FjVI9g2LesLg+Wp2rkSWdV28wb4
	opqKgZZXkdDkY3cN7DJxyj9NG4O+rAzvPq8DAZZvd9Qdj/XrL3ssMFjzPD90dcRUZGNAhvbL/7t
	OP6a5dAyfKUKAJR99sP0EAeRba5gv7zUxQtJVEAo53cXxfVg4DbHQFBkXHZ8UATEF4BOurbJ8dv
	1RD4YNH3zxI0OFIHj/PRMOvD1aoCJlLTwoHpI2PlyAWnSc1M9kyGzCdXIM3phgPsjPa7nasH8gL
	M5Zuotsgoam3bdNLUaudd1sC4W67OWdo51F8YLXRU5HdksOoenkKhq/KgCYnI0Jk4X04Pz1Xjba
	7WIBop
X-Google-Smtp-Source: AGHT+IEJqHbkHI51oLwthDBdM14x9BRA6o4XpfhutS14lFvPM4hb7n6dH96yyy1TtkFbPpqu1FWTzg==
X-Received: by 2002:a05:600c:1f93:b0:46e:376c:b1f0 with SMTP id 5b1f17b1804b1-46fa9a8ca9fmr232864395e9.7.1760613695784;
        Thu, 16 Oct 2025 04:21:35 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711441f776sm22609835e9.3.2025.10.16.04.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 04:21:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2] io_uring: introduce non-circular SQ
Date: Thu, 16 Oct 2025 12:22:44 +0100
Message-ID: <3b5663b78dbca1dbddf7402f4e37d2c22f41b2e0.1760613249.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Outside of SQPOLL, normally SQ entries are consumed by the time the
submission syscall returns. For those cases we don't need a circular
buffer and the head/tail tracking, instead the kernel can assume that
entries always start from the beginning of the SQ at index 0. This patch
introduces a setup flag doing exactly that.

This method is simpler in general, needs fewer operations, doesn't
require looking up heads and tails, however, the main goal here is to
keep caches hot. The userspace might overprovision SQ, and in the normal
way we'd be touching all the cache lines, but with this feature it
reuses first entries and keeps them hot. This simplicity will also be
quite handy for bpf-io_uring.

To use the feature the user should set the IORING_SETUP_SQ_REWIND flag,
and have a compatible liburing/userspace. The flag is restricted to
IORING_SETUP_NO_SQARRAY rings and is not compatible with
IORING_SETUP_SQPOLL.

Note, it uses relaxed ring synchronisation as the userspace doing the
syscall is naturally in sync, and setups that share a SQ should be
rolling their own intra process/thread synchronisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: expanded the comment

 include/uapi/linux/io_uring.h | 12 ++++++++++++
 io_uring/io_uring.c           | 29 ++++++++++++++++++++++-------
 io_uring/io_uring.h           |  3 ++-
 3 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 263bed13473e..750d881c65a2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -231,6 +231,18 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
 
+/*
+ * When set, io_uring ignores SQ head and tail and fetches SQEs to submit
+ * starting from index 0 instead from the index stored in the head pointer.
+ * IOW, the user should place all SQE at the beginning of the SQ memory
+ * before issuing a submission syscall.
+ *
+ * It requires IORING_SETUP_NO_SQARRAY and is incompatible with
+ * IORING_SETUP_SQPOLL. The user must also never change the SQ head and tail
+ * values and keep it set to 0. Any other value is undefined behaviour.
+ */
+#define IORING_SETUP_SQ_REWIND		(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ee04ab9bf968..e8af963d3233 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2367,12 +2367,16 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 
-	/*
-	 * Ensure any loads from the SQEs are done at this point,
-	 * since once we write the new head, the application could
-	 * write new data to them.
-	 */
-	smp_store_release(&rings->sq.head, ctx->cached_sq_head);
+	if (ctx->flags & IORING_SETUP_SQ_REWIND) {
+		ctx->cached_sq_head = 0;
+	} else {
+		/*
+		 * Ensure any loads from the SQEs are done at this point,
+		 * since once we write the new head, the application could
+		 * write new data to them.
+		 */
+		smp_store_release(&rings->sq.head, ctx->cached_sq_head);
+	}
 }
 
 /*
@@ -2418,10 +2422,15 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
-	unsigned int entries = io_sqring_entries(ctx);
+	unsigned int entries;
 	unsigned int left;
 	int ret;
 
+	if (ctx->flags & IORING_SETUP_SQ_REWIND)
+		entries = ctx->sq_entries;
+	else
+		entries = io_sqring_entries(ctx);
+
 	entries = min(nr, entries);
 	if (unlikely(!entries))
 		return 0;
@@ -3678,6 +3687,12 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 {
 	unsigned flags = p->flags;
 
+	if (flags & IORING_SETUP_SQ_REWIND) {
+		if ((flags & IORING_SETUP_SQPOLL) ||
+		    !(flags & IORING_SETUP_NO_SQARRAY))
+		return -EINVAL;
+	}
+
 	/* There is no way to mmap rings without a real fd */
 	if ((flags & IORING_SETUP_REGISTERED_FD_ONLY) &&
 	    !(flags & IORING_SETUP_NO_MMAP))
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46d9141d772a..b998ed57dd93 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -54,7 +54,8 @@
 			IORING_SETUP_REGISTERED_FD_ONLY |\
 			IORING_SETUP_NO_SQARRAY |\
 			IORING_SETUP_HYBRID_IOPOLL |\
-			IORING_SETUP_CQE_MIXED)
+			IORING_SETUP_CQE_MIXED |\
+			IORING_SETUP_SQ_REWIND)
 
 #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
 			IORING_ENTER_SQ_WAKEUP |\
-- 
2.49.0


