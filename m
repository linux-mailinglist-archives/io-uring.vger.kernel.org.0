Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DAB3397BE
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 20:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhCLTso (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 14:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbhCLTsc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 14:48:32 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969CBC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 11:48:32 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y67so2586862pfb.2
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 11:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=69h9s/OTEyM0gb9INZR+WZj2wRJHvFJXlOVpH6EP0rw=;
        b=DXXznV/F7UEVgY7Nz1QeNV2it1/S7+F87Hp2NKuOcTmfsQo23bk7uHh3tQBrF2fku2
         KBj6cN+UrhD2MjkhxaTdHgRK4HXLluTxZhLHI0WmrOdugfn1eRzAcrWtyKYY/7BUXuLi
         T1oAlXbdypMTyoOI5/mapJzaVx9Ozw0JC6dhOgPSHMdl2jFFpJtmJ2v3SwF4u/rxJdtI
         0s0r9sl1nCk594wTOzEQs7GFx9/3RGANTzu4eG7n+MfESfpJyeToRbhK5hFHngsOn7Vv
         imsE+YG30HVgk8TZWCu5CuuHBfNuXBhk+DLbsDdApWCfUt85Ru1bUFfzLgI+Ua/xaqa9
         TcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=69h9s/OTEyM0gb9INZR+WZj2wRJHvFJXlOVpH6EP0rw=;
        b=R4ku4K6Wk/B32serRDVC/LDwZDNLfXNg5vG1/v/l3aVr/hqsovf4jYlyJpnFbfIXbV
         FiUk6PgahW+iko0lsSzcnTcHLlrm77HhJy7ACGld460gjYGHI1hkIvP7zD76a6EppfBN
         s5qvpaenmWWKurPnePZOyE6eKy4DWac1Hh4lhmE+gAU22L3Ak6KCIWnGl+9jvb1blmiO
         qxmAhv5/CvK++cjbS3knXBv2Wk5pnjaBA9xLbD/YYJv5BmZ99Oiue8oLOFOj8FRF0Ln3
         DC/aU67b1xHlZAFaPldRc91sZz8WZgUnsqw3B7nswDjjKkKJ7BzvaRLV2hPeCs3eLO8u
         RH5w==
X-Gm-Message-State: AOAM532A3lEfRg89UqRlqjOEaoFmW0o7zBQ4u4iYXAjvEr0Vz89PRL9i
        iPJZJqqVCffN1mMrcipnBLvZoFrQbphwPw==
X-Google-Smtp-Source: ABdhPJx1NyOtHrh2MPE/mytf2b/80HMqa/Az50xUQUh2sWrZiPsya2yt/erODdBnc6Em1MyOjoLo3Q==
X-Received: by 2002:a65:6a48:: with SMTP id o8mr13130587pgu.424.1615578511687;
        Fri, 12 Mar 2021 11:48:31 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x14sm6440965pfm.207.2021.03.12.11.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 11:48:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.12-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
Date:   Fri, 12 Mar 2021 12:48:29 -0700
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

Not quite as small this week as I had hoped, but at least this should be
the end of it. All the little known issues have been ironed out - most
of it little stuff, but cancelations being the bigger part. Only minor
tweaks and/or regular fixes expected beyond this point.

- Fix the creds tracking for async (io-wq and SQPOLL)

- Various SQPOLL fixes related to parking, sharing, forking, IOPOLL,
  completions, and life times. Much simpler now.

- Make IO threads unfreezable by default, on account of a bug report
  that had them spinning on resume. Honestly not quite sure why thawing
  leaves us with a perpetual signal pending (causing the spin), but for
  now make them unfreezable like there were in 5.11 and prior.

- Move personality_idr to xarray, solving a use-after-free related to
  removing an entry from the iterator callback. Buffer idr needs the
  same treatment.

- Re-org around and task vs context tracking, enabling the fixing of
  cancelations, and then cancelation fixes on top.

- Various little bits of cleanups and hardening, and removal of now dead
  parts.

Please pull!


The following changes since commit a38fd8748464831584a19438cbb3082b5a2dab15:

  Linux 5.12-rc2 (2021-03-05 17:33:41 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-12

for you to fetch changes up to 58f99373834151e1ca7edc49bc5578d9d40db099:

  io_uring: fix OP_ASYNC_CANCEL across tasks (2021-03-12 09:42:56 -0700)

----------------------------------------------------------------
io_uring-5.12-2021-03-12

----------------------------------------------------------------
Jens Axboe (9):
      io-wq: fix race in freeing 'wq' and worker access
      io-wq: always track creds for async issue
      io_uring: SQPOLL parking fixes
      io-wq: remove unused 'user' member of io_wq
      io_uring: move all io_kiocb init early in io_init_req()
      io_uring: always wait for sqd exited when stopping SQPOLL thread
      kernel: make IO threads unfreezable by default
      io_uring: force creation of separate context for ATTACH_WQ and non-threads
      io_uring: perform IOPOLL reaping if canceler is thread itself

Matthew Wilcox (Oracle) (1):
      io_uring: Convert personality_idr to XArray

Pavel Begunkov (20):
      io_uring: make del_task_file more forgiving
      io_uring: introduce ctx to tctx back map
      io_uring: do ctx initiated file note removal
      io_uring: don't take task ring-file notes
      io_uring: index io_uring->xa by ctx not file
      io_uring: warn when ring exit takes too long
      io_uring: cancel reqs of all iowq's on ring exit
      io-wq: warn on creating manager while exiting
      io_uring: fix unrelated ctx reqs cancellation
      io_uring: clean R_DISABLED startup mess
      io_uring: fix io_sq_offload_create error handling
      io_uring: add io_disarm_next() helper
      io_uring: fix complete_post races for linked req
      io_uring: fix invalid ctx->sq_thread_idle
      io_uring: remove indirect ctx into sqo injection
      io_uring: cancel deferred requests in try_cancel
      io_uring: remove useless ->startup completion
      io_uring: prevent racy sqd->thread checks
      io_uring: cancel sqpoll via task_work
      io_uring: fix OP_ASYNC_CANCEL across tasks

Stefan Metzmacher (2):
      io_uring: run __io_sq_thread() with the initial creds from io_uring_setup()
      io_uring: kill io_sq_thread_fork() and return -EOWNERDEAD if the sq_thread is gone

Yang Li (1):
      io_uring: remove unneeded variable 'ret'

yangerkun (1):
      io-wq: fix ref leak for req in case of exit cancelations

 fs/io-wq.c               |  25 +-
 fs/io-wq.h               |   2 +-
 fs/io_uring.c            | 837 ++++++++++++++++++++++++++---------------------
 include/linux/io_uring.h |   2 +-
 kernel/fork.c            |   1 +
 5 files changed, 470 insertions(+), 397 deletions(-)

-- 
Jens Axboe

