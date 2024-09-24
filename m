Return-Path: <io-uring+bounces-3276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C61E983C2E
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 07:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CED57283B72
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 05:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7F9364A9;
	Tue, 24 Sep 2024 05:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qpXucAwp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1987770E5
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 05:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727154343; cv=none; b=mBHuNr1iWxYUpzoCo9JkoYXnwKAsj12SX7rxeMvL7+pJi+aneLzQ5s1t30p8J5rYzFRPo8InNulFz4wdbl6lvs9Il3sfWEeAfcrjexl0D4UXPZe/ppRlCpJzoQ+Ap9UaHWQH3lNYMABsc3cy9DCSiKMEwYpDhQbX1RE5Tod21c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727154343; c=relaxed/simple;
	bh=nHOekwxxrWOMd4e0NVGSZfWbmqqk0dmvDU166EF4STM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmQgxxqF8ae0dgx+8NYQPWoBGnqVpstcWKCjcES+d6Jy1yyERhZaSKwX7zmRAhaXO3V0r3uKy3lQN6xvXPJ07+E4N4DjBuNNI8nxXBHMuzLrV5qEZwJgQq5TlO77sps3Bpp0yJqMVE7817opEqYPWluCOrZb95JRoz3Z8jjF7BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qpXucAwp; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-374c1120a32so3212862f8f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Sep 2024 22:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727154337; x=1727759137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzFz5Fbg1UGV08p7CjE4WyJ8aTycvUcSoMBplb8dRqQ=;
        b=qpXucAwpFt5UysrahsxMDhaQMAhHLk9ucmnrF7G1vpmz4FQ5XgyC4dw4UJgxggeclZ
         5spQidiM0wpGPeMIv6Kd4yHCXzcmvz0VYp90LUZpm4DaNBt7s8TeQv6V+HpEjyMu9egY
         zWi6KXG8QNJrVc75jL6VeWRjrjmDrv03AC+9n8d6tW/nkMCNo9Ce6ojZoFU3xVhkGGM9
         /xRGW0pBoY1oKP6BwaLlrb5WSZf+yuzhIOniTFt/lOjs3oyKG5lx08kRQ6RyX4S7HlVs
         HdfyTvNQvuATChvmfqJZc9EuRPvY5eIcxCKkdV+cZXaJq/2nQ5ovqR/HE3leVtXbpJil
         MTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727154337; x=1727759137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XzFz5Fbg1UGV08p7CjE4WyJ8aTycvUcSoMBplb8dRqQ=;
        b=tyW0Eoa2ZNnn1iURMq6dcGEUH2uvm/+fTdFRDgAhH87ja0HXQd2irELVZD4itWfDtR
         CZsgepyXNFqYZl/4bRq4WxiiIKVIrTFIQ85uurUdq1xDX85EHxUn0uUTEQ9Ju6nvPGcp
         qhCW+58cAjtV0c4xlfNc712TZ4h2YyPtCkBODC0tJiz4ULxYhRnIR8SFZvAOBkkTxumb
         I0KYIMXinUUsEJeH2NbcpO9arWeIH/xRpRVS1632Nwr4WcgzZYFOKMPZFZzXyf7ml82l
         79GxuhQgo/kvVih/n1Hi/tHr8BpyoeheY9n3uxZ7pX8wlCkSKyzwmHSsGPQMMFhyNQSU
         43qQ==
X-Gm-Message-State: AOJu0YwM84VkHqpvdwX4rhan6XORewwbWV0H2oHlGhGmQh2+CNwcUtmt
	PowOSj0aHmGNakKfPcQxt5lsAZY8gCar4aFoDB7OsIlcAZurwb496BrAgiZZNn2uLGJT7nd7+Mx
	AnGvD50dh
X-Google-Smtp-Source: AGHT+IGIETHofQvSHDp6BGh0QZaPOXJJnQ8oAC3ZWgu3QQsSmtr9hsqLzIHKHy+MDeyUuR4P2GBrxA==
X-Received: by 2002:a5d:4d50:0:b0:368:633d:f111 with SMTP id ffacd0b85a97d-37a4235a1f8mr8778747f8f.40.1727154337455;
        Mon, 23 Sep 2024 22:05:37 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc32b694sm552480f8f.116.2024.09.23.22.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 22:05:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/msg_ring: refactor a few helper functions
Date: Mon, 23 Sep 2024 22:59:53 -0600
Message-ID: <20240924050531.39427-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240924050531.39427-1-axboe@kernel.dk>
References: <20240924050531.39427-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mostly just to skip them taking an io_kiocb, rather just pass in the
ctx and io_msg directly.

In preparation for being able to issue a MSG_RING request without
having an io_kiocb. No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7fd9badcfaf8..ea4c7a7691e0 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -116,14 +116,13 @@ static struct io_kiocb *io_msg_get_kiocb(struct io_ring_ctx *ctx)
 	return kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
 }
 
-static int io_msg_data_remote(struct io_kiocb *req)
+static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
+			      struct io_msg *msg)
 {
-	struct io_ring_ctx *target_ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_kiocb *target;
 	u32 flags = 0;
 
-	target = io_msg_get_kiocb(req->ctx);
+	target = io_msg_get_kiocb(target_ctx);
 	if (unlikely(!target))
 		return -ENOMEM;
 
@@ -134,10 +133,9 @@ static int io_msg_data_remote(struct io_kiocb *req)
 					msg->user_data);
 }
 
-static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
+			      struct io_msg *msg, unsigned int issue_flags)
 {
-	struct io_ring_ctx *target_ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	u32 flags = 0;
 	int ret;
 
@@ -149,7 +147,7 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
-		return io_msg_data_remote(req);
+		return io_msg_data_remote(target_ctx, msg);
 
 	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
 		flags = msg->cqe_flags;
@@ -166,6 +164,14 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+
+	return __io_msg_ring_data(target_ctx, msg, issue_flags);
+}
+
 static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
@@ -271,10 +277,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	return io_msg_install_complete(req, issue_flags);
 }
 
-int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int __io_msg_ring_prep(struct io_msg *msg, const struct io_uring_sqe *sqe)
 {
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-
 	if (unlikely(sqe->buf_index || sqe->personality))
 		return -EINVAL;
 
@@ -291,6 +295,13 @@ int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+
+	return __io_msg_ring_prep(msg, sqe);
+}
+
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-- 
2.45.2


