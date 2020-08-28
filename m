Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861702561D0
	for <lists+io-uring@lfdr.de>; Fri, 28 Aug 2020 22:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgH1UD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Aug 2020 16:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgH1UD1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Aug 2020 16:03:27 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416BCC061264
        for <io-uring@vger.kernel.org>; Fri, 28 Aug 2020 13:03:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c142so1116851pfb.7
        for <io-uring@vger.kernel.org>; Fri, 28 Aug 2020 13:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=h7Ftm48B3zFmIS9M4aT7GVlSUnSM7LcCY/YqVFwhLHo=;
        b=XUd1hfAyoS3QpCSSDAtZZ4HWcuSrlNFYYcOyQBKSJodElFHPqQmepn/jSxfDhXtjph
         IMLLUf86iQd+mOQcSNo4mtJhoj+wykLrWjnJ+TQ5GessrrCwly5QOj92iAFong1Tu7yM
         cG8/D3zz7cai+Z5TdtOB3VPw6LVfosJU5uVBBKJig3gmXJxg76P88VpwTM4SR11yn7hL
         tbYigjN6TOgmffKRkck0h5OZPorG8r4cs1tzcXkRxPhTN11Ng5PBIxWWb5BhaX5Orpp5
         XyVCVKrZQKaPI1Zgrxou88EbFniVHY3NQdMDf6vTaw42heBSSFpQVrngznIShUAyaBQp
         PK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=h7Ftm48B3zFmIS9M4aT7GVlSUnSM7LcCY/YqVFwhLHo=;
        b=QmZbPtr7cVC0aplYgDw2BpgH+70X088YmneDnfuSA+e7rZOjlRbZaJ4uGhRTbhtaAl
         OmYRm9S5MiHcN9t6KtSkY926NumVAq4fUMI4QT48bvbAuAkJ2boafE0SK6/s+8KX7XqU
         zi8v/nLDnD7xR8sNcpiKHTwrZyGsNWEUPmAFCjmm9HtMpYe+SBbEPaR3+kWvq7j/0oS3
         U2vDWX6dceqLrk+hmrhnDHnXI8Hl/TeM52P9svfieR+/l4LSSwobPiHRQplDGHrHV1MU
         XVgp7OHIlNMLslFGhAqDDwZhQbSZguORwtKsXZopUITzLOlmkuZOWCzO9nZ6bpFk3fn6
         Wa8A==
X-Gm-Message-State: AOAM530HVEwBS8B05GIY6Chvh7e/fW5Vza5aIJCRXe95odaoQU7IphYz
        Bbezm5RadnWzeNxMWrvQVaTnNsM3JObl2sZj
X-Google-Smtp-Source: ABdhPJxSXzNhTuv3cHgMU3UDiBBvHEeMnOCm0dbPY8aUswPt0mPJGecOb/Hx4Q2e3wEFwkGsInCCGg==
X-Received: by 2002:a62:b608:: with SMTP id j8mr542187pff.126.1598645004641;
        Fri, 28 Aug 2020 13:03:24 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x1sm262394pfp.7.2020.08.28.13.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 13:03:23 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.9-rc3
Message-ID: <654bd4f0-7d2b-a39c-46ab-e7d180246bdd@kernel.dk>
Date:   Fri, 28 Aug 2020 14:03:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes in here, all based on reports and test cases from folks
using it. Most of it is stable material as well.

- Hashed work cancelation fix (Pavel)

- poll wakeup signalfd fix

- memlock accounting fix

- nonblocking poll retry fix

- Ensure we never return -ERESTARTSYS for reads

- Ensure offset == -1 is consistent with preadv2() as documented

- IOPOLL -EAGAIN handling fixes

- Remove useless task_work bounce for block based -EAGAIN retry 

Please pull!


The following changes since commit 867a23eab52847d41a0a6eae41a64d76de7782a8:

  io_uring: kill extra iovec=NULL in import_iovec() (2020-08-20 05:36:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-08-28

for you to fetch changes up to fdee946d0925f971f167d2606984426763355e4f:

  io_uring: don't bounce block based -EAGAIN retry off task_work (2020-08-27 16:48:34 -0600)

----------------------------------------------------------------
io_uring-5.9-2020-08-28

----------------------------------------------------------------
Jens Axboe (9):
      io_uring: don't recurse on tsk->sighand->siglock with signalfd
      io_uring: revert consumed iov_iter bytes on error
      io_uring: fix imbalanced sqo_mm accounting
      io_uring: don't use poll handler if file can't be nonblocking read/written
      io_uring: ensure read requests go through -ERESTART* transformation
      io_uring: make offset == -1 consistent with preadv2/pwritev2
      io_uring: clear req->result on IOPOLL re-issue
      io_uring: fix IOPOLL -EAGAIN retries
      io_uring: don't bounce block based -EAGAIN retry off task_work

Pavel Begunkov (1):
      io-wq: fix hang after cancelling pending hashed work

 fs/io-wq.c    | 21 +++++++++++--
 fs/io_uring.c | 99 ++++++++++++++++++++++++++++++++++-------------------------
 2 files changed, 76 insertions(+), 44 deletions(-)

-- 
Jens Axboe

