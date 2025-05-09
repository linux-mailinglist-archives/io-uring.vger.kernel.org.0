Return-Path: <io-uring+bounces-7929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B29BFAB11EB
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C73DA1B620E1
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9385428FA94;
	Fri,  9 May 2025 11:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ccdUOzK+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C1828F942
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789115; cv=none; b=mBqoKW8pFEjuKcKWIWwwqFlOkw4JFkFENCNPE69P9quZ4lkgTA/Dfk1jpr8YhRH4fyg0TKTWzopuCZpkLLygv1d7TSIj7YhbNeFWgjLEX1+x1B4Mk4+w01SJKxQkTuCMm0qG1eVn2vPfPp/so6hjIEFvboPn8LATsMtjXdIzz1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789115; c=relaxed/simple;
	bh=KuX0BWYg0cE2lOcVxD4T4H9BRBsLxIg5U+yyHy0z3Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaW5CZYZg+atWjlrlDreLm1SdWMMXsgAVvcQe2BbbA6estq+Vuvp0bWpn+nXVmA0DcP4+GPmmcrpmFpH2S8xvEFwJHmV734NjwOiU/rC9Ye9DrvkFbJi8itXnadnVBSnP+SBrT1NdSnJcnOtKmHBeBvwEKW+8J8yvhy0wqjS+8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ccdUOzK+; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5fc8c68dc9fso3495361a12.1
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789112; x=1747393912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6dgPT5YN3VVq2sktM2NfEuZzX+C/FbQrHzkw6wCKwg=;
        b=ccdUOzK+nCeZ4707zLlpFsPGtI2GJz5R+7lo4juPlALQTSpS865eMea7SveAmtnQMV
         KZR7TjGaVrsp6pvDIUQ2gR1z60A5QYVbVjZCbx1hJ/f68k6eiQpUHquUCnfHmdSoHLn2
         wPC2AIbcKubQjAKZvmAj3Qe8x2icvNXrJ0GZM2AUSpjYPd8SXrcB+zOcUJ9xtX79eVm6
         1QbMD2iGE4C/1+OkVRsX/xpZ8Zi/o1vptoQmZ/df6ADRdM6sTZsQz2aPopOzyjJhxCFY
         oR/qtfEJNaaGBTUpWXsFO+40NzqfKCvhguod0Aj1a08wDSxd+xiBcUeBjrtWYibNln9M
         iCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789112; x=1747393912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6dgPT5YN3VVq2sktM2NfEuZzX+C/FbQrHzkw6wCKwg=;
        b=LRkInG8CRidHqiOrZGYB0wgL1+p0+jTwpMQxqQqFGJKz6chfQboOIsBBJO5fCJgOo3
         MCy5G0MHLanV9N8E/CBC8CeMXzrOpSIYCgC0cqZHFVFqZehTG4NW8ZbyVOLMYO7IdJ0G
         S0j5nNOfuJEnLM8LhNy0schqNAbDTKQ7Sx2fLYMcxYMz69XNWo1aAjUDFz3hclWtMdvm
         vwDzZv3DUu333A5HCmAfl6g/sg3C9SMcnvN5bmtKAvnXATs329SkauxpoxDj4vmMxJKI
         sfYa6S2jcR63RA3gEwUEfgkvxQWIScz7DElitvhp2zO3klCSgtLCHRMEHwX2XLAtUfzp
         Ckww==
X-Gm-Message-State: AOJu0YzRraU3yBuPWp7y5dC075MKVgleXkbg/B9or+WTtMP2gNU5zak5
	DnJEndf3TIwLbVy2Ze7Zyb6ZW/aGeYgGVTM9iMigic6UBqDOaXUj9i77MQ==
X-Gm-Gg: ASbGncvTIwMXS6pQdT9Hd+01ivR09/gUcqbrkiiBRirdTV4zaJ+PhfECaWvrl+O3BXe
	NS0o5BvejHMs9P4EIgzWzTk0e1om2/YeoN9SdTY1fMfkWqPZuwySQs6AGDw5DRxWmMGMgjHo/or
	5pTaJIJylDhwe7lO3cr7GCQyTWkue87LGuVwD5LHQKfZd8wM/vJA4W/3KRnULQpvCyTjTyruQbb
	8PCfhivVU8P/JZbUlcDAfbka4jcynGtlbNY3Ums49Hy0XKAdU6tvabb/VjeYpcJKrfinKrO2oIS
	hcu8dVeYSBVvoUs2YxCADGyN
X-Google-Smtp-Source: AGHT+IGforXTUq/Hgb3i7qoofqbkxyaL1gYOg+d+Xb0v+zkGyuJwC+MQWLhirry4+y0n4yxObiNfrw==
X-Received: by 2002:a17:907:a0d3:b0:aca:d66d:cd0d with SMTP id a640c23a62f3a-ad218f89715mr301629066b.30.1746789111541;
        Fri, 09 May 2025 04:11:51 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 6/8] io_uring: open code io_account_cq_overflow()
Date: Fri,  9 May 2025 12:12:52 +0100
Message-ID: <e4333fa0d371f519e52a71148ebdffed4b8d3aa9.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_account_cq_overflow() doesn't help explaining what's going on in
there, and it'll become even smaller with following patches, so open
code it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0afae33e05e6..9619c46bd25e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -381,14 +381,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
-static void io_account_cq_overflow(struct io_ring_ctx *ctx)
-{
-	struct io_rings *r = ctx->rings;
-
-	WRITE_ONCE(r->cq_overflow, READ_ONCE(r->cq_overflow) + 1);
-	ctx->cq_extra--;
-}
-
 static void io_clean_op(struct io_kiocb *req)
 {
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECTED))
@@ -742,12 +734,15 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	ocqe = kmalloc(ocq_size, GFP_ATOMIC | __GFP_ACCOUNT);
 	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
 	if (!ocqe) {
+		struct io_rings *r = ctx->rings;
+
 		/*
 		 * If we're in ring overflow flush mode, or in task cancel mode,
 		 * or cannot allocate an overflow entry, then we need to drop it
 		 * on the floor.
 		 */
-		io_account_cq_overflow(ctx);
+		WRITE_ONCE(r->cq_overflow, READ_ONCE(r->cq_overflow) + 1);
+		ctx->cq_extra--;
 		set_bit(IO_CHECK_CQ_DROPPED_BIT, &ctx->check_cq);
 		return false;
 	}
-- 
2.49.0


