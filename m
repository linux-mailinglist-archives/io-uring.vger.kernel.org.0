Return-Path: <io-uring+bounces-8011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25702ABA47D
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 22:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1731BA26086
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545D022C356;
	Fri, 16 May 2025 20:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ijMaeoFK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD8122B8AA
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 20:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747426216; cv=none; b=lmA+mFzQEL6PkXoe/ZRrJQyut61Sa991Idlx8mKR+ajClFkw7XKZWNTdwY7eGhyHvtYh6c+CGE29dASkNjlbgibPd90DlOT5pMUmIkjf18o/9Uxl+w1LLVkWkfHP1Ogh9zUqDqLRQ2lML7N3w6pVwVZ4qIKIZWfmfZS3wlK9qLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747426216; c=relaxed/simple;
	bh=AvfUX1hqOxX8B5vmP+cAbzo1eNI4wSJIZcPsOa9SKWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nNf3ewZqWXtGyqsyNpWFB1RqcDDXy4a9Imko7bqnRJXtLQhsxHrPSmOodn5XSP8G3yzdq9Uq+QqwUSmvracyP3bMJ+fXmueLA+Za8U9uI7BDJGXdfUjaKX91QPSEkqPC+tsLSa+NIe2wGj4Ys95zaKyRnUbVWHVJ8bk4PSH+rCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ijMaeoFK; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso8574445ab.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 13:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747426211; x=1748031011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i6XfP4cXc1FZ3fqW81Kng1n3xAoC2SzVbpEt6qf7T9U=;
        b=ijMaeoFKvo5RVuTpcUJngpk+OJeMLsMBXcbo5m0OyyWceONBm2Cv7urIOM25ZAIVnZ
         Qlnuy3uBwXvx1RprVW/+aUqQpe5EajMSTCLtx3agzMMoa+f/RG3l9rRAH+BMqs+NCBeb
         Tl4Ga/9sq9zKzadgUc1oATuHnsUI30rpYJNxHguJf7AJPhnTW/627B6W7ypOP/Zq5CUA
         hxjvNx4mDhXeuoDLlhuDDroxB/AwikzsIiuHwMd1oeTEJOwVfgmlgaRd7ClIkpJIrQWs
         kxZlK0DvzT0PQCWXBu4ucwV6BPC62YG+iBcrhU7h7G8fdG4EPTbgHOATlolwvVcCRfQM
         g12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747426211; x=1748031011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i6XfP4cXc1FZ3fqW81Kng1n3xAoC2SzVbpEt6qf7T9U=;
        b=XRLPb3QcNnAHsJaroyBGT1GYt8EyhwoZAhm/LfwcL0/NvkY84LCoD/B6/Gcn+3gu8g
         kkpfA5GUuAob+e7j+kchHpoxyzaJlR/e20cSQT6mE5zUsN+p2ZyVrFKcVvcqNpkfXviS
         G8sjNgcuSJhiRJ3xsmUnc8Bv8SCAql+Zhg3yXcNTG4GIvKhnB2cm3L9MBP+Cg8wkZaxg
         YCU4+Bu17hBdQXTD+CrUr+AKkcXREIgZiZddoKdmHkgeJBS3M5FIydgM5fklH2yrueMM
         Gcb/QjQbVvPFVzJ7LTw35NhFHMEKLEkrRcJ9SsEn6u/G1U3iPl9oJBamNhf/HbOsRTvq
         Ibkg==
X-Gm-Message-State: AOJu0YzUn/TRCm9oL0f0wI4R7LD6S9PxvD/Ze/rM9IQsr0YCDsUU3X5G
	eFqV+Gz9iOQYKwGoogZ/ZvUZQ2jcOAthvApxgrpRTXRPBnMUv+zTnmwNQaSGNWGZoEpD6qbDjM2
	3W0FH
X-Gm-Gg: ASbGncuqHNdRLO8Z5YLo9PJJRmEPgnYOX1RvEIAqj7xP6bBendA/IRW6qFiKw02aPhy
	VXeI38k3AvvLFhaoy3a7mDYe7ilL4t//usoRuSPKuRxQ2wSck2d1Yd96Yfd/yJSjrf2QI0rEP8C
	wAAUIXDq0fu9JKTfrL5Dbvu3Oh1HG9pu3ueJ12J4Cax3un42A+65Hk35xAU9gsYIylfQfRBi3W0
	qCWyNtpolWR+FR14IssLi18WmrY9ko71z/SuwbEM7DU3WY3JnYtVihC6z6/W8S8LEK7WokarwAD
	Yd266CsOKwUnpKl+mm7intldekoJBolmIxlhQcXs+N5cy4BvvstWKeoA
X-Google-Smtp-Source: AGHT+IEu/AR6B4abklvm0KtJUO59MaXkfrkeD7+FpnthxVnIzsl4IA+R9E0nimp6+17kxFviy9G2VA==
X-Received: by 2002:a05:6e02:308b:b0:3db:74b3:3875 with SMTP id e9e14a558f8ab-3db8435664amr55250115ab.22.1747426211410;
        Fri, 16 May 2025 13:10:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea4b5sm541805173.136.2025.05.16.13.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 13:10:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com
Subject: [PATCHSET v3 0/5] Allow non-atomic allocs for overflows
Date: Fri, 16 May 2025 14:05:05 -0600
Message-ID: <20250516201007.482667-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Sorry for spamming this patchset today, but I do believe this is close to
final... Last one today, promise. At least it should appease some of Pavel's
concerns. Basically this patchset tries to accomplish two things:

1) Enable GFP_KERNEL alloc of the overflow entries, when possible.

2) Make the overflow side pollute the fast/common path as little as
   possible.

Also does some cleanups, like passing more appropriate and easily
readable arguments to the overflow handling, rather than need 3..5
arguments of various user_data/res/cflags/extra1/extra1 being passed
along.

Passes normal regression testing.

 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 97 ++++++++++++++++++++++------------
 2 files changed, 63 insertions(+), 36 deletions(-)

Since v2:
- Finish conversion by adding final helpers so that each of the three
  call sites can use one of them without needing open-alloc + post.

-- 
Jens Axboe


