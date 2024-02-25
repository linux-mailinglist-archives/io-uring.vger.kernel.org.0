Return-Path: <io-uring+bounces-701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C102862894
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:39:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E08E2819F6
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C717FD;
	Sun, 25 Feb 2024 00:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F5J9YhTg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8F2EC2
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821588; cv=none; b=W7V2YWUyqGL0tlRh3SIcpl4JH8fGQBLTE/zXWFiNxBN7dc0eVcTQLF2Ht+733Q7f/oFBOMPwOeiM6Sg7GV4pdq77F7WJqdn7PjhsprATRxOB3yJT9jyUDsQVeMgOBy3yLI6B4yMVQpA2Hm3S/lp+ByXl4dj3ZqhAgeLpzsr8d4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821588; c=relaxed/simple;
	bh=9fAI2TqHWslRYn1PPjEqpuq2pHKJ0p+s6esOFYFbeuA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bL+U8N1amY2TikBQTkNQIBrWYe1EDJCah81wguu0l0WILlW9KnwporADaWPFqC5DcfVt9vOuoIuAqyagLQ+1E+YBazZTDePbknL/NOD5u6f3nHbA5DpViueKeOG4rY0NjEADqeyT1YsdZqXdBYLsmUp6sthmgUV4b2OQhB1578M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F5J9YhTg; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so861964a12.0
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821584; x=1709426384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fiE+JvollnNSSkiqU17RrExFih1TH4h5tdHvRIK7gxM=;
        b=F5J9YhTg4sCV6JmSD9RypqO9ATPJ4oYFwIja3/svDf9m+avgxgvRq5K6EdBfyAEqCr
         lIoKoBZVIlR3fM0HKCBrV2md9l1Fmo12mjpVIo/qqPRdAZArxmf+3em6zX+32ibTxLO4
         QmXg2zy3uCJo6buAyFxYsG6KSW0DMc3C6kSXa4ZgFdAu/6J5ozFck0yN7B3HUDybUHIM
         r8lT+1vvWQst4lxzQZGPqPCgYN9w5wvL+mPNE3wumOOrqxd5rIsW1jPxFV1xJAC2UmYD
         uwIOJU24FyEIEvSHseKypN9wbVdFCJUyob0HJsmwP62A01ARLM6UVnEzQl/T190Wn14M
         aT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821584; x=1709426384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fiE+JvollnNSSkiqU17RrExFih1TH4h5tdHvRIK7gxM=;
        b=GuRnLxGUC4KYHg1eW/SvVhxTA+L8LcBufOtBTGHE13Rto7XDnlSlQFBMLyJWSseUt8
         hOJeQchpWo4h1jw/zy3wsI45tcQOMm1Yl8FVoy1i5rnXOb9OM16Tq2Do+MlV55ETOy+v
         +btdmUwahWwhXFqJrUlSNFR46MbzTxwVF0S3BODpsx2mHvMDdQqHpt7UZmmUTRf3elZz
         cMNKeuI0OvMVOgb9rU6YLaRzrxw7h+ZM4g5NeFfaCrJqi0aeKP9FVN07LGVYb7QbnGfc
         fwLyrpi5eQObktPZp/uy9Q5j2PlgIx/oVRE5STVsZj8ivMUsU1Jtt9NXKphUgSYpoiSb
         N0mw==
X-Gm-Message-State: AOJu0YxzkUg9qzsO7syvnVubfh89bGclKKF11GWGsZuXodiwX6FKLVZT
	5rxFXIkZt1SYxUE9fJ7FORNncGp+e8eJGSZPPTwpqz6qvNxECpEhXYH0r0xOat/mn1TC2B7X5lG
	2
X-Google-Smtp-Source: AGHT+IFcGD7A6Ja10RrPARAGaGosu104uSXugiMMi6jk3jS/cgLO0+IV44OhE4flfBAVISH/roD59g==
X-Received: by 2002:a05:6a20:3d01:b0:1a0:d4ae:b12 with SMTP id y1-20020a056a203d0100b001a0d4ae0b12mr5056020pzi.1.1708821584401;
        Sat, 24 Feb 2024 16:39:44 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/8] Support for provided buffers for send
Date: Sat, 24 Feb 2024 17:35:46 -0700
Message-ID: <20240225003941.129030-1-axboe@kernel.dk>
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
a pretty big win on top of making the app simpler. Using multishot
further brings a nice improvement on top. Need to rebench on the 10G
setup, in a vm it's looking pretty tasty.

You can also find the patches here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-send-queue

[1] https://git.kernel.dk/cgit/liburing/tree/examples/proxy.c

Changes since v2:

- Add prep patches unifying send/recv header handling
- Add multishot mode as well
- Fix issue with REQ_F_BL_EMPTY on ring provided buffers

-- 
Jens Axboe


