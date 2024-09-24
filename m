Return-Path: <io-uring+bounces-3288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD6398454D
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 13:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 717D61F22764
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0768785260;
	Tue, 24 Sep 2024 11:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uqOe+kxw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F87824AD
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 11:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727179194; cv=none; b=fqEekGWKPgZMJg5ph41cjDP/DKOo+9vcA4i4EICWwruCOqLeKrky7M0LS3dYX0O2Wmx1gdiUM3B+g7V34SKXTKKfI/7VSBBtgVn3ZPr33IINB/k8dPxRcI528V3Zg3BbhH3UowXpYdIYMUA93x+/B4cZvL4ohdET2r0+YKD6M6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727179194; c=relaxed/simple;
	bh=jtW2tmpoVFx3fDto+e6Bj8kZzUToNLRfet4+USbCS1Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cRhlvCf7qSIVWWrI1CkNS+12bn04lpcccZhOOXOgQad//QZLyq2VT4XvfzYLw1OWOT4JWR1bd33NCeL87DuET5/iMeGLrTez9dgUL8adefON1goDN2xl4m6wvHuredmL/oAFolsR24jOajfHIglg8cUdEeAYZxbEmzTVjT0uu28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uqOe+kxw; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e1d06c728b8so4989010276.0
        for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 04:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727179190; x=1727783990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ge4dol156bs2Ulm9Rco2G5p+wzjtZGwmkelTCQOwmNg=;
        b=uqOe+kxwpvofsVKx84sUWdzi5GmYKjc5aVcm/KFu5stggg9lwugSbOaUUmov/gT7RD
         ryTAl2zUKKUGuWm+aEdGJQo2uhMjqRswsH9W7SKaWwbyUXs184obEi4bar1BgfcFywIZ
         Ve6dE4d/KxNzWVFdKySRgUZCsvwHY+9NQPhV6f/vDpBVQgK/9RX0GPs+NsS0BIq/MZaH
         /xoIQMDBtIbC4u7iDT0rIrfxMo7ownGfNWvpQ4NAv1XSfFIYzmttyRkD/PqIH3AqP8lw
         5vNfbGV2cY1KUsB+EU80jXV53phuRyjIanYjpFtiotcFfL1n4drUtGymzDgQ4kYH35+K
         ngPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727179190; x=1727783990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ge4dol156bs2Ulm9Rco2G5p+wzjtZGwmkelTCQOwmNg=;
        b=pP21M0TDheCK5JllFszz65TzjCYg7HI9MjRPEZaM9gHH/axwkPJR4ygiO6iHc6hP+4
         3WSQi/ZYTO5aPVFwG63g6fOMoOV5m4BC3xzcPHSjpbowQMzjSv5Tw93PlXiFzhfPT4Pa
         99IpM+2jmmpENPeGsqLCKAx2Tv3pYUFjMCDM+gz7+RY8DpbMRzL6344pvd93dxWcf5tA
         fwzhz6vWQzJSd9BM+oXvhtsWxnDAzripuJiKVDzZrkx/FH7PReiuaXjWleHr/WoZoSoE
         mlxKqoxpa0wHPM/6yPs/8xWQwQEAuAT3NFzeBw9TOkmKvOALGD6TTbHxobvHjQ9lzhYT
         7yKA==
X-Gm-Message-State: AOJu0Yz2ZFpngQX4/65YKzvT9vZzMeD29CIcPUid3zup/PZ3EHuRMCU4
	Eqbku2CPyYLohzxSYDEgm7+Ce1PTRFfd3RZ/pRYU04xjCi/5cTGIkM+6q2L0PYmeOeLApk3I8fq
	xgfsJKg==
X-Google-Smtp-Source: AGHT+IF7/DVPTUwI5WYQfk0SoNQp8UrAnlv5//NM+ZQMguEaowEW7+XwXB1VWb4R3ZUf+cGL3Qtgvw==
X-Received: by 2002:a05:6902:f89:b0:e1a:9336:8b54 with SMTP id 3f1490d57ef6-e2250c47987mr13230637276.32.1727179190125;
        Tue, 24 Sep 2024 04:59:50 -0700 (PDT)
Received: from localhost.localdomain ([2600:381:1d13:f852:a731:c08e:e897:179a])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e2499ae6a06sm210598276.4.2024.09.24.04.59.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 04:59:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/2] Add support for sending sync MSG_RING
Date: Tue, 24 Sep 2024 05:57:29 -0600
Message-ID: <20240924115932.116167-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Over the last 6 months, several people have asked for if it's possible
to send a MSG_RING request to a ring without having a source ring to do
it from. The answer is no, as you'd need a source ring to submit such a
request in the first place. However, we can easily support this use case
of allowing someone to send a message to a ring that their own, without
needing to setup a source ring just for that alone.

This adds support for "blind" register opcodes for io_uring_register(2),
which simply means that there's no io_uring ring fd being passed in. The
'fd' must be set to -1. IORING_REGISTER_SEND_MSG_RING is added, which
simply takes a pointer to an io_uring_sqe. That sqe must be setup just
like an sqe that would have been otherwise prepared via sending over a
normal ring. An sqe pointer is used to keep the app side trivial, as
they can just put an sqe on the stack, initialize it to zeroes, and then
call io_uring_prep_msg_ring() on it like they would for an async
MSG_RING.

Once setup, the app can call:

io_uring_register(-1, IORING_REGISTER_SEND_MSG_RING, &sqe, 1);

which would like like:

io_uring_send_msg_ring_sync(&sqe);

if using linuring. The return value of this syscall is what would have
been in cqe->res using the async approach - 0 on success, or a negative
error value in case of failure.

Patches can also be found in a kernel branch here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-sync-msg_ring

and a liburing branch with support (and test cases) is here:

https://git.kernel.dk/cgit/liburing/log/?h=sync-msg

Since v1:
- Cleanups
- Sanity check sqe->flags and the actual opcode
- Use fdget/fdput
- Add a few comments

 include/uapi/linux/io_uring.h |  3 ++
 io_uring/msg_ring.c           | 60 ++++++++++++++++++++++++++++-------
 io_uring/msg_ring.h           |  1 +
 io_uring/register.c           | 30 ++++++++++++++++++
 4 files changed, 83 insertions(+), 11 deletions(-)

-- 
Jens Axboe


