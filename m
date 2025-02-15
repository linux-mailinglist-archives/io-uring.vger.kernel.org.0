Return-Path: <io-uring+bounces-6469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3368BA36BFB
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 05:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E092316E4FA
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 04:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA52215A842;
	Sat, 15 Feb 2025 04:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="OCNK46sS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536D6C8E0
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 04:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739593140; cv=none; b=nlZB6wSuNuOzsbiF0ZocvG1YlFjEt42aozBS+fw/Ry4HhQgBaZXHYeZBM+a4SlDhZVNkgvLN+vKE+yYZbPfCt9RcRGm7AIQN5f/l09BS3zJwUHr1D/9R0/cSp28PU2xBv3CiuBT7W/g4bAJUZLSjZDAd79BoEKfxFgaLjseUb/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739593140; c=relaxed/simple;
	bh=tNEsZSgD0HVQRjgvLNb10k2vnMTYe96KGSjRv7eNC4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mBbEImSv9p551VK/044gaFUkpWIvKDlTx3KLJP8/PJg6+jYUjb2bWGDoDht6sfhVCbsOXV4/djQz2S+lGIPEITj3jaeceD/dUKDSaOFdn5xK96swR5kfUBAKZQW3HsL27F43movEcZ2x4VIswkJEqFVl+H0tu81rAc4D6JLj0E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=OCNK46sS; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22101839807so16165905ad.3
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 20:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739593138; x=1740197938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GcrA3CRMbq0KMurkjqgP9oXSHnqx6IOKxq4Qnj2OVLY=;
        b=OCNK46sSjIaJm236yQoiIoBVUCMOu0s1lk7Eej4WJ5l079RltHZmLkOAZ27SQE21CX
         l9OIH3v4fx4zRzPucK7mj3skac767yP7fas671B+5uip0m8mg/VbtWpzD9aibl6yQMQh
         1X1QF2HKRfeNYOIwOnoKtNL8kHy7lGFbh5kFzuSNfr6kbb8o11yydefAsQQUsaq7klYs
         f/siz9bcHMLaYUPwWz2QpyR9MgRa7k6rTXJsK55YDvPhKgpBD1MchXGTMTRsu4PucWt/
         kwJkU5a2DVv6LMPgcgcgipfVw+20TCRYk46gvbM24Re00svrkzMVaE7vpGEpnw5MEd+0
         9ypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739593138; x=1740197938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GcrA3CRMbq0KMurkjqgP9oXSHnqx6IOKxq4Qnj2OVLY=;
        b=IP7CNYy11UvBvPlRdBUiVN4rhpUMbnOvfpIpzOGuK0mShSS3Rf1wIJTYT4e5EUPiVb
         GIKJumRyFXheRzqz8Jkj6CKsGI7rMkYsi2prI1g2eZIvX9ggYBPEPYFmg8jTDTpXamGR
         //7ycWdaOpeCUEq6SfofJkksCScAmUQwUHtPNPsA/KV0eMcZudY113NFtjWZAOQCTNfi
         Vwx6zh0srTa2ck/9E2GQs0cGf2CEe/gr0WiNj/yyQoC74MLI35QPgN3e2e4zqV66+Src
         /9cs0NGIBSDXKEn/E9DMPX8mJ8ZWE04Bm6A/TwKjOAovyf+dL+kXcRsV5Y+8DWjmgHPT
         pp0Q==
X-Gm-Message-State: AOJu0Yw6n7BfJP9uMfnOzDEgq1KmkIGl+WYHc0rui1u8PkDv6ipLZgJj
	pgo0M4DpItxCRZVq6ipw/5AQjHOQcUCL6HeDrhVncQVoWq8kHa+b+OPVJ9Qzwn6eDqnePtVjHmT
	3
X-Gm-Gg: ASbGnctAznCbX03pXoUOp/zoOoGeDLntoVlOTEZb/+e67HblChrNDbQAjzTzH+s2YSa
	xTD4IPv25zpF9UIYYc/lmHYI/A9tCqMQxN1ePHZ4Yer6rCqAB9b4oEV7RDfmrUR5BFIUduKTZMA
	YbiPyuBUrTj0oF2LsgTyNwePYKdZTt1gXIJJhagUBnNkzLZCOPYSzYBLrnEehMeZWmVM3GR2Y5Z
	q74J963UQYwpTy1XDlAzNi+b2+JBxzobp97JqQO6YPsg6N7AF/NewpBmKmKYVNpmk3b0WqqUMU=
X-Google-Smtp-Source: AGHT+IEVi4A7rRN4XVFwTftUPxEOcnMmWZSx2JLafiimya2RV8hXXa171s+UqR1gbvqmNv5ng212jw==
X-Received: by 2002:a05:6a21:483:b0:1ee:62e4:78c7 with SMTP id adf61e73a8af0-1ee8cad2d0emr3368029637.16.1739593138572;
        Fri, 14 Feb 2025 20:18:58 -0800 (PST)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73250dd701bsm2257306b3a.131.2025.02.14.20.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 20:18:58 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v1 0/3] add basic zero copy receive support
Date: Fri, 14 Feb 2025 20:18:54 -0800
Message-ID: <20250215041857.2108684-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add basic support for io_uring zero copy receive in liburing. Besides
the mandatory syncing of necessary liburing.h headers, add a thin
wrapper around the registration op and a unit test.

Users still need to setup by hand e.g. mmap, setup the registration
structs, do the registration and then setup the refill queue struct
io_uring_zcrx_rq.

In the future, I'll add code to hide the implementation details. But for
now, this unblocks the kernel selftest.

David Wei (3):
  zcrx: sync kernel headers
  zcrx: add basic support
  zcrx: add unit test

 src/include/liburing.h          |  12 +
 src/include/liburing/io_uring.h |  62 ++-
 src/liburing-ffi.map            |   1 +
 src/liburing.map                |   1 +
 src/register.c                  |   6 +
 test/Makefile                   |   1 +
 test/zcrx.c                     | 918 ++++++++++++++++++++++++++++++++
 7 files changed, 999 insertions(+), 2 deletions(-)
 create mode 100644 test/zcrx.c

-- 
2.43.5


