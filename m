Return-Path: <io-uring+bounces-7450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9394AA844C3
	for <lists+io-uring@lfdr.de>; Thu, 10 Apr 2025 15:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 892E83BFF21
	for <lists+io-uring@lfdr.de>; Thu, 10 Apr 2025 13:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E051EB5F7;
	Thu, 10 Apr 2025 13:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GHTbCY4D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A00757F3
	for <io-uring@vger.kernel.org>; Thu, 10 Apr 2025 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744291496; cv=none; b=EDg2X33JlWhFDJr3Tz0sWq1gFUE1e6qL222niv+isguUJQGWeVj3Erg9tdiZI53oY95DJsJsAdepuIzbc3hrJzrBgIogBCrYZl1h/q6Bl95wJbA/l+fDCGzfdpqNjpH2ZG70BSYmmYoMGsGfzifxh66tdGnX+7I5BZazFg5H1cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744291496; c=relaxed/simple;
	bh=QWFYfPbm6iYQRBiTj/DOw0ZZ/6mS8m6xX7As5Uz/+bM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=gYSm3Dcn0Q3n9KN3RqN/4qHgU/hj8zL0K6XjToVPZl7QtAJ5j2Xopwf3pL/ZDHBuhrNAAhKQgr/T/Ix3SfhRx2nAokf51HJkF0FyoeY7TcUqTezY3RsxprxupoFDUQwFty7oaGQNA4JNsR+p431+FG4m2jwKAHpC3CxqKg2jL3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GHTbCY4D; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d58908c43fso2240235ab.0
        for <io-uring@vger.kernel.org>; Thu, 10 Apr 2025 06:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744291493; x=1744896293; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkVNGTvYp98e/LRlIxclG4w4uxqR+t2r+DfrBr/9CaE=;
        b=GHTbCY4DHySM2Jkn9w7mb2fTXcxQrNY1W7UM9kLiodzjW87MquWozlT2yrftZnCITF
         Az9Rm3i9djaY+8bYazWvj1fe2sq/umT4vGmJUXsJp43CjiixWLwqd9GC440+oVAYrVlA
         bDCC0MX24eAePOCTylM8zmVLDbMUUNSn7REllYgpEh8IR8kwZzjiYN7SGjSHryAY17PR
         z8Zrzl6fjAjUFcbY3LTY9XOqrjGUiKK2NA9/Pnzgu5a0JtiZd5fHAH8xu97XpyWUOrG2
         rbzlsPLsBa4IJpvzXMWusrkBswa6Kv2MNCnfSp6EZDTkBKpq5Pa2rV7ddu1P4RXnrBXi
         CslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744291493; x=1744896293;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VkVNGTvYp98e/LRlIxclG4w4uxqR+t2r+DfrBr/9CaE=;
        b=jTcez4xo0VRRXSI/fu8c6iQi3YPRlIvGSOBTJix0R1vnpPO1wS1xHlKSgqeWN6YgUu
         LanRr96mF7vrGPf+Le8ZyBDLrjNJv/6g0l+wlfJkY1RHa4uXoBDw1pM+URAWM5i8gw26
         h3XYAbHM9lAw36GMJHvwwf4BZ2E5VdaG3HvuIPrWdJNiVAufj0ieAhk5Nden0PTzB5p7
         LIRldKqVuIrKSiE+PfZej0U95drESSJJ2Q5mp67hJfGnzPm8Vmi7pRsZ8rZckU7j/UVT
         YUGBE2Yak/YH2ebRLhGO0xKaNCsZSIIrasmparsvi1asrfF1rvHyZpVO7i72f2TBDytS
         RPEw==
X-Gm-Message-State: AOJu0Ywh14/+yCrBXTBAWZqYLzcf9vHGvTZlrakaDbGDMFpyQAQoxotI
	8x6qjjndwIjCebAgcFvYftzFWRz4AMiNoa/QqnePk2nCfeQin3fwauplZ6Pjz8qImiSsLLuOebe
	g
X-Gm-Gg: ASbGnctiYQoaFtqJgUVFASURBOZ7Zyp1mujlyvyEod8GzXbyT2Ki3kdCP722tQFYXXE
	Z+W0pGlH1tebcIWFTOtFPilXsZCwpE10rtcXYcLXs4PpUIsFb3GWVfpgH9eo68qDVTLPvq5r1fv
	EZuAjEAflKYpX4pBoZfVIn+9z9olJ4WJHDKt9EazFQxsAxbTIEzh1AtPxOolaYnDI5lBLUGaOgm
	x4O+aGc6wa+f6Oa2pDe8EEdSSaCTOU6rzMNs55tQrNd3NRgRY6EvBbnsYnxlDf94Uym+K1XKWAo
	RrTGGcxuEfU3Tu0k+DPD+HyzEbSM14xsC+C+
X-Google-Smtp-Source: AGHT+IGs0bh/d8ddMYMQ4RMBorJR0tA/8b1DFQq3NhXCDgBVRsnMAG+Q3VmHtcqjWnQmdKrjpTAv5Q==
X-Received: by 2002:a05:6e02:2162:b0:3d3:d965:62c4 with SMTP id e9e14a558f8ab-3d7e5f6a34emr21092085ab.10.1744291493419;
        Thu, 10 Apr 2025 06:24:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505cf80fdsm755972173.12.2025.04.10.06.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Apr 2025 06:24:52 -0700 (PDT)
Message-ID: <69eb3ff6-ae4c-47be-86ef-b83fc8327a3e@kernel.dk>
Date: Thu, 10 Apr 2025 07:24:52 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.15-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few small fixes that should go into the 6.15 kernel release. This pull
request contains:

- Reject zero sized legacy provided buffers upfront. No ill side effects
  from this one, only really done to shut up a silly syzbot test case.

- Fix for a regression in tag posting for registered files or buffers,
  where the tag would be posted even when the registration failed.

- 2 minor zcrx cleanups for code added this merge window.

Please pull!


The following changes since commit e48e99b6edf41c69c5528aa7ffb2daf3c59ee105:

  Merge tag 'pull-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2025-04-03 21:12:48 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.15-20250410

for you to fetch changes up to cf960726eb65e8d0bfecbcce6cf95f47b1ffa6cc:

  io_uring/kbuf: reject zero sized provided buffers (2025-04-07 07:51:23 -0600)

----------------------------------------------------------------
io_uring-6.15-20250410

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/kbuf: reject zero sized provided buffers

Pavel Begunkov (3):
      io_uring: don't post tag CQEs on file/buffer registration failure
      io_uring/zcrx: put refill data into separate cache line
      io_uring/zcrx: separate niov number from pages

 io_uring/kbuf.c |  2 ++
 io_uring/rsrc.c | 17 ++++++++++++++++-
 io_uring/zcrx.c | 19 ++++++++++---------
 io_uring/zcrx.h |  5 +++--
 4 files changed, 31 insertions(+), 12 deletions(-)

-- 
Jens Axboe


