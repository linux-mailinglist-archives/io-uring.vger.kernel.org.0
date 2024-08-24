Return-Path: <io-uring+bounces-2941-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 956C595DEBC
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 17:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C31A6B216CC
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 15:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091F02EB10;
	Sat, 24 Aug 2024 15:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2htA/JUy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5024D1EA80
	for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724514363; cv=none; b=mzbaSIiTS17gqmm/QdvGsvG7+C8+YtRv20FoWbit6Oj8DEgo3YRCPXVzrVYU6YcT6cv6oyA4KaJB5CuOj+5hC8x0RjVyEMBxZBkQMjMpbbr4+M0aIiqEgQ+O1NrHasB+Em8qVvHqc0OSggpTREfFZbbSagTVJcliFpkb1iiPllo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724514363; c=relaxed/simple;
	bh=SMF8Yj+oCgOuYLULOUAKcsi0UgGRm/FuYzrlfO7XO4w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=iGvlG+uWJ6Sqf4E5XQbuTcJJ28a6wYhvWg1bgXx0egktSvHXiRvaINlziO6kMjI722qkLw0P9tJCOzslzhsF6mrCKpS2et8L7MHYkbJVoOL1QRxAklmdzjj19UEF7GgQEG9J7DbrSYsGDJJ9Y2vQ/AXvG5Q+7eqgnTe1lqZ6Jp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2htA/JUy; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d3c098792bso2324101a91.1
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 08:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724514360; x=1725119160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YxjAtj4VI1nZqCazMK4NHreKhs3b726rvUF7y5EdvqY=;
        b=2htA/JUy4kyAscjOoDv6N5GQkMcSN4/20yXUGBCDeBhQ+YF/0fe99/vWjLiOn38ZQ0
         ftCSVVCetDHfaNVyD9FGmGtf+VuTeaBmgLIO3QkAODSzZvhQ5F2tumTo1RM2qdNM5sUM
         fYZ5CBxOcRlGFaxd+uAgxrhrSfaUDZ549KKkgHHp2sI+PqKjWmysSuIL+Ery4kIx4IkS
         hmf/f0Qfdvxm4b8EUh8TwH8R1e+i8fG0i1XjnuQEBkWt4tkT7/7JQ1ytfRJyl55m4VGq
         0QwQIHbovv4yBF6wye1X6nfJ7LYGFw46pWZQStSksgdPGr6jESqg3BFj4ige+IF/B7dt
         wGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724514360; x=1725119160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YxjAtj4VI1nZqCazMK4NHreKhs3b726rvUF7y5EdvqY=;
        b=VQb8GZVyg6ynZ8+YlA4HTsIl+y9bSwJaV6sBIxP5tY108suRmjlXTh+0JmIKTCtaIg
         8p/8YeT7HT5ySNM5sfLPgfdj/3YmdxKsMe/6GgemFopVPPTwhxO+2BTMtntDah0D2vXv
         Atl5jsrQadiX4H1SjVGDiRp9gBQyi0wHoRdtKFLDYdyhpM+eAjVGY8wGk6SEQN4y503F
         aHZQaVEUHZybKO7lgijN3sh67bHnFUiJjLE6chY+0pGQN7vth3Cb7v6BV27USA73VLVS
         leSN57A1p6Dk+yC9KKUe4mBgA/rmmFodz7zXT78/FUJs4ER9/mxRJ18D/8EPJ887BC+8
         p3kA==
X-Gm-Message-State: AOJu0Yz0FsSdkkPobcUC5+TN6yV5tdK6cu6T8EzEDD9S7E9pMZMP873q
	+Sd7f33qBbncMMw093C3JBTk8neKfkoBqb3kES9bU4SELUhaOq8sND+akKAygsKbnRD6NyDacvl
	W
X-Google-Smtp-Source: AGHT+IEWUDIffMZuMNBSbGo07C7ML6QUNLOqMZWlkKhDOzRoWFlBVlJ7thMj7C6icQiPCKUg+7gRTg==
X-Received: by 2002:a17:90a:b401:b0:2d3:cbbc:fb7c with SMTP id 98e67ed59e1d1-2d646d4dd9amr6146792a91.30.1724514359991;
        Sat, 24 Aug 2024 08:45:59 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eb9049b0sm8596939a91.17.2024.08.24.08.45.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 08:45:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/4] Add support for incremental buffer consumption
Date: Sat, 24 Aug 2024 09:43:53 -0600
Message-ID: <20240824154555.110170-1-axboe@kernel.dk>
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
tests and support for this, as well as having examples/proxy support
incrementally consumed buffers.

Using incrementally consumed buffers from an application point of view
is fairly trivial. Just pass the flag IOU_PBUF_RING_INC to
io_uring_setup_buf_ring(), and this marks this buffer group ID as being
incrementally consumed. Outside of that, the application just needs to
keep track of where the current read/recv point is at. See patch 4
for details. Non-incremental buffer completions are always final, in
that any completion will pass back a buffer to the application. For
incrementally consumed buffers, this isn't always the case, as the
kernel may generate more completions for a given buffer ID, if there's
more room left in it. There's a new CQE flag for that,
IORING_CQE_F_BUF_MORE. If set, the application should expect more
completions for this buffer ID.

Patch 1+2 are just basic prep patches, patch 3 reverts not being able to
set sqe->len for provide buffers for send. With incrementally consumed
buffers, controlling len is important as otherwise it would be very easy
to flood the outgoing socket buffer. patch 4 is the meat of it. But
still pretty darn simple. Note that this feature ONLY works with ring
provide buffers, not with legacy/classic provided buffers. Code can also
be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-pbuf-partial

and it's based on current -git with the pending 6.12 io_uring patches
pulled in first.

Comments/reviews welcome!

 include/uapi/linux/io_uring.h | 18 ++++++++++
 io_uring/io_uring.c           |  2 +-
 io_uring/kbuf.c               | 55 ++++++++++++++++------------
 io_uring/kbuf.h               | 68 ++++++++++++++++++++++++++---------
 io_uring/net.c                | 12 +++----
 io_uring/rw.c                 |  8 ++---
 6 files changed, 113 insertions(+), 50 deletions(-)

Changes since v2:
- Don't enable peek-ahead for partial buffer consumption. Not needed as
  these buffers should be bigger
- Consistently use io_kbuf_commit()
- Fix bug where BUF_MORE would not be set correctly

-- 
Jens Axboe


