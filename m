Return-Path: <io-uring+bounces-3289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B8B498454E
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 14:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69D901C22638
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ED4713A896;
	Tue, 24 Sep 2024 11:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ocR/S4iK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48DB83CD6
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 11:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727179196; cv=none; b=NhmF1o1xWlsX2MidYtWoZQMEbgTvULWT0fxUF8aNoqSADXgJuvlzwBL0gntChBlZf7QKZcnRzJDgGgrbyXGFcoHWmcfRP2Ac0nkkn3y3TyP90KF0vi4mVriFHVa03C/pFuM8zI6JeOKK4N/wGJIpnXfN0uyAPDYh3ppYgQBc8tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727179196; c=relaxed/simple;
	bh=lmR+UuF6HiMAQOCwu1iUbAaWfc+280+bYx8agLaLgm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnxBn8ZFgWD/19BqHoT1J1Qru/jBewtFk8U5E9Bvf9vS6FscygOAR9ewV1RVqo3mtCRmrEmWUt0CPHjndlGApetxwsDLg1cu1O2hpx0TNIE6/EFW3rY9InkPoWdI5grNlD9SNke4ZuYrDIWmOIzZKMKlTolBJLXke/mUit4Wlz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ocR/S4iK; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e05f25fb96eso4808131276.1
        for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 04:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727179192; x=1727783992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4raUV2DbC3AQ8aQFBEp/ZNoD+88To087Yqsmti5BzXc=;
        b=ocR/S4iKMXUf8K/eE57xD6foobDIbErsg2a/50S0f1dwc4meH2/ysR1taNRdxhQg98
         gSQJ4hlzwzO7wn65UeEo+x319J1iCkvpMK6WJ6y75hJgxifVWdYhO1eiWXC3AfNXVd/c
         csrMdfSA2umocsccd9JZ7qmO6q+EknNVcpZr8P/2i0o8U7eVOCxLHD7MweHZa57bl+LA
         xolFJiWL0uVPwMZYTMjTvannkj6wvyT2o74KOg/9vkEtmzy5nk13qVnsKL4Dh2E4hsym
         xkT5rsSmbLcb3U+J7D95gEb4L7NeHOluhrH5PSngDMO5zgP0KuT50aCdakckCe82WStJ
         Ubdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727179192; x=1727783992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4raUV2DbC3AQ8aQFBEp/ZNoD+88To087Yqsmti5BzXc=;
        b=NLsC+7K2Evp5R5X9pvl746oArfN5W9keH28mitGTbLbpR0SjdjPAFtb1DvXY7KBwwC
         dQzUNY0pfWW8ZJOqjpXaqLYm99TL+7YVkOCie98Ny+S7TXm5t2FTKqyVZfY9AP4lTF1i
         fcWD79+MY1j2f2IiNgHFkbpnt/zQp3o5r5o6/niIMgkex5ZqpKlPjgMB2AwwUjUOIIPp
         wwK0906+LZ0aJoEzAbZ8q2vqTMqxRbNmlAoIvcyoMlQ3QrQjrKDG2ptSzYPNGdkMuRnD
         wO5fgVzaSs7ldwsVMgWW0QbyU37KhB51zdDd2LNfHFyHen6C6N3r1uVcYTDzler1NJDB
         yW1A==
X-Gm-Message-State: AOJu0YxX3HoYt8IW6mQUtBXQCxxfeqzBW5jUJJdmnj3+HCLhnczPokvM
	TDtk3UDHMVmDRcm1+AY1bx4RxbYrGXWffmlbEcw72khmXzxBse0/Si8ho0vWI9oDvcI2PqguL9S
	hIv4aMQ==
X-Google-Smtp-Source: AGHT+IFYwWiIOV3CZIln36x4iWhTDUPbMRwIFq5SlF1M3dJ20uE0mEur2gFZ/ysldIgSEDQIv6izcw==
X-Received: by 2002:a05:6902:1612:b0:e24:9f65:ec7b with SMTP id 3f1490d57ef6-e249f65ed92mr428973276.41.1727179192167;
        Tue, 24 Sep 2024 04:59:52 -0700 (PDT)
Received: from localhost.localdomain ([2600:381:1d13:f852:a731:c08e:e897:179a])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e2499ae6a06sm210598276.4.2024.09.24.04.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 04:59:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/msg_ring: refactor a few helper functions
Date: Tue, 24 Sep 2024 05:57:30 -0600
Message-ID: <20240924115932.116167-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240924115932.116167-1-axboe@kernel.dk>
References: <20240924115932.116167-1-axboe@kernel.dk>
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
 io_uring/msg_ring.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7fd9badcfaf8..b8c527f08cd5 100644
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
 
@@ -291,6 +295,11 @@ int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return __io_msg_ring_prep(io_kiocb_to_cmd(req, struct io_msg), sqe);
+}
+
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-- 
2.45.2


