Return-Path: <io-uring+bounces-2956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5073D9611F3
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 17:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82E951C233A9
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 15:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCF21C6893;
	Tue, 27 Aug 2024 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1IvBdrDM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADB91BDA93
	for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772306; cv=none; b=m5othA0rp753FuCgTfLFy3sRAH2msVcWiG0Yh9HlsUthdiMYrbjKjvEIZWMch0CjoL1IKxpUqdJWhGdCGyTNqvmu+ITkMD3JBySYqDVvYDo37xCuCgM8zYFRRv0/1kW3XVaBDozRKBtL/wmgno/mVt69/HOw1mmh6sP8YQSTdOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772306; c=relaxed/simple;
	bh=fDUxUdYkTCXBLeOtgLPNqu8BLnziJO5xCaiwnfaG/JE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Z46NLXUZxzBu49Hi8IEqjiosbCVVoY+VaaFi7n9ykeKUSQ6Ndysw/acpqwfHeOE0AiCZ6ks1PeGUA9xq4wDxjSHpBe1y9rnyVprQjo26M58kX1c8bxcvDQDBbg5owZ8sOGFRuUgfjyIDotEa84TmI0wjsC1mzvppJxcNXOZbz5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1IvBdrDM; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-81fb419f77bso311456439f.2
        for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 08:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724772302; x=1725377102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NQ6VfjmZ5EPupi5c3Ny9VkkZZixPGKXiWB0Qsw8NyWg=;
        b=1IvBdrDMudSLVUZ2b6GyDoUy0LVDXtr1MYeQL7dLHIzKu1crpN3GSia/giVYh8svOU
         +ACDL20q7VJJJe/Ho7p4YxF+OK/68bGqWtDY3WZVZaTH9J+7Wp3Z470pfBH9PtaJKYH4
         Kvi2G8xXTDSeaDn5fKHY12E/isBAJUnw5F6dtQqXykFGijUJy0euvRb+n10P+ytqEgWq
         a3Du+PPzMhxzi91J3ateg8qoRysn7qHx+DtZlkdMng3PjGYB3i6KNbIhU67eehOEqauR
         L4GjT7fFsX5qC7rzvlQU0NUKdUKc5eTbA6YHXCuy3mJeLcgrBNztubzKgG+XF+SCraFC
         kUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724772302; x=1725377102;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NQ6VfjmZ5EPupi5c3Ny9VkkZZixPGKXiWB0Qsw8NyWg=;
        b=dYtEiFfR6vO9hdNaOHnNWCl8Y/hbxakZlBEd9Mis3GYgokJ8lCruomyWjBXtn/0agZ
         cKMzrLDdLf6TWeCkVwKU1EPrEPttwXvFxdxYBQaUCrmm1r5b3Y4FqL0UfehcHO8IrrKb
         ef4aqIXRKwIrXaN8DMKa+WUrDXFhBx2E6u5cU9JioOuon4BFjg/S8D3zqih1lgd8WVqt
         d1qh6vgfNQhqXun1bNNEMnuYSccAYYBiPQ4XgyXgzZEaODXCsxw+lK2M3gH+GpJZHKjC
         5z6SdVBhC2mNwNaMDBu/oNUOT8MX3+OEHwqwMtnyDuLyHYhUTQ2xIewRG60iLdXag2EI
         I3Dw==
X-Gm-Message-State: AOJu0YyTpXNLgN4TZAky8WfsHjKolGKLjuFe3eVXfXllyZFdq/usKaJv
	daZnAtOPVA+vCIlIboCHOr+PoE4dpnVRpHh0a1uUUi/+Yu4/mPqspy1/DIErlsiwgEmT0pz++QX
	z
X-Google-Smtp-Source: AGHT+IEJfAdPaTgV05N27axM0aY8U8DBdJKbiR/MFcBgsJER/Y4PNhqpw14B0hlhqWmMuPz1L0wUVA==
X-Received: by 2002:a05:6602:1506:b0:822:43ef:99d1 with SMTP id ca18e2360f4ac-827873102e9mr1835868139f.2.1724772302397;
        Tue, 27 Aug 2024 08:25:02 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce7106a4a9sm2678580173.106.2024.08.27.08.25.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:25:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v4 0/5] Add support for incremental buffer consumption
Date: Tue, 27 Aug 2024 09:23:04 -0600
Message-ID: <20240827152500.295643-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
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
set sqe->len for provide buffers for send, and patch 4 adds a 'len
argument to the kbuf consumption code. With incrementally consumed
buffers, controlling len is important as otherwise it would be very easy
to flood the outgoing socket buffer. Patch 5 is the meat of it. But
still pretty darn simple. Note that this feature ONLY works with ring
provide buffers, not with legacy/classic provided buffers. Code can also
be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-pbuf-partial

and it's based on current -git with the pending 6.12 io_uring patches
pulled in first.

Comments/reviews welcome!

include/uapi/linux/io_uring.h | 18 +++++++++
 io_uring/io_uring.c           |  2 +-
 io_uring/kbuf.c               | 61 ++++++++++++++++------------
 io_uring/kbuf.h               | 76 ++++++++++++++++++++++++++---------
 io_uring/net.c                | 12 +++---
 io_uring/rw.c                 |  8 ++--
 6 files changed, 120 insertions(+), 57 deletions(-)

Changes since v3:
- Split "kbuf consumption takes length argument" out from the main patch.
  It's a separate change anyway, in preparation for consuming less than
  the entire buffer.
- Add a few comments.

-- 
Jens Axboe


