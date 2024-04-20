Return-Path: <io-uring+bounces-1597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1127F8ABBBA
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 15:32:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C2A91F212C2
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 13:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1D1168DC;
	Sat, 20 Apr 2024 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RHokDwJl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCD18C10
	for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713619973; cv=none; b=Jpw1KN1KYVNxxLjay91yuROI7my+8qEvKNdkzrYSIfBv+5B6E9FuG0OB8/OWFlC9jEfgIk8//inlbF8027m+BBfAPKIikhTCTbw/CWLDGUA1VrccQczsJSUkYCobpt9AvHEOjvVAy+cX7novLH717SYYzddWyinlUVR/jp2tE2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713619973; c=relaxed/simple;
	bh=NE1jXqCuGfeUU0bg/EQCnzUD1zEnbs399yNn2NcKRXM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HTz1hqS4MBP3JSNeZJDFRal/C1kh7X7BOHNCyka+DNzE3/jfeUpkN4diRwzOfh2zqZVIF7CbRRgsakjYPCUNTAKjLSLa2OZjn7NsqALzgAHC6to/CIZHAr7pMkuUmdxopMFt055WZZdQp/S8SyYEv97IOXgMLU4XzUlvCLXxi0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RHokDwJl; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e825c89538so3735475ad.3
        for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 06:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713619969; x=1714224769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0RaIa4+tm9DmFRwWGonCyu4+VUFmgElseYGLEyTbL4Y=;
        b=RHokDwJlseMlJqAoX3swfffP4zWHJed9FjlX7CfC0SYpeS1tKRc18bC05YLEXpMBAh
         YY1wHAIiQ0ouwrYPkrPV1hLvw1cqnwlmT6omJU0h5ZdSeYCi0R4s8C4Cqhkxyv7XVeag
         8v7LnYfs1jjfY9jJVQvYxc700N3SHoNt5Rdn1rWpxZW0KXsFpj5Iz+PObkz8QPd1zF2I
         afhR+RbMRvMobk4mP+S/4XQeADRlZsETZUSTOCcksRJgjWdU1A+vZ85sUjamSf0agfvk
         yh1NudqYVf+1W91hIxgxbrsEAzCjxaM6hNWpKCLqidNoRJ+H2HO7+Zl5Mz/XvzX2qWNd
         CNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713619969; x=1714224769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0RaIa4+tm9DmFRwWGonCyu4+VUFmgElseYGLEyTbL4Y=;
        b=GEs73hA9qOn2hADrtNb6zroMWnzCEI5hfj8zMvnTyDMqhEA6A9WtvwvYGBel13ASqn
         Q/bvzklC0oIHyfyDtaILjNUHCsSXhOjz84LVKozVjjFRQ4QE1PtSlGlO4GW+1zQsFxeD
         Ic8t2KFozbs6VSwNzcFoa+GnUy9Ar/fxFyklhAnZmT4TGUZxwiEm5U2CQD8gueJd9owF
         nHqF07hIfTywZ6GRb5b3vVWHhuluymtLnGQnHm4jJdplonrDOZECyz5zj82CeqnWhsgm
         IjaXIoVOkgt2wMmueaWe3qNIrtv3wnjzapZuxb4vOSsKPSgt6gMsJ+njXY8ZP5oevhnO
         HwNA==
X-Gm-Message-State: AOJu0Yyuqbu6r6KYN9Vk0hN4V0crDE00pP6oDKkTDuU/mJlFzHEP7f5W
	7Qnrdz4lJELpuL04CuLqzpSA2kH02y4sxhTq2PqQy7cULcCPzMaqUk9R+15HotS8oqbxH8Ej/DR
	Q
X-Google-Smtp-Source: AGHT+IH1BwQ9cQPlw+yBgFnO5a/cgCffROTCftR+Ke4uMEQWf0HMyFvKmrIGMuhnVl7OelLjEkSAgw==
X-Received: by 2002:a05:6a00:8a14:b0:6ec:ceb5:e5de with SMTP id ic20-20020a056a008a1400b006ecceb5e5demr6271311pfb.0.1713619968510;
        Sat, 20 Apr 2024 06:32:48 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a6568c5000000b005f7ba54e499sm2926610pgt.87.2024.04.20.06.32.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 06:32:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/5] Send and receive bundles
Date: Sat, 20 Apr 2024 07:29:42 -0600
Message-ID: <20240420133233.500590-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I went back to the drawing board a bit on the send multishot, and this
is what came out.

First support was added for provided buffers for send. This works like
provided buffers for recv/recvmsg, and the intent here to use the buffer
ring queue as an outgoing sequence for sending.

But the real meat is adding support for picking multiple buffers at the
time, what I dubbed "bundles" here. Rather than just pick a single buffer
for send, it can pick a bunch of them and send them in one go. The idea
here is that the expensive part of a request is not the sqe issue, it's
the fact that we have to do each buffer separately. That entails calling
all the way down into the networking stack, locking the socket, checking
what needs doing afterwards (like flushing the backlog), unlocking the
socket, etc. If we have an outgoing send queue, then pick what buffers
we have (up to a certain cap), and pass them to the networking stack in
one go.

Bundles must be used with provided buffers, obviously. At completion
time, they pass the starting buffer ID in cqe->flags, like any other
provided buffer completion. cqe->res is the TOTAL number of bytes sent,
so it's up to the application to iterate buffers to figure out how many
completed. This part is trivial. I'll push the proxy changes out soon,
just need to cleanup them up as I did the sendmsg bundling too and would
love to compare.

With that in place, I added support for recv for bundles as well. Exactly
the same as the send side - if we have a known amount of data pending,
pick enough buffers to satisfy the receive and post a single completion
for that round. Buffer ID in cqe->flags, cqe->res is the total number of
buffers sent. Receive can be used with multishot as well - fire off one
multishot recv, and keep getting big completions. Unfortunately, recvmsg
multishot is just not as efficient as recv, as it carries additional
data that needs copying. recv multishot with bundles provide a good
alternative to recvmsg, if all you need is more than one range of data.
I'll compare these too soon as well.

This is obviously a bigger win for smaller packets than for large ones,
as the overall cost of entering sys_sendmsg/sys_recvmsg() in terms of
throughput decreases as the packet size increases. For the extreme end,
using 32b packets, performance increases substantially. Runtime for
proxying 32b packets between three machines on a 10G link for the test:

Send ring:		3462 msec		1183Mbit
Send ring + bundles	 844 msec		4853Mbit

and bundles reach 100% bandwidth at 80b of packet size, compared to send
ring alone needing 320b to reach 95% of bandwidth (I didn't redo that
test so don't have the 100% number).

Patches are on top of my for-6.9/io_uring branch and can also be found
here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-recvsend-bundle

Changes since v1:
- Shuffle some hunks around
- Fix various bugs
- Rebase on current 6.10 branch

 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |  10 ++
 io_uring/io_uring.c            |   3 +-
 io_uring/kbuf.c                | 157 +++++++++++++++++-
 io_uring/kbuf.h                |  53 ++++--
 io_uring/net.c                 | 284 ++++++++++++++++++++++++++++-----
 io_uring/opdef.c               |   1 +
 7 files changed, 456 insertions(+), 55 deletions(-)

-- 
Jens Axboe


