Return-Path: <io-uring+bounces-3597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E04499A6FD
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 16:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEE4B1F216A6
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 14:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B077DA81;
	Fri, 11 Oct 2024 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DcmwCq9T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD7C405FB
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728658479; cv=none; b=Wg7RAw1x5fh3OIMtWYYFTaiLViCqWJ1aU3QJ8H6iHCHRAAK3X/m5oSV0ccQcvgXyPq3kxdui2yj33DAt8jk7ELC9bCapr0Tm/BuxNY7RfNzj56XIqnawJuQETSmcNaTMIm2U3G2DOSoV0gm61e+jZW/+Uzy2lzwlSpjKUiGUX4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728658479; c=relaxed/simple;
	bh=K8xdhC/kGAMUpAGxw8ydJKbwdOMnmAobTqtA2GYHGhU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=MF9hNfogaDRRvV/aQsYtVwkX6fqjOHc0zDWEkHe4bM1md5aw1PnrKGmn2XcuZRWREMn/ThkWAc7chwVYYfV9JYD8y/WzvyMdhem46bzFEPD002phnX8lHseP+Lkzkho2G2tcOX+wzUnJR0YuOXqMHxYzWEKSUunrBOhJggL8nSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DcmwCq9T; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a3b3f4a48bso4489755ab.1
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 07:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728658476; x=1729263276; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9irWn0fLFvInFzntSkKKQ9rWUJHPnxxLcUTPOhb8xpk=;
        b=DcmwCq9TGHHDpTcf/0JANJI7NlmGLjqcpz6YjLmCLpNrHqtGFcF2Q/YBvue/uHPoVQ
         TnOSKEr7xCuakGHz/vpIhlb3SNCeyCjeYvMuqfP9a2PzU4NYvcQxH1MhSBovrxa/bp+m
         U+HsjCplNzDSTlB68m7XA+XG8nwNBIcmuVd4GwqlkdcnOuZvQ3jMBWpYyGm38L3MfoEE
         +/NP8aYhsxvEBPbLLy7YI6PUy8udUMrDs4BSLmbbSVtnV4ugpLmzhKhgBLVnBE4H9mCI
         HkFapPM4mNvJ74qHkAmrN61ubmonpzBeKznrjH4im+Rfvvf30bkfiwQIjICyP63ZFraW
         Rm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728658476; x=1729263276;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9irWn0fLFvInFzntSkKKQ9rWUJHPnxxLcUTPOhb8xpk=;
        b=kxK+5VkTZpws07hvxneU0iUJUZDtB+B6Q2UhOh1/etEdHkNlP0jX2lO2Ce1kjB9BbP
         DDb2SxtlzXfXvElGsjgJ/OqBbTZFpi937IExXdnEc7nC3BB5k3aePqSjIvmARuErVEcV
         cChogHyaSFLFlwQ/5ygXl6l/YLRUfJvPL/wu09FblYPHYHyyH2Jz4VK2UyL3SWY1WUmn
         nk3G2z/lWRnwwXaVx52qobbk6T1kuMofhZeVeu3iCkJMFzdzDR2ry9s3RV+DfoMhtwG9
         S2dqI+AaM2WGNGcocYkIY9Mp3VNTEnYyDIszYOs+LeTevH9wQOwhXb6onz03s1y6CNw/
         gfVg==
X-Gm-Message-State: AOJu0YzqerkcetrQmmJdbdxcX2CYQOmhTs+Pspxe4czz8Wq6ffMOS7lQ
	H+i4CbKAksLH1pIwccC9P7Pu13Fdo8o6WC2MC43gmJzr9n8ffIhx6oww27q4hQzuyuecwXbOGPd
	ohdA=
X-Google-Smtp-Source: AGHT+IE4VBVcss2FXWF5oDfB121XvSkfsngqI4IAD+f97YtjjBzctr9Th9NpkQLdCOlE21rADB8Ryw==
X-Received: by 2002:a05:6e02:1786:b0:39f:325f:78e6 with SMTP id e9e14a558f8ab-3a3b56ead3bmr20399795ab.0.1728658476236;
        Fri, 11 Oct 2024 07:54:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3afde8d0csm7598275ab.74.2024.10.11.07.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 07:54:35 -0700 (PDT)
Message-ID: <da0401d2-0479-4115-ba5b-185f25ffe4b6@kernel.dk>
Date: Fri, 11 Oct 2024 08:54:35 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.12-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two minor fixes for 6.12-rc3 for io_uring:

- Explicitly have a mshot_finished condition for IORING_OP_RECV in
  multishot mode, similarly to what IORING_OP_RECVMSG has. This doesn't
  fix a bug right now, but it makes it harder to actually have a bug
  here if a request takes multiple iterations to finish.

- Fix handling of retry of read/write of !FMODE_NOWAIT files. If they
  are pollable, that's all we need.

Please pull!


The following changes since commit c314094cb4cfa6fc5a17f4881ead2dfebfa717a7:

  io_uring/net: harden multishot termination case for recv (2024-09-30 08:26:59 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.12-20241011

for you to fetch changes up to f7c9134385331c5ef36252895130aa01a92de907:

  io_uring/rw: allow pollable non-blocking attempts for !FMODE_NOWAIT (2024-10-06 20:58:53 -0600)

----------------------------------------------------------------
io_uring-6.12-20241011

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/rw: fix cflags posting for single issue multishot read
      io_uring/rw: allow pollable non-blocking attempts for !FMODE_NOWAIT

 io_uring/rw.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

-- 
Jens Axboe


