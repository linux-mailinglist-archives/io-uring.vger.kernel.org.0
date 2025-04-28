Return-Path: <io-uring+bounces-7752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA9DA9F16B
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 14:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87ECB4616B3
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83ACD26A090;
	Mon, 28 Apr 2025 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jUQXaMZR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEB6268C73
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 12:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844706; cv=none; b=IIzyzuK8lGG3YLCqmdPFTci3Wteda7xV8CP+rDTsoNTYPqI0zWMlHnRo5Q0wpsqtbCgxMyDhfhcWJRiHla7SM98Q0WWhh+HB/rxcwvHu+h/2LjObRvZhGXQ6UNU9rdRyBYvPCDPKF8YOFJjieet0dBfWE0DP9ij1zdlhA/Tsk+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844706; c=relaxed/simple;
	bh=swjzFg6FmdbUpDyG+r8YHZNBCT/+fBSdNx64FCf0BD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW+BF+qXnY5PLv3DV/Jq252D9IGFvrFB2vdDoAeQKIpCEBghgnZZZSFkZcccHo0Sq3E10Me/nwcim3Qm1o8psg0QkSAHgvIw/u4iGK5WnB9uvSqM+/IP22NuISXw2RFyBQc/zYlV5V9bGUf30l3sISSD93O7qks0++IFyUY5Ppc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jUQXaMZR; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e8be1bdb7bso7472039a12.0
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 05:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745844702; x=1746449502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xyZKB8zZuWwPb162fxEHvFJzKPvkT5aQ5wVJ6zSBYc=;
        b=jUQXaMZRWJOU6vCHIFcYpc8yLwTg7lJp++NFJ3lMroXQKhDoU5lxJlx77f+PXZQalM
         e9S5E3/eQl1CK7Ab7fABavPDAG0aL/2uzAiNVijlcjknwDcdoZwmD4V1tHpQ1cOhBmI8
         35EijZPJd1M4ikaN89LV7hKi9ewqH32ttx3L1ceqLyL3XZuevJw2tjPk69emHU2i4WSZ
         F1s3+lePbzo565iNmGm8pjl06GEfWy9+cA4o0JR2JvlOiDVXhZsQ4WLZKDfKkEWN+QWY
         cXVLsl012IUnoXNSYI1WUOrsUP3Hyh5aICJyRtqQGhDYkK8n8eXQ/DohWePtmoLgydPG
         UfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745844702; x=1746449502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5xyZKB8zZuWwPb162fxEHvFJzKPvkT5aQ5wVJ6zSBYc=;
        b=gvTbHjetun0Hwe5IVgUq6TJGsPdBLjiCS9vfxfY1TzzPnAQImFTfeNC3yo5BeQl7ep
         bSnD2kXaQ84Q+Z9e1cAFnRW2uU7pw+5QRSVyXpKVzBhvyuu24Hnscp9Nr+xofxTuOoxQ
         LWKXuOX8s6odfcLM/6tGLtzc5O7JvtXw0VQMvQOy1xqGCNMCNooknobvKl9trdtKm4ad
         JfGYQGXSA+0xSyBc1nHqPnLQLO/a8cpPVCrGBAkYfEI2XewTHFEFxcNtBlTpUBmqFlVc
         RAQkfZ3B6PgNwM+jq+uGhpSxX2WEWeM+yYsHVKI5q9fuDkW7SeMvkpMHr5S6Sdz5VK0z
         apYQ==
X-Gm-Message-State: AOJu0YxiCqkrJKRkIE4ULPGtiZohI9eTQzy1P7GVm1ZR/+50nYL6K7fq
	mTRDvJJySLZLR9KxvbC2q+fpMjD9Nq5euPhmycsFpniLdG2AyaQo1UE1iA==
X-Gm-Gg: ASbGncvdwybmCtsF+q8rT+WqZ56bHkiahCGq1P8YzcppUEn3CHf4v3kLkR31GlLsLdn
	mu19Xq7VGxAeXPR39AUPwJt7xXDYKFFmdshRjD7jsBdZIlBYNUfb8nq3Qwyno2s3M13clv0h97c
	MRyZQL8uRyDyFRojn69DPcboLzBTjhPSyjXZXTp+27Jai0BK64s5Nw91YQMSj9rH09MFVOkmTYQ
	Yf0QtvRBIlAV7jxttqva75c8h4kvwv3Al/WiqKancbkLvBII7aXnV49f6umVOcQZfeAy7BG0/nb
	q9vfwkJ0M33u29u+ydyEwVMr
X-Google-Smtp-Source: AGHT+IGbkX7SepOdIlXP0IaSTtt0zYYcsLjrZCDsbLAZEOQ6mz9E/UP9ttSAuCh/Po8CXB+MyqoAlw==
X-Received: by 2002:a17:907:a088:b0:ace:50e3:c76c with SMTP id a640c23a62f3a-ace710c694fmr1191418966b.21.1745844702295;
        Mon, 28 Apr 2025 05:51:42 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e58673dsm613010766b.76.2025.04.28.05.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 05:51:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH RFC 1/7] io_uring: delete misleading comment in io_fill_cqe_aux()
Date: Mon, 28 Apr 2025 13:52:32 +0100
Message-ID: <021aa8c1d8f20ef2b66da6aeabb6b511938fd2c5.1745843119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
References: <cover.1745843119.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_fill_cqe_aux() doesn't overflow completions, however it might fail
them and lets the caller handle it. Remove the comment, which doesn't
make any sense.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7099b488c5e1..dc6dac544fe0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -814,11 +814,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 
 	ctx->cq_extra++;
 
-	/*
-	 * If we can't get a cq entry, userspace overflowed the
-	 * submission (by quite a lot). Increment the overflow count in
-	 * the ring.
-	 */
 	if (likely(io_get_cqe(ctx, &cqe))) {
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
-- 
2.48.1


