Return-Path: <io-uring+bounces-9847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E26B7B89BCF
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 15:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EDEC7B1D7C
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D8001E9B1A;
	Fri, 19 Sep 2025 13:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SEmTVoHs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1110F1A9F91
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758289933; cv=none; b=XxNl5ARR0X+XmNrgro7aqErJwUyzlvuFWq7zmKKQKnq9LVpc1AJ9qCDEgEoQR3OffeqV7TYuMLIctbx6G/oBUNUh51Mk6KzitmGsBBXN6BuK0RAh5ii9Q7oAMhOAURI/mY0O+fgxITz0nsXqZjuL1z1BJDHW7l3+M8VXQhctXqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758289933; c=relaxed/simple;
	bh=/lsf0wrjkUn/Z5SCVgSjE9C2uXdQdiaMCmnF8lURqMU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=XB86BiieksXWfLVPlIPQC/7MfDkNdtmgW8eFferCuxsJh+1Qt1Q3zVA06XIJTBWJZoWZnnPfpmbF8qXaT/5dBSBvtICMnp4Wakxs25474fNFgl8mcYWTkxstbjgeSfpyyKXiz2D35h3psVmOsLkqd4ceV8Et7YNkQgQy8hx3gG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SEmTVoHs; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-889b846c314so59995439f.2
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 06:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758289929; x=1758894729; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMSTkIcsO+0RpWilWhJUSWU33BSmSD7P2le1N319Bws=;
        b=SEmTVoHshdP2ZQnUj/mDakeetaKvc4MSV2r/CgWvNZxd/EO9aI7tmDnUzxXr6CmYBF
         YJ7B1VByiDEWld1aueYzobhQV/V7Rx/oq7PCWqnqL+G2dRrYY6rWb7sRzCB1B1OwZi+J
         FfEdQCzVTnqWjDqYgbIwYMhlQWyTJhEY5W/SqFdi3lkMPevgDVeWxyPYCzkb3X4h1O1I
         cbc5tGG6xyLI4Qh3JIt3yR1yzpHCm6rtJRSQOXLgBy5IZd4pvUdnnL3TpcZUg/9pbUuK
         kULifP1UoxPvMkWV8671UPVb1Tzk//9/aMKG9imo+LxquvkJo6Q7lSizOBS0FVZca7RU
         qXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758289929; x=1758894729;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OMSTkIcsO+0RpWilWhJUSWU33BSmSD7P2le1N319Bws=;
        b=TZnmbVthof5fPFBl1i4YqXNjP35H8cMVW9YrepNwFCK1RGBl/t19T4X55NGOP0fF9E
         CCmnPwRvDNHL3N1cQnpF2U/tb4nh0MXGceV+j1rKF3vSd+RYAaARh+hzB521t8d4nQ1l
         kbUzE8jQIZ2xUZtL2bSaTVxv6Mbh7P3Tq7d9Pp8LF6jOp6X2lT46DVndzmowFfv/MKv9
         f+qzeDf6e0zlOTfiTWjd+QYKl8j8Y87y8kaHe0K0vaRNO24bQk+lSR9s3I0kV5HPLQA+
         sQGhUhbBZ4MTnxAr/FDcmAWSW9O13TM860x3Aiom2KpsijDwHrZK7BAdazy0rx1zuTPW
         uIDw==
X-Gm-Message-State: AOJu0YxGPZKu2Hnk3kI/yWCr3RdZNWww83JZYYEHuev8n0fNXIzOTGOh
	cl4YHC6LO1Vb/7NlhSmoMDIujfJIz7jMEzfId0zpq4Jjzw01Ig5LhEh+s+uiy7yooM9pNCKwkds
	BjoYr
X-Gm-Gg: ASbGnctMOMNNti1GXg8ZrL9IDJINR8eEaX8PTXZR5J6MmXcs5L5YNmIAyTlp4izApbc
	towuzMbptAi37aLq2wyc96CniGv9vaCOgq/aJOTbKxxpAzICuB9PFPBOBwIb/e5u9AU5G1oDZWZ
	1xv3587Py0JVc0b/A9iuTwu/uSlW/WVQ4IeWrGbVvueJlqeAnTBVooeVaj6Bo9ZEJEsGo2CmuCw
	As08T1r1BToy7WAwrl47uOyeSYazkvpmP2v07dxK1xBl2mrUz5odem+N+MV7g0arW2RsFz8I3l7
	R2/Sep82oeyJ42FdzBcNBA/Lquo9dTO+q7iM8FR4PJbPHwspGWRd3Gkt4CuZhYkZLMgLkb7e9DA
	60DhiW9EVy8Ow0jpTTajS4X5kHyqP7g==
X-Google-Smtp-Source: AGHT+IE7ZDaysgQNN1wkN4G+qEF3YH7l4o4PaKNg12w3foaV35blmkvIWwIDWkHwaUi8rU1AVrNRGg==
X-Received: by 2002:a05:6602:6003:b0:887:56b5:b502 with SMTP id ca18e2360f4ac-8ade016a376mr544038639f.10.1758289929048;
        Fri, 19 Sep 2025 06:52:09 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8a47d92185asm163228039f.14.2025.09.19.06.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 06:52:08 -0700 (PDT)
Message-ID: <7102d62a-bc57-4bd3-b74f-201a35c770c2@kernel.dk>
Date: Fri, 19 Sep 2025 07:52:07 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.17-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Set of fixes for io_uring that should go into the 6.17 kernel release.
This pull request contains:

- Fix for a regression introduced in the io-wq worker creation logic.

- Remove the allocation cache for the msg_ring io_kiocb allocations. I
  have a suspicion that there's a bug there, and since we just fixed one
  in that area, let's just yank the use of that cache entirely. It's not
  that important, and it kills some code.

- Treat a closed ring like task exiting in that any requests that
  trigger post that condition should just get canceled. Doesn't fix any
  real issues, outside of having tasks being able to rely on that
  guarantee.

- Fix for a bug in the network zero-copy notification mechanism, where a
  comparison for matching tctx/ctx for notifications was buggy in that
  it didn't correctly compare with the previous notification.

Please pull!


The following changes since commit 98b6fa62c84f2e129161e976a5b9b3cb4ccd117b:

  io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths (2025-08-28 05:48:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.17-20250919

for you to fetch changes up to 2c139a47eff8de24e3350dadb4c9d5e3426db826:

  io_uring: fix incorrect io_kiocb reference in io_link_skb (2025-09-19 06:00:57 -0600)

----------------------------------------------------------------
io_uring-6.17-20250919

----------------------------------------------------------------
Jens Axboe (2):
      io_uring: include dying ring in task_work "should cancel" state
      io_uring/msg_ring: kill alloc_cache for io_kiocb allocations

Max Kellermann (1):
      io_uring/io-wq: fix `max_workers` breakage and `nr_workers` underflow

Yang Xiuwei (1):
      io_uring: fix incorrect io_kiocb reference in io_link_skb

 include/linux/io_uring_types.h |  3 ---
 io_uring/io-wq.c               |  6 +++---
 io_uring/io_uring.c            | 10 ++++------
 io_uring/io_uring.h            |  4 ++--
 io_uring/msg_ring.c            | 24 ++----------------------
 io_uring/notif.c               |  2 +-
 io_uring/poll.c                |  2 +-
 io_uring/timeout.c             |  2 +-
 io_uring/uring_cmd.c           |  2 +-
 9 files changed, 15 insertions(+), 40 deletions(-)

-- 
Jens Axboe


