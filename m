Return-Path: <io-uring+bounces-6267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD7CA28966
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EE2F3A4E2F
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E8B22A7EF;
	Wed,  5 Feb 2025 11:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ze3tnAA0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB222A4F2
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755412; cv=none; b=SzxxdHbSbU7pagVtcW/Y4FLfF7xQnvpBdt0aszSLlhkagnAVXY36lUQQvFAeCwp95k9hWSTZX1iaaZZy6+HQQ+WYzohrk2ii74tBUlUFoozbRYF71Y+xkGCrV9jbzRYDQYqm9caUrhgp2i2fOhdbLWG/dJUrTTlKQUKFToKZqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755412; c=relaxed/simple;
	bh=R8B2bAOqbdY9BKKM8Zmeep2GB7REgWnCUGhbUhJNYQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tnp4ot0Rm4thj59A0+zilaCLPYllpq/epkF8i3e4tfR8mCadhDZBTtgoc8EbwIXypOr2l2r+ad+H4y+Wl84sxfhy2EcFeLEnmk9nmF6qJ0Abx+Ur4HcR+KJjVd3tFc8JUkSuyo8XDMIWemy8Mx/3DKX0LOE4Aetg3fErlgB5T9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ze3tnAA0; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38db0146117so811533f8f.3
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755409; x=1739360209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KdQMMM+vu69NjwQNUGDxHQUFtinRBBO5UjK5C9xPV8E=;
        b=Ze3tnAA0K00Llx6r7ILGHobBY55jUNF9HefIciZ0SaB7E8TsSXvgkirXNa28QcGaBt
         VL/V910flj/04kXfIbvfcrp3/5FKPF3mJouq0EcNTj8+bKQzSzZMeFLaQF1m7kUUO5Qf
         QXhAml1t/HwbdEjtJILwDOFcWcVhjxgTosGDllOmw/W2tmj7qw/zQ4Zy15ZUxlqotqaZ
         I0rmFCbuNGYCP187ff6nbwlWjkp+UJpsXJ1IOIjP3swwSVSrX8XbzcAQLRqCSrTKJ5qH
         0E6aTBrTELTEyTXyvRLJdnuVTA+KRdf7XYP40uhJAC07YRnN4w8aQ9jx6S+wJkI0kGwP
         s2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755409; x=1739360209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KdQMMM+vu69NjwQNUGDxHQUFtinRBBO5UjK5C9xPV8E=;
        b=bvHg+EH1buSxeZLpXJq/ha0HsdcSw6XCeFY4hbGWEbBYOdmDr+nzqG8QojXi++gZN+
         8HavFgVYYB8UVQAiwddiC5+30WlOG34NHsF2awneUbmikKx1+ShVYsr2D6vKWNOGOHzd
         oX1vQXVeRi7t13Pn3ZdwmotTq0N9XPI4ztpqAb/wQEMraeYez3/rvVntquAq1XtqJ9v3
         HAa+xgUaPbxkTjVP3FMjy7Nf3p+DD9UxXHfnICYOU1W6zrCECo9c7wpPAr0bI890i4LZ
         B8mE0pY9SWIrMNXC8OPfPBzynx0wEU3XqiX97oLWqOnuiNe4LS1dgRzdhz+uQiNYqm2y
         BCZg==
X-Gm-Message-State: AOJu0Yz116BByrwRmx1I3KrI5ZWQKKtrelLm3BK0n4sCNfbbfdGa893Y
	DatgDtxxDjH4nHEEr2p56IPHlLlrhfHioc7VsK5zPQenPti9Ur6n2kPdJQ==
X-Gm-Gg: ASbGnct155pQDc8iSG3tPtBx5vc01uJjgfZPObtwzRCkiG2Jlm9xo5lnImvjyMkCTOP
	VrZWwfOvO7UqnfIbd97Qzucl3+bXcZCblf0gQoMGFHjoR0WE4Dp9e7sPcgIOu/LMZv1xYj4wooP
	ZTzQkf2u7CQsxZXGbRaDsgRs2r7VqdJXdbO/v1tQFMNeD10emdaFGpkm4TSnCSKdC8HJwWNbYWX
	mzs7bOJt2lKVHRT4F1EiKZ3aIJrhp4GApGIM6hXNVxp27VMG6LhWppjEATM6w1S/yZA7G+LLeVp
	qYhNEN6jGgV9HqruazJjAAa7dXg=
X-Google-Smtp-Source: AGHT+IFaSD1ST6tOUeoAkdO+dC3bmWlV/NtvNiZ5zKonnHn6PHHWg8YZ1RkBkpDtS/1ylSSOeq+xQw==
X-Received: by 2002:a5d:64ec:0:b0:38d:adcd:a05e with SMTP id ffacd0b85a97d-38db48fda85mr1723558f8f.39.1738755408357;
        Wed, 05 Feb 2025 03:36:48 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/8] io_uring/kbuf: remove legacy kbuf kmem cache
Date: Wed,  5 Feb 2025 11:36:43 +0000
Message-ID: <8195c207d8524d94e972c0c82de99282289f7f5c.1738724373.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738724373.git.asml.silence@gmail.com>
References: <cover.1738724373.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the kmem cache used by legacy provided buffers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 --
 io_uring/io_uring.h | 1 -
 io_uring/kbuf.c     | 6 ++----
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e34a92c73a5d8..6fa1e88e40fbe 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3927,8 +3927,6 @@ static int __init io_uring_init(void)
 	req_cachep = kmem_cache_create("io_kiocb", sizeof(struct io_kiocb), &kmem_args,
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT |
 				SLAB_TYPESAFE_BY_RCU);
-	io_buf_cachep = KMEM_CACHE(io_buffer,
-					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 
 	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
 	BUG_ON(!iou_wq);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ab619e63ef39c..85bc8f76ca190 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -418,7 +418,6 @@ static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
 }
 
 extern struct kmem_cache *req_cachep;
-extern struct kmem_cache *io_buf_cachep;
 
 static inline struct io_kiocb *io_extract_req(struct io_ring_ctx *ctx)
 {
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 0bed40f6fe3a5..ea9fb3c124e56 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -20,8 +20,6 @@
 /* BIDs are addressed by a 16-bit field in a CQE */
 #define MAX_BIDS_PER_BGID (1 << 16)
 
-struct kmem_cache *io_buf_cachep;
-
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -411,7 +409,7 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 
 	list_for_each_safe(item, tmp, &ctx->io_buffers_cache) {
 		buf = list_entry(item, struct io_buffer, list);
-		kmem_cache_free(io_buf_cachep, buf);
+		kfree(buf);
 	}
 }
 
@@ -514,7 +512,7 @@ static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
 		spin_unlock(&ctx->completion_lock);
 	}
 
-	buf = kmem_cache_alloc(io_buf_cachep, GFP_KERNEL);
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
 	if (!buf)
 		return -ENOMEM;
 	list_add_tail(&buf->list, &ctx->io_buffers_cache);
-- 
2.47.1


