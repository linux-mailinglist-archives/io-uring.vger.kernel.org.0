Return-Path: <io-uring+bounces-3179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E1BA3976EE7
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43FE51F25FBF
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512021B9B3E;
	Thu, 12 Sep 2024 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="E1wSAWiD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6021E1B9845
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 16:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159227; cv=none; b=BoAWUYxzDDsLUevbvpqiXXjL3VLWbH5UJSGSymxaGEHQbp3XFfWFGM9TkZzlfDSND3TY27OatVDyyIJnNE4oNwuauXQO+wA99qpZAM63v5t/ONh2EV09so0Iye4Lcnry0p6pEmc1hAmWAoVjTwpFuRN7zrWRohzIW1xl4aJB2BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159227; c=relaxed/simple;
	bh=GM5rez7i8AcYityEiDjC4PZI1ccMmlLlITNVJtUHxTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkhBdjhyvkfxb0c2ZaeAQLkQUcyXfGKRPwLJeKy1oOqUi2j42q8IKjmumuI9se6pjJ/JCuc0jzMqe+e8GJxIwuamZAek8asFCvXyKlfD7BvBD653FV+/Us/d0nU790WH5iBaTUYqDYREqcq0MH+4s55bQRpie7VO94bvrGibNuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=E1wSAWiD; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-82aef2c1e5fso48752539f.1
        for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 09:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726159224; x=1726764024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbZg1ed04SkE9PDBN3N3iel9ESiPexbtZx/Ls3JLSeo=;
        b=E1wSAWiD1gSckzywNHUzq9ej0vQlhdXI0OsNP4VPSPQrWsngRt3gskiK4HcZ3tqScj
         FsgPC8w3hoC2HlXapPCfdqCWuYAZvvAX0xxf52KK6vDP7iPDOu/FhVE6nZVsLXscUOow
         WxLdK6iVdXvWS9jUYk2/UHtkJTR+ZI6Rd5rtbQiuRNhRhB2zUwQRoi8eX+eN0I0PAMjb
         Xm2P936iRlDzPw8PE1kKk+QSvKDSB8RgvLfR45+OruD7vxzp3QojYnfCFSklyLjzlC8l
         0YwXoDd+GTYsRhkVz3dMvn6+L5IssyHaX02CK7JoIyry1JfEMXFxfLQRrB1g2uxZuwRX
         i5wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726159224; x=1726764024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbZg1ed04SkE9PDBN3N3iel9ESiPexbtZx/Ls3JLSeo=;
        b=iBTK1+Ts8H6kwJYVUOUrDqpWTrqLt4G4Iy0mrcVQPt72L+dvFnKjqPmtVXt0oo3Hhx
         J+URSf2fYz1u0JvNJDmnnpIiDSy76hEfHUONXu934ggcMxUNbu7zWy4n6kCk7uty1EHN
         W9axeJhKxuyMIE+49hfPtNgyf+tAz3EyZXEWgOhH9hlLNLg3MN+5EeAb6QCt/ZN8IdAn
         zyFZS1TthJ8KP1OPfeSzMUKeUL5SruIxRKWwaE5CIS8rEcwJdyjsbeg5lEeydZR4L4lz
         L04rcVrC5QJpM8C7UkjIpOwbbBlrHEbl63m0BuEQxgzWZwx36LWPKofWNZSjSXKisWvi
         vo7A==
X-Gm-Message-State: AOJu0YyOJgjjmaFrjHzoshgGL8qQXRJBWsJs68pm6oSe5ib+HWkr9KzH
	ClzUVCmL2Y0U/3SuIFMprIOQyaGM+sYJTG7GSrfXNtsXs2VQU7Eu3sgqoSM4ohCmFcgvgSwth2q
	W
X-Google-Smtp-Source: AGHT+IExWIGzrlEC7JBM5SwarLb1xLbFUbbqvX9k9TZqLkIayJUyJOaxjq5KoTl9Gn50qVjEfhd0cw==
X-Received: by 2002:a05:6e02:b28:b0:376:4049:69e5 with SMTP id e9e14a558f8ab-3a08494abffmr34449475ab.23.1726159223949;
        Thu, 12 Sep 2024 09:40:23 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a05901625esm32564985ab.85.2024.09.12.09.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:40:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/rsrc: add reference count to struct io_mapped_ubuf
Date: Thu, 12 Sep 2024 10:38:21 -0600
Message-ID: <20240912164019.634560-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240912164019.634560-1-axboe@kernel.dk>
References: <20240912164019.634560-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently there's a single ring owner of a mapped buffer, and hence the
reference count will always be 1 when it's torn down and freed. However,
in preparation for being able to link io_mapped_ubuf to different spots,
add a reference count to manage the lifetime of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rsrc.c | 3 +++
 io_uring/rsrc.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d42114845fac..28f98de3c304 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -116,6 +116,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 
 	*slot = NULL;
 	if (imu != &dummy_ubuf) {
+		if (!refcount_dec_and_test(&imu->refs))
+			return;
 		for (i = 0; i < imu->nr_bvecs; i++)
 			unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
@@ -990,6 +992,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		imu->folio_shift = data.folio_shift;
 		imu->folio_mask = ~((1UL << data.folio_shift) - 1);
 	}
+	refcount_set(&imu->refs, 1);
 	off = (unsigned long) iov->iov_base & ~imu->folio_mask;
 	*pimu = imu;
 	ret = 0;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 3d0dda3556e6..98a253172c27 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -47,6 +47,7 @@ struct io_mapped_ubuf {
 	unsigned int    folio_shift;
 	unsigned long	acct_pages;
 	unsigned long   folio_mask;
+	refcount_t	refs;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
-- 
2.45.2


