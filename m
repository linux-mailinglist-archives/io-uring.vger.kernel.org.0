Return-Path: <io-uring+bounces-11851-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLW1I+Lwb2m+UQAAu9opvQ
	(envelope-from <io-uring+bounces-11851-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 22:17:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3125F4C17E
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 22:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 082A168EF90
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 20:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC02D3BC4F7;
	Tue, 20 Jan 2026 20:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKydI1sz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8333A7855
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 20:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768942075; cv=none; b=bK3luKu7abbeOOHqZJos/nt3OKgMdEV9H6xcH1pWIzHaFz4tOXqCRU7rFK52XHmsWyd8G7Kj0F0okf3Uh6ysl4pORFhrWLGk2czTAjluRfQ28jpW4k/XpNTELKI11UoVZEdIj7qK1/H+XWr+dJ/KkNhYIjiMzX8uPdintwLVe34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768942075; c=relaxed/simple;
	bh=ywgWyHu0w/TzJfqt35wQG7lo61Hg+EY7exaP9bWssPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uZXf1sC04x5ueW88vpm0atpurY65Dz/cK0xN4chHkeFetu8pUB+GjH332yduvJfcVIQCQaGP7w8g1PmsI+LaTwrK64/anhUNzjljuHt2yqEcpjCJWcBXAgxOPXXqHPDPj+O6NaG6KeG2d+K4JKR8re4YF3iRLdneiDa7xXvuryI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKydI1sz; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4801c314c84so37991085e9.0
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 12:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768942071; x=1769546871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjM5d3wPJEXGs1cuuGckweQ/7NVkfTnJldtxpRSXezE=;
        b=WKydI1szubTdbuQxIFAeNr8legxa4iR2cO9Db7pOAm6O86NksJ/Z67Vqt/aueynLKS
         2O0Z5QDrxacZB60e3+08oroMFjDBkVP8SQIhce1hITr1C29QiWxrwH35XDqa9cTSVuzb
         JbZZzY02uTfX7lto+sdTgK13c8H4Emcqf79YQXDmVP56djfHm1y75v5LTXj3mv+TjiD7
         mCFHPWPUVobJPiN14uLUFfj7qYbt2cy4P2XK3uLwTmSzsnGp8kA2RqDQL1OMxhrwwJd7
         vo+eiz3hWFbLUZ0fa4TK9ES1b1LTJRwzMP+h+Ui24ECj33QTDEn21of53pX+pxBSac4X
         1RVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768942071; x=1769546871;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZjM5d3wPJEXGs1cuuGckweQ/7NVkfTnJldtxpRSXezE=;
        b=HJxli0QO+rwnBflrgbiTIffJ1obpoceMLaQ0wXD0wyJEBG3tLYU1M6uXaOhleuuuX2
         XsQH29CtFcw14W+Ml22SH9n6IIYjx8doY9XlHd8u8HUfHU037ZRiHTsd5L3QGdf2wW7r
         xhgsOFvVEXypQuHBzey8avBwjCtir5XqGn1ITyA74qRVoI1Fo9iKsDnGATbS2wQn5Cjc
         qyJBIJXff4OH+/aA6h7a0mjruofPAZsn+b0bmEEuZmIJeMAP/giupjJLSAJo5b3Hvw8Q
         wZWdRmUZK5egukHMzv8YiVvoSsiThwvoBiPw6WuFBHnBp0sXwls918dNGIMB1hVZW+ab
         b6KQ==
X-Gm-Message-State: AOJu0YzOJNRM0qQrmpDGGc/UaI9FhK5lqhTisyXei+qHqUnV984mjrsJ
	J0mQsTcVAwl9k0DV5mKPIImxz2TVnQLR/nwG+flvllw0j7m09x/+Pt0UlKGkVw==
X-Gm-Gg: AY/fxX78tKATxDwR/ym6XKnLaokv0I7EfMadX+TBaCYqYWVqaL/9HYtsiAw1CEPAcca
	WgqkWY7yIxxCqOmA1VxWTN5PSLmBoZ0N1D5pPkSSUMxy6y5KajeXJwV/wQV10TJNbCZeb4G6uP3
	LDZEswmaIGm2XVz5bj84yT4E8yV78Oho9q/+tiPFmtfSkWOlQVDnI2ojveKaLYxJewHt7hzNIbB
	4uRf8u5yjdgaZHNbEGCUp8y2wT5246bpJcbUZ35y4iQ50mSgrviqMGSLgwU4ZQP3r+d00nlHkdf
	C/nkSgzye0VlTI+03jXnieJixXPh3VEdxvVTa786kbMVdUfiZs16L6kMHzysKX0bO9S13bDE+xh
	BfMDuqaCCZuRzEkPRsvb7EDs0K80FmE9vKa7Mc0KlD3U55npu4SH2KayGxWNY0sR7gdmxLyo5y8
	snMn1k5ROeslSzPwNYRV6H3LPw9wLsp9QfJG/TkVIg6XX1gfCICEcH+DcJrZ7mI5milkldYxhlU
	pCulisMIOn+eZnDgWO/Icmxp50=
X-Received: by 2002:a05:600c:64c3:b0:47d:92bb:2723 with SMTP id 5b1f17b1804b1-4801e30a168mr180580455e9.3.1768942070440;
        Tue, 20 Jan 2026 12:47:50 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48042b6a3e2sm1364825e9.1.2026.01.20.12.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 12:47:49 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH v3 1/1] io_uring: introduce non-circular SQ
Date: Tue, 20 Jan 2026 20:47:40 +0000
Message-ID: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11851-lists,io-uring=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 3125F4C17E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Outside of SQPOLL, normally SQ entries are consumed by the time the
submission syscall returns. For those cases we don't need a circular
buffer and the head/tail tracking, instead the kernel can assume that
entries always start from the beginning of the SQ at index 0. This patch
introduces a setup flag doing exactly that. It's a simpler and helps
to keeps SQEs hot in cache.

The feature is optional and enabled by setting IORING_SETUP_SQ_REWIND.
The flag is rejected if passed together with SQPOLL as it'd require
waiting for SQ before each submission. It also requires
IORING_SETUP_NO_SQARRAY, which can be supported but it's unlikely there
will be users, so leave more space for future optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v3: rebase
v2: expanded comments

 include/uapi/linux/io_uring.h | 12 ++++++++++++
 io_uring/io_uring.c           | 29 ++++++++++++++++++++++-------
 io_uring/io_uring.h           |  3 ++-
 3 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..475094c7a668 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -237,6 +237,18 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_SQE_MIXED		(1U << 19)
 
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
+#define IORING_SETUP_SQ_REWIND		(1U << 20)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ea4eb3eedb43..4e97cfe488c6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2333,12 +2333,16 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
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
@@ -2384,10 +2388,15 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
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
@@ -3422,6 +3431,12 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	if (flags & ~IORING_SETUP_FLAGS)
 		return -EINVAL;
 
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
index c5bbb43b5842..baa1a20d0d6a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -68,7 +68,8 @@ struct io_ctx_config {
 			IORING_SETUP_NO_SQARRAY |\
 			IORING_SETUP_HYBRID_IOPOLL |\
 			IORING_SETUP_CQE_MIXED |\
-			IORING_SETUP_SQE_MIXED)
+			IORING_SETUP_SQE_MIXED |\
+			IORING_SETUP_SQ_REWIND)
 
 #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
 			IORING_ENTER_SQ_WAKEUP |\
-- 
2.52.0


