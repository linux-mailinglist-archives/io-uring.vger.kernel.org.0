Return-Path: <io-uring+bounces-10408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB24DC3CAD0
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23E7E1891962
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16293145B3E;
	Thu,  6 Nov 2025 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEVTvaIe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B42A334366
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448524; cv=none; b=AJJ6Loyxisb2UJ6CAUQI6mOrnzK0ITSXPDa+Zbc2eThRhfES3pLiDCB1nuMLqfTmE9kFtEa8Al40fr78N26Y7IZR32B25uwJ541w59bAXODp3F5Dmp2ddJHgB0Q0sFijRtrDYvv8agiB3fh2VJjVw6ByjrU8kzLiDmn9wpyHaEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448524; c=relaxed/simple;
	bh=vWjn3/+EgqwYx96exKs33TmG9a2kbKZ1ER9YJ/QZJtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kCwryxRh47iJNHhBdmQfNWR7100YyTMLxENBmjL9AOUPFM44JNXQMc44MaT9lsY/cv+srDYJrpiqn3W//fdL+4fs1S5otNKNgIzbj/3r1dGyw8J8Y5R1Yc++j1dBKsKF9aFNxLQKLvu624k89nN0Sby50mfvYh/6fI1WWFWgQNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TEVTvaIe; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47754547a38so9657395e9.2
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448520; x=1763053320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F8NTvTBugoeIT1nUD/2RUz50knuAaoKR/S7iVj3KnnM=;
        b=TEVTvaIeh/0GSRBGsLM54zqC8EEeos9lK0kH5QnucST3pIbtDNzGnfQgNEiMq7EROb
         DZ/ghqSP17F4xpahzt3zo9GBpBt1++aMaRPbfMHal86jCr0z4ZPbJwCq99MrW+Nf/n3y
         vIAfRME3S7sSd11x4nXmcbQGBzfSbtbVeMMx94lTyla5vTlBGheEuUiwi0kqX9cR3mqt
         9iVAVlPB6GQiTV6iRxnr5USbFommW9u9WG9bSmYg10NshdeVBgzaIqnbVELLd4w7xWso
         kQQBzI5DN9/30cYbnggpbiwqy2pgSAr1qoDfHaxClbRiEWrA7ByndIyAuZBrhtgx3aP0
         JNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448520; x=1763053320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8NTvTBugoeIT1nUD/2RUz50knuAaoKR/S7iVj3KnnM=;
        b=RCFhF3dfriiIB0g9ZmT2uSy5U0d11NPoI1BjMiUsgGqEo5ucz4j6G1gp9E5ReQ//Ix
         2ZljawawEypn1xrsszOyXaM7tdVu/AWoe0KNFoN56y+zdOi6LExw7DzfVqmV3ekK0h1E
         Bm7r7SDmjsit61qxvyevULNKVZLCnof5kWWNeip+RPp/CYhLVrC3i1/PfKvmoLfW4f4V
         euVxGZ3OpDMlC+DjPXBeDJ4B86jGf9ZASXojBIM1jXPKuRSdsl5tfyGOndDPBFFAZTET
         WHt7IN179LSeuiq5m4Sir5nuHCflh8gwqPaS1xyue+NrWuRMc45Ldv17PbfoGo83jW8E
         i2BQ==
X-Gm-Message-State: AOJu0Yxq3Zf/NX3NyZbNrL4S3XYXhPNOzc/ENb/GIF9c7u+3h7UxsU6Z
	kRn7QS9TV/gcanHc5oU8XfAv1hP15QWX5vwdfs9NwUxahJ4/cLg3FFr65+RKQg==
X-Gm-Gg: ASbGncvnhD2Om3zoB1tr/JsbiMXZCbs8WyGMeZjI14L6hNt8qfKbZYRH2XR4RQRbsXF
	t3oEtl3VEr9Jo3FCRpxmS/GOIek2LyMT4ZHd7piHSeLkLbbSoFH8lkSpdgMNR7shPpbVUBReS0M
	JI3dJ8I/iB1Ju5rWkPP+OhxpiB36RysBAUbwF6bohnxPSdouPaGFgx+PimjEUzVBUPRHJrTOjL3
	WfeOvVnOMFbB5RPQhSGvJYiipfUNL3vFQHNalaFVCh33kPAj/4heqHwyPFgKK1ej4fh97GjUJkR
	0T6edDHIdpt6H3GgDC9DSMZKexbcO/8h+08pSabiGlUwV3Vm4QMHPGfpKV+WZB0P+eOU89pKK+W
	p5jPGUaFjELPxjAyKY4od21Xb7xTgVqkWIhMSOwY60f2dX+G1CzLckGYZb6w/LDW3tTGTXRV0Dp
	t/Uaw=
X-Google-Smtp-Source: AGHT+IEMhWXtAZNqZcAx1H6iWuVDRJA8199/6VzUNSNJPQddXM0pVeBL5Bm5pS0JWAl4lqxHHBDrjQ==
X-Received: by 2002:a5d:5888:0:b0:425:852e:6ea0 with SMTP id ffacd0b85a97d-429e32cc2f3mr6247029f8f.2.1762448519685;
        Thu, 06 Nov 2025 09:01:59 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:01:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 00/16] Introduce ring flexible placement
Date: Thu,  6 Nov 2025 17:01:39 +0000
Message-ID: <cover.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset allows the user to put rings and ring headers
into the memory/parameter region and specify offsets where they
should lie.

It solves a problem where the headers are placed before ring entries,
which 1. usually padded wasting memory and using more cache lines
than a smarter placement would need. And 2. it grows the region size
to a non pow2. It's also handy to have a way to put everything into
a single region.

It's implemented for SQ and CQ, but planned to be supported by zcrx
as well. There is a bunch of cleanups (1-13), it'd make sense to
merge some of them separately. It also adds an ability to register
a memory region during setup and not via a registration (Patch 15).
And the placement handling is in Patch 16.

Pavel Begunkov (16):
  io_uring: add helper calculating region byte size
  io_uring: pass sq entires in the params struct
  io_uring: use mem_is_zero to check ring params
  io_uring: move flags check to io_uring_sanitise_params
  io_uring: introduce struct io_ctx_config
  io_uring: split out config init helper
  io_uring: add structure keeping ring offsets
  io_uring: pre-calculate scq offsets
  io_uring: inroduce helper for setting user offset
  io_uring: separate cqe array from headers
  io_uring/region: introduce io_region_slice
  io_uring: convert pointer init to io_region_slice
  io_uring: refactor rings_size()
  io_uring: extract io_create_mem_region
  io_uring: allow creating mem region at setup
  io_uring: introduce SCQ placement

 include/linux/io_uring_types.h |  17 +-
 include/uapi/linux/io_uring.h  |  21 +-
 io_uring/fdinfo.c              |   2 +-
 io_uring/io_uring.c            | 341 +++++++++++++++++++++++----------
 io_uring/io_uring.h            |  34 +++-
 io_uring/memmap.c              |  16 +-
 io_uring/memmap.h              |   7 +
 io_uring/register.c            |  75 ++++----
 8 files changed, 360 insertions(+), 153 deletions(-)

-- 
2.49.0


