Return-Path: <io-uring+bounces-4634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 078239C67CB
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 04:25:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1176282C4C
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 03:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3046A166F1B;
	Wed, 13 Nov 2024 03:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbg6ej+K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7910915F40B
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 03:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731468322; cv=none; b=stTt98JlN+wy9RcWNsZ84wnZnfYxmNroSiOyXkqiX7s9kHCTE+G/rGIj1ksA3cA5tSZtIsQSAR02K2+O+brDsNA8IWquenbJvrC8u1FbYUspoDtTSS0nGfjI26t5Jp6XF2RAxLSnlU9HR3VHu3x5NUOORAaSgFO4jf7m5f7Lwpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731468322; c=relaxed/simple;
	bh=eqSYwEOXhdLlmw4h0pKAwaqWf6FkiVxc8iO/Fliesmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C0c1GHP002L1n/8S0ChYO8LNVu9+fWwNNtAlLeutjpu26rONCkO+A3D+0i5TJk9jy2y03sTlcipxJ7W0PL3xPxBwnOFGRB6TRdfreNc3Lh8D+0kAdy6OLZ9IKJrSUb2BPtz8Fg97q35n9NCJVGivrU+dQ8qSu4DfnEMJI0oaPck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hbg6ej+K; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43152b79d25so53944885e9.1
        for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 19:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731468319; x=1732073119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W9PHFX19JO7aEDyPCPoGmB6kyxp6GJCC82C3tQrCuB4=;
        b=hbg6ej+KYVINTOGPwY4QivJob4cEMyFKLDC8LzIK7MKtlu/56AhoEqmeLhc9QAQNSY
         PXbZzQMmVm+J5WjKVTRtTu/goF0vJ5EqPTPR2Q4DlXtgQgcmjqgBGkefrXqtwCVCwXx+
         LxPezrMh8qY1HXVhSwjXtWEVAPRFQAI7c2YXxm4yks3LXoyjtg4F2itWsUhWvWNW6Z2y
         2UbUoxVb0f6RiL0TLXRWFFx00jCq0A3WjlfBH8X+YW0f09Yvr+lYN/urK8NsiX21eswI
         5G+xLCLjd1917Zp+WR2zhTBSi8h7Nhdy8kF7Fh19ciR9HPjilgTMW1Akv4Jt/qs+u1KX
         1O1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731468319; x=1732073119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W9PHFX19JO7aEDyPCPoGmB6kyxp6GJCC82C3tQrCuB4=;
        b=SJ/c4jrQ1mFYepSUgnesXMvcWHg8FdYzgYIYho6EWtqfM37zOUMexYLfqAcDfL8QOV
         53TxogeS7ya1U6bIhZNwRmVd76yCxNuZM05zmkhbTZnv9nAMHSg27G0bFUm37aghqh1+
         cqVqGVe/eV2ScNo4NBRR0WDm16w0WPyc+nB7iBn9ylfXORRTv1zTP7PFOtzXUrSAwdt6
         yZUvkOdhi/JlRkJ3h6R2E8aXxBh3UKO1YTLK8o341U38MwovbE64x1K4UZ7uIo5JHh/Y
         92o0bGhoeHKfTrZH8OW3J7p7nLDVCcIIi0O/Dxzvhi4+hbfE7wsn6vrGirSZZkwJFgOy
         ta1A==
X-Gm-Message-State: AOJu0Yys8VDBTxGkreBkFrxWtARwsENrhpQE/TfrNyx+ETV8nBf4uz3J
	UpX+j7fzhir3f7kJr4+t33CWegZKI0XkmALJTygl+/L0j3M6z5pUOptWWg==
X-Google-Smtp-Source: AGHT+IE/aUBNpXoLqKGPxtCRic1EtCAUV+4GOXaDeJIuXrUmJbB3tAcAY6Ie46rX7pIjD3p0XfXS0w==
X-Received: by 2002:a05:6000:1f84:b0:37d:4ebe:1650 with SMTP id ffacd0b85a97d-3820df7ad83mr1098108f8f.46.1731468318444;
        Tue, 12 Nov 2024 19:25:18 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed9ea4c5sm17256857f8f.76.2024.11.12.19.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 19:25:18 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	xue01.he@samsung.com
Subject: [PATCH 1/1] io_uring: fix invalid hybrid polling ctx leaks
Date: Wed, 13 Nov 2024 03:26:01 +0000
Message-ID: <b57f2608088020501d352fcdeebdb949e281d65b.1731468230.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It has already allocated the ctx by the point where it checks the hybrid
poll configuration, plain return leaks the memory.

Fixes: 01ee194d1aba1 ("io_uring: add support for hybrid IOPOLL")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f34fa1ead2cf..8a7b5a899d46 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3915,11 +3915,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		static_branch_inc(&io_key_has_sqarray);
 
-	/* HYBRID_IOPOLL only valid with IOPOLL */
-	if ((ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
-			IORING_SETUP_HYBRID_IOPOLL)
-		return -EINVAL;
-
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
@@ -3970,6 +3965,11 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ctx->notify_method = TWA_SIGNAL;
 	}
 
+	/* HYBRID_IOPOLL only valid with IOPOLL */
+	if ((ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
+			IORING_SETUP_HYBRID_IOPOLL)
+		goto err;
+
 	/*
 	 * For DEFER_TASKRUN we require the completion task to be the same as the
 	 * submission task. This implies that there is only one submitter, so enforce
-- 
2.46.0


