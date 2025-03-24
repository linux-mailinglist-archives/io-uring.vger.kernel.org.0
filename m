Return-Path: <io-uring+bounces-7221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB9BA6DEBC
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 16:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7A691667E1
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 15:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E613E261562;
	Mon, 24 Mar 2025 15:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eh5up+Rf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307C72A1BA
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742830317; cv=none; b=BHxDokcMyrIju2WTvtfThKfH2OuOEMlVaFfY9XV/XY6mXsfhnQ6YAnvLOzh4dr6AyRuZ2YKQUPCGSIjyDlol5d7yOV2Crv2kXn23BBtUNMUnO7B0a3uB6RNyAZEQ95VjCGO3cXPxSkc2zUAtBmKpzqZNPNBRjrFIan+/Upth2ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742830317; c=relaxed/simple;
	bh=Y3rTpo127LeXriZKPxIrInUloQD1ppURYmFyzEYocsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uu6vwGbDCFZbc6W6IOjorHVRfs1yCAd9psuT0zCBPyrTREsjRA4rbkKX89VZbmBg8Eu0WNhst6SIjACPYp38YR09h347DCVf4mRBeaQUs0mt7ieMo2hLLZmVxZxrIjwkeOQClZM25yGMDxEC3ze6i+XIj+9V4nBnfLkMKTxef5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eh5up+Rf; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac2dfdf3c38so634650466b.3
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 08:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742830314; x=1743435114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYfYKFyG1gPXNYk50ZezDX2QY1wL/pY3Ug6Y9O5t6ro=;
        b=eh5up+RfCxrWWuxdpXRvjfBQ+bLke4e+N3MYIiL6hEpAowgdOhbzQEBKaCmgkgYl/K
         L2xtGOQUURxhAGTRzvzx/ZY5C2PjHzl8aWd31VUJUA39V5Ss4mFqNDktvB85Go56TKWb
         yo2zODqXbZsoGO4091iInJ9rDt+Hvnud+sfWVNz2Xd81gZsZORNmaVDflK/juD5L4p6i
         7vd7/b0KEk7lSkGBdIMlrj5Kj/WJf/VAew7cr/yV39C4S7tad4A3CK0eAdr4MivR8yAl
         BR0hcpuRt2C5+RY92IO4RKZw72INb/o1Wbd4uYnwysgS4KWDMkNJkJP03dXo7wcGp5/9
         TSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742830314; x=1743435114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYfYKFyG1gPXNYk50ZezDX2QY1wL/pY3Ug6Y9O5t6ro=;
        b=NEggy1hEcu6eMDMUtwTPfsYm7xCbKQHLuM2/hIbhJfB4cwpIqQ5lB2jDfOTbSeCq4d
         fwT+XdfC7/q+9xn3sxcmnVlgZI9cMvRsayte+P9Vf+FmIjZ4sIApRJS0ZfTVMSV8xjQ3
         rhGxALlteo6Tu5COzsE62fhhtWHhld8sPUT22O0cduLk3p2jt3ufnAdi/05IEJfMu4Fe
         s0K10tqgaJEQgpIxD4ZTPlb6GRwjVAjbSphHyIRZ959uXp1xIJWpyN9lS1f/RMq29F4a
         ILGFnD61KY2RGFYk1HuqRj/dInwP0LfwCTuuRy1UnlYcabP0RnTpMNKQ6rZyEGnDvjFn
         6qXQ==
X-Gm-Message-State: AOJu0YweKhDz4G6SPpUunDB5ZC+VxuI5OJCposGI1+76vrrmgxasMiyK
	WwBGpwdeajr2xMApSnwecLFbWpvoaP4W8pSSQFyuE9OYl6PCunkGlJZuNg==
X-Gm-Gg: ASbGncvcVRuLCMmVH8VcBF5Q6XMSpqIXGJ1gVrPUJEJYyS7PJU/w1dSSw8Cw5VglrGS
	V3wITwZ2Tms2RjcPD9Rjrqhaj40BEibKGWq74XJJL7TRUs4TMRNGQhAsnyk/oyHW8TWmivpe8xF
	Zkzgv1/NCzIWRPZy8qAuLd95quEXNMZpE1OlSBw9xMI3kD0bKl7dW4n0659kJY6dUUjyI0J5rWU
	b3+qmDW6TFQZJGyCyp+hfeckqq3Zpk99BTamy//wHhNbdXUpUjF1eiVUHIG9hj4FlGcW+eJ0YCV
	YuFEEr5vukO5zb5XafSF+Sy0QIWp
X-Google-Smtp-Source: AGHT+IFXJ68G1LKnXktTTXdmr7NL6ft85BKxYvryF/ZBpby3/bCyIfsUQdMESDntoStsyKPNbnX8rw==
X-Received: by 2002:a17:907:d8c:b0:ac3:aff6:817f with SMTP id a640c23a62f3a-ac3f210a068mr1317145066b.13.1742830313788;
        Mon, 24 Mar 2025 08:31:53 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8aa1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef86e514sm688103866b.35.2025.03.24.08.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:31:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/5] io_uring: move min_events sanitisation
Date: Mon, 24 Mar 2025 15:32:36 +0000
Message-ID: <254adb289cc04638f25d746a7499260fa89a179e.1742829388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1742829388.git.asml.silence@gmail.com>
References: <cover.1742829388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iopoll and normal waiting already duplicate min_completion truncation,
so move them inside the corresponding routines.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6022a00de95b..4ea684a17d01 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1505,11 +1505,13 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static int io_iopoll_check(struct io_ring_ctx *ctx, long min_events)
+static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 {
 	unsigned int nr_events = 0;
 	unsigned long check_cq;
 
+	min_events = min(min_events, ctx->cq_entries);
+
 	lockdep_assert_held(&ctx->uring_lock);
 
 	if (!io_allowed_run_tw(ctx))
@@ -2537,6 +2539,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	ktime_t start_time;
 	int ret;
 
+	min_events = min_t(int, min_events, ctx->cq_entries);
+
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
 	if (io_local_work_pending(ctx))
@@ -3420,22 +3424,16 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			mutex_lock(&ctx->uring_lock);
 iopoll_locked:
 			ret2 = io_validate_ext_arg(ctx, flags, argp, argsz);
-			if (likely(!ret2)) {
-				min_complete = min(min_complete,
-						   ctx->cq_entries);
+			if (likely(!ret2))
 				ret2 = io_iopoll_check(ctx, min_complete);
-			}
 			mutex_unlock(&ctx->uring_lock);
 		} else {
 			struct ext_arg ext_arg = { .argsz = argsz };
 
 			ret2 = io_get_ext_arg(ctx, flags, argp, &ext_arg);
-			if (likely(!ret2)) {
-				min_complete = min(min_complete,
-						   ctx->cq_entries);
+			if (likely(!ret2))
 				ret2 = io_cqring_wait(ctx, min_complete, flags,
 						      &ext_arg);
-			}
 		}
 
 		if (!ret) {
-- 
2.48.1


