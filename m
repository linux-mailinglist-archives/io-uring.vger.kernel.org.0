Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA31401136
	for <lists+io-uring@lfdr.de>; Sun,  5 Sep 2021 20:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhIESwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Sep 2021 14:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhIESwS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Sep 2021 14:52:18 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403EEC061575
        for <io-uring@vger.kernel.org>; Sun,  5 Sep 2021 11:51:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id pi15-20020a17090b1e4f00b00197449fc059so373184pjb.0
        for <io-uring@vger.kernel.org>; Sun, 05 Sep 2021 11:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZZPMwc/C3BYZ8H/Zhi3U90mS6EtyZwNIOkRSfnfgWwU=;
        b=CdZreQt5enNCZrVr0YD0by0WMKyr055EnvywOIBKv69ORrF4SEOGFqNssxqWIcK3SZ
         CCEW10AQ77BnQrFwkb8NJUtDvzXSsOSFbKcWquNyOFnwuaZ7ckFSO2pxjTAXgqWfbkeA
         Z+cNAUxDWHr1gXbSdNcmFobwkVH0nWyRlSdCy3qRaKO67zH1m9OeLO28jFhXmvgO4v+U
         tQw2GenCnERCfY8LkMaTf0EB4DK/B3Q91STPjCoj9YmF6veZcM//tP99VYwt+yV4hyGE
         CUHHU+vqKWI67ve0oBQAT+63edqCNTFEKIjZp8wjfDr/0uhsMbY0g1XrqMPq413kzbvD
         zO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZZPMwc/C3BYZ8H/Zhi3U90mS6EtyZwNIOkRSfnfgWwU=;
        b=muGf53+BgNM1e3c5a28Lso+zs94cFwLsZ43gZaYOQ4+0AlysIqk1b4OMygcL0Fm7se
         NzLh4ASby7ALJMZcg5F9SZ8Cmgr9yNuficbt1UNk7sFm4oOUZIhs5b5DhrzBCy0HMVYE
         o7Ef04J1QVIa74amOBXPjZqqAksYn9w5rIk3CWlxb8DUOeUKkzXDcQIk1QKfkeBdS4OW
         UNGQuf/C9sg5z/X02JsbmHryeYNDSbIOubMxeegvChzAVtiNoEZ8NmcK8jBlZJxp/0bI
         ainDjkWDFglrmkxMupdEs/Ncpr0dkobt7JGWgDx5TBthQg0SQstmQE0u8FcZxE4g4Bgi
         zKVw==
X-Gm-Message-State: AOAM5312e55Key7VCXXfTjuY6tiiPhlWpnlfQU76AJ37ABW2acBObiJg
        g+pIF+6H76nVuc3HvH7vAAFf1fQkyZWlpg==
X-Google-Smtp-Source: ABdhPJy5+65oe0q2j1/lRpO1LXRyaGIGfzpUhhF+wtvbQhtplyGkvMsQCqxj4L7bepsf/7IIzGSxiw==
X-Received: by 2002:a17:90b:1645:: with SMTP id il5mr10182333pjb.57.1630867873345;
        Sun, 05 Sep 2021 11:51:13 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id k25sm5076094pfa.213.2021.09.05.11.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 11:51:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring fixes for 5.15-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <625ed118-a5f0-781b-fb98-b555899f2732@kernel.dk>
Date:   Sun, 5 Sep 2021 12:51:12 -0600
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

As it sometimes happens, a two reporst came in around the merge window
open that led to some fixes. Hence this one is a bit bigger than usual
followup fixes, but most of it will be going towards stable, outside of
the fixes that are addressing regressions from this merge window. In
detail:

- postgres is a heavy user of signals between tasks, and if we're
  unlucky this can interfere with io-wq worker creation. Make sure we're
  resilient against unrelated signal handling. This set of changes also
  includes hardening against allocation failures, which could previously
  had led to stalls.

- Some use cases that end up having a mix of bounded and unbounded work
  would have starvation issues related to that. Split the pending work
  lists to handle that better.

- Completion trace int -> unsigned -> long fix

- Fix issue with REGISTER_IOWQ_MAX_WORKERS and SQPOLL

- Fix regression with hash wait lock in this merge window

- Fix retry issued on block devices (Ming)

- Fix regression with links in this merge window (Pavel)

- Fix race with multi-shot poll and completions (Xiaoguang)

- Ensure regular file IO doesn't inadvertently skip completion batching
  (Pavel)

- Ensure submissions are flushed after running task_work (Pavel)

Please pull!


The following changes since commit 87df7fb922d18e96992aa5e824aa34b2065fef59:

  io-wq: fix wakeup race when adding new work (2021-08-30 07:45:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.15/io_uring-2021-09-04

for you to fetch changes up to 2fc2a7a62eb58650e71b4550cf6fa6cc0a75b2d2:

  io_uring: io_uring_complete() trace should take an integer (2021-09-03 16:59:06 -0600)

----------------------------------------------------------------
for-5.15/io_uring-2021-09-04

----------------------------------------------------------------
Jens Axboe (10):
      io-wq: fix race between adding work and activating a free worker
      io_uring: IORING_OP_WRITE needs hash_reg_file set
      io-wq: ensure that hash wait lock is IRQ disabling
      io-wq: fix queue stalling race
      io-wq: split bounded and unbounded work into separate lists
      io-wq: only exit on fatal signals
      io-wq: get rid of FIXED worker flag
      io-wq: make worker creation resilient against signals
      io_uring: ensure IORING_REGISTER_IOWQ_MAX_WORKERS works with SQPOLL
      io_uring: io_uring_complete() trace should take an integer

Ming Lei (1):
      io_uring: retry in case of short read on block device

Pavel Begunkov (4):
      io_uring: fix queueing half-created requests
      io_uring: don't submit half-prepared drain request
      io_uring: don't disable kiocb_done() CQE batching
      io_uring: prolong tctx_task_work() with flushing

Xiaoguang Wang (1):
      io_uring: fix possible poll event lost in multi shot mode

 fs/io-wq.c                      | 424 ++++++++++++++++++++++++----------------
 fs/io_uring.c                   |  76 ++++++-
 include/trace/events/io_uring.h |   6 +-
 3 files changed, 323 insertions(+), 183 deletions(-)

-- 
Jens Axboe

