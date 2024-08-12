Return-Path: <io-uring+bounces-2704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C2A94F245
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8934C2826EE
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 16:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E617183CA6;
	Mon, 12 Aug 2024 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a4IISM3L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDBF1EA8D
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478507; cv=none; b=PBmud/l0zc436T00DkmNr3zyqT8TLqeNNoY/o0gEpATTfyScshSdzY8YdaERxa92YZhD1+nprzu340xcy2da8lBf5aAJGEouwikAi7p+L9vfLM0s0ZhoIYBkrKN5uWElIOAk5+tdy3lpTyOKVUlBvKO+s27l/VGgYr8EEBSRywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478507; c=relaxed/simple;
	bh=idxi3DVrC/UkJ03AyJNxeVwStbbwgH0EfNELskrJWn0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=fk++cxny1CvM6enMN92CYa3RNjHTOpkb8AYXQygPplGDrbVx6FgMZxKImkzLpMknA8vL9lvsRFLFOWvDT2rWfk13QAtWFE/QjsR9sKmNriKPJKZcQHEh1HHlboh3Rr3FWnxk6EPwCiuPsGIvl83011uYYC2JzD6aY/lv9T4yhQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a4IISM3L; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fc4e010efdso976915ad.3
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 09:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723478502; x=1724083302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+zYkozzIV5E++q8oMG6WK4QghL6A306K6fkD7lkD9l4=;
        b=a4IISM3LQBq2e7iUBPhyqVmtdw10sOv+ftwtITxos88dp3b8TrJCLGbLmXML1twcbc
         PIq48lhnCWSRXF8b3SFuFEfulWaM6wz7/jtSG3wfl/JsjC+YqKKh+cXJ+2Fs194/dfJT
         Gr+cAk67xUZ/qRT6bR/XKxlxzd87UqrsSYGnLOW043l9cpVjJjgYSw6iLInH0vubU4mZ
         9o3tKevNJbeh/7w+AHIuHRIHKFcj4npkFIK8bkgoSSQr1M2ZN0C3hEcM0ytltsRUTI+V
         y8ZiozJ0EdCC/PyBkGWF2JA6hT7GoeKGds6shw2b/kuFUL/zaVOzYtknF5mCZSBW8l/j
         mVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723478502; x=1724083302;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+zYkozzIV5E++q8oMG6WK4QghL6A306K6fkD7lkD9l4=;
        b=cWoQkczi6rHf+Mm6KAfjqTO6dZoRv1IemkLx+ETQbclLWQb1Y1T3fH1A75F3y425hI
         XepbEsVF/w8RLPdunhctj8PksEUXvqEy5giKpXY7oNjGks9Tp/TepFv1L1vdeZo+1YAk
         mD+u6Y3KboeUOytfuS9z//SbUU5XGuSZbmhj/FRuzeLgKT0YV2gr+8vHY56bVwxzWQAE
         pG0KKR1yds39NiKuYHTbKHyh6VpitkGFWzDmc9MMpH+/W/kI+1WeuutiIlYpUTmXb+lN
         tmDGG+Db6y8CWHt5jrkCDPyt2jCHTcIV+HPL4EORI+gRG130cFQs1vnohnGXRLSb7M0X
         CtNQ==
X-Gm-Message-State: AOJu0YzB37kBMtcMZ5+5S4okKnugQyzQl14jzXFcZVo7j3pi4xHn3ks/
	Y0VjnT+GMgEHwuSudJahZsG6LfrUqn5/BaOJLCuDe9mV15mt9OgH5i6epWB4Q9sre7J3bx/gyHB
	I
X-Google-Smtp-Source: AGHT+IFDBvDX9G2RnMdJw7BzIu2XMqcS8JB0tXbyxAVWc3PHr3o4CB93+IiSxoDZdNMEpREcgXHCBA==
X-Received: by 2002:a17:902:f0cb:b0:1fb:1cc3:647b with SMTP id d9443c01a7336-201ca180742mr5064335ad.5.1723478501634;
        Mon, 12 Aug 2024 09:01:41 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8f7546sm39749705ad.77.2024.08.12.09.01.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 09:01:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/3] Add support for incremental buffer consumption
Date: Mon, 12 Aug 2024 09:51:11 -0600
Message-ID: <20240812160129.90546-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The recommended way to use io_uring for networking workloads is to use
ring provided buffers. The application sets up a ring (or several) for
buffers, and puts buffers for receiving data into them. When a recv
completes, the completion contains information on which buffer data was
received into. You can even use bundles with receive, and receive data
into multiple buffers at the same time.

This all works fine, but has some limitations in that a buffer is always
fully consumed. This patchset adds support for partial consumption of
a buffer. This, in turn, allows an application to supply fewer buffers
for receives, but of a much larger size. For example, rather than add
a ton of 1500b buffers for receiving data, the application can just add
one large buffer. Whenever data is received, only the current head part
of the buffer is consumed and used. This leads to less iteration of
buffers, and also eliminates any potential wasteage of memory if some
of the receives only partially fill a provided buffer.

Patchset is lightly tested, passes current tests and also the new test
cases I wrote for it. The liburing 'pbuf-ring-inc' branch has extra
tests and support for this.

Using incrementally consumed buffers from an application point of view
is fairly trivial. Just pass the flag IOU_PBUF_RING_INC to
io_uring_setup_buf_ring(), and this marks this buffer group ID as being
incrementally consumed. Outside of that, the application just needs to
keep track of where the current read/recv point is at. See patch 3
for details.

Patch 1+2 are just basic prep patches, patch 3 is the meat of it. But
still pretty darn simple. Note that this feature ONLY works with ring
provide buffers, not with legacy/classic provided buffers. Code can also
be found here, along with some other patches on top which aren't strictly
related:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-net-coalesce

and it's based on 6.11-rc3 with the pending 6.12 io_uring patches pulled
in first.

Comments/reviews welcome! I'll add support for this to examples/proxy
in the liburing repo, and can provide some performance results post
that.

 include/uapi/linux/io_uring.h |  8 ++++++
 io_uring/io_uring.c           |  2 +-
 io_uring/kbuf.c               | 28 +++++++++---------
 io_uring/kbuf.h               | 54 ++++++++++++++++++++++++++---------
 io_uring/net.c                |  8 +++---
 io_uring/rw.c                 |  8 +++---
 6 files changed, 71 insertions(+), 37 deletions(-)

-- 
Jens Axboe


