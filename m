Return-Path: <io-uring+bounces-5042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 342199D8EE9
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 00:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED283289B45
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 23:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15863188015;
	Mon, 25 Nov 2024 23:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f/H5UwOn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499F11CDA2E
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732576207; cv=none; b=YK2/BqQGlAwoEagyNXzJ/+0+oNGeX/qEgsvVHpVXLggUf2dd0ddqZ1rt7DL293C5mQh74DDPXUthXHdrqvkzo8nPmH9bNDnV5lg8TLp5o0JI02/1G5pQvNACg9S+O+H0v654sIGAxgl5sPlj9l/h85fJ2CT4F2aqej2b0BcLFT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732576207; c=relaxed/simple;
	bh=FGIsZv5Pa1il/jASYIolh/sm1f7YUuYdp3IUOqjUNwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PQX5C3ruouP7Xt60wInjUn6o70OFH/gHPgYZX4kzBa6vifwznz7ofnFTrWUrnPPEkzcMQiPMQvfX7X7WH6HEMvd2vaYASem5VxxMegZCGwUpRqpWyEq65fPpteouhd+vgKHHZu/zOtGzld5rXF1hLbJOW8Ep6Snt6tX+oEvcCsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f/H5UwOn; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43169902057so44093395e9.0
        for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 15:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732576203; x=1733181003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XNOsfWU9vSUYaAJTd4Alu6y4kAdrqaWu6zZBUyllz48=;
        b=f/H5UwOnoli99/+ZYoZVnNsWO74VnZgefRphMWlY32iUr0kVUFdjgrisPGyxrts/I8
         RWZvoEEYtxk6qxUvkoU6TZHup7gk+58iAKLGO4FSkfG0Glk49dbSfzzJcTIDBjOowB2w
         xCdSiuAqps9BLuEUccmkj80y6U1PkGgBliMtDkGEBjrxOddTQyQxiaY+o1hNB7vyiSkP
         Q/X/+tmoTmL4ePEpwq9JEEa0SjIAnZXt9ikQQVZ+USUnh+vtPuCMLMLmjqbU1BEAutIB
         UCNb7GB97kozemIq2/mf4SYv2hrtNaBgOSriv7JBiMttyDYFXcIw+8nYx3Ek/uDO02BM
         M49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732576203; x=1733181003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XNOsfWU9vSUYaAJTd4Alu6y4kAdrqaWu6zZBUyllz48=;
        b=DJ8em42SjD7gH3Irb37qguWuWH7d1RY/8I/S2l2fIVwgUy6YSrbdal0fMPRE+sAKCj
         zT+U0b8yJs8QrBLp+roFPWPyApI3/xtkILkdgZzuWjZMCe6ly/wvY1gH5ojuzceu+F2m
         5sAOCPi/AwJMGY4MthETVXVXi54GFaGTN+QhZlPx+8Wxn36FyKBGJTKyBzpS1jaTJ9OM
         Vy1YhHxrkfhfwBg6Q26oFFyZ0rAT67fyBXfKFNOTfUpzkRrCHCzoe81FIY7Ph2yF3m96
         ns/2ENd0N6KH0zDTLhBIEOuDCv/ZfMLfFpJNLW4lvBgTT9GMFrp2HmG7fscRIkRysDH0
         r30Q==
X-Gm-Message-State: AOJu0Yw2o3v5OR+ewMhqaiTsDzulM3nSZgIoEIfdZTWzpJ80Ts8Y4DOQ
	dLPbpW8R7FTa8vqK5JUJ0MxraubnL14UwOL0hsnNFQbOYU0/ntyCx1HTjw==
X-Gm-Gg: ASbGncvBMIIF506PTi669tEkIyiDnrULTZ+HZ4YL+Uzi8pNsBKYhBf6k6VNEmECEakN
	rFnhss6cbSWaqXsROCfVzDmmAtYJMtdOW14bQTorF7+gb7Sj5WTq/b90X2ftNZyoHZK7I3XA9+E
	lP8f9msIR+Z/wBiRXhG2JBV6Ig6Af1d+g4y7iNscUq7OFu2L7rGmf+Ibdrvvks1Nv2SzVROssD3
	msX3twHgtAbXfwnryp2qnIJ32Tfk9jl/DXNFAir8W7bgutpfygcD90A7wpUSQ==
X-Google-Smtp-Source: AGHT+IGiUiWrKK+Fx1PM3k7yJhj0+LrUdEX2t2ukGeaFoIAhGpLnSo3SdPRL+Lu97KfRl+BXacm2Xg==
X-Received: by 2002:a05:6000:4901:b0:382:32ec:f5b4 with SMTP id ffacd0b85a97d-38260bd07eamr14010666f8f.47.1732576203253;
        Mon, 25 Nov 2024 15:10:03 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.233.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbe901esm11801920f8f.87.2024.11.25.15.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 15:10:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix corner case forgetting to vunmap
Date: Mon, 25 Nov 2024 23:10:31 +0000
Message-ID: <477e75a3907a2fe83249e49c0a92cd480b2c60e0.1732569842.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_pages_unmap() is a bit tricky in trying to figure whether the pages
were previously vmap'ed or not. In particular If there is juts one page
it belives there is no need to vunmap. Paired io_pages_map(), however,
could've failed io_mem_alloc_compound() and attempted to
io_mem_alloc_single(), which does vmap, and that leads to unpaired vmap.

The solution is to fail if io_mem_alloc_compound() can't allocate a
single page. That's the easiest way to deal with it, and those two
functions are getting removed soon, so no need to overcomplicate it.

Cc: stable@vger.kernel.org
Fixes: 3ab1db3c6039e ("io_uring: get rid of remap_pfn_range() for mapping rings/sqes")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 3d71756bc598..2b6be273e893 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -73,6 +73,8 @@ void *io_pages_map(struct page ***out_pages, unsigned short *npages,
 	ret = io_mem_alloc_compound(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret))
 		goto done;
+	if (nr_pages == 1)
+		goto fail;
 
 	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret)) {
@@ -81,7 +83,7 @@ void *io_pages_map(struct page ***out_pages, unsigned short *npages,
 		*npages = nr_pages;
 		return ret;
 	}
-
+fail:
 	kvfree(pages);
 	*out_pages = NULL;
 	*npages = 0;
-- 
2.47.1


