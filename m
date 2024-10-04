Return-Path: <io-uring+bounces-3420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CBD990730
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 17:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F79B28293E
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 15:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFC61AA78A;
	Fri,  4 Oct 2024 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B+kpyDDk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD20514A4F0
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728054658; cv=none; b=olBk6Lm10Mw6FUeu+oo8b5m0D28/H3UugqTxWPAk62+UihkJfnJMYuakXQv9MKbHKaqMZyEUaMMl78P2blLn7w2237p9lAMNu94dDa3e56tyAwrMfp1ebYMjVgSFf2TMqMTPWJ9lT7HPBalUfsaLnGv+rBd/UqA61f0O1dlo+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728054658; c=relaxed/simple;
	bh=ARqFmjtg0cRWFh+GPjHJ9u4M+aM3tOSBUFpO/5jdCTc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ti7xBHoVPXVbXRK+cMsIiFzzG75A9YPKBNypJ+yTPzroU9lqEheBk2a6otCb4rpFmO/dEYuRGoxMMwl0Qm0VDSezeksZsQHoa7bbYNSfdtBVZwz9DozgeU8cWq27qd6mh9kN8uekM7vFgCc9G/ezXmPhH7c1Gy/GHkRgVssg69g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B+kpyDDk; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-82cd872755dso100791539f.1
        for <io-uring@vger.kernel.org>; Fri, 04 Oct 2024 08:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728054655; x=1728659455; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNX4cqdN3Ei7rd/lKkYhj3rn3vPvrVr7u+If1NqJhZ8=;
        b=B+kpyDDkqMjRE0J7UOc1mi21mChjmo5FcyEG9jwSyNTz2KGVUCVBVA9/tNpHW17hv1
         nZy21/v2hPejMYikWarSgzs8PfsJwpcgvHUay1WI1UOl3RSfXAG857/n1NMxZwl7OuHN
         3Ube1SIIItKLanFFbhtx/zlDKFUPELXzaGApFe8emVVCoTAcZFXSwctzvxb6B2vVbcMQ
         PmTJHixi094WDO7Pf3VIoQX94B65EhTEhb9BE71K+s6WMJqjTiWbP9KETyY7E8Da2UxF
         xJmrvAtQsEY6WVGoC9ZVbV323/T80feQhHlBb/mOPmyhaCgP4ge5KESJT4oWZqT7JOyF
         bzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728054655; x=1728659455;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jNX4cqdN3Ei7rd/lKkYhj3rn3vPvrVr7u+If1NqJhZ8=;
        b=le6WFKoxCkF9c8U4qCaeiozv+kZ+xtgoKW3fx7O1Hz9Np6tCD0lvuj2ymmFcop+6tA
         FOiXKeEAxoR0bM3gd6YGRqtayzESPjFwFfQM1/DpUe3SEy6iYeFyLcTEhTgZMKgkXtmS
         TkHleBa++Yu8putwQc7up73adbUp11AEJWeXCzu60qZ7oSSwaMvfp90iRuhPrMmLdXMK
         oKeEsUoCPFu0uLOedE7DYtQlwwfn/ERscV41FdiMUJ1BsHrfNYZaQ3FJcZ0ri2yEsG2S
         pQOLcnU1doAEWAPX3NGkYgiok43pG5wTqHnIK15o8FqPkoubUU3PGlPnLTUlMqIgJ4VB
         r3Hw==
X-Gm-Message-State: AOJu0YxCdqy8QZm4bnLTQAy+a+rJwv9w4d2kPyZyTdZxB7liVt9TUWy8
	+1uqzIdMy5pFJmKygw7a8cPJNGtKi/woYth7c0qatwI34fG1qaoo9ruLbcxND5H1DL6z/nrLKJf
	/YsU=
X-Google-Smtp-Source: AGHT+IEcM2NhQkwFFqfDoxU87gwllZ9RZnnVnPBLqAAi8vYZRppZSajar22ANrrH2oy09vot0hB7ew==
X-Received: by 2002:a05:6602:14c1:b0:82a:2143:8 with SMTP id ca18e2360f4ac-834f7d65974mr440464239f.10.1728054654787;
        Fri, 04 Oct 2024 08:10:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db6eb36685sm12445173.33.2024.10.04.08.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 08:10:54 -0700 (PDT)
Message-ID: <08765cba-88f0-4439-ab81-ce949544cdc0@kernel.dk>
Date: Fri, 4 Oct 2024 09:10:53 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.12-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few minor fixes that should go into 6.12-rc2:

- Fix an error path memory leak, if one part fails to allocate.
  Obviously not something that'll generally hit without error injection.

- Fix an io_req_flags_t cast to make sparse happier.

- Improve the recv multishot termination. Not a bug now, but could be
  one in the future. This makes it do the same thing that recvmsg does
  in terms of when to terminate a request or not.

Please pull!


The following changes since commit 6fa6588e5964473356f0e2a02093ea42a5b3fd56:

  Merge tag 'sched_ext-for-6.12-rc1-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext (2024-09-24 11:33:50 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.12-20241004

for you to fetch changes up to c314094cb4cfa6fc5a17f4881ead2dfebfa717a7:

  io_uring/net: harden multishot termination case for recv (2024-09-30 08:26:59 -0600)

----------------------------------------------------------------
io_uring-6.12-20241004

----------------------------------------------------------------
Guixin Liu (1):
      io_uring: fix memory leak when cache init fail

Jens Axboe (1):
      io_uring/net: harden multishot termination case for recv

Min-Hua Chen (1):
      io_uring: fix casts to io_req_flags_t

 io_uring/io_uring.c | 7 +++++--
 io_uring/net.c      | 4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
Jens Axboe


