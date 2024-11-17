Return-Path: <io-uring+bounces-4766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8A69D01BF
	for <lists+io-uring@lfdr.de>; Sun, 17 Nov 2024 01:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46EE81F220C0
	for <lists+io-uring@lfdr.de>; Sun, 17 Nov 2024 00:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C859815C0;
	Sun, 17 Nov 2024 00:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUd5apyj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF0F1392
	for <io-uring@vger.kernel.org>; Sun, 17 Nov 2024 00:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731803872; cv=none; b=bgNFfzmXBeXgxtrQHAp3ToxlQn4pJ1e/Xfe3nVkt0JmGruYBlKelJc6aBfR9wv5K+6kIzZsKhhruaGVAqqCYva1y7rLMyZrQmvosnv4PPYuYHHo24w6mHPzSlwEx4Big4tNSzhnETjrjSDHfUYOmhQh5KuLZdjFidSQqvuHup0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731803872; c=relaxed/simple;
	bh=iPi25ceYuNphYyBlYLk6fTpKrQhqwPDwMdJtx/6m8mY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=meKZrOmMgDVr+N8Y8N6Cvzoho94HqzA3dThGxBka651pf6fn3/BIygZtYBR3DVXrH1U/DuwJsIpnIjau1qHnFKSZoX+UTj34utSzJaM82iV8rdsu3Ft7iT9hpRW8oCXvJILV9WmvYA+oHpM0MqEeRnFgYrUVl2lhKG4IMbbOwVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUd5apyj; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-432d9bb168cso17439255e9.1
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 16:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731803869; x=1732408669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zUCJEu02rz4dMeAxFHnrYgG7cpw80Nf1L5ti5qJjdWs=;
        b=LUd5apyjI7/X9kPmeWpuXkTum0kEVgk2qojmdDmpBVmyGx5YFEg/UBR43fBjNh/r5o
         PLmRqR23gTOVMSrUdv+Pf/RhkEHQfJHFQA9Hzq6uJhP85fBUob908zubn8454NLcG45u
         ia8jTdJlWXKXxu//HI6gEWMQqHOYO691TCV4Neha8xabcNg0cITl/Ib7WGKlf90JhK/b
         Jq2aeTh8zFfos1kIJATF7dVcXGNQwcs70Yg3AHoX1nTGiOgLlAZOFcdtY242VaBZNaid
         X5Vjmm0W5qCgPqy4w/6iC0c1w6XwjCQtgXt5mPbF6HpIk97HZ8U7LU9h/MpeAgkJKP6n
         paMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731803869; x=1732408669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zUCJEu02rz4dMeAxFHnrYgG7cpw80Nf1L5ti5qJjdWs=;
        b=kfnreSCgGXII+iCFijLBITNqSu0IZ5LRg47aNqSOjpX0htbnY47hk17odoO9a77y8A
         ae7qgdbp0tK/uUsIyPuv4XXOrawyLQYujuzYqv9F91ZX2kAdin+GAsavSg+PB6RU/TXU
         okuqJS1dFKwU5cM3TWJg8TAAR+lNZ66Q5YYVoxKfcMhYH1VLGgt++Ls2omNZU5Hmv2ey
         +0pILvU95Oy7GGsm1qyclJe8E+BWdMcCaYjLvwYMa5uSGotIO+RZkUOzgxDZOTpQfjoP
         /T501x3OnQchxmrN1S7mPQaVCgBstCWUS7+0m5iQqO3v0TUaTS2z1Qwnqmq9EQiE3aPG
         6LXA==
X-Gm-Message-State: AOJu0Yy0YaeOlt+/ZeSZ/d4PonvU6EKz/Cwr4iBRgI8xx++57IvHo0hI
	k2jpOyAd9Itkl99J7uPFPrejM6t8P/X4cI3vczL8sM6OcEya1X4yP2RT3w==
X-Google-Smtp-Source: AGHT+IH227RiVg/po1OGW2ABjUxSDuuAuV+EblHvstj2TNgWH1a007qJqYpB7jRiiCj5fxJBlCS+1A==
X-Received: by 2002:a05:600c:4685:b0:431:47e7:9f45 with SMTP id 5b1f17b1804b1-432d9762455mr107438145e9.11.1731803868642;
        Sat, 16 Nov 2024 16:37:48 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dab7220asm102457365e9.6.2024.11.16.16.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 16:37:48 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/region: fix error codes after failed vmap
Date: Sun, 17 Nov 2024 00:38:33 +0000
Message-ID: <0abac19dbf81c061cffaa9534a2471ed5460ad3e.1731803848.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_create_region() jumps after a vmap failure without setting the return
code, it could be 0 or just uninitialised.

Fixes: dfbbfbf191878 ("io_uring: introduce concept of memory regions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index bbd9569a0120..6e6ee79ba94f 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -247,8 +247,10 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	}
 
 	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	if (!vptr)
+	if (!vptr) {
+		ret = -ENOMEM;
 		goto out_free;
+	}
 
 	mr->pages = pages;
 	mr->vmap_ptr = vptr;
-- 
2.46.0


