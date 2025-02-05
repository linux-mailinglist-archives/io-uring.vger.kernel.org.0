Return-Path: <io-uring+bounces-6269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D541CA28960
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61E1F1634FB
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6656F22B5B6;
	Wed,  5 Feb 2025 11:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWeioakO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0122A4F2
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755415; cv=none; b=CUYQUg12ZiaYVwfIb2f9nymrTG0i/2wlK5Vazh3bjmt8pc4l6NWN3/jdC6H8zlM8j59U8sCmNpEiDPboPp40ANjMfp9ApmZVel/v4O9HxUcqE2DKNVGKN3Q+FGlXPbZT86OE1eP4VXHQu97Eibez1ipjTwRFQ072z3CmcGgva9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755415; c=relaxed/simple;
	bh=G3CfUWxMfny6vrqzl01oo0Ss+bMdT1rg/x0pNzSy+4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXjz7zBNbEZ1ol6HUUXpT7uORgzfmPpEdO0NMDe55V1a2H6ahvi0u7+C7eXzAEjFhQHjogl259+Y3L2YKLX2SXMILKOhHCQvv4vhHQxVA1+w6sLQ1TzJ8XKKHsBkLi0pnL8OU9rrvEZpDXHsaOkhJkwBflB5oNA/mqS0ofCFcZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWeioakO; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43634b570c1so47120535e9.0
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755411; x=1739360211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7fmmYIE47lfgA6A2mQ8rveu6ZE5mZQb5KMBp3G7/DaM=;
        b=cWeioakOPwru4ZvhLzzc9Rs8Wd+IjYTWJeFFsJ+sZJhbfjFf2s8E8sE7tHAt59kCPv
         TtVr6Tj8P6TazHtEjY5KJVvGLoxyU2s2UUORdL2pN+pBBj3OD02jKr1ZjUz2peTCFWHc
         a5TP/GJIrfB589SMWqpkctxIN5NRFSJ+XsrP2VtfZNDwQLdTe7CpekI1QD8QI1TGgNmr
         3kgq19kxUu5eK+iP0Jo/bp+shreeDY2i4U3/Get60MZ53yygW9Pvguax4x6UD0+WF9Y/
         tUUx1tgjMc7bxoAEOnLHvZUtkPMs5r8htHe2SnFCt8USJCkIMPfg3hckqpCPGPfoCcQp
         1ZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755411; x=1739360211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7fmmYIE47lfgA6A2mQ8rveu6ZE5mZQb5KMBp3G7/DaM=;
        b=QJz8icjPRiL7HdAnrNc79fgw5Jl5+B6MiP1F4lSJlUFH6MbS4ymFLpK7iOvxrCl6cY
         XzG/Aftr4HkW6RbonIY1b+t7IAjsSYEtWmKrm7Jyl5+9PjxD/WVEQzzq1lAV/bz8txxp
         zYIsNFiOHyRE5pdJOszFl9pwPSeSQe5c1EoI20qqXIhHAlqUpetfrAqVlHTMed4nlV0H
         ssnC0xCX317HNN/4fKp+BxmrGjm6N/EgnTSxC2zxARarCCUXZFlJjkCtLKPu2UAHtEQb
         fLTaJL0C+DN/6Ec/Um2tAU3HF9AlDD+SVCqbDrly8Ln6X0hOBIYcgSS9zqcXCnpYMZ6I
         cv5Q==
X-Gm-Message-State: AOJu0Yy3fa7Opk3Qe6yPOe0yMb8OsM+jpy19u8R5BhTeI3fhjVRUYoZd
	NAbax7QDeUWdv2Ia4lQo+KnmNpG8huvTX4btitDcsN9g2LijEy6KlpraTw==
X-Gm-Gg: ASbGncvZh4wgU+7A0OTQhMWQy4SjYRSTy3Wx0jqBhJQqwv4XH0k1/r2FyPFIm4ct3WD
	eaZuu+9VxZAuwyp+5x/+duGBdddtzoGTwdTbHamQOg2aVVt5T9FxCYLpjztMMsJpLLQK9rVntk8
	ZvLXBe9I03AyAe/cbhWZ/ehMCPEYJf6+1tlbJUhHODuTS/if/I50gzYEO+wIy8XumgCsYjHhP4P
	+wjZ8dwEQgGe7dSD8xZaFVj3JYNsD/RnyPoQh9iDUvJRPErpfvffF4htFp0Qz1MmcEpeIZv99+Q
	sTeoITD1sdsQhXifm7gWqTRonFc=
X-Google-Smtp-Source: AGHT+IG2kEeBu8e+cE188/NyEcsK3Rgf2Y5opRrd8AmvCdk5Hev/SPeq9F2UUZTPkUqkHpkBRhEToA==
X-Received: by 2002:a05:600c:3508:b0:434:fb65:ebbb with SMTP id 5b1f17b1804b1-4390d43da6fmr18080345e9.17.1738755411205;
        Wed, 05 Feb 2025 03:36:51 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:50 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/8] io_uring/kbuf: simplify __io_put_kbuf
Date: Wed,  5 Feb 2025 11:36:45 +0000
Message-ID: <1b7f1394ec4afc7f96b35a61f5992e27c49fd067.1738724373.git.asml.silence@gmail.com>
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

As a preparation step remove an optimisation from __io_put_kbuf() trying
to use the locked cache. With that __io_put_kbuf_list() is only used
with ->io_buffers_comp, and we remove the explicit list argument.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 26 +++-----------------------
 io_uring/kbuf.h |  7 +++----
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index ea9fb3c124e56..eae6cf502b57f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -70,29 +70,9 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 
 void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags)
 {
-	/*
-	 * We can add this buffer back to two lists:
-	 *
-	 * 1) The io_buffers_cache list. This one is protected by the
-	 *    ctx->uring_lock. If we already hold this lock, add back to this
-	 *    list as we can grab it from issue as well.
-	 * 2) The io_buffers_comp list. This one is protected by the
-	 *    ctx->completion_lock.
-	 *
-	 * We migrate buffers from the comp_list to the issue cache list
-	 * when we need one.
-	 */
-	if (issue_flags & IO_URING_F_UNLOCKED) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		spin_lock(&ctx->completion_lock);
-		__io_put_kbuf_list(req, len, &ctx->io_buffers_comp);
-		spin_unlock(&ctx->completion_lock);
-	} else {
-		lockdep_assert_held(&req->ctx->uring_lock);
-
-		__io_put_kbuf_list(req, len, &req->ctx->io_buffers_cache);
-	}
+	spin_lock(&req->ctx->completion_lock);
+	__io_put_kbuf_list(req, len);
+	spin_unlock(&req->ctx->completion_lock);
 }
 
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 310f94a0727a6..1f28770648298 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -160,14 +160,13 @@ static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
 	return ret;
 }
 
-static inline void __io_put_kbuf_list(struct io_kiocb *req, int len,
-				      struct list_head *list)
+static inline void __io_put_kbuf_list(struct io_kiocb *req, int len)
 {
 	if (req->flags & REQ_F_BUFFER_RING) {
 		__io_put_kbuf_ring(req, len, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
-		list_add(&req->kbuf->list, list);
+		list_add(&req->kbuf->list, &req->ctx->io_buffers_comp);
 		req->flags &= ~REQ_F_BUFFER_SELECTED;
 	}
 }
@@ -179,7 +178,7 @@ static inline void io_kbuf_drop(struct io_kiocb *req)
 
 	spin_lock(&req->ctx->completion_lock);
 	/* len == 0 is fine here, non-ring will always drop all of it */
-	__io_put_kbuf_list(req, 0, &req->ctx->io_buffers_comp);
+	__io_put_kbuf_list(req, 0);
 	spin_unlock(&req->ctx->completion_lock);
 }
 
-- 
2.47.1


