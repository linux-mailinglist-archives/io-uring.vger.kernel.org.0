Return-Path: <io-uring+bounces-2613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C99394219E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02D86B22DC7
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 20:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A9418A6C8;
	Tue, 30 Jul 2024 20:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gx/kbh4u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C0718CC1F
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 20:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371367; cv=none; b=i7/FvORK8ldm+R+1/qgu+8Q+EE0Pxnq4pu0m6n+NivCrNqF5Ogynt6i/Qc8AcVuTjdI7eIuDK9wuMAsIMdbuZ6MNARz8SD10Berg4vt+8b92XSxVoh1WItFLiUSiaVaPwY8Gey9Y6d5kfWOVpib540tjg5Opbn/bw5nhFIgoT0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371367; c=relaxed/simple;
	bh=yMnMp6sYGz4/6Z7wV25uL/n2ygpp95FpW6CIeQqXrF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHQ28em/yOn9ZnrSCbQTaLA4Srzcgc47Uv6wHw47IgYPwX9ilmaiqJs+RdeZ3jDPGCLwY3PAURA5KJy0U/c+sJTD0zKzMgQlshki9kk6SzCKSxMnEGtx2G+tFHMeApI6AkY9WufErQuzBLaE5w9lZz2BaJESqRUgNbc8axpRn4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gx/kbh4u; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42808071810so31122055e9.1
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 13:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722371363; x=1722976163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aCDFSYLRz664AJ+uUNg7sg3G8Ma7AxzpoUVwna2Z1b0=;
        b=Gx/kbh4uNzrDgx1w4dQkdHjkOB76F2NtwtWaqBJMJms5sEVj9iGFMUp3joXjziUeK4
         fFoLYUc/k9J8CTpHEMeVAPrk3DVsnLCOcZvymngeXUJ0u+pkJUMiss69rxmtflOb/Ce2
         SeiF0VimHtxa74aFdJ6KmnHL/jN10c81Grp39G6ZygyVcfZRfsuAW1+4zvG/EYhk95x9
         EXgjxKpCUW8CxO7dfeIDS1xmtZDWEsmyJxxrHjsohfIyYFtQQX7HXbQb2LnBdCl+7y2H
         fge3QS+bUY3Xkgk18YglMAsDU1kI/aeHW/JNabyRopxeRMXvKGVNcUZciDM11A5OCMLp
         NAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722371363; x=1722976163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aCDFSYLRz664AJ+uUNg7sg3G8Ma7AxzpoUVwna2Z1b0=;
        b=wsXKwSbDOSddvTlcNTSMMC89qTJmcWJk8so4Gz4QJxlw+e5HjvUCsfN+JaFxqLckXN
         DLprsJPYZnk1ILgGGQeQ2kxYzVstIDQTIHzbuFb04CzWAp0A7f0VE6R//oZjqMJEebeu
         JiUeCp9XNKkUB4c49V4Gks+2Gl7cztV7UEjqCtXt0NsbMnuDSSJlRhYAqs4fpTTGfF7L
         z/HxQ5Y9CkY+Syj7GOtFhDc24G4LeL3QOUClL5gZTzkof2Tq368zeQ08wwMM6Y7JtsQg
         rD9DpsY9sBFX7XUp7Nla8+gCsuakPnoZqhY2Mdm4BIcfMsOK7WQiCsCia4ECShZe/y3d
         6Y5A==
X-Gm-Message-State: AOJu0YxQ8+Zm/Ubx4qlwyDz32YIKP0LwML7YL2KEbrjRbPoqvVQSmCdb
	L/x+vIWYkYHtf6oChbjxDsKHV7NgRGwAt1rBQPWxKNSAGKNHYWJ/LwPYgg==
X-Google-Smtp-Source: AGHT+IHUhBZQXAYok0Vt9EZ5vQ0hNJz0JyYRgiOvPbcYkfYDFTgOXVIVEWdXKVzRDZkpspENfdjmqw==
X-Received: by 2002:a05:600c:6c4c:b0:426:5f06:5462 with SMTP id 5b1f17b1804b1-42811e422e4mr71058665e9.37.1722371362714;
        Tue, 30 Jul 2024 13:29:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42808457c7fsm214488065e9.32.2024.07.30.13.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 13:29:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Lewis Baker <lewissbaker@gmail.com>
Subject: [PATCH 1/3] io_uring/napi: refactor __io_napi_busy_loop()
Date: Tue, 30 Jul 2024 21:29:42 +0100
Message-ID: <b4296a2b49770886cb759d7ae267f0e2f5e2f55c.1722357468.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1722357468.git.asml.silence@gmail.com>
References: <cover.1722357468.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

we don't need to set ->napi_prefer_busy_poll if we're not going to poll,
do the checks first and all polling preparation after.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/napi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 4fd6bb331e1e..a670f49e30ef 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -301,10 +301,11 @@ void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iow
  */
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 {
-	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
+	if ((ctx->flags & IORING_SETUP_SQPOLL) || !ctx->napi_enabled)
+		return;
 
-	if (!(ctx->flags & IORING_SETUP_SQPOLL) && ctx->napi_enabled)
-		io_napi_blocking_busy_loop(ctx, iowq);
+	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
+	io_napi_blocking_busy_loop(ctx, iowq);
 }
 
 /*
-- 
2.45.2


