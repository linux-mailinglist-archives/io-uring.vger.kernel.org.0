Return-Path: <io-uring+bounces-1045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C1F87DB18
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 18:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47079282A07
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1232518C36;
	Sat, 16 Mar 2024 17:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wUN+9jBu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A201BF27
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 17:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710610274; cv=none; b=oAIJom5FBO7Q/Rt8b0ABwKC5TscQI1JrHTgW+ZfQYieNBpFVJ1nbevi4VpGNCWZJbQfe9ux4rNxk103PIppwq0zfEmLbzDeRABOFfY0LhAhXG32D6NNm7lrbhvzpX3zkEhPNq6NiwKVPQMTZhcyC8U4gx8EDqRGU+3mNyH541SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710610274; c=relaxed/simple;
	bh=Qk/Vm235cZxoYKgf76EFCB/0VoJijnWCJWB/KeytLPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeCeYJwMiFz6CBUVeWdcrK2E30wLp78cKEihX10Y7frQHwQVNeNB/Q6EGiW7BcLc8j4h6qj6lOmCwsQm62qlw1SgSWQOnHCkYYezxxese9fwEWuQlRAcDKmrG1szo9gsuswUVr6a0ERxBuYUKLDb2o60k0wVzUHVifzaHbbP14U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wUN+9jBu; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-29f8ae4eae5so29110a91.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 10:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710610268; x=1711215068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9AtdCZ5nnGZyJoSUh1PePrxtV/hQ5gF5IDbuv1f5JfE=;
        b=wUN+9jBuKN5qGHzAOrtS98F2hN0UpsGgkCoKM4zylYUjGRNeIoaXLlr5DH4P9tDLSc
         VDbNjlYInPnoGyQn+U5RPMePQAT/VRJV41V98xnQVCZgZGWRMdolt4k5ZP5mfpLPbcBC
         IuFxqgSLEZPpFuMhLK42gLobx+APshNWRTIF1VP3RplDa9MpgATrfHGTFJpsEiow+pWv
         zTNVNjoz7Cqr6vHb0x0szGm8RSJcYB1LWsIi6OpypLWoQOkgJ3ZZ8N5kfZ5XTH0m5xFc
         MPl/AxyStbTCn2iLuTZe5pKQSqrmkzt0CfP5E7WgsyFVP4qWhdxATgJdd33ySmaXtiTI
         2DBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710610268; x=1711215068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9AtdCZ5nnGZyJoSUh1PePrxtV/hQ5gF5IDbuv1f5JfE=;
        b=A7bQTv79NdtQp+QFygkv/3pHmbfsJwxg6CM/hRwVefNUFM6PWrOmBlOmTf51088kL5
         2DHglVHhSAaVy1vVTs8R03vzMC/eFELxQ15kmOyFcyPKU+UK4au7jXTr5EJE6Qv6wBhy
         NW3Nk/3PwzZ+OfG4UNszXinDRq/qHgMmKv8fzORLQjFJ0YwR/r4JGAMwJhEALPYQvsXs
         dVwbzHoqvuw+cp0IPPmb/7E4yzQ6OnHuhyA1gESKW0cP++SAzZby4AdneG1Qoira6qk9
         aRxu8htiG+SAU3DmH2+4XonYvCi/bjcNB5pO+KtC6zzpbd3FviXFm6Vos2AWiMhc4WH3
         r0Sw==
X-Gm-Message-State: AOJu0Yzg2k2avpLQXg/7HF9dfjb4v0uMz9/Ue3EPf2iIjJ1r/MhS0I+e
	a12NVIm4iEHpsdUOYeLioQVpxYhnnfmeSlcolbJe59AbgWBeEvcyHIj7d3nEfJDIKPysELsNNaf
	P
X-Google-Smtp-Source: AGHT+IFGMneQ3Ppr11uP1c7jTVzP/yWfuKFwo+ADKcKWc2XG5nFoi8CmOuaSTW8d05pihaIPGlrlPQ==
X-Received: by 2002:a17:90a:b889:b0:29b:780c:c671 with SMTP id o9-20020a17090ab88900b0029b780cc671mr5640510pjr.0.1710610268642;
        Sat, 16 Mar 2024 10:31:08 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id nd16-20020a17090b4cd000b0029deb85bfedsm3978567pjb.28.2024.03.16.10.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Mar 2024 10:31:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/net: ensure async prep handlers always initialize ->done_io
Date: Sat, 16 Mar 2024 11:29:34 -0600
Message-ID: <20240316173104.577959-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240316173104.577959-1-axboe@kernel.dk>
References: <20240316173104.577959-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we get a request with IOSQE_ASYNC set, then we first run the prep
async handlers. But if we then fail setting it up and want to post
a CQE with -EINVAL, we use ->done_io. This was previously guarded with
REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
potential errors, but we need to cover the async setup too.

Fixes: 9817ad85899f ("io_uring/net: remove dependency on REQ_F_PARTIAL_IO for sr->done_io")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 19451f0dbf81..1e7665ff6ef7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -326,7 +326,10 @@ int io_send_prep_async(struct io_kiocb *req)
 	struct io_async_msghdr *io;
 	int ret;
 
-	if (!zc->addr || req_has_async_data(req))
+	if (req_has_async_data(req))
+		return 0;
+	zc->done_io = 0;
+	if (!zc->addr)
 		return 0;
 	io = io_msg_alloc_async_prep(req);
 	if (!io)
@@ -353,8 +356,10 @@ static int io_setup_async_addr(struct io_kiocb *req,
 
 int io_sendmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
 
+	sr->done_io = 0;
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
 	ret = io_sendmsg_copy_hdr(req, req->async_data);
@@ -608,9 +613,11 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 
 int io_recvmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *iomsg;
 	int ret;
 
+	sr->done_io = 0;
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
 	iomsg = req->async_data;
-- 
2.43.0


