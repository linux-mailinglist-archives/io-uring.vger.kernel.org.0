Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E8D34BA4C
	for <lists+io-uring@lfdr.de>; Sun, 28 Mar 2021 03:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhC1BCW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Mar 2021 21:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhC1BB4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Mar 2021 21:01:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACFCC0613B1
        for <io-uring@vger.kernel.org>; Sat, 27 Mar 2021 18:01:55 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h3so7427932pfr.12
        for <io-uring@vger.kernel.org>; Sat, 27 Mar 2021 18:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=eyL4y7J+sguIicsgUYHfgkDhUQoIalxnWBfG2EfxytA=;
        b=fX3BOBqExjNXL6EmkdjX1VcvtoV9E9R1PWvpXzSLleMft5UXpEHgx1z1jTBZa1suWq
         rks4OkDFyAupzSOHROcqYYDNTNtx6c1UtNnp+ldLm2bnPbsJ6xCDOqZ/fhKoSDcIORb6
         xLlzrBOn+MhkyhU6Ktf8JW9o6H+xs9W2AXjFtVy5iWmUCemB086xHgXs/Nh5ODpEbknW
         Nd3QGjDqYsjLhRqP3uA1lWLqXA55l4GGoAS209AbPkcfInP+29vWa2PlCXCNQ08lHhpu
         gfu0zHWo94TG6+vkcIs2bHIXcStHI9DF2JdB5ifVVnFC7V90M9NTjz5yqYxQ4y5fEu8s
         JeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=eyL4y7J+sguIicsgUYHfgkDhUQoIalxnWBfG2EfxytA=;
        b=fpD0RdAAtAvVpbMvroE2rbRSyonIbh5H+JZ75kbdUbNqL3JS9exKd27UKg9omdfGnv
         lHdEoaT/563/Q8ro5X7lfDTsXf5hJXGnURTbeYRAIVeAWPmbjnjSp4N7nViYe+NYpFUz
         VwYrVqWJOZTrZVp20Xjcqgq759dzPULIQYFepx3ZsanvIji9dvEvI5621D5+pyATyr1h
         U/NFriJ13PiOjrT2gBuuUzaLWq8S8S4aH7H2N612P4mbVEvQr8CkbbHHPzFxd73aqz9e
         BMf6PfbLK6byNH1NegQHa450wlJThQH29Rmje3O/9LMLJ90PK3bmOMlf2YCEqOAqNkwp
         ut7g==
X-Gm-Message-State: AOAM533slgM6W4Rw5/ZfC10+7AzXEjbu0CAaLY09/XmeTkg6hdi2Bl2a
        mdUmwaa8rmHYhxaX7kZP2frKoQ==
X-Google-Smtp-Source: ABdhPJx73kxUG3WJHrzZ2lSc8HYNHZkKzu6lSLl5J9vPnGlpgNQoeNJf6yRpsWFYE4INlRkZeMgvkw==
X-Received: by 2002:a65:4344:: with SMTP id k4mr18395508pgq.48.1616893314956;
        Sat, 27 Mar 2021 18:01:54 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id mm12sm11787671pjb.49.2021.03.27.18.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 18:01:54 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.12-rc5
Message-ID: <aa67d57a-ba51-f443-c0f2-43d455bff25c@kernel.dk>
Date:   Sat, 27 Mar 2021 19:01:53 -0600
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

- Use thread info versions of flag testing, as discussed last week.

- The series enabling PF_IO_WORKER to just take signals, instead of
  needing to special case that they do not in a bunch of places. Ends up
  being pretty trivial to do, and then we can revert all the special
  casing we're currently doing.

- Kill dead pointer assignment

- Fix hashed part of async work queue trace

- Fix sign extension issue for IORING_OP_PROVIDE_BUFFERS

- Fix a link completion ordering regression in this merge window

- Cancelation fixes

Please pull!


The following changes since commit 0031275d119efe16711cd93519b595e6f9b4b330:

  io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL (2021-03-21 09:41:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-03-27

for you to fetch changes up to 2b8ed1c94182dbbd0163d0eb443a934cbf6b0d85:

  io_uring: remove unsued assignment to pointer io (2021-03-27 14:09:11 -0600)

----------------------------------------------------------------
io_uring-5.12-2021-03-27

----------------------------------------------------------------
Colin Ian King (1):
      io_uring: remove unsued assignment to pointer io

Jens Axboe (9):
      io_uring: don't use {test,clear}_tsk_thread_flag() for current
      io-wq: fix race around pending work on teardown
      kernel: don't call do_exit() for PF_IO_WORKER threads
      io_uring: handle signals for IO threads like a normal thread
      kernel: stop masking signals in create_io_thread()
      Revert "signal: don't allow sending any signals to PF_IO_WORKER threads"
      Revert "kernel: treat PF_IO_WORKER like PF_KTHREAD for ptrace/signals"
      Revert "kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing"
      Revert "signal: don't allow STOP on PF_IO_WORKER threads"

Pavel Begunkov (9):
      io_uring: correct io_queue_async_work() traces
      io_uring: don't skip file_end_write() on reissue
      io_uring: fix provide_buffers sign extension
      io_uring: do ctx sqd ejection in a clear context
      io_uring: maintain CQE order of a failed link
      io_uring: fix timeout cancel return code
      io_uring: do post-completion chore on t-out cancel
      io_uring: don't cancel-track common timeouts
      io_uring: don't cancel extra on files match

 fs/io-wq.c       | 32 +++++++++++-------
 fs/io_uring.c    | 98 +++++++++++++++++++++++++++++---------------------------
 kernel/fork.c    | 16 ++++-----
 kernel/freezer.c |  2 +-
 kernel/ptrace.c  |  2 +-
 kernel/signal.c  | 20 +++++++-----
 6 files changed, 94 insertions(+), 76 deletions(-)

-- 
Jens Axboe

