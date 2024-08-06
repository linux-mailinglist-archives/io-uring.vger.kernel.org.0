Return-Path: <io-uring+bounces-2660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EFF949717
	for <lists+io-uring@lfdr.de>; Tue,  6 Aug 2024 19:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B50561C209FD
	for <lists+io-uring@lfdr.de>; Tue,  6 Aug 2024 17:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE3846444;
	Tue,  6 Aug 2024 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BbmBjwyx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCE12A1C5
	for <io-uring@vger.kernel.org>; Tue,  6 Aug 2024 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722966578; cv=none; b=EoCoD86WpxcRT7mwbmO+NXF04d7U3cIDCyTh9ChEKnZGpSmvXO3c/EF9qYQKLFc2ISZD6FpPHEzMtEFG2NwhUzRXjBjrFfWXDq2ka3AIqq/VSzYXvVo7ix9N8dPozWbHH7gC2c6+d6ovx3BYPVE+0XeHUVtjBxghUnflEopPDP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722966578; c=relaxed/simple;
	bh=b+OYpCJYzdsKLx+xRUrn4Ae8k0h3waFilEH/87838zQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=PN7hlIS60jSEmt6BUQnTBupk2wW892lsLWovK10WKshFgjYjhZ+wg58QyAU1GNSVBg+n4ukDVOn3+Uy7o/g1QxkRXU5FPqRqEEsy5Ru50eC1dXHr3+j1TuDknwjXslFNYxixuv4WV4oxfvd+H427rxlGY0hvWaFtXUXnBCQW3Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BbmBjwyx; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2cdba658093so227681a91.1
        for <io-uring@vger.kernel.org>; Tue, 06 Aug 2024 10:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722966573; x=1723571373; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ka5wPBf5hAs117sDIFXIP/0JgnmbjnHdzqu+ri8uRT4=;
        b=BbmBjwyxALawq9IqrqX8SZLEIK0Q0A/xPK0QCG+Q1Lw9n88Vb85kpDuNQpN1Z3g6Mh
         hiYJryz5RL1Ted9XzU9CSUcNtAq4b4U2fJH5T90BEsfa7q1lADsj0Wx98BhJFDH3WO95
         3PD+QUoJE918xpMW9VxfPTNbSNBjZMxd00qlKzvmBwKNmlEdRLaUFLY5l4ceTAJtU785
         Lhoflhx7uiLBNEg45reZqK5ed5tmas8JL2Em9kIfhc3w2RQWVnjFhIVC/SQmyIVuLxRu
         kQm3uhxurhzQJdHADQ30hcEyIGTGWzvKWme5nLOwlZlTUp+qmJQ8gjN/vrJLzQpUNBYV
         /XBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722966573; x=1723571373;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ka5wPBf5hAs117sDIFXIP/0JgnmbjnHdzqu+ri8uRT4=;
        b=w679OtDatk78uyxukWJnoGxSHQ4MWyzUCygutjP33OgoaGZo6xj1ImbiZ7NTFfZ125
         h1akZ8Bu05j93orPvSLN4m2ybiphF8pPZ2HN5jCRXOpfk41pAbJdZZKGvFgd/Pin5KAO
         mGcQjjeMgazutCdr6GfcRGIAu3+1jqYD32tgHeoRWAxOun9jZgvY/oUiEaav74hbSQV/
         XsiypOCt5W/SBipBinc67yKUCgWk85DlZ9lCdUTl2MVhlHO4dVO0pbiphpciZqrgBWCP
         rl/MVA4r80buKKrm2BV6RidkcFOhyuIFUOGIXIQKTRWfF9r+ApEtQvahAf9F4FZS5yAo
         5zVw==
X-Gm-Message-State: AOJu0YxIf6N8pDmg/FYR0ZA0/vU6S32AQvH52v8GqW/An+qJHcgx5kkZ
	g9BfSYIOlVAU+7TiLYnItNb1K/FMqqV7q5AzUo3T+ncugkCCI5q/x+RUiRo+sn9JC2+jLUerZ98
	v
X-Google-Smtp-Source: AGHT+IGoerw1UoRqRlGuM+LC1jWZz0/ihWlr5ckxsP7bR7L9V2Q+c6iDLs9+Qb1C4+B/gpu5LmLVqw==
X-Received: by 2002:a17:90a:630b:b0:2cd:8fcd:8474 with SMTP id 98e67ed59e1d1-2cff9599f55mr11024104a91.5.1722966572904;
        Tue, 06 Aug 2024 10:49:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cffb38d3fcsm9390988a91.50.2024.08.06.10.49.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 10:49:32 -0700 (PDT)
Message-ID: <5fa6fc2f-b39f-4327-a195-61997d36b0e8@kernel.dk>
Date: Tue, 6 Aug 2024 11:49:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: allow opportunistic initial bundle recv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For bundles, the initial recv operation is always just a single buffer,
as we don't yet know how much data is available in the socket. However,
this can lead to a somewhat imbalanced string of receives, where the
first recv gets a single buffer and the second gets a bunch.

Allow the initial peek operation to get up to 4 buffers, taking
advantage of the fact that there may be more data available, rather
than just doing a single buffer. This has been shown to work well across
a variety of recv workloads, as it's still cheap enough to do, while
ensuring that we do get to amortize the cost of traversing the network
stack and socket operations.

Link: https://github.com/axboe/liburing/issues/1197
Fixes: 2f9c9515bdfd ("io_uring/net: support bundles for recv")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c95dc1736dd9..2c052996c9bf 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -209,6 +209,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	int nr_iovs = arg->nr_iovs;
 	__u16 nr_avail, tail, head;
 	struct io_uring_buf *buf;
+	int needed = 0;
 
 	tail = smp_load_acquire(&br->tail);
 	head = bl->head;
@@ -218,19 +219,22 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);
 	if (arg->max_len) {
-		int needed;
-
 		needed = (arg->max_len + buf->len - 1) / buf->len;
 		needed = min(needed, PEEK_MAX_IMPORT);
-		if (nr_avail > needed)
-			nr_avail = needed;
+	} else if (arg->max_vecs) {
+		needed = arg->max_vecs;
 	}
 
+	if (nr_avail > needed)
+		nr_avail = needed;
+
 	/*
-	 * only alloc a bigger array if we know we have data to map, eg not
-	 * a speculative peek operation.
+	 * Alloc a bigger array if we know we have data to map, or if a
+	 * a speculative peek operation tries to map more than what is
+	 * available.
 	 */
-	if (arg->mode & KBUF_MODE_EXPAND && nr_avail > nr_iovs && arg->max_len) {
+	if (arg->mode & KBUF_MODE_EXPAND && nr_avail > nr_iovs &&
+	    (arg->max_len || arg->max_vecs)) {
 		iov = kmalloc_array(nr_avail, sizeof(struct iovec), GFP_KERNEL);
 		if (unlikely(!iov))
 			return -ENOMEM;
@@ -238,7 +242,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 			kfree(arg->iovs);
 		arg->iovs = iov;
 		nr_iovs = nr_avail;
-	} else if (nr_avail < nr_iovs) {
+	} else if (nr_iovs > nr_avail) {
 		nr_iovs = nr_avail;
 	}
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b90aca3a57fa..8248ffda3a43 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -53,7 +53,8 @@ struct buf_sel_arg {
 	size_t out_len;
 	size_t max_len;
 	int nr_iovs;
-	int mode;
+	unsigned short mode;
+	unsigned short max_vecs;
 };
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
diff --git a/io_uring/net.c b/io_uring/net.c
index 594490a1389b..48667f3a2388 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1076,8 +1076,14 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
+		/*
+		 * Use the passed back residual if we have it, if not allow
+		 * peeking of up to 4 buffers.
+		 */
 		if (kmsg->msg.msg_inq > 0)
 			arg.max_len = min_not_zero(sr->len, kmsg->msg.msg_inq);
+		else
+			arg.max_vecs = 4;
 
 		ret = io_buffers_peek(req, &arg);
 		if (unlikely(ret < 0))

-- 
Jens Axboe


