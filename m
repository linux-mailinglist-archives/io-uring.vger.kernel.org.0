Return-Path: <io-uring+bounces-3275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5882A983C2D
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 07:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 894871C2222C
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 05:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE128C07;
	Tue, 24 Sep 2024 05:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HkEXOTos"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CE6770E4
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 05:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727154341; cv=none; b=kc+BnuzmmLlNMt++IQ9Jqpmgc3iya91/E5lnb/J7B3ymtxDcnr2r0daxSHfT1BRUEFD4cFoE0NC4yGDV58P9yTgwnzdWgpuTlmKYBCBYa6E1qtTc5V9eEKHHsm2ANRDRHYnyuJrhIEhc5yW8N+lLNgwcAl8pmFbE5x5pR1qK+Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727154341; c=relaxed/simple;
	bh=I/91W8SX+B/1JeCqUVqK/muK3Qa9E9mTJDj0/B6p/Ns=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dkAgMkwIaDaqWSJxGUoCQ6rmm8RCTq8gI3pHHjHqizFos2GVsOjQuZEzYfQvKkPoTtt0LnhiLIZQBhMEts8/cF3x3j8EB+YsZR2qebvA+aokcJUK2scNiECtfhSyNCcKSz1b+DCHWCsWLnV6jQgGy+e0BYCFTAWCSqoIFaH6/Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HkEXOTos; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42cb57f8b41so65646355e9.0
        for <io-uring@vger.kernel.org>; Mon, 23 Sep 2024 22:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727154335; x=1727759135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=QgM2M+ynVcAcUwdDDI3RIN5aRoFMGcLqkfV2zkxUcyU=;
        b=HkEXOTosRdQBzqpPWrxVqo0X4zgDx5bdgO8n68/X99qG04GeCVI0Os1Kq5lnZbAl/H
         DTeXhEjwLFKCZWsM2Poc8dPf6FanI9M5wuf7aSABHXIYInR1otoeW7uqZ2Ky8rTjv1oG
         Kt7dHYTDxgqVX7dFpugikkNDOUYBmKwqRdpLfyjgu9WkCNAhPhrvpN4BOi4U6SppMZot
         fE5Oo0GyQa5iAysEQQ1oizRjwhhj9p2Gk8CRz/tc1SVfCwuDVKHVfnj28yZWm0tO5wAX
         77+GriJizx7J1NUoeiYfsF1cQBASqcXKmTjkqTmE6w22SxwJhAXTzSDm/xqO8vtpOrbl
         LC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727154335; x=1727759135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QgM2M+ynVcAcUwdDDI3RIN5aRoFMGcLqkfV2zkxUcyU=;
        b=XHqlkY7/kGk/KYkmibydLpbzvx2RPfqEGdxy50HwmtxdzL7H2954PIzto76Id5XzhE
         IilmR2giKI91qGJW2BfsVnJ+nCd3znsHOSASkOxBQ7E0Yfij6U+bxY3B9f1bRzsmtf7P
         YIoPzdlNT7HPdfVfdVJj9R/gNFOKNgV9PCRCiE/TJa2hCsZiBO06/StAi2l8+1E5rx34
         2ANisuO2YnE0yjzdJxKliz+RwL8wJ4tmPyEbNcoqbdpcX2LBreiJYd7TxjVpdTnYpXM6
         MJzSaL7CE9bgf2PnwajrbhxV3/YMTj906jpx4dCvsaQnSSfz8UEDD/ATRcctgGv0UttW
         sB1A==
X-Gm-Message-State: AOJu0YwXc3UyDD2fcAHidOttBV5hlXTXZa+v+Z8SdPyuJuoQ2xZuModA
	cObZRyP+yN31k5dXzV7TIbFCE0rFvB4fS6exEd/WnUFc5Em9ZPy2bYa1S+6A51ITnOp5m008/jx
	AHUbeLI8B
X-Google-Smtp-Source: AGHT+IE5kpTEVoIlTa713YfK8G6nBgYsJySk5Ld4tT5XvsXpqo9i6SEDPt93XYww/r5H6QncDMjUyA==
X-Received: by 2002:adf:ee04:0:b0:374:bd01:707c with SMTP id ffacd0b85a97d-37a42386e42mr12718768f8f.48.1727154335256;
        Mon, 23 Sep 2024 22:05:35 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc32b694sm552480f8f.116.2024.09.23.22.05.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 22:05:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Add support for sending sync MSG_RING
Date: Mon, 23 Sep 2024 22:59:52 -0600
Message-ID: <20240924050531.39427-1-axboe@kernel.dk>
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

 include/uapi/linux/io_uring.h |  3 ++
 io_uring/msg_ring.c           | 60 ++++++++++++++++++++++++++++-------
 io_uring/msg_ring.h           |  1 +
 io_uring/register.c           | 27 ++++++++++++++++
 4 files changed, 80 insertions(+), 11 deletions(-)

-- 
Jens Axboe


