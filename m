Return-Path: <io-uring+bounces-895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D5537879725
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 16:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B7D21F222A1
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 15:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12EE07B3F5;
	Tue, 12 Mar 2024 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dE9nCxP2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6168478286
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710256070; cv=none; b=qQbLPH9H4vuly7vwa56m/ztvodPp4Hqc05P6jEPGy8OVgz1GdlELQHNGsLmOxtyZYID7Ezmy2NqrKyvJgnl0GCj1TzEOASY44Vl0ck7FmCDpPzTOsRw3Fdi3/TFburHxXcOE0jSuYsb3Hu+Hq61Nr7ociWYbkYoiUfuHUT/pRJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710256070; c=relaxed/simple;
	bh=TdqiDXEWnE8SBD/0mcBgFTW1mK3vOPH8tnaR0ScU7/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NaDzSEjSWQk/PkbfiOIcWN69/AwiH2oS3xzzTapPYs5IpzEQnTUYdKtw5uK4SoSaeYvsffdrNXPSWUrAlMYfaMiiemtFVcdDsdCiAHFAeccHAR411gNYr6oCwlOgjosexgAfus4sVdMf9TSYg9J1r5T+x6m1lrpCK3HA5f/nwNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dE9nCxP2; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-56838e00367so4959136a12.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 08:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710256066; x=1710860866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vFfmXKOXtpHRhC+FgxiDDeeRHGPGCzJGWPHeK9OoFow=;
        b=dE9nCxP2erpuZI78kjUpNoRkV6GJ3a7ANoTysFqSTrW0PShxovuPkqR5AJ7t9bjmOb
         Iafs8rjCSuK4hkOWJm9pg6mzzLTCNB2HjnWB6ToEkwm49cqpo7+hVBnrvnIzWGJI7voM
         4ySYwmCauIsysUaYGFJdfaS0zI2EbwSTK/Az+tqVp9kq6EEIkUul+pfTXOZfQaWYbz/a
         T50jjOtPrnglQBy7lc2e93kvsc0A/NrttNnNcebtxsV6jDKl08Vk9Am1StmHUATkwnsE
         xFCeib0jLoRlv7zz+CbCPWO96ZmqP4HQzre530WXBDyUfQELXfcbGtH31J2oOwO/XE0R
         E/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710256066; x=1710860866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vFfmXKOXtpHRhC+FgxiDDeeRHGPGCzJGWPHeK9OoFow=;
        b=n6SKvAqBEzmYVaFyKaGHXN60knUPSUVrYuM2dW9gHngrlio571rLq7HBduQ2IaFxTM
         w9nCN1TGYExiOoOdhpcePq+EtWL/WLXy1D+sSse6qpPERYQ9DDQM5393QfZUaBeKj2P9
         dEV04gJHcsqfBbosnW9oSPlyntSTTBkjRWUHgje/wCsE/5NmHG3oB6YTdVvPw4FW/2jw
         1GD2aKXUTSGbXf6qhvA0ij5GyTaGANw4PpjgKDzIYBAqCvIfQXKEsDjdtmEnGMS93h1Q
         GzLq24GXd0oPj4sZCntSNyCo0xLCt36+tXeEGbhERHtWaY4v05U29nwKAdWQ+bVyYZCU
         wR4Q==
X-Gm-Message-State: AOJu0YzpUqPj0xtwm6fHDaUtYeOyVhAfTieRsxJe3ZPTpD3dIkTJOw2u
	E7Pv/7RizdGlH+pGvwXn/cdkSzvEIVxxVPnXL1P8Z5RJ/wYc0CtNxC9lRw5z
X-Google-Smtp-Source: AGHT+IHevXyv/yHtk9JLUqNheBhPmOJlMEWIc7QuPnzNIzoqpLZl0o3Hyk6f7r6cKpDX+DFMzYsENw==
X-Received: by 2002:a17:906:bf4c:b0:a46:4cc8:6d60 with SMTP id ps12-20020a170906bf4c00b00a464cc86d60mr511078ejb.73.1710256065885;
        Tue, 12 Mar 2024 08:07:45 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b00e])
        by smtp.gmail.com with ESMTPSA id l20-20020a170906a41400b00a46163be639sm3060941ejz.12.2024.03.12.08.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 08:07:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: clean rings on NO_MMAP alloc fail
Date: Tue, 12 Mar 2024 14:56:27 +0000
Message-ID: <9ff6cdf91429b8a51699c210e1f6af6ea3f8bdcf.1710255382.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We make a few cancellation judgements based on ctx->rings, so let's
zero it afer deallocation for IORING_SETUP_NO_MMAP just like it's
done with the mmap case. Likely, it's not a real problem, but zeroing
is safer and better tested.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25bbc ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 49a124daa359..e7d7a456b489 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2788,14 +2788,15 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
 		io_mem_free(ctx->rings);
 		io_mem_free(ctx->sq_sqes);
-		ctx->rings = NULL;
-		ctx->sq_sqes = NULL;
 	} else {
 		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
 		ctx->n_ring_pages = 0;
 		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
 		ctx->n_sqe_pages = 0;
 	}
+
+	ctx->rings = NULL;
+	ctx->sq_sqes = NULL;
 }
 
 void *io_mem_alloc(size_t size)
-- 
2.43.0


