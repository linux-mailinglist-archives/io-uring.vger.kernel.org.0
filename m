Return-Path: <io-uring+bounces-5203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACBEF9E3E7B
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D575281116
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 15:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE20820C47C;
	Wed,  4 Dec 2024 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATH+asxk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0D120C02C;
	Wed,  4 Dec 2024 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733326770; cv=none; b=Q5s3mI000tUqojBzQ0KqzPhWnoFS81mVKhUztNkRYL99SnEHeXK5XNaL7N6AIDCxDUOqxqQIq0H2uwfYLIq9ATYeyQ0HD8S20xsdEbq4bDTVt2IR5yLfD66XbC5/du6cncngkn93HHAWKw20l1Jc+j4AhK/MrcPRiyrInF0gLt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733326770; c=relaxed/simple;
	bh=1KLvifziJbjh4pRqHKFaVZ0dtAKC1haIZRmPiJO9xZY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=f3/c176S73Gm1HlBz5+Jv+3izR456t4YubIWwxxYE/Ozcz9AWzNYdAtzuQmQR6SgjFjScmZPKMZqL+bIum9DEYOd3dii0pQvxw52Y6Yj23exHcbD21X6COzinmz/bFAMGd5umKlZfdjce8IItwpQDTJdvgksc2638aDurFGN17Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ATH+asxk; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-434aafd68e9so57328965e9.0;
        Wed, 04 Dec 2024 07:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733326764; x=1733931564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aMys5V1UTDgHq7pxYmVg8DrcO/JHKqHwaoAxkhnrpU0=;
        b=ATH+asxkFAdUw4bQkq1Z7ArhuiWnmcxTi4wh0Eq1mb+zIpvW3ZcfU1W/ga6nBJlDw/
         hNsiQRVp3hHklfmbuCRQ6YkWVYVDIJOt5A5X/jzdj4y02RLXPd3LAh3tE8TaaPHhvkSQ
         Vtg/2Ry143dKdoxh8kA0Gl8XfW9vz1PmHudDuIpbIVTGAP+5XUe6g/22vqkz9DeLTHAs
         k9Tu+3By9DxFqSp+4rIZF1EMPVYVAp84G6TegwfxRuBYxMlv5R4dXm+Tvh49kkNDPgKO
         6zDUJfEdr2UvSkAn+z6LelE9SZc3WmUsZ/xu4mNUi1hKRwR9ylFccfD/UCTFjWCtV4t8
         8OCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733326764; x=1733931564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aMys5V1UTDgHq7pxYmVg8DrcO/JHKqHwaoAxkhnrpU0=;
        b=GX9lCm2niZ1bNPyOrbVYSApzAwSXlhhfEJaccyditMqe8Qht4YxiKsGK0LxLeJtWQj
         j3T+mzr8RZBVo10DiWY6RDlWKsNv1DrllQk2fv6o6wQoOZ+ae17kcBBGyq6FdL3X5x96
         NKFTrIGPSAF+pdbn/ZMUuMVCF2CT2UlzUpA48p5iJm6TZL6d6iggohYrLNf6fJWbCFgy
         Qa412AKIqISnwei4BCs8AySSfkgzp8X9OJPENEsb+d9v4TN1T895pVJkkIpXfjKU/0ND
         r9bFP0yuAsfOv5B1g5x8Q5OY73soLnlHYK1mgkb5aexschLs9nQkaZ6Q5g0kKPay5RVQ
         Cq1g==
X-Forwarded-Encrypted: i=1; AJvYcCUcfRVxO2mvcrspbnO11ZyWsudnac2xgnQZsagukw5+mbyI4K2wxWICxeeswS0i0/2ByiaD7ZYnjA==@vger.kernel.org, AJvYcCVeiTe17DkOwAQYXrcusABnUdJ/agTnzadhfLZ/ofZHcVGuF0relMgfXjg0Dos4ekKUp4Lijxfop22A98d1@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwl+ECLCvNfnbvWOoFLdKD0egN0e0fOWfjHm+/AIJnCSIh2Ydx
	y+uEvngQENse56dPBnbEE4rvQkokKh6gqGAaWc2gn6TrZgMBP10SWiLc/lukuH3vkQ==
X-Gm-Gg: ASbGnctsHNw8jxi9wC8bcMevaNr04/I8718rCgyyHMPjrR9EU3o6eg1xalFyH5XXJ5r
	oqLRd3hkp0HQUiycYJlx/Sv+uO/pPW8dYawusNE/E9/7gE9qz5zp7S9qpbLjvs3VXsC2tF9fJNz
	znYrc+U8PyBvri7ERBMxgMyv6zNsigr9bddI0VrwDTB6aNiJOtVkLOh/An4iFr91rIJKllyC2O+
	Y1Q+rmU6UcDsORsWCIYwlULAMCJRL9lZgSUbOBcaKAsgJilQQw=
X-Google-Smtp-Source: AGHT+IFDtt6Y8nH2grDoAeaoEZHxBB0gdeNB563wKehiNeGHaviDfMWxStlrMNFWOalCeJSFG7AR+Q==
X-Received: by 2002:a05:600c:1ca2:b0:434:9e1d:7629 with SMTP id 5b1f17b1804b1-434d0a1dab3mr53925035e9.33.1733326764433;
        Wed, 04 Dec 2024 07:39:24 -0800 (PST)
Received: from localhost ([194.120.133.65])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d52a46e6sm29130355e9.30.2024.12.04.07.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 07:39:24 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring/kbuf: fix unintentional sign extension on shift of reg.bgid
Date: Wed,  4 Dec 2024 15:39:23 +0000
Message-Id: <20241204153923.401674-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Shifting reg.bgid << IORING_OFF_PBUF_SHIFT results in a promotion
from __u16 to a 32 bit signed integer, this is then sign extended
to a 64 bit unsigned long on 64 bit architectures. If reg.bgid is
greater than 0x7fff then this leads to a sign extended result where
all the upper 32 bits of mmap_offset are set to 1. Fix this by
casting reg.bgid to the same type as mmap_offset before performing
the shift.

Fixes: ff4afde8a61f ("io_uring/kbuf: use region api for pbuf rings")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index e91260a6156b..15e5e6ec5968 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -640,7 +640,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 			return -ENOMEM;
 	}
 
-	mmap_offset = reg.bgid << IORING_OFF_PBUF_SHIFT;
+	mmap_offset = (unsigned long)reg.bgid << IORING_OFF_PBUF_SHIFT;
 	ring_size = flex_array_size(br, bufs, reg.ring_entries);
 
 	memset(&rd, 0, sizeof(rd));
-- 
2.39.5


