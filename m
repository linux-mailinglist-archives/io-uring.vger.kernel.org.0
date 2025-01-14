Return-Path: <io-uring+bounces-5859-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F91A10EFC
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 19:04:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD6373AC85E
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 18:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AEC2135BD;
	Tue, 14 Jan 2025 17:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XEUYQjpx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3A320CCD9
	for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736877571; cv=none; b=W3Gd5wsSfpkrIkuCrpYddCp7ruEVwVnZgXWT2W0cjmJQqPqsikcmH+wB5ct1wBo92NHIsLpNgDFn36eh39kh0RYgVjU9AZoNv2QMVct5EssjUNLLxWH8bGi9bNQgS/MJOWoKyTD7LhQRPpPmAN3VjU+QUycqnD7frT/MBuc3zUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736877571; c=relaxed/simple;
	bh=uFhOkTsmsK6MYq9Hm804YiBis5X8oUeDp6VYyvxXRSk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=jVABKYcqpq15N1VLguHJ5hMCvU9dOrcfQigxp0Y9TFbnmfSkZH9/K4GzpY8gf4GpJ+UKoU0V3ezvkPYUNohFxKW1v1xY7o5KMl1PJJ3G8Zp+tZQRWZRhd4JoEH8H2uYHpcFQFyrNDjr5FUCtF076p5W5pWplpgc+R6WXFEHcB4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XEUYQjpx; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-84cdb6fba9bso464540739f.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 09:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736877568; x=1737482368; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybYHHKzvlXeuyMxw9p0R4MX0glUCn/c4Je7SQiCEjJY=;
        b=XEUYQjpxEZbXoqfX+XPYZ/3G0uh7uVznyd20lXztcJTPhjgiZBYOtDlxZ2CaD8u9fc
         Nrr/3WL266l6nhX0II1albcS9EzQKrLvhI1tCGgU1pHif43l2l6C5r2t/mGdWhBvNzUe
         MGHENGn2qY+W/c1O3ftSG1O3Zppj1+Tng0nJ7+epgzXv16cfq+2kIhBVI14JURhWjlc3
         DvWdg1cAfFIrntM0mOLSDBqS/a1GtV3A3JNwHpVL1XxpqtDcXHJCVB4JCRwmx7TN3rXa
         svr2WrrQ67l+xDeEmkI3bJV6STQ6JwX01Y4na8Qkw09YmPVpXD1KXF5PZmLNTiwLge9p
         GmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736877568; x=1737482368;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ybYHHKzvlXeuyMxw9p0R4MX0glUCn/c4Je7SQiCEjJY=;
        b=dc5QHRtUj93VzUyXCqQl93k+VhsMraxk4nMmZ6pO0UwrJlcWFy69ig1RXKM1tjtLQB
         vAJ4BtL/Yn1CmqzSkP/LEUkin3QNb5/dSVeYK7qk+eZY2RBECy7GmVpjhMWoWo7ZImDS
         k2qW7fpdnmrZNwknmdAKn9eCXZL8dGp7TmXugUOF63BZlnwFJ62NaaVU7xhfE/9RsVSf
         z8SizAu3j1DwCnEDS2JWa828QHmy+SKVwncjaiQsZZTDehdFdl04ErzRq6dNHvMS81A6
         X93C2MQmrL1a2Uo4CEqNvfYoRqOSgJpdOnYWqJdXxanHk/We72efgaNAzQITpyK4PrIb
         jIKg==
X-Gm-Message-State: AOJu0YwkcCyea8c2Ha/C091D2aDoM53znvAvL0YvkDz2hiZGdWqtPxhQ
	Iqy7W/+8DW+lwH0eBvsxWTbzhEISveXkrS45AEvuI+hwlYupGktU5UNm9BGZg+AQKq+N1ccSynt
	V
X-Gm-Gg: ASbGncs4J2i3drTNPOIm4vMhkI/x8X7WG3wtrNP+UcR0pFqXfjyo8N9jKe/NQyDgL8/
	xvQ6/m2yFLIJtZpThR1CIh5OqYpx1A4qTZRQpWgthRE2gESAadPBfpIY2EK37XUopxrHh5F3Oq4
	+i0KsEOYgG3yWb5EUgWs603xGEUzkfoMOHmfRDJWxOeqOd+OJoRFg3gAdTD8SeL17RjU1Dh2viT
	17t3KxNVq4Q2vXMGpbmbiCbMdSHpwoj8X7BgHer/3BgNtHIIDgS
X-Google-Smtp-Source: AGHT+IEweEtQ6hApvXZtUeGi3B4GqOWyHavvMsfy6580EQT+328FvWnFwtcm8mOd1nGDfVkqVfjFfA==
X-Received: by 2002:a05:6602:4c06:b0:83a:9488:154c with SMTP id ca18e2360f4ac-84ce003d275mr2579970139f.3.1736877568338;
        Tue, 14 Jan 2025 09:59:28 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84d61fa419asm352469639f.35.2025.01.14.09.59.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 09:59:27 -0800 (PST)
Message-ID: <bd8c86d8-3423-40ae-a9b8-f1478fbf0426@kernel.dk>
Date: Tue, 14 Jan 2025 10:59:27 -0700
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
Subject: [PATCH] io_uring/rsrc: fixup io_clone_buffers() error handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Jann reports he can trigger a UAF if the target ring unregisters
buffers before the clone operation is fully done. And additionally
also an issue related to node allocation failures. Both of those
stemp from the fact that the cleanup logic puts the buffers manually,
rather than just relying on io_rsrc_data_free() doing it. Hence kill
the manual cleanup code and just let io_rsrc_data_free() handle it,
it'll put the nodes appropriately.

Reported-by: Jann Horn <jannh@google.com>
Fixes: 3597f2786b68 ("io_uring/rsrc: unify file and buffer resource tables")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This only impacts 6.13-rc, not a released kernel.

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 077f84684c18..69937d0c94f9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -997,7 +997,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				ret = -ENOMEM;
-				goto out_put_free;
+				goto out_unlock;
 			}
 
 			refcount_inc(&src_node->buf->refs);
@@ -1033,14 +1033,6 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	mutex_lock(&src_ctx->uring_lock);
 	/* someone raced setting up buffers, dump ours */
 	ret = -EBUSY;
-out_put_free:
-	i = data.nr;
-	while (i--) {
-		if (data.nodes[i]) {
-			io_buffer_unmap(src_ctx, data.nodes[i]);
-			kfree(data.nodes[i]);
-		}
-	}
 out_unlock:
 	io_rsrc_data_free(ctx, &data);
 	mutex_unlock(&src_ctx->uring_lock);

-- 
Jens Axboe


