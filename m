Return-Path: <io-uring+bounces-8918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA2CB1EDA7
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2998F6264F5
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C79F286D6F;
	Fri,  8 Aug 2025 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cFh9rzLw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A54B23AB8A
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754673231; cv=none; b=Udnwl1TV1fowXWiM/BPzFgZ8yFiv0JVqzUPTxIZLX1hr4pxWeezvIumndJqCcQHt3+AGGF8Jt2GdTf4MM/QfuyfYzNoQ3rjIVZg3D7oGz5dE9LXmrFEAPOikXbJnNwMvha1/tnGZMGuOCZgl9ZobGSDBj1GtPGSLR5pklRs+P/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754673231; c=relaxed/simple;
	bh=R0o1UWO5feGAR508nFaUjzQUYJoY6KZu6SCMBKX0Sbk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=raLClMxxXwCSBdxAq6RPQfQKfjNAnhufbIZ2wB79xO0nYJBtc1SK45rV44CeHn26It5D7eLvtY+ShHnpt++uieANdYuYm69mJKopqgVw5vG09mncb8FGi/xJjqTxG9sdol9asc/V69++9DfEJHhL2BjYZ8lkl0/KI4ppDwy48kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cFh9rzLw; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-880f82dfc7fso154064439f.2
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754673227; x=1755278027; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1CL0bKnm+2YB4kSwKyB+L8cThARYOk9lV/gaeBBbgz4=;
        b=cFh9rzLwaXWaYYDDz8sET29vWGC8Gpz9M0ZuL6uqI+qAvz5e5hM+XAcExRiup78srk
         G1Xs1NQvjWSjDwO4SvulY690oevhoNTycNEaXCb3sxE9YuFH+kKtjLFDWFULsp9XIRwn
         kBenEvhme7/sJQn4OoN4Md7shC7ZNwcqPXuqW+N/7eNhZRM3PmnNvVoLZ4eWmQYjDQQv
         jB0qaIWynz8XJMdCLsGw9tU5iRnSoClv1CP14GUkGcF9KrmQp0+btIvDh88DYw00ppOU
         GWhJ/uiy+iNIMW9UqbLuiz3+3k3JRN4XCm908dfVZ9WzFkQSpWSR+cSQIgeA8JJlpdul
         EOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754673227; x=1755278027;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1CL0bKnm+2YB4kSwKyB+L8cThARYOk9lV/gaeBBbgz4=;
        b=vhA6ivG9ngSf6pJWnNYIZBEu0Wns7t12C/Ew1O/4A/EqvYRDKvLSsQUij2203olLC2
         mhj8vxXk6jZcx+Z6I/qjybtMcaEg7tO+VF7PnIVbLVwwPQN+BYx1vhyo+EMHZqxrDtwO
         sumcqzSh+AYWLfuR+txe6PYNvIDXAsQcAI4hDkKGwtmHMuW6UqUJgGugin59T3RuuZBd
         d5x2FdQJLvS65Oi7kfqGDN238ssiC5HdSgFD2DaHYDaHdn+JV3OftUDM+knuEsVC0ZwM
         0O7ChMxymNPOzw081WYg1zLnmx9bX9elfkgpCDy7esUYrJatylPVRX2IxGXkqxpni13C
         0Bag==
X-Gm-Message-State: AOJu0Yx9ZqJBoy289uxaKAu0LB3hwzYzyFvTLz6pjIOWv1XXONZ9cGSB
	MJbihV/aW1DhCxCD1mIKSd81nDvcmiEgB96Eu3dmvs56ii2Mu+WLPTwbzV8KBPLynwb7++lSJDC
	EumO7
X-Gm-Gg: ASbGncsjXUxCcZtEGyftsOBQoIwkTVC0ykoRJqAIipfu8bKDk5UeW+IeYqtx6GK1uEQ
	L38ng/FknXCRQqbN5kSgsHWexuYqGEddSc2MzhIcW1778f+Ez4YvS5F5s+7l1gberB/PvsEWG9Y
	EfcfoGr4v8AYNpbvqXm7/DjOIol01R/+1IB3IWjyOJzGLJwWeo88sGdKTmfPZm+tU6YF0v4rkZV
	aAnws/7r0dlk3y0/zUYpGrsNSxU48ZYwS7WSp5DPxRZtV3QDYF1HljYFYNKEbTXIVn8ND7B9Fdh
	FWhwnbP1jPPLka3j9PfIZl9x1Nl7h9sRhC4HSMKhfdMd9dJ5TLeAaZ/I3HVMLLt6fGYReMU0gGx
	ij6ajI+FD5AlUD1C7aKw=
X-Google-Smtp-Source: AGHT+IEqyiPALEYagGsV5DgiBCpudSx+KrSPRWp1ohJxWSNrrYnDluLc0wXTcrPysy0CP6pRqdpoMw==
X-Received: by 2002:a05:6602:1485:b0:87c:3d17:6608 with SMTP id ca18e2360f4ac-883f10e0b75mr676898839f.0.1754673227509;
        Fri, 08 Aug 2025 10:13:47 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f18b982csm70162239f.1.2025.08.08.10.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 10:13:46 -0700 (PDT)
Message-ID: <5ae36e4a-8839-4bb4-bd66-24367f161683@kernel.dk>
Date: Fri, 8 Aug 2025 11:13:46 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.17-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just two minor changes that should go into the 6.17-rc1 kernel release.
This pull request contains:

- Allow vectorized payloads for send/send-zc - like sendmsg, but without
  the hassle of a msghdr.

- Fix for an integer wrap that should go to stable, spotted by syzbot.
  Nothing alarming here, as you need to be root to hit this.
  Nevertheless, it should get fixed. FWIW, kudos to the syzbot crew for
  having much nicer reproducers now, and with nicely annotated source
  code as well. This is particularly useful as syzbot uses the raw
  interface rather than liburing, historically it's been difficult to
  turn a syzbot reproducer into a meaningful test case. With the recent
  changes, not true anymore!

Please pull!


The following changes since commit 4b290aae788e06561754b28c6842e4080957d3f7:

  Merge tag 'sysctl-6.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/sysctl/sysctl (2025-07-29 21:43:08 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.17-20250808

for you to fetch changes up to 33503c083fda048c77903460ac0429e1e2c0e341:

  io_uring/memmap: cast nr_pages to size_t before shifting (2025-08-08 06:35:14 -0600)

----------------------------------------------------------------
io_uring-6.17-20250808

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/memmap: cast nr_pages to size_t before shifting

Norman Maurer (1):
      io_uring/net: Allow to do vectorized send

 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/memmap.c             | 2 +-
 io_uring/net.c                | 9 +++++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

-- 
Jens Axboe


