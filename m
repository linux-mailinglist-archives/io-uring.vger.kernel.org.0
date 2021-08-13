Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FE93EBC5D
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 21:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhHMTC7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 15:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhHMTC7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Aug 2021 15:02:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4A8C061756
        for <io-uring@vger.kernel.org>; Fri, 13 Aug 2021 12:02:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso22026466pjb.2
        for <io-uring@vger.kernel.org>; Fri, 13 Aug 2021 12:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vy6MTwbbkSTZZwE46I6ZiRyYCFHHqWwDpjlEx38Rltc=;
        b=lRVAatBwmU3ElgjudxV0xPy0w78n4z2SCVZCX1NoG395kiUxi3DKxS76duTmJx0ypK
         uIcWoEn/wf1OUhwlGIQXSuDt869XnvCAKjE20L8QBpfp2d1vp0w771Bkq6Nmhg86fUwt
         xsB7SKtYiXDGFtObC6QcNW1dlz8HRORq29tUb6UW6nxaz6CK9Y21A1B4uzgHTj+ZP9bY
         /Kt4w1twmGV/KuHT64BTbFZ5wJaH++zFDh9Y/2Sl/AvHLJjSm/o5EydImB6Jxi8BtryL
         xk/u1/Mx61JOM/EgtgbOQK6YoiVVIVO8z40hwM0VWLe2rlouLwW3qrG2J1cgePsRNf6Z
         mOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vy6MTwbbkSTZZwE46I6ZiRyYCFHHqWwDpjlEx38Rltc=;
        b=Ex8JHIRQGNmhn8nU32/ZOg5LKqt1s0jyRy2zdZvd2s2g8KQnTAC7jMQhP/qfL5fhmz
         FpuCCQAzHmAIEOc+impiv/4oycWuckXsisfDRmdfVcz81uOgCR0UsK6ud4HXVc16YVyZ
         VWF8f9JRRixtyr7m1NLxOomDtmpcnIsd0axrPnZrZsahjyX5vbFBTr2kxrb17DCv2TRh
         LflfXyGceOpa6opYWgGMaCeIm1nQbJosh2VCgSrw9HmSgMr0OzEYw78i/7Q+5nP0xhIl
         hRaw93nvQASAkZFvKMONDjuEWCsaajQqZCc5qka0jcJPci1+AZo5TjfbH/EmvpGofPWE
         UHoA==
X-Gm-Message-State: AOAM5300xW3vSXkrs3D3ltxpcUWchjGfqxqaujoKgrtBohfBoX7pnP1D
        PabDCGjg9Bxk15etR820mZsHxu0S80vf0eTs
X-Google-Smtp-Source: ABdhPJyOfrnyitgRXgwk6Q7ww8pznKU/fgxWpHG4tc5t1bdDf4/CDUd7CCxHGEx3nPwLUbELEpWmig==
X-Received: by 2002:a62:ea0f:0:b029:319:8eef:5ff1 with SMTP id t15-20020a62ea0f0000b02903198eef5ff1mr3896774pfh.74.1628881351210;
        Fri, 13 Aug 2021 12:02:31 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 125sm3258682pfy.17.2021.08.13.12.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 12:02:30 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.14-rc6
Message-ID: <9eecad5d-8432-d9c3-770f-b4ae7aac13ec@kernel.dk>
Date:   Fri, 13 Aug 2021 13:02:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A bit bigger than the previous weeks, but mostly just a few stable bound
fixes. In detail:

- Followup fixes to patches from last week for io-wq, turns out they
  weren't complete (Hao)

- Two lockdep reported fixes out of the RT camp (me)

- Sync the io_uring-cp example with liburing, as a few bug fixes never
  made it to the kernel carried version (me)

- SQPOLL related TIF_NOTIFY_SIGNAL fix (Nadav)

- Use WRITE_ONCE() when writing sq flags (Nadav)

- io_rsrc_put_work() deadlock fix (Pavel)

Please pull!


The following changes since commit 21698274da5b6fc724b005bc7ec3e6b9fbcfaa06:

  io-wq: fix lack of acct->nr_workers < acct->max_workers judgement (2021-08-06 08:28:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-08-13

for you to fetch changes up to 8f40d0370795313b6f1b1782035919cfc76b159f:

  tools/io_uring/io_uring-cp: sync with liburing example (2021-08-13 08:58:11 -0600)

----------------------------------------------------------------
io_uring-5.14-2021-08-13

----------------------------------------------------------------
Hao Xu (2):
      io-wq: fix bug of creating io-wokers unconditionally
      io-wq: fix IO_WORKER_F_FIXED issue in create_io_worker()

Jens Axboe (3):
      io_uring: rsrc ref lock needs to be IRQ safe
      io_uring: drop ctx->uring_lock before flushing work item
      tools/io_uring/io_uring-cp: sync with liburing example

Nadav Amit (2):
      io_uring: clear TIF_NOTIFY_SIGNAL when running task work
      io_uring: Use WRITE_ONCE() when writing to sq_flags

Pavel Begunkov (1):
      io_uring: fix ctx-exit io_rsrc_put_work() deadlock

 fs/io-wq.c                   | 26 ++++++++++++++------
 fs/io_uring.c                | 58 ++++++++++++++++++++++----------------------
 tools/io_uring/io_uring-cp.c | 31 ++++++++++++++++++++---
 3 files changed, 75 insertions(+), 40 deletions(-)

-- 
Jens Axboe

