Return-Path: <io-uring+bounces-12414-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WC8UCmrRnmnwXQQAu9opvQ
	(envelope-from <io-uring+bounces-12414-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 11:39:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98103195DFA
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 11:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1069430F05E8
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 10:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704DE392C5D;
	Wed, 25 Feb 2026 10:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YH1Buoku"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48FB392C50
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 10:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015771; cv=none; b=FueLNXMZe8x+BSWL8axld1ydkcw3ryGiGVQz2CiApkc/IrtwZ93gwKS69WIOWJmZnpNzpUj/Xgo6TWYQSBVYxw2ZQ1Zc//yfKfiI+EBPHxuHQ6btYQQd6k5wfCBcbDmRR3z8FXYb1bTq0Yg5KZ5dYqtXwqceaflBbrSSl0oji18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015771; c=relaxed/simple;
	bh=KI01rWDLyrwMUs9sRMyxAtnKvx7s3uBQtFYSohBHsq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgmcnD0pqJbjIsyRm07AHfmb0DsZMFOipWDJKUjuVlBG9iRDXYDt6PuyX6Tt7eSDjyIDXujPLR43WSOTkwnfx1sPS4/RtImiiwLMQPNswxaf4j0O5lWDfGV9EwlDxkR7V0T5nh6B+WBNhbxJu0NJKwu7e9uy3Fm68nJ89YbHDQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YH1Buoku; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65c01595082so9769911a12.3
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 02:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772015768; x=1772620568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+f9OUhtk1Jt/f2+uHK+M/WGDZ/ktGjugV2mUmuZLtkE=;
        b=YH1BuokudBwL18hHlzb6CfgStzhzo2n+uUDboDhUIEf58VM8F2yrX2uzDQ2TCTLSMQ
         T8UFHxH05Y+AAfwcSydGcR/0IpZ5kHE1mFTBLVCjR6veg3Mm90YGmGi4JvCP7nlTq0PL
         MQdJw0hYsB41WMQtG2gx2yY3njBT/OFg9u06yKd4xSWICTmjX9qrK223f50ea/Qod5eR
         7M6v7BX4uEHv2CSmnNafi3heO4Fa/5TgHdGdDQqL7UzA/EBu/DK0RHf3CWCwx/uVMd8Z
         wsXE6mDWeKJpteLYoWIz3yx8I244qzoKe67aUuphF6POIZXfHeWcK6P7onhJflGkWn6v
         GTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772015768; x=1772620568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+f9OUhtk1Jt/f2+uHK+M/WGDZ/ktGjugV2mUmuZLtkE=;
        b=B0DqKDg4IzL8QojIyaWBMdUsGl6SFBLT8zoYUmE7L/IFxFXMT/RgDi0PZjCJyDn/8l
         sP85TzOBRkJGmasSVnWe4/4rYj9juFNRlvGS6MMOK9mIwd/MWZZfSPkUYf4txGjrpDwg
         u91KKlcibnZTFVWUQI1HgdRIHCHEzsR8OBB762nDKRYmgdHrIfdoytkBDm58Go85NE4T
         4l+VHJjpFtdUZ+CEyOWlQqs8SCIWsGLwvDJnbBRaFXUPl1heg4pX7MyFHWXH01nsCjl5
         SPH4xw38vF7H9bR1IExc/+BQoY8g9Ln5mHrTAXxMJfL9APxFyYSlyApZx25O3yXXWwLo
         W3Ag==
X-Gm-Message-State: AOJu0YztKPQ5CdWixh4Rm2rnN46U3cqNtE4WePSJ9SIickgczhKFWmqX
	J3cIKGhJG9QrojtTLk6NIIPvTS0KUejm9PphVZ5iO9083CXh4fG0y011R6NWyQ==
X-Gm-Gg: ATEYQzw42nP3sjyaffqkn0Vs53fNnWvJmOS6lGCl2HxhNNGnr/lQit1PegItDuzMYnw
	VDriNH6ViD9+Ci4ly1Kwz55Z1MWIDIWUuYIUrBJUGl4hlNpcSh3pbQm47EbV3icp/jqZVnbuJsE
	eG5uUOD4Mt49Ob4y8GHZlkIlkHGrG44LUU0L/0jNIdRBSkrFo5QtQLE/w9nUGRIZIWJMHZEN3lm
	VOjYwIekhVn2ipVTn8uEHVJvIJwEiH10FQcAtrYetSMA3FpcQQ+L3aLDwZ9Vu2gWl4SbT5617Nt
	17+nRZX03RxR7y5MhEHp3zwBDyZzoSfywVmVANhCuEA7wfKJsp8MsxR/cOA+ylugnRSl9s9Jzc1
	E5wzvv5OZMETqoMxgIfBfVy4DxF3PLBGNzdPR8lNV073KpdNtW6E2xLirwJOH5fbmPqn9UIgSOp
	mbzaavKoJKUNvS2SZ0Vk9zsx6sHXRpHQnA6HXyBcbI7kAWgrP2uMfSXTNkZqqHMjDqDgRZvKE70
	towGCNXVVXLlq4jcLi8ZPI0/QoiEd27vTL7tHNFoV7S9sbmJP/2eRcWhH2I
X-Received: by 2002:a17:906:209c:b0:b87:1590:d528 with SMTP id a640c23a62f3a-b9081b6d72cmr594311866b.40.1772015767307;
        Wed, 25 Feb 2026 02:36:07 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-214-161.dab.02.net. [82.132.214.161])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c82495sm500530666b.20.2026.02.25.02.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 02:36:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
Date: Wed, 25 Feb 2026 10:35:58 +0000
Message-ID: <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772015321.git.asml.silence@gmail.com>
References: <cover.1772015321.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,kernel.org];
	TAGGED_FROM(0.00)[bounces-12414-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 98103195DFA
X-Rspamd-Action: no action

One the things the user has always keep in mind is that any user
pointers they put into an SQE is not going to be read by the kernel
until submission happens, and the user has to ensure the pointee
stays alive until then. For example, this snippet:

void prep_timeout(struct io_uring_sqe *sqe) {
	struct __kernel_timespec ts = {...};
	prep_timeout(sqe, &ts);
}

void submit() {
	sqe = get_sqe();
	prep_timeout(sqe);
	io_uring_submit();
}

would lead to UAF for the on stack variable 'ts'. Instead of passing
the timeout value as a pointer allow to store it immediately in the SQE.
The user has to set a new flag called IORING_TIMEOUT_IMMEDIATE_ARG,
in which case sqe->addr will be interpreted as the timeout value in ns.
It only works with relative timeouts and rejected if set together with
IORING_TIMEOUT_ABS out of concerns of not having enough range in u64 to
represent a good long term API.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 +++++
 io_uring/timeout.c            | 28 +++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6750c383a2ab..8f4de786e6e9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -340,6 +340,10 @@ enum io_uring_op {
 
 /*
  * sqe->timeout_flags
+ *
+ * IORING_TIMEOUT_IMMEDIATE_ARG:	If set, sqe->addr stores the timeout
+ *					value in nanoseconds instead of
+ *					pointing to a timespec.
  */
 #define IORING_TIMEOUT_ABS		(1U << 0)
 #define IORING_TIMEOUT_UPDATE		(1U << 1)
@@ -348,6 +352,7 @@ enum io_uring_op {
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_MULTISHOT	(1U << 6)
+#define IORING_TIMEOUT_IMMEDIATE_ARG	(1U << 7)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index cb61d4862fc6..a0d1db98d1fc 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -446,6 +446,7 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_timeout_rem *tr = io_kiocb_to_cmd(req, struct io_timeout_rem);
+	__u64 arg;
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
@@ -460,10 +461,20 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EINVAL;
 		if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
 			tr->ltimeout = true;
-		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
+		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
+				  IORING_TIMEOUT_ABS |
+				  IORING_TIMEOUT_IMMEDIATE_ARG))
 			return -EINVAL;
-		if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
+
+		arg = READ_ONCE(sqe->addr2);
+		if (tr->flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
+			if (tr->flags & IORING_TIMEOUT_ABS)
+				return -EINVAL;
+			tr->ts = ns_to_timespec64(arg);
+		} else if (get_timespec64(&tr->ts, u64_to_user_ptr(arg))) {
 			return -EFAULT;
+		}
+
 		if (tr->ts.tv_sec < 0 || tr->ts.tv_nsec < 0)
 			return -EINVAL;
 	} else if (tr->flags) {
@@ -518,8 +529,8 @@ static int __io_timeout_prep(struct io_kiocb *req,
 {
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data;
-	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
+	unsigned flags;
 
 	if (sqe->buf_index || sqe->len != 1 || sqe->splice_fd_in)
 		return -EINVAL;
@@ -528,7 +539,8 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	flags = READ_ONCE(sqe->timeout_flags);
 	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK |
 		      IORING_TIMEOUT_ETIME_SUCCESS |
-		      IORING_TIMEOUT_MULTISHOT))
+		      IORING_TIMEOUT_MULTISHOT |
+		      IORING_TIMEOUT_IMMEDIATE_ARG))
 		return -EINVAL;
 	/* more than one clock specified is invalid, obviously */
 	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
@@ -557,8 +569,14 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	data->req = req;
 	data->flags = flags;
 
-	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
+	if (flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
+		if (flags & IORING_TIMEOUT_ABS)
+			return -EINVAL;
+		data->ts = ns_to_timespec64(READ_ONCE(sqe->addr));
+	} else if (get_timespec64(&data->ts,
+				  u64_to_user_ptr(READ_ONCE(sqe->addr)))) {
 		return -EFAULT;
+	}
 
 	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
 		return -EINVAL;
-- 
2.53.0


