Return-Path: <io-uring+bounces-7240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04644A703EF
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 15:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 588EB16C8A0
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45CD825A630;
	Tue, 25 Mar 2025 14:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="F9x6+6R1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f99.google.com (mail-qv1-f99.google.com [209.85.219.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F0625A62B
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742913591; cv=none; b=ojH5lsoYO9IWwpSDMWnAgbK4o0QRWFKOfMtMEi0+6hHbmyZUC1LJRMSrqfM2Z1S3VAEsvTYDEz1hznLUXu85cb8jITCc4U+Ri/t4dOIzI/L4r1Xwff+M+PRoK5CfX4ZU23lroWP9E0mGCxdYXqIzdVT+/cjDyLBfO3w2Vw9aYks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742913591; c=relaxed/simple;
	bh=rCLSYeIfXuVSPFtngy9ZTWChJeLAUNk74DjLait3gKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q1yE2pxxjDQ8Ljukhy8vP9aDe5ieUvvS2b87HWye8lOZUSD9JiW1D87LCv395yBNMuCgiLZ/byFt1OK/yYu+s5j39H46VgZLvmrhidVb9yf7Wrp67++EVRSBnkpnmyH72qPs1l4/DQwqolf2rUQ3v6gvqWPM8L0Y9+0MbSqBBKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=F9x6+6R1; arc=none smtp.client-ip=209.85.219.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qv1-f99.google.com with SMTP id 6a1803df08f44-6e8ff1b051dso10019496d6.1
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 07:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742913588; x=1743518388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KvEoHJR3H5rDtrh76cias56A8NX1LxdTDYMAo9ZEIug=;
        b=F9x6+6R1Cka3xUiCXNJM7VL/QYoEyVEgl4yoptQVdZQT9LMb4AG3P0/2b7LgpFiTG9
         sIw6PwdH9AEbBMlXs/xWXmd3alDrbi/C+FKndS+ciKXk+lKpxG0XH17NmoUJNfKtQfI5
         uMae7ucukA/tDcScBDG6O2Li9s31ss1JK8rvH6OpAWDpQVV3gduzFJJbhq7fKXF+lGTg
         MgGRXeWi3qMim5M6Z0m6KHQNVYgL+G9+NwezI3xgzSYZ/T/Dtj9n9VZRzM+NFgKhA+IJ
         fVFXII7HfHI1wOz8piiFka6fo1wRvCrj33An8OzM7DHgxyynSavYpw7Ww4YAiu4cUHPf
         hJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742913588; x=1743518388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KvEoHJR3H5rDtrh76cias56A8NX1LxdTDYMAo9ZEIug=;
        b=LQ6Zv44J85kFYa/GHHNMoXwmhNOkiqbpdg6E6+yB9OD++XMxAqrG2oKk2qu6HP3GZv
         SRB51qhziac/6TK4ys5q/uEUQuw8xOa6bS9in/NhNwL2hlnDQDOsR2mfbyBI1zHyyPGM
         Uhm1IX5KxFFSDrDkgu4FbjgO0Juqv0nb0pflYoIASG3ZiLS0+0JkcO3GH/8kW8Z30xWx
         yf/rfs/XZ4uW8Qb2MgR0lPmQthyqRpbxeyhGJyEj45VpaedV/o67N+Mir+XwQ+wsroMo
         iX66ahOim2vYt7BvobdWGgafa80evGaM7SqzYZCPS6YXaSLvkqg63G0b3n3cah02EsoJ
         f3+g==
X-Forwarded-Encrypted: i=1; AJvYcCU0h4xqmm+reCNBVReDxqzCZ3RWMsOWLiQyNhvpNOrHVO9O6UY7MpYl+CKe5/YYaTeJCpQ8SzYzew==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBmT4TMI7FCDcxS37bZRKNvvvbLGeuAg3l3sWgcwZwCCNjXg04
	2H7lXKPXbSz9tlYZOuJm4jryKM0zmVDJdq8WaAAF4RQ3b4PPJrzXzIJ26hGwLFqwpVWYFvPQBSV
	7764FlJ/B1LhjJiEyh9TB1uc8JV3x1DG3xV/0ikZaOc5cxmus
X-Gm-Gg: ASbGncv3aA8rs3p2OzG5uUytxupMeW7QcU9n9eFXs1CLdpA6iepLCz9wrk27TCbkVDi
	pt77rHkP6rMeaSVuiyqsRrriINAB8riyLf/gYC3YhAjw/laSLpxR0BKH2BMoqfCXtJ3CXM1xAOT
	BAKJWkjBwQ2fY11QM+BZHGAbbLbMfAuD658NhslrGmKjrwhIlzc4DoQDROw8/yOL0oUmLjjRhqN
	uxZNYFjhn352IMx+ytXKa0v1qHB4l8rOizEyg1u5R0Mt/3hyCQ+MM+PBVkGjvt0eR94iP3GtQyp
	RGasCLaqowcrpIXfdKCwbJcnW6ChCyohvQ==
X-Google-Smtp-Source: AGHT+IEhlp6iFJ/nyrhTZLyoIqP0PYN5prYdCkGBn4s3G3ahC1K2ifu4QgQbVRpdOZOSyBRCptdVsrJl6HW/
X-Received: by 2002:a05:6214:e4e:b0:6e6:9c39:ae44 with SMTP id 6a1803df08f44-6ed0c28045emr16629676d6.10.1742913587787;
        Tue, 25 Mar 2025 07:39:47 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-6eb3efa9663sm5438656d6.34.2025.03.25.07.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 07:39:47 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8E6973404BA;
	Tue, 25 Mar 2025 08:39:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 96FC8E40ACF; Tue, 25 Mar 2025 08:39:46 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
Date: Tue, 25 Mar 2025 08:39:42 -0600
Message-ID: <20250325143943.1226467-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
track whether io_send_zc() has already imported the buffer. This flag
already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 ++++-
 io_uring/net.c                 | 10 +++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c17d2eedf478..699e2c0895ae 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -583,11 +583,14 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* buf node is valid */
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
-	/* resolve padded iovec to registered buffers */
+	/*
+	 * For vectored fixed buffers, resolve iovec to registered buffers.
+	 * For SEND_ZC, whether to import buffers (i.e. the first issue).
+	 */
 	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
 
diff --git a/io_uring/net.c b/io_uring/net.c
index c87af980b98e..a7b3e2688689 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -75,11 +75,10 @@ struct io_sr_msg {
 	unsigned			nr_multishot_loops;
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
 	bool				retry;
-	bool				imported; /* only for io_send_zc */
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
 
@@ -1305,11 +1304,10 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
 	zc->retry = false;
-	zc->imported = false;
 	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
@@ -1351,12 +1349,14 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (io_is_compat(req->ctx))
 		zc->msg_flags |= MSG_CMSG_COMPAT;
 
 	if (unlikely(!io_msg_alloc_async(req)))
 		return -ENOMEM;
-	if (req->opcode != IORING_OP_SENDMSG_ZC)
+	if (req->opcode == IORING_OP_SEND_ZC) {
+		req->flags |= REQ_F_IMPORT_BUFFER;
 		return io_send_setup(req, sqe);
+	}
 	return io_sendmsg_zc_setup(req, sqe);
 }
 
 static int io_sg_from_iter_iovec(struct sk_buff *skb,
 				 struct iov_iter *from, size_t length)
@@ -1447,12 +1447,12 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
 		return -EOPNOTSUPP;
 
-	if (!zc->imported) {
-		zc->imported = true;
+	if (req->flags & REQ_F_IMPORT_BUFFER) {
+		req->flags &= ~REQ_F_IMPORT_BUFFER;
 		ret = io_send_zc_import(req, issue_flags);
 		if (unlikely(ret))
 			return ret;
 	}
 
-- 
2.45.2


