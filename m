Return-Path: <io-uring+bounces-2645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9BF9463E7
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 21:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AA1F1C20DAB
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 19:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C1915C144;
	Fri,  2 Aug 2024 19:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hLI5dcb4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C4F25632
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 19:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722627006; cv=none; b=Ft2Z925pyBgApbU5pad54RN26eDS1OHR7Az2749mxa2Y8IKOXUSbkFysTWyMn52yD04hVHgZ3yayQvTUNyvS1O4qqjtXo9q7vRKsHiBxPFp/4YsbuqVOBJee6Bc/5BPS0alUa5xEhkG4ZcVN11vuwXSQSauCTKxD/OvEm5bT3nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722627006; c=relaxed/simple;
	bh=C9mzieJT1C9rlXf4CrhnXEaLOAXd0TGEUmhLAX/Hg3E=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=eVObwBym3CfJp8o7xiGGygymDCsVYeE+SRLpIbtZBJiKHfi3E9jUZZW9X5zwDbOATjfoIoszZ2rmzufFYmlIcqIXgvm0KoDiKmQRycnylJs84TpDs6Vm1/ayQDzG3r99Gm4HCj2y9YDXKxy5xQuePNS8NmWIXVGRfJOyLesKn6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hLI5dcb4; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-39b0826297bso1748865ab.2
        for <io-uring@vger.kernel.org>; Fri, 02 Aug 2024 12:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722627000; x=1723231800; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9O7cVV7q/YD6E4sjLZ8hRIxdJbwXlab9Imh3alm/jY=;
        b=hLI5dcb44Oh/Rz1nM3OWI3zafkOqvPlHtA2FA+hzkGIZXx8vf0NU3lS3V80FqkHonr
         ClpJEHNJTpiy4kwK3Y+pdsq97JYH3DN1CfkXvMQ3sYcmnysK2N6T9Ls+kS3Z79HqRqA0
         Gr+uCC+rCDyuKvcdQTSKycqTwnsnfD1FnKzS8agHdgJk5Pr0G9anfHPJbitgh6WDAGE7
         5W0I4QcvaNGVoINjfyWWLKFiqBGwLGqZd9z6HXjvduP55zm6on1l2fl1+bbb2JESBm1X
         ekLMPslJqbATS+Zml4ZNmP2b9jkJHo7Ye9dFy2gSUgwXuC7DGynzRnN5yZwNcfmxUaw0
         PsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722627000; x=1723231800;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=a9O7cVV7q/YD6E4sjLZ8hRIxdJbwXlab9Imh3alm/jY=;
        b=K/U+bS5kyq1px7ES+0hIlVZVK6VbxyDkzGzLB7HCM0zRfYXGAnB7bhaja4Lq801vNE
         fMwZbPh5lqM4Z9acNAS8PNjnyoRIUfj8An8iej/EcnOuORnnC/I4tacCHiG4jnojLfAc
         izyQhAwUc2owoNLiHrZuI7N0jFkylt82KFB2dGSJyFi7/WmS93x2g3E3lx03bw16ROYb
         UOKtRINKZSMzhrV8uVD3wN4QRGkBj8u720YUiCkNRwGPDIygT5RR2M/q+VvU4h1fihar
         y+VB1m2mrUjX69AYrYmdtE5lXlqYxflcKgMM4D8IRxSS90wSoS/mR1ZhYbwXqgHI9ukk
         xCSw==
X-Gm-Message-State: AOJu0YwxLZaEq69t8ziYYrzCEsOFTPnRnJd1eATQApx/fzYDX2Lc2KdA
	a2FpIgh+5ClP0/b+7I3HY5lTuotL+UNwY7tOSFWC0Snt29km4l7iiTA3Q1JFUrN5D4cl6h8mdBI
	e
X-Google-Smtp-Source: AGHT+IGx459Mkr8demHb7n6Lj5Bxwf7we5ni4LygKvDSxy83iXZfPBT2q6VGjR1j/7XxDeiY1e/Zmw==
X-Received: by 2002:a05:6e02:1d05:b0:39a:e7b0:78b0 with SMTP id e9e14a558f8ab-39b1f78a161mr36472735ab.0.1722627000586;
        Fri, 02 Aug 2024 12:30:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39b20aaaf79sm9574295ab.26.2024.08.02.12.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Aug 2024 12:29:59 -0700 (PDT)
Message-ID: <acefe232-8ea3-4961-9d27-67222d5d9e16@kernel.dk>
Date: Fri, 2 Aug 2024 13:29:58 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.11-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two minor tweaks for the NAPI handling, both from Olivier:

- Kill two unused list definitions

- Ensure that multishot NAPI doesn't age away

Please pull!


The following changes since commit 358169617602f6f71b31e5c9532a09b95a34b043:

  io_uring/napi: pass ktime to io_napi_adjust_timeout (2024-07-26 08:31:59 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.11-20240802

for you to fetch changes up to c3fca4fb83f7c84cd1e1aa9fe3a0e220ce8f30fb:

  io_uring: remove unused local list heads in NAPI functions (2024-07-30 06:20:20 -0600)

----------------------------------------------------------------
io_uring-6.11-20240802

----------------------------------------------------------------
Olivier Langlois (2):
      io_uring: keep multishot request NAPI timeout current
      io_uring: remove unused local list heads in NAPI functions

 io_uring/napi.c | 2 --
 io_uring/poll.c | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
Jens Axboe


