Return-Path: <io-uring+bounces-12229-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAtMJ1hXkmmjtAEAu9opvQ
	(envelope-from <io-uring+bounces-12229-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:31:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C07D914015C
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2BE693002F69
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FEA23BD1F;
	Sun, 15 Feb 2026 23:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxgcbX2w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D411F181F
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 23:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771198291; cv=none; b=d0CvGNHx042K7Mt3Z2t0AwkVy/RUJnTpd5mmvfRVlRxRWbsL9R4Cl8zxStEvgsbX5sTsh53bN4CB4+byKDCnnTZdOLzpwePZN944A2StuXNfdQvi9E4y4qsqq6tWYEXNeIIibQDOWMzOZ1L4lZbGMSw3XW9eGUH7KSzXYgyILE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771198291; c=relaxed/simple;
	bh=/UTZ3+eESrAxvzZCIeUe9RqgzV+4GH08uO+QHKmgYvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YX7H3nebUgptyz/vN0LvJeouTlv9bNl+tyOoxuoZLJGIYcft4rhZqfy+uUhGCtb4L5kAF65AzU9eV0Rt/cgvcy3EAq5yb/UMGoGGxm/DNg9S90iSVTlNrnj+m38RWgDtU7LKz3/cJVLTwshPv0LoIvn/RQ2TDpWTPsLP9vHh2qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxgcbX2w; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4833115090dso23678455e9.3
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 15:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771198288; x=1771803088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=StVXhxzh9g9psFpbjyJgn5evB1o+q9oCzqQx6kpImaM=;
        b=LxgcbX2wis8B9KUKx89WHjhR7rDv4RLlywBc79iI2Ef033eYbgO8b1B/mwBpC4UNPZ
         tTeNliqHe0hb9K8TpqflQ/T7C8pETy/5X+VmEJq6nb/uOmahFOJtYHWOdYdDVqPaS4iG
         9WJBYvW/T67Eq/L26wsQjAnuCXr0yVWjVtwNb6NYtw3bfA5C6WY5xspsvCI7XDE1D5hR
         VVuEQMf1jqMdXLcL7Ibd2x38+SQG4SE4ZU5IHn0AupZ+zRWc6U7fEF5F5z4zdZaWL+rA
         2qWJRyF6a4fLbYzn/K7UDsreWtDuyqzLX0aLGiyIjp2i5mmykdXp3baojL7djx5au/3T
         swxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771198288; x=1771803088;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StVXhxzh9g9psFpbjyJgn5evB1o+q9oCzqQx6kpImaM=;
        b=RIT31wL+Eh8DL2hysgSno1+j/u1lh5eZ+Dmo7yU8UsLeMINi5fAppDaz2yAZ0wVZ5o
         +JWLyTiiJbksnJUiUIZ2SWaX7Hp16vTYxAFuR2Q6fb+XAmIDcHLSfPYUnH1fHDOtD4ol
         AHPmdZac0JlD8YHEkc0+ZbMvvXmQml/tCaCaO31VJs0yHLSgmvvlu8g+yTtriQWT1G+1
         8ckZ13FEb5zsScpYvLR8TuAuxFDcvo4QxwJKPo6STa8uluh2ftDoM1DowfvV9RN8W9jX
         MD2AkwKYOg86v8eUZzQqG4WSXAzEHzIlL5o37ODyz0J4N5DI4aI1Ot74/D7HsAglT73Q
         A6nw==
X-Gm-Message-State: AOJu0YyuV6xhJ2AB6sQBYgFUNcc53lac3jo1qA2b8hZ9+faycyoetXXr
	T3hGA9plWj0LCdmPkmmx8R+u6H2rhqNwdNuRP6PooK+5tuhx9MvCZijNvk2XkA==
X-Gm-Gg: AZuq6aLYBzMl383bZNLZ078mFtunEJGM55/CoDoU/hVtWGASnL/AgkRpvdl7bf9B2Hd
	UKFHHRatfYgj2ILi3ACoeGKldW7knx7FZYmXAXNtsJaUNC40nqw3Cjy4cBPVXRflkPfHs/bsq+y
	jlOWgfsqmWjiOFBWC4yr/hhzYDerhnUWXgcZl+EDvaLvmktW8MyM3jmd/9C36j8sLITrsSLsJZs
	5tUXgZ+FcXyittWXS/BbKa1Y/ZRaUCijEMkKnK2hSSTATyV5Tf+UrjwUiQ7ppY5i5HSByZVl0iq
	6TmEmNHpEMkR0MK+D0Fgtq7XY/F/SAFKz4MOxKFcSmD+Hy/LYSP/uGaHFlsrwg1OWhUfgsYiBZL
	FN7iwbbDLh1sdBHWwIHdvATQCQ6ifFuEUoeshfGZNsXF8RMLEKQiZQK6K7ZEn5rYJyXZA2ZJtUN
	aRw2LNBLSWdgvSDgcnVOgfSgUB3OH4ajTaGp5pcwturCgdjl0lZFJqRNd47bMqXGeErusK3Se85
	oflslBbD2wiy4z7Bz/zcQ27eIyn2g==
X-Received: by 2002:a05:600c:524d:b0:483:4807:210c with SMTP id 5b1f17b1804b1-48373a5d7a0mr179075505e9.24.1771198288454;
        Sun, 15 Feb 2026 15:31:28 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ad112bsm22924803f8f.36.2026.02.15.15.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 15:31:27 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: move zcrx uapi into separate header
Date: Sun, 15 Feb 2026 23:31:20 +0000
Message-ID: <14826e580830261478a74ed89941694538209bab.1771198073.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12229-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C07D914015C
X-Rspamd-Action: no action

Split out zcrx uapi into a separate file. It'll be easier to manage it
this way, and that reduces the size of a not so small io_uring.h. Since
there are users that expect that zcrx definitions come with io_uring.h,
it includes the new file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Depends on the patch that added querying zcrx features


 include/uapi/linux/io_uring.h      |  96 +------------------------
 include/uapi/linux/io_uring/zcrx.h | 108 +++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+), 94 deletions(-)
 create mode 100644 include/uapi/linux/io_uring/zcrx.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6750c383a2ab..7a70ec70ff04 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -10,6 +10,8 @@
 
 #include <linux/fs.h>
 #include <linux/types.h>
+#include <linux/io_uring/zcrx.h>
+
 /*
  * this file is shared with liburing and that has to autodetect
  * if linux/time_types.h is available or not, it can
@@ -1049,100 +1051,6 @@ struct io_timespec {
 	__u64		tv_nsec;
 };
 
-/* Zero copy receive refill queue entry */
-struct io_uring_zcrx_rqe {
-	__u64	off;
-	__u32	len;
-	__u32	__pad;
-};
-
-struct io_uring_zcrx_cqe {
-	__u64	off;
-	__u64	__pad;
-};
-
-/* The bit from which area id is encoded into offsets */
-#define IORING_ZCRX_AREA_SHIFT	48
-#define IORING_ZCRX_AREA_MASK	(~(((__u64)1 << IORING_ZCRX_AREA_SHIFT) - 1))
-
-struct io_uring_zcrx_offsets {
-	__u32	head;
-	__u32	tail;
-	__u32	rqes;
-	__u32	__resv2;
-	__u64	__resv[2];
-};
-
-enum io_uring_zcrx_area_flags {
-	IORING_ZCRX_AREA_DMABUF		= 1,
-};
-
-struct io_uring_zcrx_area_reg {
-	__u64	addr;
-	__u64	len;
-	__u64	rq_area_token;
-	__u32	flags;
-	__u32	dmabuf_fd;
-	__u64	__resv2[2];
-};
-
-enum zcrx_reg_flags {
-	ZCRX_REG_IMPORT	= 1,
-};
-
-enum zcrx_features {
-	/*
-	 * The user can ask for the desired rx page size by passing the
-	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
-	 */
-	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
-};
-
-/*
- * Argument for IORING_REGISTER_ZCRX_IFQ
- */
-struct io_uring_zcrx_ifq_reg {
-	__u32	if_idx;
-	__u32	if_rxq;
-	__u32	rq_entries;
-	__u32	flags;
-
-	__u64	area_ptr; /* pointer to struct io_uring_zcrx_area_reg */
-	__u64	region_ptr; /* struct io_uring_region_desc * */
-
-	struct io_uring_zcrx_offsets offsets;
-	__u32	zcrx_id;
-	__u32	rx_buf_len;
-	__u64	__resv[3];
-};
-
-enum zcrx_ctrl_op {
-	ZCRX_CTRL_FLUSH_RQ,
-	ZCRX_CTRL_EXPORT,
-
-	__ZCRX_CTRL_LAST,
-};
-
-struct zcrx_ctrl_flush_rq {
-	__u64		__resv[6];
-};
-
-struct zcrx_ctrl_export {
-	__u32		zcrx_fd;
-	__u32 		__resv1[11];
-};
-
-struct zcrx_ctrl {
-	__u32	zcrx_id;
-	__u32	op; /* see enum zcrx_ctrl_op */
-	__u64	__resv[2];
-
-	union {
-		struct zcrx_ctrl_export		zc_export;
-		struct zcrx_ctrl_flush_rq	zc_flush;
-	};
-};
-
 #ifdef __cplusplus
 }
 #endif
diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
new file mode 100644
index 000000000000..3163a4b8aeb0
--- /dev/null
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
+/*
+ * Header file for the io_uring zerocopy receive (zcrx) interface.
+ *
+ * Copyright (C) 2026 Pavel Begunkov
+ * Copyright (C) 2026 David Wei
+ * Copyright (C) Meta Platforms, Inc.
+ */
+#ifndef LINUX_IO_ZCRX_H
+#define LINUX_IO_ZCRX_H
+
+#include <linux/types.h>
+
+/* Zero copy receive refill queue entry */
+struct io_uring_zcrx_rqe {
+	__u64	off;
+	__u32	len;
+	__u32	__pad;
+};
+
+struct io_uring_zcrx_cqe {
+	__u64	off;
+	__u64	__pad;
+};
+
+/* The bit from which area id is encoded into offsets */
+#define IORING_ZCRX_AREA_SHIFT	48
+#define IORING_ZCRX_AREA_MASK	(~(((__u64)1 << IORING_ZCRX_AREA_SHIFT) - 1))
+
+struct io_uring_zcrx_offsets {
+	__u32	head;
+	__u32	tail;
+	__u32	rqes;
+	__u32	__resv2;
+	__u64	__resv[2];
+};
+
+enum io_uring_zcrx_area_flags {
+	IORING_ZCRX_AREA_DMABUF		= 1,
+};
+
+struct io_uring_zcrx_area_reg {
+	__u64	addr;
+	__u64	len;
+	__u64	rq_area_token;
+	__u32	flags;
+	__u32	dmabuf_fd;
+	__u64	__resv2[2];
+};
+
+enum zcrx_reg_flags {
+	ZCRX_REG_IMPORT	= 1,
+};
+
+enum zcrx_features {
+	/*
+	 * The user can ask for the desired rx page size by passing the
+	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
+	 */
+	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
+};
+
+/*
+ * Argument for IORING_REGISTER_ZCRX_IFQ
+ */
+struct io_uring_zcrx_ifq_reg {
+	__u32	if_idx;
+	__u32	if_rxq;
+	__u32	rq_entries;
+	__u32	flags;
+
+	__u64	area_ptr; /* pointer to struct io_uring_zcrx_area_reg */
+	__u64	region_ptr; /* struct io_uring_region_desc * */
+
+	struct io_uring_zcrx_offsets offsets;
+	__u32	zcrx_id;
+	__u32	rx_buf_len;
+	__u64	__resv[3];
+};
+
+enum zcrx_ctrl_op {
+	ZCRX_CTRL_FLUSH_RQ,
+	ZCRX_CTRL_EXPORT,
+
+	__ZCRX_CTRL_LAST,
+};
+
+struct zcrx_ctrl_flush_rq {
+	__u64		__resv[6];
+};
+
+struct zcrx_ctrl_export {
+	__u32		zcrx_fd;
+	__u32 		__resv1[11];
+};
+
+struct zcrx_ctrl {
+	__u32	zcrx_id;
+	__u32	op; /* see enum zcrx_ctrl_op */
+	__u64	__resv[2];
+
+	union {
+		struct zcrx_ctrl_export		zc_export;
+		struct zcrx_ctrl_flush_rq	zc_flush;
+	};
+};
+
+#endif /* LINUX_IO_ZCRX_H */
-- 
2.52.0


