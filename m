Return-Path: <io-uring+bounces-2711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA9D94F57E
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 19:01:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7FE41F211F3
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 17:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DA51804F;
	Mon, 12 Aug 2024 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q1Jhkl2R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A29D13AA47
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 17:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482058; cv=none; b=sE6a6fnFazLH2GfGAyskGFNkJbswnkSleNuDqlYcUDQCaT5La+dwIYxtleiPiIZL505Cuupp6tfpfvOHLkgakBNQfdUbYjrcmZuWgMa7Huep+oPy9zKZcVH1qM83zsNk21UrXVwn8bkFDxRmC7vNtOfByi+edIatD9tmoYJOjL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482058; c=relaxed/simple;
	bh=kEK9aFaDFaRtL9J2hVxr8jMo8+cADSfUsHnGS+JgYzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMwUlRUQjFAqiqbH2KgCZqsyR+ZsY7XKeXnSaPrYggaQTNFfUQUQFuo57ejEMoL6wMvxBvUDiHVFWi9BZGRVTFSRVG860/mPMgNhZUsO/IApafN+VKUtw8KFI+BvBqL+ISnOZBsEewimA2uoM6cHPINX/35jr3M7tj05ospa75U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q1Jhkl2R; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fc57d0f15aso3052655ad.2
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 10:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723482053; x=1724086853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o80CQNJb0yqYiBgWEpKfZgN9Dt8er/w2Rt4Yd7KyRkU=;
        b=q1Jhkl2RVXSUJle7AyfzEdSwe8xIE0CMoG2X3G5Z1lEXIQWAeUqm8MkEleSU5yyFyt
         Cc07b1IpdRTXGMlijlgd5JD0aCwtMpBMQqrq1NtN1dL3hX/LFTVSiJcapT17JMq5LCRd
         Gx0Dn3vhzrRBtQboXtuish9w7HROVCW0FspQnLrjMlANgkw6O84NcH8oGhEpQQi2tYQp
         StZFVDQChl3NVhls1KYxCfOo6Gkvm2BuqcUYoogMPG906+/tJ98gmuTMQsnzJYDs/Tjo
         Fhy5uF5SCD2DzoXv2mE5al6b0HndeVnX79x+ApJvLimuvA0Cyk114OZHaHAM5kseNFx2
         1jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723482053; x=1724086853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o80CQNJb0yqYiBgWEpKfZgN9Dt8er/w2Rt4Yd7KyRkU=;
        b=lNnCmcplOhhmyS4YbhXSTHELHEJefdliN++RsFg7eqV2UvFR/fYEEcEkmmdiE9Y5or
         QJRJ+jMehu+KfqHyQZGOQP40i/FLCOzoOTzz2QZ4lCCOUC5Uhm5zEqHgArTVD7JIRSzG
         OHzf0QDXDIo4FJu4eR+k/D7+aHufro5xD/RhxM6NrxwElXdVEP9POdnB3s19AtJ3bC6r
         rAtLsMTeZATcMKUGR+ZCTRCvDvrkcAfxPYgHtYfRQngdSbEA/+niFOKSq8jtpiR4tm0d
         oFaagr25NYFmd/aht0/VJrKrOtuF87jWncM6egbzghIT1aiiK4QrzG+eb5dCmp5ZbW42
         87Gg==
X-Gm-Message-State: AOJu0YwoEZIeX9grAZXIMOxu1yaLvhjT2iEcNC9ZUWPQCTsXfF2dQGqy
	eQpj+Ds4usLVm5MyznXVw+O4JNPjdU1fA9S9h1NbpkNXqkeB+37K6/gXnfl74Iv0oteBk/CoRHY
	h
X-Google-Smtp-Source: AGHT+IE4+3uAatWw8oHQdwf8QJhtcVULK/+WdIFJJcM2GAhHctCIqITBGiA/PYpEv9hxcVGWMVvhMw==
X-Received: by 2002:a17:903:1c2:b0:1f9:b19b:4255 with SMTP id d9443c01a7336-201ca139a9emr6506315ad.4.1723482053305;
        Mon, 12 Aug 2024 10:00:53 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9feaa4sm40212725ad.213.2024.08.12.10.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 10:00:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/kbuf: have io_provided_buffers_select() take buf_sel_arg
Date: Mon, 12 Aug 2024 10:55:24 -0600
Message-ID: <20240812170044.93133-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812170044.93133-1-axboe@kernel.dk>
References: <20240812170044.93133-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than pass in the iovec in both spots, pass in the buf_sel_arg
struct pointer directly. In preparation for needing more of this
selection struct off that path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 793b2454acca..794a687d8589 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -119,7 +119,7 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 
 static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 				      struct io_buffer_list *bl,
-				      struct iovec *iov)
+				      struct buf_sel_arg *arg)
 {
 	void __user *buf;
 
@@ -127,8 +127,8 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	if (unlikely(!buf))
 		return -ENOBUFS;
 
-	iov[0].iov_base = buf;
-	iov[0].iov_len = *len;
+	arg->iovs[0].iov_base = buf;
+	arg->iovs[0].iov_len = *len;
 	return 0;
 }
 
@@ -296,7 +296,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 			bl->head += ret;
 		}
 	} else {
-		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
+		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg);
 	}
 out_unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -323,7 +323,7 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 	}
 
 	/* don't support multiple buffer selections for legacy */
-	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
+	return io_provided_buffers_select(req, &arg->max_len, bl, arg);
 }
 
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
-- 
2.43.0


