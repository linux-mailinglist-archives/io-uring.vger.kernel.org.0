Return-Path: <io-uring+bounces-8246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F33AD036D
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 15:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF5723A2D51
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 13:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9D7284B41;
	Fri,  6 Jun 2025 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ol/LqPF9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE69F284674
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 13:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749217599; cv=none; b=hzeVKl0hhe2ZX5f843ziDFtBGJnexabWj09DGGXQ/xAU6Co/evkfPEgwW0EpT/f3RAJmHhlml45UOYDJdm9gRk4qXO9LZrLaw7pb8D+jgWgH5a4HFEmXm33+nnutEL4h3tBroqL1aQH94GpMTqElwaXgk8FRvJX9U/T3Gg/OdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749217599; c=relaxed/simple;
	bh=W6u4tfI6bzIyhA+7aUIB7pMXA2Y+g/bIOrYxy7JENuY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Lk5tWyOkzfOye5In9QUyp3/BBm6Grh/JjiaqJzy1d632ojV0+H9h5qqnfYThq/eTx8svPNoIovUQDZicnEjm0tyQQ2m4K/TKRisCp/eUfj20vKefTBSrD60E04E2WqDkIp+trChGxhkjYNM+1z7qaBil2vlNyg4YVs4D1VSIIfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ol/LqPF9; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d817bc6eb0so9949905ab.1
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 06:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749217595; x=1749822395; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ziD/bBO1TvUvx10/RW67l68T8jNfWCYHRJFpEKAugc=;
        b=ol/LqPF9StHpWMsEQwbAzIaFTgTq3KH8qVO1zNPTFbocN6hjiQ56HRg0s9OohWz7s3
         KBTYpAI0SO9pAvt5P1i61Jsyhg/LQS6o4Z05mt+L9w1I7dco8qhhDv5fbcQvMJVAEZjz
         +Av7niqIxdANZrwIvqngzjJCvKheUjGtBhKqkX4WePfGhWjur43ucf9ZcviRAUjgv4GH
         5Jd0QM2gl9TtzcWE9dpqcNKXoU2JGzMdWuGdkyF+skPdRDTHqat06YYUX0AkYbCF0vzK
         yO7se2Nj5sp3sWI7AnWgZToh6gjvYvBSoRV8as7gPdlhblltdGpYjoa4HuAVUGW/ELIz
         QzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749217595; x=1749822395;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7ziD/bBO1TvUvx10/RW67l68T8jNfWCYHRJFpEKAugc=;
        b=mAvlHPNVo4qSTlrlkYk1FhruwKFB44Y2fEzmXgSIcRr/n/ejBk/UX+qtuGgwVmA0IC
         h6XimsOsJAKu+HMwrutmV/v+pI+NjNit0h3bHyP8dTJTv+reoqs2xh/Wx1wLmZL9i1We
         bxovTCl0oEnL7iMTB38ZC1a8dpzlFF0QxIMrGakeGhzbR1wLNOPARBKSWmbt5SA6zbv2
         SGvfYDeGk4O6hFoKPdcpST0gHtrm4AWnkbqxYqyO5JUlQviD6JUM6AJvRe6WQTNOHjiw
         kjd7vKtMHI9BX/UCSZfBWvnLPm/Yz+m3+6L9nbgLEHF8lJVH+bMQ7k0KSjOnXQhSSIaU
         lyCA==
X-Gm-Message-State: AOJu0YzTw56jgIA1XJBAVUudQM0yFr02IHB9g+HnwTwbf+LA9xSJP055
	yTi/CvcbnjivdmpxF1WRFV/2KOr0/+ZQb7sAiH6EX7b9dvfljcPJas0OMB+o1JboyVFWUB6ZqX+
	ixDrm
X-Gm-Gg: ASbGnctgSlMvoq75fLAJZPbUovro6kuMxr2pGQqhy8A2Q3nrOj/A0mEXGz1gwyKM6oW
	kxM7dJL63TGFLdEiiSNugFAuWBvTm7gPLoISQBKD86NM4rZMzRIXlxMu7IHN3eB4Fbs2/74ZiN4
	sBf6o4k7nX0+PkqsouySyO7Wvb4AqzB8oC5jwoEuORaNphcMh7ArCC8vwb6M5zrF0OUN4tcyhA/
	s/8xXs58XaIOVFXqL/F7VfgqI68qRo1gktYLJ9o1IzDqG+Vvy+PGTYvWrq+xemQ1zGqHYRyElXX
	iU+3GO73TUaUOdmNM+ef1LcVaSVVlez4iRj0K1W5uZp8cXI=
X-Google-Smtp-Source: AGHT+IFdC3NQHPn62fA7YMjOiVbEjnEAH8nDhvpU8v9pEH1A0R2BezaezCTSLGF8JX6K91+CnJExDw==
X-Received: by 2002:a05:6e02:4408:10b0:3dd:d155:94cb with SMTP id e9e14a558f8ab-3ddd155975dmr13832125ab.7.1749217594689;
        Fri, 06 Jun 2025 06:46:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf244dd2sm4125045ab.42.2025.06.06.06.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 06:46:33 -0700 (PDT)
Message-ID: <11cd89b1-1650-4c73-b358-79ab4fe6916f@kernel.dk>
Date: Fri, 6 Jun 2025 07:46:33 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.16-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Followup small batch of fixes for io_uring that should go into the
6.16-rc1 kernel. This pull request contains:

- Fix for a regression introduced in this merge window, where the 'id'
  passed to xa_find() for ifq lookup is uninitialized.

- Fix for zcrx release on registration failure. From 6.15, going to
  stable.

- Tweak for recv bundles, where msg_inq should be > 1 before being used
  to gate a retry event.

- Pavel doesnt want to be a maintainer anymore, remove him from the
  MAINTAINERS entry.

- Limit legacy kbuf registrations to 64k, which is the size of the
  buffer ID field anyway. Hence it's nonsensical to support more than
  that, and the only purpose that serves is to have syzbot trigger long
  exit delays for heavily configured debug kernels.

- Fix for the io_uring futex handling, which got broken for
  FUTEX2_PRIVATE by a generic futex commit adding private hashes.

Please pull!


The following changes since commit 44ed0f35df343d00b8d38006854f96e333104a66:

  Merge tag 'irq-msi-2025-05-25' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2025-05-27 08:15:26 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.16-20250606

for you to fetch changes up to 079afb081c4288e94d5e4223d3eb6306d853c68b:

  io_uring/futex: mark wait requests as inflight (2025-06-04 10:50:14 -0600)

----------------------------------------------------------------
io_uring-6.16-20250606

----------------------------------------------------------------
Jens Axboe (4):
      io_uring/net: only consider msg_inq if larger than 1
      io_uring/kbuf: limit legacy provided buffer lists to USHRT_MAX
      io_uring/futex: get rid of struct io_futex addr union
      io_uring/futex: mark wait requests as inflight

Pavel Begunkov (3):
      io_uring/zcrx: init id for xa_find
      io_uring/zcrx: fix area release on registration failure
      MAINTAINERS: remove myself from io_uring

 MAINTAINERS         |  1 -
 io_uring/futex.c    | 11 ++++++-----
 io_uring/io_uring.c |  7 ++++++-
 io_uring/io_uring.h |  1 +
 io_uring/kbuf.c     | 17 +++++++++++++++--
 io_uring/kbuf.h     |  3 +++
 io_uring/net.c      |  4 ++--
 io_uring/zcrx.c     |  6 ++++--
 8 files changed, 37 insertions(+), 13 deletions(-)

-- 
Jens Axboe


