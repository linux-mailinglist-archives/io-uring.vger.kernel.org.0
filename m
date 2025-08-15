Return-Path: <io-uring+bounces-8978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 750B5B28290
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 17:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B05F91888E9F
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 15:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38631E9B3D;
	Fri, 15 Aug 2025 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bxzZBzV1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF9A19DFAB
	for <io-uring@vger.kernel.org>; Fri, 15 Aug 2025 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755270106; cv=none; b=KUi0W952vARNWednEO1PIMbbIdcmt+2lg6UjL1lRC3rvTpzMEYu/oVFA1v8+bUVd5TzxGKJ+q+yEZ6jFUO0h7wloPuBdrLvQ7d2r8jYHQYZ6mZY5d34+7oWncPrILyDY8gII3yNoM4My7tAp0uvm3gb+QyJBys9zTzzpG9G7Fxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755270106; c=relaxed/simple;
	bh=X3GcPSn7X371ROLmgR0KGSc+zfHhYVtGUHPS8bQV3Fw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=l8J9OPbMF1Mdw0ZdUN/fAOXAdJZ1Q5do7FRq60cvd2JVR7iC2+vsZIxWSNqoRgpbRLxSIufOc3aG6tnzT0muX3QTcXXsgQnDEmuainUT4TcQRz0JdZJBS8jsieK5+jHaAl4X3d8CN2H/my5FVzJSfS6zWjwMZ4dT25NxeHDy3sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bxzZBzV1; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-32326e5a623so1853481a91.3
        for <io-uring@vger.kernel.org>; Fri, 15 Aug 2025 08:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755270102; x=1755874902; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QgPP7rrng+sy4dcfBblvnjThKqdXt7Hn/5xhtB1OVM=;
        b=bxzZBzV1Y4AM7nFOsNeK3ChDtVDJId8bjAWljSNyECM8GPUY0/uDjGkkuDpV9VmSeG
         OtXAII9+RCkfAKdEy226c2h21Je3ELL4aS/snnpRbrtVxPobN1pb6+1lVRKGdt/wgMwq
         0/pF6eyZBy+v7sH+0ghCRdXzZSUHKEBToCI22yDg05cFleGslkO31keeVM9DjZa1wrRh
         eN4tkkpESpQ6r6Se7YlwoEMhqRoR8RzZ3YmJMsxuXVKHRT9mq9ORzRr7g1YcUm+GXAHn
         8YEDY+GMC3SGip6kKIBCKAM6LNbj9i0i1ssq7BG3y9qg6lfcGMWkZn1J/wA2IeozqEXK
         uOEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755270102; x=1755874902;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+QgPP7rrng+sy4dcfBblvnjThKqdXt7Hn/5xhtB1OVM=;
        b=VvCEo5PoaJI7LzKgjGMYlu0gNst9og7mCQCwI0HxEoNXHmVTh22tglT8ok2uhK7jmT
         ErOmo2d4oyvwu5DbXzJwIvthutbiMkQ0FCKmH2r8tFRzgLOOga6ocu3pG4BITMW0VNQP
         kUJlNLc688ZUXu7Ne3JjwvKHsbHaCcUXjb2GAb58FwN34yZwlC3zSW4a89TYMSboWcHu
         a2VCT1R6pTjdUviPQxSf9QojQ5yUwLblJsNR2Cs9vvvijN5R9d+i7UeuZC9pDWHz3J/Y
         OjYFMVlljzx8KTcgIWQgat3aj88JUzpmqVT5vSQTBYwRsnLO8rMwH2V+0//jKQ1xNJOA
         k5Qw==
X-Gm-Message-State: AOJu0YyiaxATO7fLk0zqXkhatzFREvk80MxvDIpq+GyTxPZ2q6hmpcOm
	SP4hBAoDc+jyzk5Mg4a+FMGJW1I3NhfV1hZEyiW4yRerWQf+3/8AXRiWjy5l3g7YscwTwIoDnal
	zaHQy
X-Gm-Gg: ASbGncv5oBMxMwyAvh7JdqV9XYci1myTtwpF8uzhekExhsZSM0lZ6VC8D73qjXv0VmB
	3TA8ghxMTHTzGOczmBS0nWcCkHKBbrj3SyJ1JrahkgMtyr1gSHrYqYfJ8Hwaa93eveNkFWXyhpT
	+QDOjNYF6vgEzcJlIuKKrxvl0HMwj9JGEbcCZ3XVXYXyHEFTo8vQJywqfqgk9XjvvZHBfQGqR/a
	ujk6KD13oEG8ohV5DLK+JwpFVF4UnWGHILA05lKP6fqSxWxr/5rC5CmIIhYhuVf1aE9ygbdpSWo
	UiIjf6qRbxlINBNFvvVMN+0PGNzvuwdPDU35jATlXqQY0RMkhkyOqBcqoMrKR1LVeOJt7o7xA4N
	VIUP1xPQjX4vRY2SyHXg=
X-Google-Smtp-Source: AGHT+IFQm9VmP8byb3xb6vz7CRxKRqr+O5+CtZEGijMhZQE6eic2iKaDWrccXPQDSVgLgJSPIulGEA==
X-Received: by 2002:a17:90b:540d:b0:312:f2ee:a895 with SMTP id 98e67ed59e1d1-32342103586mr3221445a91.31.1755270102244;
        Fri, 15 Aug 2025 08:01:42 -0700 (PDT)
Received: from [10.2.2.247] ([50.196.182.165])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b472d794a4fsm1485622a12.57.2025.08.15.08.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 08:01:41 -0700 (PDT)
Message-ID: <dc23ce94-35bb-4224-8b9f-2d456f05a561@kernel.dk>
Date: Fri, 15 Aug 2025 09:01:39 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.17-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two fixes that should go into the 6.17 kernel release:

- Tweak for the fairly recent changes of minimizing io-wq worker
  creations when it's pointless to create them.

- Fix for an issue with ring provided buffers, which could cause issues
  with reuse or corrupt application data.

Please pull!


The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.17-20250815

for you to fetch changes up to 9d83e1f05c98bab5de350bef89177e2be8b34db0:

  io_uring/io-wq: add check free worker before create new worker (2025-08-13 06:31:10 -0600)

----------------------------------------------------------------
io_uring-6.17-20250815

----------------------------------------------------------------
Fengnan Chang (1):
      io_uring/io-wq: add check free worker before create new worker

Jens Axboe (1):
      io_uring/net: commit partial buffers on retry

 io_uring/io-wq.c |  8 ++++++++
 io_uring/net.c   | 27 +++++++++++++++------------
 2 files changed, 23 insertions(+), 12 deletions(-)

-- 
Jens Axboe


