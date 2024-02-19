Return-Path: <io-uring+bounces-644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4593485ADA5
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 22:28:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F25C41F2282C
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 21:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAAE9537E4;
	Mon, 19 Feb 2024 21:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O0nU9MTg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE29F2D605
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 21:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708378078; cv=none; b=V6WI4xqcOkY5kGrx1DKjkpK4TuhKscYambF3ADk0MS4Fg3NgFW77+PQI+Dk6+L95bcdlRATIeDUPqhVBpsXF4cRd/Tzt1QaZPY4HJ21lDxb/UGvW6SP2jJ53NPl1Sbo3hxEQYAbwtCQm96ATOETyN3NAAJGqFPLy/8CNJHkQQo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708378078; c=relaxed/simple;
	bh=Q1zpMdbUlVWUgwKiX39X39uiTwdFVT6/Ddu40web/vc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TBF7WYggjTCjfJId4C5m0/8+Csa3RXoMCwDJiSETZDqMQPZbxyisrslpv7xjFHpDzJ7kIXRIF41c0CZ9AywgPifTj15BZ1F+0/j48xPdNrVIPBhwLofjVxZJqNPwMPaOI5IUBwCoB7AQZ7F2H8q8a27duLnKEDIG/02rKGpXcCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O0nU9MTg; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso1452998a12.1
        for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 13:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708378074; x=1708982874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=A9MUqtFDPCXAQjJYTHYhParpt5XaS2vOZ5Im4xUxIbM=;
        b=O0nU9MTgrnyHdRMljmv37yKGwCghuSkv2Z+hS7JjsHUQ5s5G4KpVlO/KllVgRY2pkc
         4Fk1Q5cKfCrCgZlNw9sNxmi4lje1mb2KONu3UAUIOKOqdgvSLVSS67ZjMIBai5ESzDLR
         eLk4wfe0gDNP5IeaBwQYuuqnc02brQrxNs3/2h6NwrhSJv2l4HVhtDhKq/Noa+hONDqV
         2gajR89VDATRSQBDVP3RE+koeA5bNqBYtaFuUjIF5/juDY5Yrb0gYUFOYOjyJBPAPpwq
         MpHWSKAhoxZvU7TpCjTbIJLB6l0yU4Rjsn2zeLzOgRQl0Gn7S47r5ofo+NLv6wjkrEMe
         FmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708378074; x=1708982874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A9MUqtFDPCXAQjJYTHYhParpt5XaS2vOZ5Im4xUxIbM=;
        b=U3j9D+0Xm5uzfZSU40SKggFaTUE9KfhofJARh4wxL7hUTgZzHuXw9IrxZdTHzut7wR
         czuNBdZZHmnDfCptNR/1C9j8IR/Z3uc76aDCo14QYKNa5C74z+8A4Ne4A9J2J8U7u8ld
         oCZmpzD/F9nfbYAHdNSNYCkJvEL4yhWaGXO+NOuZn0Rag1IRlqiYbROpTOCBNyai85M+
         icSuAfJOp/0NWVm20buUr1hdeG9r1BF7Y0SXc1Xi8IlloaZdbirR1lcoP4HG0C4yWaFi
         JanfypR8Jkg1iwIS1OSNICnBQuzonyj9wHYs4UlSedjeYchiEkcpZmqT+Zi5xX9FmAGn
         EHjA==
X-Gm-Message-State: AOJu0YxOaBdnhKogLLUmG60OW3+rr43doHQ8i2zE5TjN4El/+Bd7w075
	TkJ6w23fd89mzRJTEw9LkeWyKiECD1o+ooZ0RrBTjAwlfjjvm2o5/r1lqAPlKZP5AbA5Do/dWxN
	E
X-Google-Smtp-Source: AGHT+IEtfRZTjz1aWRNj6JhHSSFHv34Lerv0nPtKBihAxl+OyXqXYwa6Pq7cFMkyQSEIvFzoUbPX8A==
X-Received: by 2002:a05:6a00:93a4:b0:6e0:93a3:cd04 with SMTP id ka36-20020a056a0093a400b006e093a3cd04mr16605507pfb.2.1708378073630;
        Mon, 19 Feb 2024 13:27:53 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b006e05c801748sm5279770pfj.199.2024.02.19.13.27.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 13:27:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/3] Support for provided buffers for send
Date: Mon, 19 Feb 2024 14:25:24 -0700
Message-ID: <20240219212748.3826830-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

We never supported provided buffers for sends, because it didn't seem
to make a lot of sense. But it actually does make a lot of sense! If
an app is receiving data, doing something with it, and then sending
either the same or another buffer out based on that, then if we use
provided buffers for sends we can guarantee that the sends are
serialized. This is because provided buffer rings are FIFO ordered,
as it's a ring buffer, and hence it doesn't really matter if you
have more than one send inflight.

This provides a nice efficiency win, but more importantly, it reduces
the complexity in the application as it no longer needs to track a
potential backlog of sends. The app just sets up a send based buffer
ring, exactly like it does for incoming data. And that's it, no more
dealing with serialized sends.

In some testing with proxy [1], in basic shuffling of packets I see
a 36% improvement with this over manually dealing with sends. That's
a pretty big win on top of making the app simpler.

This also opens the door for multishot send requests, which is an
interesting future venue to pursue!

You can also find the patches here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-send-queue

[1] https://git.kernel.dk/cgit/liburing/tree/examples/proxy.c

Changes since v1:

- Forgot that the sendmsg side uses the generic helper for this, whereas
  recvmsg rolls its own to deal with provided buffers. Unify them in patch
  1 instead.

 include/uapi/linux/io_uring.h |   1 +
 io_uring/io_uring.c           |   3 +-
 io_uring/net.c                | 309 +++++++++++++++++++---------------
 io_uring/opdef.c              |   2 +
 4 files changed, 175 insertions(+), 140 deletions(-)

-- 
Jens Axboe


