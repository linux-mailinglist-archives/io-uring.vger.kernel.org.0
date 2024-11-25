Return-Path: <io-uring+bounces-5043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54DE49D8EF4
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 00:21:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19E06287753
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 23:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E076F06D;
	Mon, 25 Nov 2024 23:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m58gjlYb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63EF1CD2C
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 23:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732576903; cv=none; b=hM7V1b38h+SHuKwB/kc1tu47CkpOcNIaF8UTtysYHmZZMVY0q9jiPB+UCYSzO1UvrKQDrkM3BUElRGbYl1xPRf9Q/ED5w4Eprh/8cqCte4gPd/8xNiffihpsuwOv73LYczkHvYfLbqN5gzc0clHuhshwZrKZapcx0bWqwLLHTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732576903; c=relaxed/simple;
	bh=LlehX+sKKwpN5AiYslZYCX3LITx7EPjbw+gj409tqlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dax/9cv+GvrchGbth2IQ4o+AGBh4Gt2cTeIih3wWYQtonvx2rRnxHcXD790s+2S/3kCpdqAsZZYRR6HM4FKM1gI7b05n+frkxyDKCb/27GUwdsik8lSk3LT15BHEelR7521FGg15/M7rsS2qB3jx49v0tzQ+kItzMe7C7gYtAF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m58gjlYb; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434a0fd9778so10788715e9.0
        for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 15:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732576900; x=1733181700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t6zKtbDg5aDv0y2ynEkpJv8d/5nTEuVOpl72XRvTdjc=;
        b=m58gjlYbCRb9S5XY8MjDHaViFKJREY3MjuNHDJGC8dxHSdzv9Z6uOpdiF/NtSkyt0G
         fKSHoQyL6Gam6vZQBJoBHuNnbKR9tleNgB3Khpg8hETFNCC/rnQI/e0j6k3dvKJ1sknh
         7WvVLeHvRYmvsQJwUU1qVsAnbCZolLrkBAevN5UZME/g7kIVeDQjuMIWm6Te9mDTsXnI
         aT7PioV8L+BZ5mkI8QCe1/UJLiwPNuqgYPea8xFYgztVxuGAe40ykkkXnsjWTrv7sltj
         dXpo2lhUwauxOQq3fQ4M0h2wfBZcHhQqiMXdASpEcKNqsLMnv0w0bjb1wKV8wjwGTs8f
         4vjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732576900; x=1733181700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t6zKtbDg5aDv0y2ynEkpJv8d/5nTEuVOpl72XRvTdjc=;
        b=fACGXu5YETfr2BcFW+EZ9JWjO+ew5pIwzqhdE1HyVidxN18wRSjH8nq4v2T0Njfupb
         7yrD8CH737ClGgGpedFfs0nn5ywqMHPPVjxuUGVqANfKfl72u6S335GYVNrs08tWTI3Y
         Uc4kkIJ9y0scfYP/WMXrbCnLwPd5IcU2MRPk6EmNaOP9UhObVN8a+iasDpXRbZ1jaWtO
         YivFw47V5O+b6sNDgrVU2PJhJCDX7CnePVYcWEP0hg4ZfOP4KuArJB6TXhYzlH+ZoXS8
         wNaxsTufFYhTC8jJpp2e8kLzcnMZk91xI50Iggo4JoJnw08wALGv9zwmjmPq6uQ27Pz0
         dSkg==
X-Gm-Message-State: AOJu0YxsYiz5EyYKPyxys8N5LfWzeJs1w62LJJooYl1nFesvksMVL325
	QXmwdycvPipMd6DSYsc6L/OHSi7Sva+N1dfZU3HPFn0bDL9U5xutAzGq+Q==
X-Gm-Gg: ASbGnctJQTt4SbRNvhJJaaVgrQbbCK9c50VWhoEYuaxUMtoX1V4R3VqTds76EOvOTqv
	nTXCcBjbccAzNA5LuChFFk1O1PokbVLlC+L3M//g2CGreSQF7aUqsggffO6QL2KAbGTrTVHmVBc
	tG+Nbyk4KDXHg2nETnh46dfbT4SwBIv8l0z3k7r0c2UMRHcbNgGu+dhPtUKYDtSoH3ZRa8eW444
	hiH3yAI6W+00tnVh2/Qt3A+8R2Q+4WxqFkG8gvAw36C+2e35HJ0FmXzB4uIpw==
X-Google-Smtp-Source: AGHT+IGP4ViUKeOn3Sb2DuyULav5eqyFzx6xEf8XmLj4uPnK+tekropFQlEGOQ920wwroaie4FyAJA==
X-Received: by 2002:a05:600c:4507:b0:42c:b5f1:44ff with SMTP id 5b1f17b1804b1-433ce48f8c5mr128883745e9.24.1732576899710;
        Mon, 25 Nov 2024 15:21:39 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.233.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-433b01e115asm213900185e9.6.2024.11.25.15.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 15:21:39 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: sanitise nr_pages for SQ/CQ
Date: Mon, 25 Nov 2024 23:22:24 +0000
Message-ID: <9788f6363f9a7fc100f8f9fb7a1a6e11e014cd30.1732576266.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WARNING: CPU: 0 PID: 5834 at io_uring/memmap.c:144 io_pin_pages+0x149/0x180 io_uring/memmap.c:144
CPU: 0 UID: 0 PID: 5834 Comm: syz-executor825 Not tainted 6.12.0-next-20241118-syzkaller #0
Call Trace:
 <TASK>
 __io_uaddr_map+0xfb/0x2d0 io_uring/memmap.c:183
 io_rings_map io_uring/io_uring.c:2611 [inline]
 io_allocate_scq_urings+0x1c0/0x650 io_uring/io_uring.c:3470
 io_uring_create+0x5b5/0xc00 io_uring/io_uring.c:3692
 io_uring_setup io_uring/io_uring.c:3781 [inline]
 ...
 </TASK>

Apparently there is a way to request a large enough CQ/SQ so that the
number of pages used doesn't fit into int. Even worse, then it's
truncated further to ushort. Limit them to the type size for now, but
it needs a better follow up.

Cc: stable@vger.kernel.org
Reported-by: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bfa93888f862..82d217cfdebc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3482,7 +3482,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 
 	size = rings_size(ctx->flags, p->sq_entries, p->cq_entries,
 			  &sq_array_offset);
-	if (size == SIZE_MAX)
+	if (size == SIZE_MAX || (PAGE_ALIGN(size) >> PAGE_SHIFT) > USHRT_MAX)
 		return -EOVERFLOW;
 
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
@@ -3505,7 +3505,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		size = array_size(2 * sizeof(struct io_uring_sqe), p->sq_entries);
 	else
 		size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
-	if (size == SIZE_MAX) {
+	if (size == SIZE_MAX || (PAGE_ALIGN(size) >> PAGE_SHIFT) > USHRT_MAX) {
 		io_rings_free(ctx);
 		return -EOVERFLOW;
 	}
-- 
2.47.1


