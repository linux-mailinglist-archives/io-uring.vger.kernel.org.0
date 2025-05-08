Return-Path: <io-uring+bounces-7915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 625B9AAF926
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 13:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B51031C06E1C
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 11:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5E02236E1;
	Thu,  8 May 2025 11:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fUEK1bRs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90985223715
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 11:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705086; cv=none; b=fgy/qRnrZThRFtJ5/bx7xqDQ9wAZhIyv+ZZu7m667lA5AMHI2R+wuemy3nBpbkiLbN9kO26sPhH48FbmLi5caRxtActdT9uIwezNTCr4xsvvPV4pW18AjLL3LcinumhiGoOIKxGr2jjOpWzw8e07xN0CQRwp8yGZW8732PVV6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705086; c=relaxed/simple;
	bh=dwTyKIw+yfQdZ3q0pxqVvkEqgCV3R5M+SKFk+PT4d1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUa5WAAuuq+kPgPqLTjtJ/xULKlMRcWSgiYov7fFD48eOr0gnQzTyuXuw18HsOQLDfrgQaLngW6Bkn7kM/Qck6wXL6ZHFFxp/qSxNOP//Zb10PmfSQevDqs3QEVAlMpbTLLeZ6pL0yAY81c+Y8/+TitMPwCvyL3y9SfV2GMlGZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fUEK1bRs; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5f3f04b5dbcso1383312a12.1
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 04:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746705082; x=1747309882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEW5cNyEKO6+UMT2bdt5SbOBD0fkmu/64KuwzBFEwnc=;
        b=fUEK1bRsMqF7zhBrOdbaZjoKf7TyXiVz2ozHVRdausKUloP41aKR5Ekjg7Zkxh1HCr
         6kqvxObcIrF/DsJ4/rwm1g87MkreAVBHZPoPxzKztQs7OYbuxaVFz/s8LpOJYKzK7iPw
         MMII49zQB/1QjVx6Lmbw2YjdsHDnoTceyE3fpmpIvJvSljak2K74SGEdhvrX4hPnbiGN
         wGAplLHCykGcW0WOppa1MRFSsdFSmAy3fBRhQJI2HFoPTgwFC/Vr3yknP4xH/i1M4Dha
         VnHjuWa5DXw3xChMit2SpnfCXWNzFoqGeLUv2UZ5cO37yzKBsq12zuIrchTQNduB1/f7
         DWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746705082; x=1747309882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PEW5cNyEKO6+UMT2bdt5SbOBD0fkmu/64KuwzBFEwnc=;
        b=CVzwfjTt49QqmTPlYSOXC3GSe2Npzp4J2H/L97u5K5neBxowDTgJ1WTzCFyfcWvNQv
         KThhqE1uLiZncvpPIX9wqJ50dJyc9L1wFO9f5M3VqOIIALtpu14HT36S0szbpHge/OAC
         MX3QVyjGrvmA82isoGIQi5+3eMLAmzqtLuAIQAs6TfJvmAD8QOi6oirIFIZBH/Zx5ceW
         N9kToad4Ij9x7cFb3dednKox7dLQv+eYUOxcNBMbuRAXxvLtk4RZhQ6b4PowdpyVGCa/
         hL86IOXYhSZtnFYtmQ814AnfMXAOb6nWziNtxbCmLSeK29Xnubqwis1BIhNAkmfuOqL5
         nKPA==
X-Gm-Message-State: AOJu0YwkBRcXY33l8dpHCKKjYEPpCBDqTKtBMnjrUu4N4h/eal5/uwxW
	dyin1hELAEAqUUv5avh6Llvm59NK3SSn1t4pdXOFgVJo7sZhuG7hXjpO8g==
X-Gm-Gg: ASbGnct0xXjVK42YeDdvFJPIJLEzMJvb2h3qn2KF4qs9qcHUdw0uQZOJx8ANdNEGj82
	OGQ3OMcZ1f8hksOni7UPdS0/Y7DSfUO2TyB/PKbQHwWhotHZ2g+Sr9yJ78hnp/fr1vD4WahJeGO
	+NebCVVhIwEVRFBBLCEeSehv5OSl96TOWIKMY3Nd+P8wcWh6Zdph3a7b3p5H1Ub+xuKG/hyQaf9
	MEz8MH5hrlaVvti49JzMzePYIj7yRGkOj1a1YkSQ070old0jXXuQDwQWG9A8rLVHc+tTN2rVmHt
	HP0KjXV5GnP7wh8vDsHlgo/K
X-Google-Smtp-Source: AGHT+IFW9EESGK91d3qBiapx66CHplE2xjj+712vNf2930Lc6K+3QjznzNocc9ZpQ88pDxhiin48Jg==
X-Received: by 2002:a05:6402:84d:b0:5fb:afca:dd58 with SMTP id 4fb4d7f45d1cf-5fbe9f90adamr6417353a12.32.1746705082193;
        Thu, 08 May 2025 04:51:22 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2cb4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc8d6f65d6sm677051a12.13.2025.05.08.04.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 04:51:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/6] io_uring: add lockdep asserts to io_add_aux_cqe
Date: Thu,  8 May 2025 12:52:26 +0100
Message-ID: <ca1d664411122236e44c982c3dd11b26d96b78f7.1746702098.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746702098.git.asml.silence@gmail.com>
References: <cover.1746702098.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_add_aux_cqe() can only be called for rings with uring_lock protected
completion queues, add a couple of assertions in regards to that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e50c153d8edc..503205ced136 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -853,6 +853,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
  */
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
+	lockdep_assert_held(&ctx->uring_lock);
+	lockdep_assert(ctx->lockless_cq);
+
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		spin_lock(&ctx->completion_lock);
 		io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-- 
2.49.0


