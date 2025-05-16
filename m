Return-Path: <io-uring+bounces-7987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F37AB9D2C
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 15:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A45369E3CAF
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 13:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3777238F9C;
	Fri, 16 May 2025 13:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bzvFA5Ln"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3CE4B1E4A
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 13:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747401806; cv=none; b=icxyUU5nupR9TeTL/PQlDih46TgOcEUWBZaUdlJSLPiaG28qqNlUHfvBCi+4kF4N8Ta59+F2/xCFXq+JASHC/dqK+e4yyv7C35ulrx0ig4n5L7HZMrYbx3T+l0oYb+gc0l1NPphIwrc7/QFsMuxA8iZUXA7Pbb2KThDwTzvzGvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747401806; c=relaxed/simple;
	bh=6Fb/vW9DQJ6Bop7iYVHdcqP8i3yN23D1T1N0sD5iNm8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=W2ncRGOlqeSIkZDL/nR/QCMXUa+1moRnYStjscFa8WLCysT9X3cMA9BeZ0GgwdO8TsU00/68s1M4k7ONfOvV1RmuUoFmvO56W4zfy4MuNOsFLzqmR/QJXuxZpbwu2MCUOPEZ6eVR7/s1nUAH7pK9/rWYoXbmXy0vWSv6zkart5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bzvFA5Ln; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3da82c6c5d4so14865335ab.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 06:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747401802; x=1748006602; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pV3e9bh0EJ50idrTK+ejc//aUOITsh/G/CbwfNCkSYQ=;
        b=bzvFA5Lnb50M6M/WG8l4SMksNUL3ZYY+s+NshwVVcELIotUe1v5n926Ns2GPhtmkNu
         FMMWJKaBrHVN3q2PcDpS8Cc+Tdd/xbgEZKuR4cs1J48YasyAhPHI8Mk5kydff697rGez
         kZnxLDVs7+LpC6AVHtwTgablfDUDPUK2hbfclbT6lqTbJFBlioMEnmgUcWABPrrnV29O
         haXeekchPkBatLjWMIbwtic98YowWuekYnLmpWDyqNBcwjmmsFV4bWSSfHrsnuDdSNpc
         yD4Sr1NltOD5NilBgQXGeqInEu6NRY2UXQDlP6WhUDv52hGW8SjDtQEDPcrY1hL5NsMf
         PoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747401802; x=1748006602;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pV3e9bh0EJ50idrTK+ejc//aUOITsh/G/CbwfNCkSYQ=;
        b=q0inSu5SxYa6ck766X82Z1oWRBoWAgK2rmhpwQ2mSNX1dE5SmLBzjPjOOwCfECopHt
         tSkdxz77Yyoan3jxhMXN6ONnccwU3piaJXttv5YsOsS/iozUQe7ZsusGOt6Wm7JzKqgf
         QvqR1eJsgEUNjmB8xlyGTkcqz4ilomt7v8h43VsgCsDZZXh4sL7fndR4TWYy03CFRXjk
         UY9UyFlTN5vZAxf7DbNhiDFIS3t4btmOHCAVsOzBbKNE17NdUnxNe1yGXlURnLFYkACK
         5lrR5Wl3sQtiRsJf5ObDu+/nxnK9Xa2cjG/0WsuHYuTJYaGNadR3RljcRmrX3wo0P3bh
         VFCw==
X-Gm-Message-State: AOJu0Yxu0MCcSGlA0f7ioRFq+PLr9R9R/5Yiu/oj7AICwPSzyz9tp9Mx
	i/kzVCuQa9JrzN0i8mi38pJn1DfywNBjHppVRO1VADVI+DgTw6519khouTtmfSEk0Ak=
X-Gm-Gg: ASbGncuCP0Qw4yeZ/V393nYQEGqaAci2JPpzchU7USS0mTQUYtEoNTVORoLNUGVgRAp
	Rohm5rv/j5KdIW8gZdBE/D48jAdBMM7b93t0GAzb6HlhFSLckf/NNh4ascPBxHEKXnXcP5OP1QJ
	so5vF5SbDXBeCxq0JJ9bwZ2hPYh7JTjqeNJoF5sYw1QQdSpkGnFDaBfF6+BSVpi3E5mfXS9LljO
	5EGF3Koaz0NoWA3ML6+6Xvjz3MjGw1BTzkJL+z/zHJ1dIhguPfw8qmFeWRlGY0rvT75IRYhqrVI
	FMvQhQdufZiKj7XBahJj5eedIaqxFQ8xrKWuH7oWpZDCxM0=
X-Google-Smtp-Source: AGHT+IFtI3kd6U8CLddXUa0mNuGetBf95dpawOllDY6vAuOTB0AfKH0O2AYXaqsHK5uyxdjrX2XnNw==
X-Received: by 2002:a05:6e02:1949:b0:3da:7176:81c3 with SMTP id e9e14a558f8ab-3db84338490mr40632875ab.22.1747401801531;
        Fri, 16 May 2025 06:23:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db843e0807sm4844905ab.24.2025.05.16.06.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 06:23:20 -0700 (PDT)
Message-ID: <a27ba3d8-e12b-4d0a-919b-6874c2b3b3b4@kernel.dk>
Date: Fri, 16 May 2025 07:23:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.16-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes for io_uring that should go into the 6.15 kernel release.
This pull request contains:

- Fix for a regression with highmem and mapping of regions, where the
  coalescing code assumes any page is directly mapped.

- Fix for an issue with HYBRID_IOPOLL and passthrough commands, where
  the timer wasn't always setup correctly.

- Fix for an issue with fdinfo not correctly locking around reading the
  rings, which can be an issue if the ring is being resized at the same
  time.

Please pull!


The following changes since commit 92835cebab120f8a5f023a26a792a2ac3f816c4f:

  io_uring/sqpoll: Increase task_work submission batch size (2025-05-09 07:56:53 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.15-20250515

for you to fetch changes up to d871198ee431d90f5308d53998c1ba1d5db5619a:

  io_uring/fdinfo: grab ctx->uring_lock around io_uring_show_fdinfo() (2025-05-14 07:15:28 -0600)

----------------------------------------------------------------
io_uring-6.15-20250515

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/memmap: don't use page_address() on a highmem page
      io_uring/fdinfo: grab ctx->uring_lock around io_uring_show_fdinfo()

hexue (1):
      io_uring/uring_cmd: fix hybrid polling initialization issue

 io_uring/fdinfo.c    | 48 +++++++++++++++++++++++++-----------------------
 io_uring/memmap.c    |  2 +-
 io_uring/uring_cmd.c |  5 +++++
 3 files changed, 31 insertions(+), 24 deletions(-)

-- 
Jens Axboe


