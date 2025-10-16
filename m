Return-Path: <io-uring+bounces-10032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C45BE3AA8
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 15:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5F30A4EFFFE
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D571FDA82;
	Thu, 16 Oct 2025 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NADb+IDm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606361E5B73
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620930; cv=none; b=i4vPdNykJB248/8UkE16PPCJ5k5fMTENKBXOI2u1Uno35sQVbIlbwqEFyRhSFHEWpjhqMnp8ZeauUnUg6m1YfXEuS54wNHVCUSLH/NOqll+8VDheibDAwMtVBG/dDyLT0P1IqzxMXqJ/wTukdnS3aDyN6ayBJC5gSxAvd6eQ3eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620930; c=relaxed/simple;
	bh=Lxmwpxrz9zFkP1dni3nk696Szt3mq0XwhMWJRDk1Chs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=quasOvAgtx6QtBlr036h6JVRIV0c6QZls5kz9yvCsZ4edAYwKLBdBm2xauEWGHeXFn/jPwNgK58gcSFTgvMZlAlzZvBoeX1njxm843a0dI0/qksAyGXpb5SNRD4dlXGzgpoJQSEOpoB4TfozZUcZIoqPeT/xpxAh9+LbYchZ208=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NADb+IDm; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-471131d6121so5251715e9.1
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 06:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760620926; x=1761225726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qy/ixv7qwm5n0k+DKeTXvH4VJiQFV4bhg+/wbM8uD70=;
        b=NADb+IDmQ6wEIfK9eaanOtFn68xAsCK6K4Ad8V/pnzjZOuIL/c+9YjetoplRK7Wt3X
         7E3tly7AZbvlVMxfioH26shBVi/5ApL/Pg2i1ERgc2/CEAzAKO9fb24UA4X/tKUhvZUJ
         xgBICf0GfkWQHxELWeIUkFobZVN2ias16/9KT9dnp2xnMIuM4XxFo4AV7m84NzVjXouU
         Ia0vMJ42JCkhazX2TvAq/9qq5Hk4YNM94PUHgQagaEAohhmulspnQcPt116mkqPRigqf
         nn+RHK+CZBXQNYro1nnltxD+dSAIPxNjdUmnal5kQ36HvWB2uIDFPNpV4vHPjhRXApYE
         g9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760620926; x=1761225726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qy/ixv7qwm5n0k+DKeTXvH4VJiQFV4bhg+/wbM8uD70=;
        b=W1xYIs4RDpAZpUWD54CgNvzJK1SWH2dz/ABeO+9TqjBjRaFJ/jGUchBkkq2l1udgi3
         kMSrJEM80Iq2r6veREcGcNTdd7Q1n79/P9QYkJ6a47eiHpGCrHocy3TQ8n7Nw6S5YsfX
         laPMMluXzB0bmfECWjK7bAfzmzHRu8pueTVDmokHKE9QMueXCBG8hI0soP/IzNhxwqxI
         xj2R7fZFGz0c/Ci0QUc60xktXw6DHxUV5h88P4hQXeBjz2MJxCx8bWw0IuWmZaZooqfk
         9FH/bM4GJiMhxLAdsPnWqx/gUgWBW9UKiyu/7AgjPoCTt3vLRSzPOcSJxoE43UCp9zh3
         e47g==
X-Gm-Message-State: AOJu0YzSWgSXMc4Lvp/w6NStL2NGR1jlOsPrI7gHMnOv/+cPj2NahmWN
	ib/h67C2cQ9Cw6SvAQNFMPIaaWQwDf17/l/Geg7CLRiuPV5+ECFDVHjYBoQBHg==
X-Gm-Gg: ASbGnctR5jXrUSvZJA0g15ZI3D89CEUln+bDXNQVbx70OrIyk322j8fQ3fWWubsqkTU
	0mb+YxmvmpF8MuMlPGEpS2tSlHLtKvhRQqCVJdm1s22I8jpUCM/Mq8l3ssj4OthxkgeY0F5Ws3r
	kbVNcmDMMB9Rj9RiPeBwBN4phZ633pPT7ZKeYZChmFnWKYMlNZ0Ui4SMCnAdbkQdDpudKc261ns
	R+0r87FZaZQDpP6hGW8bc9x6URYV3rCLSlNTgUFftYQlNWJR7NJ/IT4uJHYLnzY0ldDRpVHgnaF
	Nj45OFB3RGE9SO0qZZsCngmzyZIouF6NJBoNFI4N9Tc1l0qITtaVKC0MWW4GWBn+dyq8WY3K/Rc
	C/CfxAYmjORHmwgg+repJyGrxlDd8TSHkmdYJ2k85auOSHUQhlatGNwYP8T9avEpb6Rd30A==
X-Google-Smtp-Source: AGHT+IFcygtmqzmpRb4Huw3hXeyCAiYGVQa8Nx7ePHS5Fp0q0cjwDbmPfE6IRJMaYGkXqAs6s1NP8g==
X-Received: by 2002:a05:600c:8288:b0:471:6f4:601f with SMTP id 5b1f17b1804b1-47106f460f6mr47188415e9.19.1760620925842;
        Thu, 16 Oct 2025 06:22:05 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm41834385e9.3.2025.10.16.06.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 06:22:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/7] random region / rings cleanups
Date: Thu, 16 Oct 2025 14:23:16 +0100
Message-ID: <cover.1760620698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Random stuff that will my future changes simpler but flushing it out
as it looks like a fine cleanup series. It also replaces
io_create_region_mmap_safe() calls with non-mmap version where
it's possible, and removes the helper in Patch 7 while handling
io_register_mem_region() a bit more gracefully.

Pavel Begunkov (7):
  io_uring: deduplicate array_size in io_allocate_scq_urings
  io_uring: sanity check sizes before attempting allocation
  io_uring: use no mmap safe region helpers on resizing
  io_uring: remove extra args from io_register_free_rings
  io_uring: don't free never created regions
  io_uring/kbuf: use io_create_region for kbuf creation
  io_uring: only publish fully handled mem region

 io_uring/io_uring.c | 26 ++++++++++++--------------
 io_uring/kbuf.c     |  2 +-
 io_uring/memmap.c   | 21 ---------------------
 io_uring/memmap.h   | 12 ++++++++++++
 io_uring/register.c | 29 ++++++++++++++---------------
 5 files changed, 39 insertions(+), 51 deletions(-)

-- 
2.49.0


