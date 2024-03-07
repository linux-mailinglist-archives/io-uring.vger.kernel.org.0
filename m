Return-Path: <io-uring+bounces-857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D37875860
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 21:31:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01FAE1C22C6F
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 20:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD6D44360;
	Thu,  7 Mar 2024 20:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UuB7cZ1S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77F922EFB
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 20:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843481; cv=none; b=pYg70gZXLeNapGXWVtCzZBoGTucvWCxqBwtkKkYYnzuN9J/MF2IoAzMe+cdKCtwmVm8me1E2qUAOSY4/FSOFOBoVcgVrosMvffun6Me4ywI7VBCnrLmjA20g6RNa9Vff+EkeC4NZFfTrG98ohjmSDkBSR5YlMY9pHd9i1wI6LmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843481; c=relaxed/simple;
	bh=MOJbzZU3ZTQ0Za5RasSdNuJI5PbJkI0sYcdd5Wx+Dek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Adl+I40rYbrKQ90abbk0PDxDhJgmZfDJHozIcw5UVn4kcjCb8UlPNzbStKj7cDzhLBooTeUV9VNZbDWwKGbGQ30oAcS5hyVO2X927i/7UeeIEtjK2MmABw/Dd/4FYuQt+JdV3o+F5Bf52RUMD5NzKxux6bNtFaEIoxgYnrtuKuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UuB7cZ1S; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7c840d5aab4so4376039f.0
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 12:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709843477; x=1710448277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NyTP/TpabmOMMvIFRa2yEBaWnqiDJyFsY60N+kaF1k=;
        b=UuB7cZ1S1LQUdX+zqEPqWqHwfYxNo+aGGJBrKKW6Qiu9+5Z1bypf3DjQKYHt8oc2ri
         bSS4aNv0IFMXfTznMoibzgXqbX1+tjUBgWZXtog9anCUMOVmwHWE+PIAJOqiDQVtDdPE
         +B7uyH7hjEz72EGyOSaKHawXGoeam6GMmE9CSCCsSD4lieLxeWpbZdCsDOG1kZQsrD+h
         FOcb9rXQND/4VfnF+1ghIHBdRUCQFOHyaWCvGZFxXhOd8X8n9Xk6HnkXfDi+zaZix6q1
         9CM2WiC8dGH99GD0redltYgQse3rdWle/Em1P5YeR5aatKURki3tqLJhTIVnMM7puM1E
         59Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709843477; x=1710448277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NyTP/TpabmOMMvIFRa2yEBaWnqiDJyFsY60N+kaF1k=;
        b=bn9baHEsnAqRh3Sqyov3IybQyVMab7pGRQjY/WKO9BKV5hIQBQfh4sO1vO9JUTmhrN
         v3020duiJldzMPzJOxjt222nqmmzITTCC12nOILVaOz5LAbFa9fTs7damZZPKOlyGOP9
         6K1SaAJAy/g+Q7bqOmurPdh7aeHNuOMGqEN+V3E6c/99jXtEtWtr30s3RQD/xGKSHkaj
         YrUJYTlDl+3Uk+hfb76BMCHPF+PVhV2m/+g1Ne8mUdeltG4HQ9ZxKZduAtKeIs51JFoZ
         UuHV0q0doVWM+vs8wXILfW7u5UEFN1Nxd68BpAUdokZ3GnEBdQ0qqRadJKi7rVCvlCvy
         +1jA==
X-Gm-Message-State: AOJu0Yzn8468Gtvl8NigHGdFv77VY/HPj6pfNIZRfPk1skmLdeTsEAAY
	tbEkaFeIkFFKJH+ZNNvkNxTTqB1pDrih0xHa/plrE8SlNagSicaKRnOXLWBUxrAEmsHuwHvmxJe
	3
X-Google-Smtp-Source: AGHT+IFUAbNDQ7RPY9u7SGA+noLrb/TZKq13Rz7LNWN7M/KL6i1bpcW8V1P2yrR/Cj4A0H1QwA2XyQ==
X-Received: by 2002:a6b:dd11:0:b0:7c8:718b:cff5 with SMTP id f17-20020a6bdd11000000b007c8718bcff5mr3557294ioc.2.1709843477525;
        Thu, 07 Mar 2024 12:31:17 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f1-20020a028481000000b0047469b04c35sm4198921jai.65.2024.03.07.12.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 12:31:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/net: remove dependency on REQ_F_PARTIAL_IO for sr->done_io
Date: Thu,  7 Mar 2024 13:30:24 -0700
Message-ID: <20240307203113.575893-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307203113.575893-1-axboe@kernel.dk>
References: <20240307203113.575893-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure that prep handlers always initialize sr->done_io before any
potential failure conditions, and with that, we now it's always been
set even for the failure case.

With that, we don't need to use the REQ_F_PARTIAL_IO flag to gate on that.
Additionally, we should not overwrite req->cqe.res unless sr->done_io is
actually positive.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0d545f71dc79..eacbe9295a7f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -387,6 +387,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
+	sr->done_io = 0;
+
 	if (req->opcode == IORING_OP_SEND) {
 		if (READ_ONCE(sqe->__pad3[0]))
 			return -EINVAL;
@@ -409,7 +411,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	sr->done_io = 0;
 	return 0;
 }
 
@@ -631,6 +632,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
+	sr->done_io = 0;
+
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
 
@@ -667,7 +670,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	sr->done_io = 0;
 	sr->nr_multishot_loops = 0;
 	return 0;
 }
@@ -1054,6 +1056,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
+	zc->done_io = 0;
+
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
@@ -1106,8 +1110,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
-	zc->done_io = 0;
-
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
@@ -1352,7 +1354,7 @@ void io_sendrecv_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
-	if (req->flags & REQ_F_PARTIAL_IO)
+	if (sr->done_io)
 		req->cqe.res = sr->done_io;
 
 	if ((req->flags & REQ_F_NEED_CLEANUP) &&
-- 
2.43.0


