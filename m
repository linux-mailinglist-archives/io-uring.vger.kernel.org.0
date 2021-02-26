Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6A03269CA
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 23:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBZWFF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 17:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZWFE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 17:05:04 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2993CC061788
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 14:04:24 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id c10so9341912ilo.8
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 14:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=y4Bn4d4G0jBEfEdZQL1RwxrrBa1Rlgj+cTx3MutHj24=;
        b=EfonGLOftDf9q766gFu2nfe0tzcRMqPmZGoDRfAPSrllbzcUso/i6sTR4IMoPAB8EH
         90HDQQacxMHzfzaDFxhRnslOITnet5C2PFggTdV8/kcKtiQRoPbTI0zgKechMFifVf6K
         CUDfIlsBMd8arspav10tPdi2YlQBB4qWSRD3C6FVdZhtCBwg5hLTep2DKcF/o7blG7WT
         r98ZcQ0XGOkwwREMXVqPoCL7iv0DjhnRmOukC4dPU3P3LApexax8m08Ek9CEexSR005o
         eoYqPKCSo4oO9cr/nqlvmR2v/35iTIRlGYYAjogyV8+y5HQixh06go6QEu5mdo/0JLeh
         n6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=y4Bn4d4G0jBEfEdZQL1RwxrrBa1Rlgj+cTx3MutHj24=;
        b=oh3yaRYo0uwL061N+06ZcZF2bMxHZp/N6yS7bn+AOB9uosWI+a9uodlpuL7C9yVT6q
         L/VQzvLfj7TbAiW5Kd9Q8yQ3ztkByl9x7uL6ZrfcKtTgr3xjDJY4+eGDOWNYzACd8OXQ
         gqPe/58BS8AF7AZ1cLzljPNszT0Y+iqU4Vs8+A5h+RqqJOhTMCswuUPZp/LWkzvXDRpm
         VDnjceUAnTG3LMGnwSUABe0Q6rhdcMTcMaoWlB6FWDV1S3Tnae9TO5ORbJjskTbwfYwN
         5RGR8lnXRsa03pVMMo87YVaARQ7GAbPNL8AivXuqrqCmp53gL/1yrK7Zytk8cj6mgA1W
         g1rg==
X-Gm-Message-State: AOAM530YPbJjiWc9LYl7X0jHalv/mmP3q+PebZZ47AOTgMJP80JdH4iP
        6QhXvwRxT27qmBwIMKTrmR/Ayy4QqW+wpY7/
X-Google-Smtp-Source: ABdhPJyBf7CwXU/vkoBMV+NOuTnWbY21ivmCczAd0ScvKanP77flpAlbo6Rm2tkuLxBBceF5YvzCwg==
X-Received: by 2002:a05:6e02:1aab:: with SMTP id l11mr4252049ilv.300.1614377062713;
        Fri, 26 Feb 2021 14:04:22 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b5sm5956511ioq.7.2021.02.26.14.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 14:04:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring thread worker change
To:     torvalds@linux-foundation.org
Cc:     io-uring@vger.kernel.org
Message-ID: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
Date:   Fri, 26 Feb 2021 15:04:20 -0700
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

As mentioned last week, I'm sending the series on converting the io-wq
workers to be forked off the tasks in question instead of being kernel
threads that assume various bits of the original task identity. This is
on top of the for-5.12/io_uring branch I sent out yesterday, which I
think you've merged but just haven't pushed out yet.

This kills > 400 lines of code from io_uring/io-wq, and it's the worst
part of the code. We've had several bugs in this area, and the worry is
always that we could be missing some pieces for file types doing unusual
things (recent /dev/tty example comes to mind, userfaultfd reads
installing file descriptors is another fun one... - both of which need
special handling, and I bet it's not the last weird oddity we'll find).
With these identical workers, we can have full confidence that we're
never missing anything. That, in itself, is a huge win. Outside of that,
it's also more efficient since we're not wasting space and code on
tracking state, or switching between different states.

I'm sure we're going to find little things to patch up after this
series, but testing has been pretty thorough, from the usual regression
suite to production. Any issue that may crop up should be manageable.
There's also a nice series of further reductions we can do on top of
this, but I wanted to get the meat of it out sooner rather than later.
The general worry here isn't that it's fundamentally broken. Most of the
little issues we've found over the last week have been related to just
changes in how thread startup/exit is done, since that's the main
difference between using kthreads and these kinds of threads. In fact,
if all goes according to plan, I want to get this into the 5.10 and 5.11
stable branches as well.

That said, the changes outside of io_uring/io-wq are:

- arch setup, simple one-liner to each arch copy_thread()
  implementation.

- Removal of net and proc restrictions for io_uring, they are no longer
  needed or useful.

I'm leaving this to you if you're OK pulling it for this release, I'm
obviously in favor of doing so since I'm sending it to you. It'll help
me sleep better at night, and provide a *much* saner base for async
offload going forward. A bit of potential pain in the rc cycle is
totally worth it imho.


The following changes since commit b6c23dd5a483174f386e4c2e1711d9532e090c00:

  io_uring: run task_work on io_uring_register() (2021-02-21 17:18:56 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-worker.v3-2021-02-25

for you to fetch changes up to d6ce7f6761bf6d669d9c74ec5d3bd1bfe92380c5:

  io-wq: remove now unused IO_WQ_BIT_ERROR (2021-02-25 10:19:43 -0700)

----------------------------------------------------------------
io_uring-worker.v3-2021-02-25

----------------------------------------------------------------
Jens Axboe (31):
      Merge branch 'for-5.12/io_uring' into io_uring-worker.v3
      io_uring: remove the need for relying on an io-wq fallback worker
      io-wq: don't create any IO workers upfront
      io_uring: disable io-wq attaching
      io-wq: get rid of wq->use_refs
      io_uring: tie async worker side to the task context
      io-wq: don't pass 'wqe' needlessly around
      arch: setup PF_IO_WORKER threads like PF_KTHREAD
      kernel: treat PF_IO_WORKER like PF_KTHREAD for ptrace/signals
      io-wq: fork worker threads from original task
      io-wq: worker idling always returns false
      io_uring: remove any grabbing of context
      io_uring: remove io_identity
      io-wq: only remove worker from free_list, if it was there
      io-wq: make io_wq_fork_thread() available to other users
      io_uring: move SQPOLL thread io-wq forked worker
      Revert "proc: don't allow async path resolution of /proc/thread-self components"
      Revert "proc: don't allow async path resolution of /proc/self components"
      net: remove cmsg restriction from io_uring based send/recvmsg calls
      io_uring: flag new native workers with IORING_FEAT_NATIVE_WORKERS
      io-wq: remove nr_process accounting
      io_uring: cleanup ->user usage
      arch: ensure parisc/powerpc handle PF_IO_WORKER in copy_thread()
      io_uring: ensure io-wq context is always destroyed for tasks
      io-wq: fix races around manager/worker creation and task exit
      io-wq: fix race around io_worker grabbing
      io-wq: make buffered file write hashed work map per-ctx
      io_uring: ensure SQPOLL startup is triggered before error shutdown
      io-wq: improve manager/worker handling over exec
      io_uring: fix SQPOLL thread handling over exec
      io-wq: remove now unused IO_WQ_BIT_ERROR

 arch/alpha/kernel/process.c      |    2 +-
 arch/arc/kernel/process.c        |    2 +-
 arch/arm/kernel/process.c        |    2 +-
 arch/arm64/kernel/process.c      |    2 +-
 arch/csky/kernel/process.c       |    2 +-
 arch/h8300/kernel/process.c      |    2 +-
 arch/hexagon/kernel/process.c    |    2 +-
 arch/ia64/kernel/process.c       |    2 +-
 arch/m68k/kernel/process.c       |    2 +-
 arch/microblaze/kernel/process.c |    2 +-
 arch/mips/kernel/process.c       |    2 +-
 arch/nds32/kernel/process.c      |    2 +-
 arch/nios2/kernel/process.c      |    2 +-
 arch/openrisc/kernel/process.c   |    2 +-
 arch/parisc/kernel/process.c     |    2 +-
 arch/powerpc/kernel/process.c    |    2 +-
 arch/riscv/kernel/process.c      |    2 +-
 arch/s390/kernel/process.c       |    2 +-
 arch/sh/kernel/process_32.c      |    2 +-
 arch/sparc/kernel/process_32.c   |    2 +-
 arch/sparc/kernel/process_64.c   |    2 +-
 arch/um/kernel/process.c         |    2 +-
 arch/x86/kernel/process.c        |    2 +-
 arch/xtensa/kernel/process.c     |    2 +-
 fs/io-wq.c                       |  621 ++++++++---------
 fs/io-wq.h                       |   35 +-
 fs/io_uring.c                    | 1088 +++++++++++-------------------
 fs/proc/self.c                   |    7 -
 fs/proc/thread_self.c            |    7 -
 include/linux/io_uring.h         |   22 +-
 include/linux/net.h              |    3 -
 include/linux/sched.h            |    3 +
 include/uapi/linux/io_uring.h    |    1 +
 kernel/ptrace.c                  |    2 +-
 kernel/signal.c                  |    4 +-
 net/ipv4/af_inet.c               |    1 -
 net/ipv6/af_inet6.c              |    1 -
 net/socket.c                     |   10 -
 38 files changed, 716 insertions(+), 1137 deletions(-)

-- 
Jens Axboe

