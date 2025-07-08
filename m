Return-Path: <io-uring+bounces-8616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B11AFCDE6
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 16:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B5885600C0
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 14:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A98226D0A;
	Tue,  8 Jul 2025 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FnAMh8Tj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD622DECBF
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 14:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985555; cv=none; b=PuwHmxbciGz9WL2whSRMWWpPCzKGAEv3X+P5nvUxVHPfDMmME0JH6Hr0/Q/fDFj+7ijrYWgJKoA/SWTIv8M0w/5dA5jo2+/qUf4cSEiWDZAppiIqIst2PEBZSomZvoJLbp02c9QTSsCvEDpaews+5FdiTNhcST3w+jxrRWPPqLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985555; c=relaxed/simple;
	bh=MzhrxlllIyzriKhkOD2wgnRnCESNbRPYUIQhBWpFe+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZ7WDSB5EGilUBgtR9UMeQtaG+nfwiv6cJ2ZZ2KYSdFVLK0mW3wJLT+YDV2OExOzFBBicn1veMaYU/3tQnokNbIhikhCQOMqGOMonPRJcG2p5EysrBMUPo+3C3knFnHrrCNdD/fczUZlFs1tCz6PeR92vRCtTkPwvUzJAgJP45o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FnAMh8Tj; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86d013c5e79so367800839f.0
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 07:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751985549; x=1752590349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9WcPOqGLZvKZ4uI+5nMqitWzZq4dJSvs2H3LMbZzEk=;
        b=FnAMh8Tj9L2lArqC1r71Z6BZcke8XZWkR02va2gvLM2/gmr/kZm9orpP/n8/YofjVI
         4ApH//gbf8UBmAXrOivy1ZBbJW8DIxFig3UemFmEjZAGB7KRxGyUWIX9A95xvXHdeLIz
         ipjFL022Hiwq4Ym406iZctf2fl/v+JObgrtE5dJqNYuTa58SrQPkxd+L/pZxSkz/zvXs
         njdNHskINH9lCAOTJEDpMamNZPhRRN4E7R1Nuy3UdMmPN9KidA03U5MPIRfWPxPmvbLA
         3GtvS2TNqy4HyKVVNHhF/w9sSin+2cAAblrZLaqkkUSzQCJMfnzvJ7Hn/IObhAH9B84Z
         OpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985549; x=1752590349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9WcPOqGLZvKZ4uI+5nMqitWzZq4dJSvs2H3LMbZzEk=;
        b=SuvGokc0xJIFsc16zmD5nqnMSn22paMXjCfM6s8qfSCcVFpuBEwpY4fIZ8v3q52kHW
         e+BdqO/oDIbxnpcoKxIWP2q7yDGBUBnljUrz21DM+1p9NbSN13lIpidwYaQlTTj6A/mp
         JllBrqsiovvoI3QOFKM1WsZhuBNPdyIRqVZnw0vvNgYdcbQovtvTg0OtzKsGSLjXYAU+
         LwjC4hGuekuBVHCAwHQEB9/LeQp1OmZIbrIPNeDzTuPWijlcjoRvzjB2lBzkM33Y6MVG
         EZ1sC9aZ59XFpwyg8d+PpgbX+f/5v8BgCZ1dVoPY9kwSKBmqkifmWiHRkEq1s2CEW1se
         yImg==
X-Gm-Message-State: AOJu0YzQiBkKyXxCV+zEJZo9AShpIMF7iFO3xOUbhuzvMmhtnMlekuwv
	OKCQ42fBcZsdFQlQiEuIEF8WiTTM4CcHIiJnyfVGwdZ98O812Hay5aP7uriy3khSggI6huohF9J
	shT93
X-Gm-Gg: ASbGncs3EIapAEVk1z1IVFiMhEMDZGVFb6TT1nW6OaIkU96LTD31hG7F6mSXoY5Rf0/
	nHmOlh6jLzshFHJpY3koFSEbFu705zmET4A4sopEsy4xvBA68jKuR0w/KcJ9O0unaUpI50WcqsM
	pso2VNupxY6Re4eK9g1RmfgpvjfwO4grFcUdUG0aZkDdBOGD/++ULO3ou1tDKZbgWamOD3wuy8q
	BR0ATVBlk+AlK44+0nj0GEs9Jk9mJR1QJlNZtR9QCo6FOjGk9A0LJC7rBgtha2ph7GKMunDsvB9
	sNZkOs+1oM7TkGBA3mrYb+K8sy+rAqWHtgrJ7In+Ct8R/Q==
X-Google-Smtp-Source: AGHT+IEA0EnGUOamjmzwnVd+PIle6WxwvBSll6fDB/fuwXN+n5Br66PSMJZ+0kV11c72G/NoKMjRcw==
X-Received: by 2002:a05:6602:2091:b0:873:f23:ff5 with SMTP id ca18e2360f4ac-876e165e275mr1379559039f.12.1751985548901;
        Tue, 08 Jul 2025 07:39:08 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5053aa4e546sm166739173.134.2025.07.08.07.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 07:39:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/net: move io_sr_msg->retry_flags to io_sr_msg->flags
Date: Tue,  8 Jul 2025 08:26:53 -0600
Message-ID: <20250708143905.1114743-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708143905.1114743-1-axboe@kernel.dk>
References: <20250708143905.1114743-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's plenty of space left, we just have to cleanly separate the
UAPI flags and the internal ones. This avoids needing to init them for
request initialization, or clear them separately for request retries.

Add a mask for the UAPI flags so that a BUILD_BUG_ON() can be added if
there's ever any overlap. As of this commit, UAPI uses the bottom 5 bits
and the internal uses are the top two bits. This still leaves room for
an additional 8 UAPI flags.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/net.c                | 29 ++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b8a0e70ee2fd..7c828fe944b1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -399,6 +399,15 @@ enum io_uring_op {
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
 #define IORING_RECVSEND_BUNDLE		(1U << 4)
 
+/*
+ * Not immediately useful for application, just a mask of all the exposed flags
+ */
+#define IORING_RECVSEND_FLAGS_ALL	(IORING_RECVSEND_POLL_FIRST |	\
+					 IORING_RECV_MULTISHOT |	\
+					 IORING_RECVSEND_FIXED_BUF |	\
+					 IORING_SEND_ZC_REPORT_USAGE |	\
+					 IORING_RECVSEND_BUNDLE)
+
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
  * IORING_SEND_ZC_REPORT_USAGE was requested
diff --git a/io_uring/net.c b/io_uring/net.c
index 43a43522f406..328301dc9a43 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -75,15 +75,21 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
-	unsigned short			retry_flags;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
 
+/*
+ * Can't overlap with the send/sendmsg or recv/recvmsg flags defined in
+ * the UAPI. Start high and work down.
+ */
 enum sr_retry_flags {
-	IO_SR_MSG_RETRY		= 1,
-	IO_SR_MSG_PARTIAL_MAP	= 2,
+	IORING_RECV_RETRY	= (1U << 15),
+	IORING_RECV_PARTIAL_MAP	= (1U << 14),
+
+	IORING_RECV_RETRY_CLEAR	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
+	IORING_RECV_INTERNAL	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
 };
 
 /*
@@ -190,9 +196,12 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
+	/* internal and external flags must not overlap */
+	BUILD_BUG_ON(IORING_RECVSEND_FLAGS_ALL & IORING_RECV_INTERNAL);
+
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
-	sr->retry_flags = 0;
+	sr->flags &= ~IORING_RECV_RETRY_CLEAR;
 	sr->len = 0; /* get from the provided buffer */
 }
 
@@ -402,7 +411,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
-	sr->retry_flags = 0;
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
@@ -756,7 +764,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
-	sr->retry_flags = 0;
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -828,7 +835,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
-		if (sr->retry_flags & IO_SR_MSG_RETRY)
+		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
@@ -837,12 +844,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		 * If more is available AND it was a full transfer, retry and
 		 * append to this one
 		 */
-		if (!sr->retry_flags && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
+		if (!(sr->flags & IORING_RECV_INTERNAL) &&
+		    kmsg->msg.msg_inq > 1 && this_ret > 0 &&
 		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
 			sr->done_io += this_ret;
-			sr->retry_flags |= IO_SR_MSG_RETRY;
+			sr->flags |= IORING_RECV_RETRY;
 			return false;
 		}
 	} else {
@@ -1088,7 +1096,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 		if (arg.partial_map)
-			sr->retry_flags |= IO_SR_MSG_PARTIAL_MAP;
+			sr->flags |= IORING_RECV_PARTIAL_MAP;
 
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
@@ -1283,7 +1291,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	int ret;
 
 	zc->done_io = 0;
-	zc->retry_flags = 0;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
-- 
2.50.0


