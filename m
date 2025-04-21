Return-Path: <io-uring+bounces-7591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBB1A94D11
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 09:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E341116DCCD
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 07:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8645F20D517;
	Mon, 21 Apr 2025 07:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXd2Rs+h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C201C1C5D7A
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 07:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745220269; cv=none; b=AqqxwzucWeDUjs6Hcb2JtCqwUwY66D5nGF5yrgKpCLa6fWm+gcdt6KgJT1pM4mGe0DO+bIw1USOFgnucjmNDud9++XOtL5/1l34Ct1N0ucjFYqLUVCV1Nq+41lnxII3JM5nXzW7tv8Lo0m76AxnBhXHjZPyr6yf25IFMYva3zfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745220269; c=relaxed/simple;
	bh=WO6QnIje4Bkhg/ph5RHwPZEZZoN/RcLOJwPdynjmRfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TM1yPTssgCzFPEWgvOGDy/xjCKNPeXI+L9xJt9Vyh79UiqwggvuEFxMYkrHNba7IgLF7R7/GRL59pcHejzYseAhmfHCrN8bqlHH6/W+M4+kPsx41JC1IR3PpF+jRjK/WEXstt/K4XCtVQobgy4ala+0I2OS1GjXRzEp2bCz4TF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LXd2Rs+h; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5f6222c6c4cso4770999a12.1
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 00:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745220265; x=1745825065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IwD0uxpX6LTgbRYJjV9x5ESmm7Cc1Zf1afCIKJf586U=;
        b=LXd2Rs+h9RPQu9Aw9s1xDHlSKWraifHmqwoIVItgyd6MgmRkYbiSgY02/ooPxVfFi6
         HJPeL+gpomfYWin4bQJ5gmcdcGe/mvjJaczJMX0K6r6yhxLMXVnEubtn7y9NpEOKphcD
         aH8f74hAA4YKjbzAVqzVd7xBGX/YP3fooxrrUmJnFgAxLGQMhEj8NWJbInAhHHZujiri
         bGsmF0K6fLM4lz8n+BZCHmePgVxmFeRO8N3HKY3wNk8CZWYnQyNL4gHkMBYKbfxb57Iz
         g1ciySPKr1ej9m9SEC23Mleo2qks1hqzmGZ3FPsOKzhKVo8SdeW0z/lZazXcOxix3I6u
         tZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745220265; x=1745825065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IwD0uxpX6LTgbRYJjV9x5ESmm7Cc1Zf1afCIKJf586U=;
        b=ltsfppcJFcDROCbUR/p82rx75ss4IC9lf3pG1s+R9mL9MUG7Pkb6KVJCd7Xa+bd627
         MsVTiDGrkzhaV1DjnZ5EyI/UbvhYw8G7hTaokYIRFpEjAy5+3okrMBB1CVOcuvf0nuo0
         CzE21hYgnYHXtxAcJN6CVatgSmu+kyUPGtfT5aEcFe4R8E9hC4cOIRj8fiphWEDDl8on
         QpKMpPgXMkWOFf/SkHnvMS2oGJpcJUMgUSdxbP2ygl876ZTR+uSLR8l8brwgY8sjZ+g7
         ljxnKZlNnDOXBrTBWFEjoQJzJtvFpQify/Yqj8Nx87IJsxsp0oT62K1JaQ0DipFdsssJ
         dkLQ==
X-Gm-Message-State: AOJu0YxVn8be0GMEDVaVu1fSUvGhe0N7SLLFzgg3bYHO5AKbTIk3JVDh
	RN7nFYghOkZfUr5SW6Onklddtz193UsDl87BqKWX+qHWtgWvPf0gCIupAg==
X-Gm-Gg: ASbGncuk+5AsEKtda8AUAGTPltrmD0RYk8OzdT+CGTKjlQMlhiHIRhiYM/PzfxE825p
	mhR1lsohQKvFHCoFGvd6L76R851cn+R0ERychiXkCufl52hNdtsR1zrCE5WiYjLqt0o4vwXVZkg
	yXgbky2RomKmEN3pU/9jVxSoQeVg4twF98rlbhMD4IT2aNaewJkloIN+O/EoJv/1GwivKsr4zsH
	pzflgBVKGMrFq70Xdn/aTSzRIIXIlnIYp4yhXJ7rURqZb64hPuH3xbvV3fFikFHug3e5JM8P3y4
	iNWqZDpcl/rL6PT+EhHfM9wGeuBGynfbRhsSOcgCKUV+hg/6UZ9RFd4pbp9Voijh
X-Google-Smtp-Source: AGHT+IFRhPSoE2lZJRY93sbWOa1+c/832+h4zg34zs2xtg3B785RZPHEa5DFDXU6ll6shooz81K4Aw==
X-Received: by 2002:a05:6402:3586:b0:5ed:44e7:dcf with SMTP id 4fb4d7f45d1cf-5f6285ed202mr9090307a12.24.1745220265297;
        Mon, 21 Apr 2025 00:24:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625a5ec5bsm4175562a12.81.2025.04.21.00.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 00:24:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing v2 1/4] examples/zcrx: consolidate add_recvzc variants
Date: Mon, 21 Apr 2025 08:25:29 +0100
Message-ID: <321d834fffb337204ade9e693c97f3730747362b.1745220124.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745220124.git.asml.silence@gmail.com>
References: <cover.1745220124.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass len to add_recvzc, 0 means it's unlimited, and kill the oneshot
variant.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 32d9e4ae..727943c4 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -140,17 +140,7 @@ static void add_accept(struct io_uring *ring, int sockfd)
 	sqe->user_data = 1;
 }
 
-static void add_recvzc(struct io_uring *ring, int sockfd)
-{
-	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
-
-	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, 0, 0);
-	sqe->ioprio |= IORING_RECV_MULTISHOT;
-	sqe->zcrx_ifq_idx = zcrx_id;
-	sqe->user_data = 2;
-}
-
-static void add_recvzc_oneshot(struct io_uring *ring, int sockfd, size_t len)
+static void add_recvzc(struct io_uring *ring, int sockfd, size_t len)
 {
 	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
 
@@ -168,10 +158,7 @@ static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 		t_error(1, 0, "Unexpected second connection");
 
 	connfd = cqe->res;
-	if (cfg_oneshot)
-		add_recvzc_oneshot(ring, connfd, page_size);
-	else
-		add_recvzc(ring, connfd);
+	add_recvzc(ring, connfd, cfg_oneshot ? page_size : 0);
 }
 
 static void verify_data(char *data, size_t size, unsigned long seq)
@@ -207,11 +194,11 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 
 	if (cfg_oneshot) {
 		if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs) {
-			add_recvzc_oneshot(ring, connfd, page_size);
+			add_recvzc(ring, connfd, page_size);
 			cfg_oneshot_recvs--;
 		}
 	} else if (!(cqe->flags & IORING_CQE_F_MORE)) {
-		add_recvzc(ring, connfd);
+		add_recvzc(ring, connfd, 0);
 	}
 
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
-- 
2.48.1


