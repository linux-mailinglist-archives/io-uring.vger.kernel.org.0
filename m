Return-Path: <io-uring+bounces-7857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3466AAC437
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6A181C245AD
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB32280A37;
	Tue,  6 May 2025 12:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MgUroDwh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF45A27FB1B
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534597; cv=none; b=KHwQH6hLvh79hU74rlCdq17TpyoJhp/nJrdLvX+T6ybmdGJAnAdkr3ZTvd74rPLKTaxaTxYGYg4TLXYglXh/8HRoL5wwFdlvRWmb8vH+bhEzwxCSIoK6oHy5R+3A3zw0orqvhZbRJ0w0jlTgs6YcPZFDOD+IAgBpuKiOlFzxxLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534597; c=relaxed/simple;
	bh=XNVvRGhoc7Pbqdgut+XnQ6sfzQLHeIGCnW+Qn+j77qA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PThU6baw0EwzxJdFD+d9K0GjmAoDT4r01/6YKlAf5FdMB8ljv4jQv31O0i0YqZZII0zgFYCBf0CxiX+3eT8uUukodOKLZuG0LAGBH1U4RA+Q7a6evfDT2jzfzWRDPcDlkZUdRAZ6DfEF0LoDN2buUXgga45HUH9LBA/vrVU+jVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MgUroDwh; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ace98258d4dso811653366b.2
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 05:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746534594; x=1747139394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LuI1cjawUjd6R5yn5XvgNydDvmOiwI3pcYiCBOO4dFE=;
        b=MgUroDwh+OzD51SaIOhVdKi/sPa56DogZvWPuXP+t5y+o1D635fnT3WEhNp3df/Y8o
         Eg0RgEVqWBCKFtkDWhxTnm2unPvBSyj6vkinIKg5jQ6OH34f7Bbcf+1vnDnjR8r/RRe5
         vb1tOJh3sL268WDSpJWY+VbsWx4GLr58hmp8idSEso4xjHLhtIeF/ibHZUMHdrWcVeS0
         VjLgGxUy4X6ACRtyG+107j9eumCZZdtjkrwAxzXI7rkq81kCOq6Q26GfhFRU7xvHBPt0
         zHwg/7Jc2uJuxEutgsKkkB9EWIBMw89HXWESgRO9YuSXjtxg9V8NhaY+1qfVclnkGkEV
         RV7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746534594; x=1747139394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LuI1cjawUjd6R5yn5XvgNydDvmOiwI3pcYiCBOO4dFE=;
        b=b3xRAsnXHrhReMyaJ7yI5+u9IqlMEbMK7/bqvU4fAfaZK/kOaFzFfdnWjfNddpDQBn
         AjYxJnW2J9WDFkg2yegz4UnpmbVZjDNLZAbkNeN0TZPzjKu4tPE1DMOE7/ChkMMk5cUn
         pBCJI5whHDhkcGKd+mLNA74Rwx1FggrAuugPgnY5pJhO5R2w9+nmHJHClaMHk7r3dtXV
         MLpQMG411i8BwMnUxsTihy3v5ZiS8iom8RQvRSlrU1eRH6TkJWivAwfMwBiZpZECk6NU
         EmXCtHy8jIFNBhalbdbRdwSTewjz0qSOEBdMiQsQgTH56dHLXtMnahPRqBJhZUT3EQWA
         yERg==
X-Gm-Message-State: AOJu0YxRJ32N8OsfjbB1Ikj3R5UIMPI9bqEeRk1wLU5+qF5Gfp3auLFO
	M3qXVBkD4BeDb0Wm2XvP8I+7UT3+F/3GMNeshxtnemdXgfbGbZasj+bfIg==
X-Gm-Gg: ASbGncsss4684Lnkmqgk8rlhJt65YaQn38IsTMWRPSkAObHspmZyeDPyp4MW0K2Xx0h
	wbLQGCR1A9jSw8LTJjjgwoSWJKWSCV7eW+Bznwx9yNY7jdjIkd9Vj7Jwm2jqvQrHtTXgyWXzZz9
	AVBg1riJ+qha+xyhFvbGWNH/Ycmyky7UGF6yO4cjfhNxKb7I8EMdm4rhebLjr4V+OE724kfZIID
	cwfZ32CzlGGyndluXg3GbtwjB22/cIosjdH066fUJJeDBmPBgIiy0gBZY1thESEZTwU2jxOueQp
	S2z+EvAw6d/7TmfYuMC8BUP8
X-Google-Smtp-Source: AGHT+IEL9dlAGrpI+gygDnGYOUTtIg0oKODJoDJHTkuG3L3rb2uWaSl1kQH+0YtebvZmK+8H7DQuFw==
X-Received: by 2002:a17:906:6186:b0:acb:b0f4:bc77 with SMTP id a640c23a62f3a-ad1d46e0043mr258295266b.57.1746534593411;
        Tue, 06 May 2025 05:29:53 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b5bd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891f3c76sm694441566b.83.2025.05.06.05.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 05:29:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: remove io_preinit_req()
Date: Tue,  6 May 2025 13:31:07 +0100
Message-ID: <ba5485dc913f1e275862ce88f5169d4ac4a33836.1746533807.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apart from setting ->ctx, io_preinit_req() zeroes a bunch of fields of a
request, from which only ->file_node is mandatory. Remove the function
and zero the entire request on first allocation. With that, we also need
to initialise ->ctx every time, which might be a good thing for
performance as now we're likely overwriting the entire cache line, and
so it can write combined and avoid RMW.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Putting "Suggested" as there was an old patch doing that.

 io_uring/io_uring.c | 21 ++-------------------
 io_uring/notif.c    |  1 +
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 703251f6f4d8..3d20f3b63443 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -927,22 +927,6 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	io_req_complete_defer(req);
 }
 
-/*
- * Don't initialise the fields below on every allocation, but do that in
- * advance and keep them valid across allocations.
- */
-static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
-{
-	req->ctx = ctx;
-	req->buf_node = NULL;
-	req->file_node = NULL;
-	req->link = NULL;
-	req->async_data = NULL;
-	/* not necessary, but safer to zero */
-	memset(&req->cqe, 0, sizeof(req->cqe));
-	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
-}
-
 /*
  * A request might get retired back into the request caches even before opcode
  * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
@@ -952,7 +936,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
+	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO;
 	void *reqs[IO_REQ_ALLOC_BATCH];
 	int ret;
 
@@ -973,7 +957,6 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	while (ret--) {
 		struct io_kiocb *req = reqs[ret];
 
-		io_preinit_req(req, ctx);
 		io_req_add_to_cache(req, ctx);
 	}
 	return true;
@@ -2049,7 +2032,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	int personality;
 	u8 opcode;
 
-	/* req is partially pre-initialised, see io_preinit_req() */
+	req->ctx = ctx;
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	sqe_flags = READ_ONCE(sqe->flags);
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 7bd92538dccb..9a6f6e92d742 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -112,6 +112,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 
 	if (unlikely(!io_alloc_req(ctx, &notif)))
 		return NULL;
+	notif->ctx = ctx;
 	notif->opcode = IORING_OP_NOP;
 	notif->flags = 0;
 	notif->file = NULL;
-- 
2.48.1


