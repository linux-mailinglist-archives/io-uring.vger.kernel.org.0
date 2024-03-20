Return-Path: <io-uring+bounces-1162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E35B8819A9
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F200828294E
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943258595C;
	Wed, 20 Mar 2024 22:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fYkicoxY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3911E87E
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975478; cv=none; b=mOiY2MDv1+r8FAhJETAf12a2PCnMjTkRXQu7vUqVlgxdR9oLtI6Lf8ZORCxqIACn2vdloggmzuRZD2NwXNBaxVUFFd9yJHntRQBXVpu/LpshR6a5+cxws6NjlhappRwiQh0WhyLe8T7C/SJ1j29elMiEU07jM/rQO6rs9/XcJGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975478; c=relaxed/simple;
	bh=P5jfpCQFUm8Xvw7UTEmp4r5yzYpq1E4359TP0l6V1rU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rehDe63Ilit0BZ0eZz/bz+75SBsBQze0Hz8wFGDqNoij51/VdyOInF4eDsNRLaDoc5x9DTMVpSz+elqrrshqK8TXfI/2cpgXlxqbIBP4TAO8o+PvqG3VkA9OuALRNruDWr1Q5UEnNBZ4gY6I5hHK9G+NP8sNFT890tJvJdpUaoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fYkicoxY; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so2536839f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975473; x=1711580273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=C3fRx3UE+JuoYbO7jg/qdr9IREDLPlXFrTilr9o5FQA=;
        b=fYkicoxYU3c8BLm9or/3AG7aFPbd2frJzhW0AUXjlJema5UPyFXS6NjxTzgSf45lYr
         BHaPyungdtmRdNdU/OrPsJ3P1VrY5xE3s0uzpAI4SjXrd5B9Wq+xgOZGMDaRi9agqh2D
         6Nmkf+TrefGgjWTwzPcNuFL0nQgqdGUdcQyMhEsSftKftomzNjFvzlVThC5HdBW7njdh
         Oe0YOMegNLXm0MMiDxC6RHma5Em3xs+VDLy3cu/8LvgBzO9E+J/nLg3oOR055tYiqs9M
         myjPwUbslnadlmGu0BvUQIe5KhAaTnxqTv+pQDo9wYHW6K8aB+C1TNO6jJbRWFSlYvBw
         Mi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975473; x=1711580273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3fRx3UE+JuoYbO7jg/qdr9IREDLPlXFrTilr9o5FQA=;
        b=DxNYwNrpRJBExhQflncJOyxbht+7Gtd+E9zg2km51jtLzkDlITt3LvdvqEB8211ULw
         j02iMGs+pnoSNDNAoiTA0lQ6kzQm+Bj0+Q9/ulBMqgJ0uzm+tuTDicWJW6OpQcK8mRGJ
         yGY/TDLES7Pc/LMGR2UwquU2W3qQhc+hJUi4MWMBVjAOPWZw/5faUxLWsnbFXWl/x8VQ
         cWh99UKeRTzH2lqZ0A+Blhf+vf1Ef45AIIAoUngVkQJd16YdTZSG1VY8uM0UWoKNSBQ5
         9DmGsN6vrNlB+llb4PqCkaCFbK32lGpd9tspzpCQhdenrkqc2esPbxtxH0MYu6oSPDKE
         CApA==
X-Gm-Message-State: AOJu0Yya7Z5KYkV3HtjOTlwIbDW1h6vx28Y5BI/lNnqd3YiT7rIu48gE
	swWZcj44AMhoarrMsJn7USiwmWAzbytyvxH3t3nAiDH+FH6m1ugeP9oRmB8um2q8pnbsbA+wZXH
	k
X-Google-Smtp-Source: AGHT+IHOII3JUuJ44KdWGdtgED3uMIzeuDObsfwhCG0Hl4fUB+6iWQW2z2jKyysMjOF53STAW55RvA==
X-Received: by 2002:a5e:c10d:0:b0:7cf:28df:79e2 with SMTP id v13-20020a5ec10d000000b007cf28df79e2mr700463iol.1.1710975472963;
        Wed, 20 Mar 2024 15:57:52 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.57.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:57:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/17] Improve async state handling
Date: Wed, 20 Mar 2024 16:55:15 -0600
Message-ID: <20240320225750.1769647-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset gets rid of on-stack state, that is then fixed up and
copied if we need to go async. Having to do this fixup is nasty
business, and this is the main motivation for the change.

Opcodes are converted to setting up their async context at prep time,
which means that everything is stable beyond that. No more special
io_req_prep_async() handling, and no more "oops we can't proceed,
let's now allocate memory, copy state, and be ready for a retry".
By default, opcodes are now always ready for a retry, and the issue
path can be simplified. This is most readily apparent in the read/write
handling, but can be seen on the net side too.

Lastly, the alloc cache is rewritten to be array based rather than list
based. List based isn't a great choice, as grabbing an element from the
list also means you have to touch the next one.

With all of that, performance is as good as before, or better, and we
drop quite a bit of code.

The diffstat reflects that, but doesn't even tell the full story. Most
of the added lines are trivial, whereas some of the removed lines are
pretty hairy.

Changes since v1:
- Cleanups
- Switch connect to using io_async_msghdr, now it gets recycling
  too
- Avoid recycling for read/write if io-wq is used
- Fix errant io_async_rw shadowing in io_write()
- Change alloc_cache to be array based
- Fix KASAN issues. Not with mem reuse, but just errors in my
  implementation of it for the mempool.
- Only mark iovec caching as REQ_F_NEED_CLEANUP
- Shuffle some hunks around between patches
- Fix an issue with send zerocopy and iovec freeing
- Move connect to io_async_msghdr so it can tap into the recycling
- Actually delete struct io_rw_state, not just its elements
- Add uring_cmd optimization that avoids sqe copy unless needed
- Rebase on for-6.10/io_uring

 include/linux/io_uring_types.h |   4 +-
 io_uring/alloc_cache.h         |  51 ++--
 io_uring/futex.c               |  26 +-
 io_uring/futex.h               |   5 +-
 io_uring/io_uring.c            |  71 ++---
 io_uring/io_uring.h            |   1 -
 io_uring/net.c                 | 550 +++++++++++++++++----------------------
 io_uring/net.h                 |  27 +-
 io_uring/opdef.c               |  65 ++---
 io_uring/opdef.h               |   9 +-
 io_uring/poll.c                |  11 +-
 io_uring/poll.h                |   7 +-
 io_uring/rsrc.c                |   9 +-
 io_uring/rsrc.h                |   5 +-
 io_uring/rw.c                  | 570 +++++++++++++++++++++--------------------
 io_uring/rw.h                  |  25 +-
 io_uring/uring_cmd.c           |  75 ++++--
 io_uring/uring_cmd.h           |   7 +-
 18 files changed, 707 insertions(+), 811 deletions(-)

-- 
Jens Axboe


