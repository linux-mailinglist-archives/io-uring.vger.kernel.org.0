Return-Path: <io-uring+bounces-5019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7263E9D783F
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 390E5281B56
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D0A15FD13;
	Sun, 24 Nov 2024 21:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeKJmL/d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF9F15A848
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482739; cv=none; b=W7Yp2kbL7jFaIbs1XT62+371pL/iZdKtcBW2LGhyq7cB1GrYzHnyvvXYb4T/k7G6xnXNvn2P5mUAnREKB64qHgLqHbkaIDMg2iT+Yr9tQ8Gk23JtglS8YMrwOrYapQD4u2B1GphRDS9J8K4G+sHfJOtvsc0ebw0a6iwOonFJRFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482739; c=relaxed/simple;
	bh=eEGFpZJs/btPVtQBKq8PqhPNCWaZDhL6G6EIywe/sxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFi+oM5pkuE56ir0nx/HFEAK+F4GwVwljF1GF6JRST47t4iLxRdQmFXIv3tIHopAVsxlaBn9XriEDmGUzWBbzZc8XEp64EZMSsPkMk+Y5oxuum+P3pceSsO6sm32+KJWAqF/9JCF94aTIsAZ2kiG4UYP0smq3sENRg0Uda4991w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeKJmL/d; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-431ac30d379so35075595e9.1
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482736; x=1733087536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eroRJWDn4SnJNKrnqVa/UqcgSVxmuwFUrHyAThGO38E=;
        b=WeKJmL/dVyWKn0C5q+63AvX/l9LQSRvF4+Fso2AbinUY/7493OlzsslCACs6xtijmC
         SXqRSendRKcxAWAG86sToW1QRiRrkZJFtQewVEq+fwfIr2m62AChv+GoZrHUwqA7PPVU
         8TJUEHjFb0PwvlBh86nx47vx+2m0my32wtV36RfHxBAZDNa8s6Ovsq7VrwTBs0cKjJYM
         W5mhs9EICzN3skCrfpuEmtDm6ozE3/veii8y8LeFQgWBJLfypn1NIHK3snyxwzewUjZB
         I3XzF+2SSDOeLcMow/eFGcCBMy8L+s6bbIm7hLlbcoTKzmqyoi2LKsk4BO2H05kmSCUi
         grCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482736; x=1733087536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eroRJWDn4SnJNKrnqVa/UqcgSVxmuwFUrHyAThGO38E=;
        b=J9w+aUY/E9rjIJFmReRFL2ltpvJ+PwRf5OLsv05IeUybbq19KxhOWzuvdoI/HZSh03
         5RJ3jPHENzdBJGoQZZLdGiDINOwiL1ULqJi3ESmtEHgqpqpyl+1ATyl3T0TmTeHSGNtg
         aJRhGqTBjxnMwqyf9MfBPuCg432tK2bgtwKXSpsdQ9+LkuGV09KnBc4cTEqdGZslu0yO
         b6m85Ygu3pew/HVp8p5kUPQy8+Q+3JWSiNIZtk/hO88LrqaNIGUwD3pgOwxi/LZTdpiF
         QxjOTHuXRSlmSK5WeEQ5hlQBASWYpnJd+iJMGhu1vyBEpPCWnUXhWLhEiQNP2RHHSv7l
         vLTg==
X-Gm-Message-State: AOJu0YzuWGsMpdsIhBKSFyr+N5qjhPXaAVCL2TxtMM7h0WV2qvnMcxq4
	PNgFRDUHES9BzESn2lfUiattvgqVEpJxbgY8y6zvHs6GjvWZKM+35Jx8dQ==
X-Gm-Gg: ASbGnctjdLPKvFIzX4KFCkc/asGNoZN/AT/wKLSGNeqjmYoN+Qs6SJx+X0pZ5NWC5Tq
	tZQ+lfZYfwQOZtPkrDobEKsv5PI/JebC88coqz+x3Xxuf+BuOtKTb/jS3RTQXK79f52VAnG3dP3
	0EShMaPAiocIBTyb6GQBLHNTUgI9g3T7g7LDsHJkOoBsT1rQrmdn9joVQOUF2govowKVUp7d/0z
	+unO0iWePb99yaV/DenO1WnLzvS7/i83a+cmxX7yRCEauXyE3Aj63m9DfKi+ZI=
X-Google-Smtp-Source: AGHT+IHYOiVhCzq0vDGsuMbIG1TuX+3i6zQKrTTycIJ7pp+0ktrZb7TXc+v6WdAIfvcWf93LpiV2bw==
X-Received: by 2002:a05:600c:1f88:b0:42c:b4f2:7c30 with SMTP id 5b1f17b1804b1-433ce49112fmr78676765e9.23.1732482735994;
        Sun, 24 Nov 2024 13:12:15 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 12/18] io_uring: pass ctx to io_register_free_rings
Date: Sun, 24 Nov 2024 21:12:29 +0000
Message-ID: <9656c906a0ab1adb4441250e3c78c017122dad26.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732481694.git.asml.silence@gmail.com>
References: <cover.1732481694.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation patch, pass the context to io_register_free_rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 5b099ec36d00..5e07205fb071 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -375,7 +375,8 @@ struct io_ring_ctx_rings {
 	struct io_rings *rings;
 };
 
-static void io_register_free_rings(struct io_uring_params *p,
+static void io_register_free_rings(struct io_ring_ctx *ctx,
+				   struct io_uring_params *p,
 				   struct io_ring_ctx_rings *r)
 {
 	if (!(p->flags & IORING_SETUP_NO_MMAP)) {
@@ -452,7 +453,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	n.rings->cq_ring_entries = p.cq_entries;
 
 	if (copy_to_user(arg, &p, sizeof(p))) {
-		io_register_free_rings(&p, &n);
+		io_register_free_rings(ctx, &p, &n);
 		return -EFAULT;
 	}
 
@@ -461,7 +462,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	else
 		size = array_size(sizeof(struct io_uring_sqe), p.sq_entries);
 	if (size == SIZE_MAX) {
-		io_register_free_rings(&p, &n);
+		io_register_free_rings(ctx, &p, &n);
 		return -EOVERFLOW;
 	}
 
@@ -472,7 +473,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 					p.sq_off.user_addr,
 					size);
 	if (IS_ERR(ptr)) {
-		io_register_free_rings(&p, &n);
+		io_register_free_rings(ctx, &p, &n);
 		return PTR_ERR(ptr);
 	}
 
@@ -562,7 +563,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 out:
 	spin_unlock(&ctx->completion_lock);
 	mutex_unlock(&ctx->mmap_lock);
-	io_register_free_rings(&p, to_free);
+	io_register_free_rings(ctx, &p, to_free);
 
 	if (ctx->sq_data)
 		io_sq_thread_unpark(ctx->sq_data);
-- 
2.46.0


