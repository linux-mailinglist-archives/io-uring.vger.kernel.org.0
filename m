Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D9E418472
	for <lists+io-uring@lfdr.de>; Sat, 25 Sep 2021 22:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhIYUeV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Sep 2021 16:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhIYUeQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Sep 2021 16:34:16 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCEEC061740
        for <io-uring@vger.kernel.org>; Sat, 25 Sep 2021 13:32:40 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 134so17256887iou.12
        for <io-uring@vger.kernel.org>; Sat, 25 Sep 2021 13:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ckfczCHGDqt59fZ5lCWMQcI3McIvnEEzCZWdAIibj/M=;
        b=lQJ4FUC/v+1do2Fx5hMQmd3xbLQB+skGUqS/14rhVFXbevYyVkkiVw8lg6KDzvKF6n
         48m1+gKBIcEXTf62tAWJHicemcyDEqy+Y833wna0K+vfSApnnWvWKEiGKUU4dAGhcyeb
         p1EOXVHtJWm5xMSuqAknX4Bd+1tquQbWc7RIFFntGRxThPSQ3PMqo1FwC5wkvZ6Byl2H
         CIVsIRgQ9jE9+Kobl+To/ZJVxylVFSwmDohhjTy6VyGOF6tNdmRnxLT5CG3hH0DQjKXb
         Lkq1R0AdaUzsN7NJDl5zRq9q2WQdEm0QRBobBLOOD0I8uffd93zaCH3nYVEa8ptt0I4y
         Fg2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ckfczCHGDqt59fZ5lCWMQcI3McIvnEEzCZWdAIibj/M=;
        b=DiMIPRMvTpItJa69NEZNnI9pLulbk+US6JKg6p+nuXVJ/u/Zmubf/vvAODKgV1F7gN
         mtZ/Vp8FyCuKYhJtxrBB56EXYu2uid619ZRhjfkd1hLBKH81XMg54GCBEY9B4kZn5nHS
         EY7wpkKhhg6w0mBvmjesTNlsE3X6qxEo6d17F+5a3QdGYV+txm5SMWvLAZVeYe6GlUiI
         FdBs/xkbT28fOKAtPisrkQE8T/YmHiepnPCN0uwptpZTo6n73fbX4/oackiA1QKFUxWr
         J8gWQFuvPMFdXjcCImeuvNbV041n1rrrLqBV/CgGuaxgVvOTlYD3dbH60p47VoCJs1BM
         MBJg==
X-Gm-Message-State: AOAM533uMRcjFR8pcLSSdpmDk20ARd9vGi8nidsyLS3j1a4vjQKI8lto
        yFPhy+cYs4NoUVZAR5tlp81c2LRz1ZjMAA==
X-Google-Smtp-Source: ABdhPJyFtVL/sdWrz/JolYsbD/6+xI9eLF1dRM6v261tQAzwwBpy64zHkpMt0M7b9n2Vc6bUaLVt0Q==
X-Received: by 2002:a5d:8b59:: with SMTP id c25mr13887628iot.190.1632601960108;
        Sat, 25 Sep 2021 13:32:40 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y30sm6293512iox.54.2021.09.25.13.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 13:32:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.15-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
Date:   Sat, 25 Sep 2021 14:32:38 -0600
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

This one looks a bit bigger than it is, but that's mainly because 2/3 of
it is enabling IORING_OP_CLOSE to close direct file descriptors. We've
had a few folks using them and finding it confusing that the way to
close them is through using -1 for file update, this just brings API
symmetry for direct descriptors. Hence I think we should just do this
now and have a better API for 5.15 release. There's some room for
de-duplicating the close code, but we're leaving that for the next merge
window.

Outside of that, just small fixes:

- Poll race fixes (Hao)

- io-wq core dump exit fix (me)

- Reschedule around potentially intensive tctx and buffer iterators on
  teardown (me)

- Fix for always ending up punting files update to io-wq (me)

- Put the provided buffer meta data under memcg accounting (me)

- Tweak for io_write(), removing dead code that was added with the
  iterator changes in this release (Pavel)

Please pull!


The following changes since commit e4e737bb5c170df6135a127739a9e6148ee3da82:

  Linux 5.15-rc2 (2021-09-19 17:28:22 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-09-25

for you to fetch changes up to 7df778be2f61e1a23002d1f2f5d6aaf702771eb8:

  io_uring: make OP_CLOSE consistent with direct open (2021-09-24 14:07:54 -0600)

----------------------------------------------------------------
io_uring-5.15-2021-09-25

----------------------------------------------------------------
Hao Xu (3):
      io_uring: fix race between poll completion and cancel_hash insertion
      io_uring: fix missing set of EPOLLONESHOT for CQ ring overflow
      io_uring: fix potential req refcount underflow

Jens Axboe (4):
      io-wq: ensure we exit if thread group is exiting
      io_uring: allow conditional reschedule for intensive iterators
      io_uring: put provided buffer meta data under memcg accounting
      io_uring: don't punt files update to io-wq unconditionally

Pavel Begunkov (2):
      io_uring: kill extra checks in io_write()
      io_uring: make OP_CLOSE consistent with direct open

 fs/io-wq.c    |  3 ++-
 fs/io_uring.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 72 insertions(+), 16 deletions(-)

-- 
Jens Axboe

