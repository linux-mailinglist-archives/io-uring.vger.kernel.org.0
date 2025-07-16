Return-Path: <io-uring+bounces-8705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A77B07F39
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 23:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8C158623E
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 21:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32F028937D;
	Wed, 16 Jul 2025 21:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M36liJ10"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A7E12C544
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 21:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699777; cv=none; b=SNmivRA3tgeRvqxax4lukgAUQc3X3bSCWh8M6F0NFkGfP5kyRLUJLOatQU0g6N9DKsDFiQhHMZLAGlQB/R2HkpXKVmlRndINCA33KJ0oddecq4b3dVBwqazsMzE6ASAA9Jhsc2KwM457A2QjZrIkU6qI6fZRDiYcpUc75E5KA+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699777; c=relaxed/simple;
	bh=x77tjbpYV+Ley1dPIR/6FMHVIn65I2E5XTV4qLsrNGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nS2b9Rv/YKgKo0hUqeLUNKlxuUkOyc8fOlG7mZ8H4BcdReBqxAKx1Xb/2S0L7lcMlu93CsIGjQXvsBJr6LBEHNgQo0YcgJ4lf/ibol3I5fzN4ySPPGvjMplMT80bsSDNX8XTmlABhuPYigDyMTiIYMF6bUh8KwwT9qOu+XVUYlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M36liJ10; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ae9c2754a00so45803166b.2
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 14:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752699774; x=1753304574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbmhbfe2BfhOOQ3Bv2X7w3hfUG0xVoaSZJ8dkxyVA+U=;
        b=M36liJ102bfVsp7JHKTaogsNv55c+rLStHXIbHX8G2S0JIubDrbUzKTRKY3z7PQb+6
         C6d85giyPo7AS5OWAZs8gP4sibWaToH050FI7AEsXU9hqwzIU4rUBg6MgFb7DpiNfb02
         IZB2RQZBeaevuNPZPxj7EW2OXuvlibtzpYnNGsdSg8Uyn7SKfToTuTps0M6MxGt21rmb
         wC+gCW7mpFIMk6B0BrGdX9x7cqAghCritg2upk/Rwm0+flu6Qthr6VUcJSZfE2+350IG
         RwAo2MBcJqZ36+ytJ/2BXcoSEbb7+6Hfe3K02Z65d+swYjlHGvyHyhyVeQ4AaiH4poPl
         D95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752699774; x=1753304574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbmhbfe2BfhOOQ3Bv2X7w3hfUG0xVoaSZJ8dkxyVA+U=;
        b=P5erp8L33w+DihLw9KrKKoolR6z/ie6ljI18NNfnfX2H/Av06KgECciiiZdvOEB09C
         Jsool2D8D93jYoeqgPifAEFwQ3rm2cnc0W26pbaVLo6Ozinf9r00WO3IbZ7ZFLFkFx0l
         B8hvMUAQ8OBjdeUkchreAR5or2GTrympNbvgr2dSdArUOa8AmTTiKsdVPiksml58UoOd
         Xc/G+duffM9MM7uoOW7Oq9whO7egNKyZRYM8+kckbwaGFw0SKgCx7h7U4NssuKXUHud5
         p5lLetY6Dx9TXBeqpJ4o+GxQhgKEuNlD2aD+ZOaCcs2smJrnwi0BXddiPI2Lt2Ue2FyG
         2z3g==
X-Gm-Message-State: AOJu0YylLSULG3isEEEC7SDjLbJ1TXEAUkp35c+AXuTwALeIKZmVtbfY
	R9xwKgp0T/QJMDMTxXJxY8zN7Eckslm9ntXbp//N1KCgu5nqdceg5jBKF/Fv6A==
X-Gm-Gg: ASbGnctDvkgrfgo+C0HvY/RIlMXNkFR8LoTV53jEPRMXnkWQO/DUFqm5zvgzOL/PAvq
	LbQVCQtWlI7ki/f2OCIAHwk+Bye7w30NAA76t0X0JWp8AEClbzIo2rYo301PiJQUzMbMLkX4TrO
	DYULuzuWByAVEDmN9rxwmeNy2E/QbxVbzdCVUkWvOmEFGH3T6905P1udl0+Cj0zIE9hpf91XEHk
	tP7yp53px6/z3VDKdL/Go7OmEXcwEbjsAKOiGkWjcpZGo6hNa3jP5DuDAycJWDPODyBFIkN9WC4
	sxtPbPtaxoz2+E31rL6+Y6wuITpOtJXvjSzMzNuPHiuG1HY/6qJ36hUK/fmulWJ5bSaypIavF8u
	CAJZk33EzfFwUN8TRLwOBgDcr8TstDmTBEn1SUEhKHc+m
X-Google-Smtp-Source: AGHT+IF+TBu1pE+eJiQl5cPywWwHR7pVCP2FP7a8rKIGdNAgs8bRqOveREqv+ApThmp0oDSmlViV1g==
X-Received: by 2002:a17:906:6894:b0:ad5:d597:561e with SMTP id a640c23a62f3a-aec4fc8b475mr34691166b.56.1752699773617;
        Wed, 16 Jul 2025 14:02:53 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8264fd2sm1254007466b.108.2025.07.16.14.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 14:02:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH 1/2] io_uring: export io_[un]account_mem
Date: Wed, 16 Jul 2025 22:04:08 +0100
Message-ID: <9a61e54bd89289b39570ae02fe620e12487439e4.1752699568.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1752699568.git.asml.silence@gmail.com>
References: <cover.1752699568.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export pinned memory accounting helpers, they'll be used by zcrx
shortly.

Cc: stable@vger.kernel.org
Fixes: cf96310c5f9a0 ("io_uring/zcrx: add io_zcrx_area")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 4 ++--
 io_uring/rsrc.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 043018bc9b9c..f75f5e43fa4a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -55,7 +55,7 @@ int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 	return 0;
 }
 
-static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	if (ctx->user)
 		__io_unaccount_mem(ctx->user, nr_pages);
@@ -64,7 +64,7 @@ static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
 }
 
-static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	int ret;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 25e7e998dcfd..a3ca6ba66596 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -120,6 +120,8 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
+int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
+void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages);
 
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)
-- 
2.49.0


