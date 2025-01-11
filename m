Return-Path: <io-uring+bounces-5825-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA81A0A4B4
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 17:19:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDB4A18837C4
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 16:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE8B14EC7E;
	Sat, 11 Jan 2025 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UMTeRLU+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DE51474DA
	for <io-uring@vger.kernel.org>; Sat, 11 Jan 2025 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736612345; cv=none; b=KUKuhbFl7asuCh4/HuxRYAtPu2x9aQv8hgp1CCSAOeYnFd7n/LOyskEdB0URm9wBYGwvD4p6afr1Uh6XU3id4Qm5v96cPQ86Ypk58XLVKsB/EvvW/PyHH2Bfcm83WKSVcxUVmL6FCHOumwOlqywg0kZ+BVClN8YGSWRFC4/KRtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736612345; c=relaxed/simple;
	bh=7qk1VQCHF9JNjimOkMYiR+FckkirTXJbe+NuC/fCr9o=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=gT7vi1ziSUKHMvEMrI5WiYcrp4RQLEYzUKOWpD63cKBGX9nXcbTw7RqJTQN2gDs97Wd/9gkabgUCT6etbymxr78fnc5DvVgJoFjEB71fGwPMaQ6fHCphZ+gmQhCv4mrBi3QfITZ8iZb2tr1BwSrknX8Jt+kTcfoaowYheBixPc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UMTeRLU+; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844d555491eso95422639f.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jan 2025 08:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736612342; x=1737217142; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zEO3m+jEJhg44dkh8FUFi3GfLIvGTwXLQCaTEfgR2jI=;
        b=UMTeRLU+LPdwTmdyWKVgrltEF8dT8nkfJKrpFOemYyYW2pKfnPLIcYS9F2ot+sKWvY
         A2PSk/NNIl2/ICCqadXCNXh5dMR5zO10Jqa+v+2+l2aQ8KCBZoSC3j+adKl/rISIMDrE
         X2nq8VE4nx5faN1AjBr97sBUzYaY4DZ50TgxTZifcUIIM+GdL36hnWFvsenZOosUrwEd
         v3sK1x2a47l7bSJQl6xyCyNGRGN5XdwRUtJU5IJo0p9rfEpbP8HeQ9VKrWZIL9SbA0/Q
         NP0Fz1zvz49LedIYOcqv9OlZZ2FhOUhoygPYGwkNo5B0E/gBOxNxGt3CiWD1dZzCBtqe
         MuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736612342; x=1737217142;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zEO3m+jEJhg44dkh8FUFi3GfLIvGTwXLQCaTEfgR2jI=;
        b=pPzIfXHsFU/CP8VtrYu/u69uOoj8GyLJiN4a5KlN+cU7jHBtY/jsspL6UuTZPrPK9S
         7kHBnzwVgvZE3PDc+SHIHAfVOkBjPrlSH+5/ckTagMnWNzZyCCs9TrIxJOBaV10Vlycx
         niV0u0JStyhSU9yFJJz/JW1JEfg7NNEThlaXnpU6Fz2xmn3rXnu4sG8L0wFjQXoEqHuZ
         4U27Na9ppxTPObUx/VdIPT/EErohXaBYp3ZcFlFNQ3f6D5al44HS9yw5+c/eSE7cQVTo
         GWhKxOjLIfEXil56kwn4tT+/nIcYaX5vLu+qfWZvLAdBkEKJ+vOYz6VoloHYceDnBg38
         8Lxg==
X-Gm-Message-State: AOJu0YzNJFuS1gGCPZ2ywS1vscZ3kmPOM6elS+Tea/JAsP6FTkNB6Le3
	61dmxXDHzr1ZXE+lPG779UnpgrD68YRN7yqqYORklOTBa9GAMcfGpe+WZ++hBlTMHy+O1l3RWav
	p
X-Gm-Gg: ASbGncs79nqZjLxO3OXkR2WvOmGb6Qh42swLD7PAyl1kpw2TXBsHxZBUeR+XT0DwXNI
	Y5kVpGbvjyFswlII1LIQm0d+sPtl7M02mpD0VFcFQwBlK33+kYQkWlioEScQcccqPVM7qDxOHOt
	IB0ce54VBOAsCYXtCWkCyR++OmkpNTb3BVVh3oJEgQ1a71XsPkFcRlkzviVbhc6aau6uDcQKGnl
	l/iFL6ARzehBYs2TXDPBaatjceylh4N/l3ksFSIurgM4pDmtblsOw==
X-Google-Smtp-Source: AGHT+IHlWqX5+//GJlk5JRvp343h4AlH8fKmsRI2lADcaDuq80IPoCkCXFRszNejfiGGr4geAujJkw==
X-Received: by 2002:a05:6602:750a:b0:83b:28e2:4985 with SMTP id ca18e2360f4ac-84ce01e97bbmr1451561839f.12.1736612342294;
        Sat, 11 Jan 2025 08:19:02 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84d61fc811esm161612739f.42.2025.01.11.08.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2025 08:19:01 -0800 (PST)
Message-ID: <0733034c-a280-4846-a501-70262a76fe45@kernel.dk>
Date: Sat, 11 Jan 2025 09:19:00 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.13-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A set of minor fixes that should go into this release. This pull request
contains:

- Fix for multishot timeout updates only using the updated value for the
  first invocation, not subsequent ones.

- Silence a false positive lockdep warning 

- Fix the eventfd signaling and putting RCU logic

- Fix fault injected SQPOLL setup not clearing the task pointer in
  the error path

- Fix local task_work looking at the SQPOLL thread rather than just
  signaling the safe variant. Again one of those theoretical issues,
  which should be closed up none the less. 

Please pull!


The following changes since commit ed123c948d06688d10f3b10a7bce1d6fbfd1ed07:

  io_uring/kbuf: use pre-committed buffer address for non-pollable file (2025-01-03 09:38:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.13-20250111

for you to fetch changes up to bd2703b42decebdcddf76e277ba76b4c4a142d73:

  io_uring: don't touch sqd->thread off tw add (2025-01-10 14:00:25 -0700)

----------------------------------------------------------------
io_uring-6.13-20250111

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/eventfd: ensure io_eventfd_signal() defers another RCU period

Pavel Begunkov (4):
      io_uring/timeout: fix multishot updates
      io_uring: silence false positive warnings
      io_uring/sqpoll: zero sqd->thread on tctx errors
      io_uring: don't touch sqd->thread off tw add

 io_uring/eventfd.c  | 16 +++++++---------
 io_uring/io_uring.c |  5 +----
 io_uring/io_uring.h |  7 ++++---
 io_uring/sqpoll.c   |  6 +++++-
 io_uring/timeout.c  |  4 +++-
 5 files changed, 20 insertions(+), 18 deletions(-)

-- 
Jens Axboe


