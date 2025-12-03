Return-Path: <io-uring+bounces-10919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CC3C9D6F2
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A39C3A0520
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605EB262FE7;
	Wed,  3 Dec 2025 00:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="He/rCLN9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE60B25EFAE
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722232; cv=none; b=ELe6YcJ5CHq4NvViRN58luvAYEZU52rI5cFFbQmjX5JU46rPOPjnLZNX0kL50Z8y5bQNuQy9aoJJ67ZKHu/tDh9rMOQw2RnO2EvYql7ykz3nSWoo5zsVrwgqvOD8YeR7cz3Low3m4jOw4cs8BZ9ndAseB/nxG56iwf3+5hd36bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722232; c=relaxed/simple;
	bh=E5B0edRrY+rm+1DIa+XmbtI1NMD+Chl2Nxqtsdgl1S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDfCDDkum+/bz2uwlKK3IRsNsvXcvi/5bbyfymiwGAA/qYkCBDjyUxCAzf5g/cmYFhq2z9U3gLAfiSWttimo2vvtcLfc648i/1RfeBs4lA3GFj/LaXW+A6Ip1NGtW+ypQuNb0epktR2NNKSjeFxghq3ZQgufs6Z99Seb8IFp5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=He/rCLN9; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b9387df58cso9734969b3a.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722230; x=1765327030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dZgW5EX2VAyyFKLlIA9JTCACFZjum/fhM4OL5/3muE=;
        b=He/rCLN9zjPYuCU2cx/141KP89fQVwW3bt9Bbn37gJW4Uyy2DtcSMYjlVSfEsB22pD
         xB2jcT55PnDREiEu/XkHFlPoFzyCKwIzi0lN15EWPVVmXj4lbKONIxAMs7ZnhhCBLiah
         gjpQZ3kIuVUPfdhxW4eIrTuwknA/0s2rvX0nL1Ovh3L1dY/Nv13s9gOVCZ4SyqKG+2We
         ad17X1+5sGOK9dxJ60aakRzX07b9PaHwHAR1eSBivqeowwtMpV+DYsgTk4lvvBZuCssS
         UJdAmxLkj7p9XYSbFcpPpYGtHDUG79HnuG+iMg7qiAZfwXJOwcT6QhKAAt3pRkFmSP++
         JQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722230; x=1765327030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3dZgW5EX2VAyyFKLlIA9JTCACFZjum/fhM4OL5/3muE=;
        b=GUvQKQqN76vMh31uEkk2oRCH8Ejqrkvc57lT26h/FL5RhJc6qCEJjH+1d/3Js69LTt
         QP+StO/mcVA213dGDW/TEV7adlkRuUhRvylmFbCCysh0IB0YVwCsg6ixKIDsA6UgZAqW
         VDCT2tF9+WwKXrbQwhRBvH1jHthl3KZQBqnPpkHX04/dVIbdzbjv25oz1u9MLXdo26RH
         YGdJGjCZRiYCbrWXN28Nr2uqtugjIoblKbosKumhhFjHE4bXpdJS6rclR8/bSxWDsMLj
         M0Qqgyw5AJaI96AqP2axqSLeTRG2QYDqmKj5fylBNGFg3n451We23Mi764emwijbFBbQ
         zumQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyP3MnwQB5e4C4nH5ww3ZaX5Ir+N61BZFiW81m8A5+iYueJ6aNZOcrxLQ0sVPaee1Hbm0/pM0T0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvTmx6sfEy8QZxoTyFrlxZvJOIc4kD3gbhtWvUEkuXpI6P1ilr
	vCinnT1NLNH1aWf1yCdrTM1AmgNRfiH51Z7hqUGRbjD2ByxSOoLFZh/N
X-Gm-Gg: ASbGncsioySXiiNx7fpPITlWi7QUUC25ZEUejDIGUxkOowOCpYmZ/1O1wyCSTniJtIe
	6ds3jYSL1Wq/wjfvX+Qir484+7QgI6iBFthj+6AZ3DNbFAMIv4XbKHWpAyScRMW3ZZZ4seUpAJ7
	j0YrrL+UQLTkFF/OhYXIK1/Kij/r497PEfwBZpRONWPrHKE7DTfYmeuRWYnQfCva2vsAoMLr63J
	8Zmnmh38kE7RBgJ2Z435PqbN77RCczGBcwn9gazMuIWHvxXWgi8STn3xjXcNkptorbUEVCaLHMh
	Hbx8RSvo3IMaWg5QKCydycIxbfIRyAuhMuYVc9Ei/TQLZw2BkFwbZsst0M5P5MmA2/XnM85CLh6
	3UkgjetYR4dyVTnz7ZRhxC5H12Fmsdu+uiOyOP0baq9FKqVS+5P0gcEJvIqb6msTss8l3dRhVy7
	rsGKdDGg/ETA6GQwCs
X-Google-Smtp-Source: AGHT+IFCE6HwROTSAgOg2+fwbRR8GMpBJxaEWeg20IU9c2K4wfOl8Q/ADtks+5Lp0Z1FXdVB0Ug0lw==
X-Received: by 2002:a05:6a00:194f:b0:7ac:edc4:fb92 with SMTP id d2e1a72fcca58-7e00ad77826mr464841b3a.11.1764722230051;
        Tue, 02 Dec 2025 16:37:10 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6cdcsm18222307b3a.20.2025.12.02.16.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:09 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 24/30] io_uring/rsrc: Allow buffer release callback to be optional
Date: Tue,  2 Dec 2025 16:35:19 -0800
Message-ID: <20251203003526.2889477-25-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a preparatory patch for supporting kernel-populated buffers in
fuse io-uring, which does not need a release callback.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/rsrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 18abba6f6b86..a5605c35d857 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -149,7 +149,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
-	imu->release(imu->priv);
+	if (imu->release)
+		imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
 
-- 
2.47.3


