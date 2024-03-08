Return-Path: <io-uring+bounces-873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBBA876DFB
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1EEE283893
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 23:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332BE3BBEE;
	Fri,  8 Mar 2024 23:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r/I6P2PJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB683BBCA
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 23:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941855; cv=none; b=BpYypLE0kQ/yOM3+q1Aqlt8nF8ZuSZIaRIhYxwZU4SQ3s4UVk6aK9TDch7+8DuX0o1bMxv7dTGQKp+YdB+tMumihb0h+MpIzPrDTrt9F11Tbc083tqu0zaEndbhikpylaU0k5LzsAr/FdOHCE77SnsWQeB2fnEyDvgeDp7Y9rQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941855; c=relaxed/simple;
	bh=4VPk3HbknrJjrjGpZcBofpHJh51oZMxIbB+AKPzcPd0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NKNndYaxawnkmv4zk/PjIzJoa6A9SKZg9Mb0cgbCtOTm9w0YG96VyKDS67bpy7KWjdkgdNChR9lAewY1OK7M1Tsj+3lcgkhAOqH8cMNXtUHI9lagJ/xzunmYoSDZl3Bg27NN2rHwNIlykZI30u0rWMqCB2BzbBEy2rZeBVPB5eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r/I6P2PJ; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so36620339f.0
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 15:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709941850; x=1710546650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ObWKCGajjvnksFC/1NUgb7iTG6ZNx8V5dgybQ+u0o2A=;
        b=r/I6P2PJ4nMIhdDqmK4jjErQYJZELzk/F1MZj3rRZWTpKf5mWuf9OiKQGcaFo5OsHL
         81aTNa8dgSXhf5zs+JsHVaUGecO8cvPXLuI8oGsZIGso1MI1bQgWtP/ZcmogjxQAyE8Z
         gFdwoSQCj3NGqFGADdAbYibAsN/bzEhINzZ49E2ifs5JpMzfjfe5XZi5vbp9SrP3E0u2
         ORMPIhgDUIns4YOG572rpaNFefiXKfQH0aKZB+PqaOUpjnzPy7rmpxHoKMriU9ObjUNh
         A/erHuG6lbQlYrVGNXJdg0cY64UxByFMldPt9REiE9eoUWFrU7/VPQxkAvoWoqWiqIuQ
         jsnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941850; x=1710546650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ObWKCGajjvnksFC/1NUgb7iTG6ZNx8V5dgybQ+u0o2A=;
        b=azQ4ONrTonaFerDO1N0t2oe4S6MmIN0VfJdY2yre8J8DZxkSKO3BbJ2eI/hk2a7xV5
         siPY2jwBgXijmmYqyDH+2dmid4V9EWR77b1xcTlurTiZeMGKkvfG2Hk2BuztUoZXieRX
         TsPvc5TzBJfgBy/7qAuhyN9gDWj7CV++th8ntPFaP+0ito/MYCci7Qs46y8m+jKqAepl
         X9OXuEtDiN0i197OVBKtSrcZKPyZo+Yne3mDFHwObjvnTIyt5FpG2a3SpiDD1I+8P6/u
         6w2H+Q75p0RVyNYO1G1u7Hc3kUW2a9jhEwnLClvu3chIPazk48WBPEP0hkw20frHRnWn
         8lng==
X-Gm-Message-State: AOJu0YxOqizSbRMHSKxckc0aY89qaGtCQFJYHhNos2MM4ZSprwK/5iiZ
	z7Mky12iJWCM/8bAXTBP5lELEMzqHVRXHi+JJ8i7d3a38S1a8PHNqe7BGXRWrG3vWXSmMhcD0Ef
	h
X-Google-Smtp-Source: AGHT+IHP4dgE2EEYeYwvIDrwGelPNJvOAlyEBxpTyGkqvXENh7YXBt3FVibOocgY2C7bBK+DsQY0nA==
X-Received: by 2002:a6b:f115:0:b0:7c8:9456:a8bb with SMTP id e21-20020a6bf115000000b007c89456a8bbmr443751iog.2.1709941849986;
        Fri, 08 Mar 2024 15:50:49 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a056602208d00b007c870de3183sm94159ioa.49.2024.03.08.15.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 15:50:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	dw@davidwei.uk
Subject: [PATCHSET RFC 0/7] Send and receive bundles
Date: Fri,  8 Mar 2024 16:34:05 -0700
Message-ID: <20240308235045.1014125-1-axboe@kernel.dk>
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

 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |  10 +
 io_uring/io_uring.c            |   3 +-
 io_uring/kbuf.c                | 203 ++++++++++++-
 io_uring/kbuf.h                |  39 ++-
 io_uring/net.c                 | 528 +++++++++++++++++++++++----------
 io_uring/net.h                 |   2 +-
 io_uring/opdef.c               |   9 +-
 8 files changed, 609 insertions(+), 188 deletions(-)

-- 
Jens Axboe


