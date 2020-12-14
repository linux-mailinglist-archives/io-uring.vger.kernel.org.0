Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80632D9A36
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 15:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgLNOmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 09:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440072AbgLNOme (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 09:42:34 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D809C0613D3
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 06:41:53 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id p187so17059888iod.4
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 06:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kTNDBm7c6GOcQoZ/1zUAOG84dY4OMBXCFN+b2dBa+QY=;
        b=jq75RGY/imY/3jNGHvA7dSXnYrfKCAfZwSBrzPbf0f86RZUaj3Ztr+0pU/UA5ySmLs
         R5C7KD8KhZO7Kv6OdDpdLpQddCylrvW6uxZUqZ9fRu6nkdtqQKK4XJ2wtEmFdJwy2k+P
         RYQ5PmLL2FEId35Uf5DcWFmeuetY17PPT5pFD0fpNa8F3IBRQGZ/QS5mWBICIdhck0Ao
         xsdyckhYEwdZyeukB5RNL5+kBnzolSm1S0FKdPiSjx25j6PijSNCJ6tGtWpieGMJNuGK
         HeTFjGPmbZC/Qi9MbuZBC93Rr9yGMdZvEm7WP9C0GlM6JVoClnl4dMXOuLcwDxXIXAOa
         EbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kTNDBm7c6GOcQoZ/1zUAOG84dY4OMBXCFN+b2dBa+QY=;
        b=cVGaj0IhIdo2CbKEJrUm0k+AFTPqzJ/yHe3usH1kNUkdkiFR99QOqwWgveVxoBnzab
         fndoi8AjgkfDrM10/qk2hseYHJmoOxSoTZbDSNY0VhuERgPPInZnWk/vV2SY38E4tWEI
         q7QNI/NUokKE+/3zJ8cyG9iUPNVATKUl9hp+joD1L+EsSElySqfA9sfst3faAPNLuP+9
         ZzZRxrziBH8eJdWvFvCEPShWVzdutTP1+IA5r7Zzf69gOx+f89fStjPAKNP4oXMGWrRo
         Gj4j0fzruDlwN4OyHr/f4krL78izwMz/7/TtXoMcpCoJe6q8HdOHleOoU0hjZJ211fCV
         c61w==
X-Gm-Message-State: AOAM532yprAuORuTdEBOWT6qLdtq0UrJLWIMIYbc6o1yBpqXPoe2t8Ar
        00pDkhmLeuXYa5uZXXyBsXEFX0eoX+vwdA==
X-Google-Smtp-Source: ABdhPJwR62fUhLpMEvkp4MRreD4CR7Mn7sT30gYN/VxrVeMpalA5znONZQ94nO9RtZAT2IRyKpY0zg==
X-Received: by 2002:a05:6638:603:: with SMTP id g3mr32911624jar.128.1607956912516;
        Mon, 14 Dec 2020 06:41:52 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 62sm9560523ioc.36.2020.12.14.06.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 06:41:52 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring changes for 5.11-rc
Message-ID: <917fc381-ae7d-bd35-1b4e-fc65f338b84c@kernel.dk>
Date:   Mon, 14 Dec 2020 07:41:51 -0700
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

Fairly light set of changes this time around, and mostly some bits that
were pushed out to 5.11 instead of 5.10, fixes/cleanups, and a few
features. In particular:

- Cleanups around iovec import (David Laight, Pavel)

- Add timeout support for io_uring_enter(2), which enables us to clean
  up liburing and avoid a timeout sqe submission in the completion path.
  The big win here is that it allows setups that split SQ and CQ
  handling into separate threads to avoid locking, as the CQ side will
  no longer submit when timeouts are needed when waiting for events.
  (Hao Xu)

- Add support for socket shutdown, and renameat/unlinkat.

- SQPOLL cleanups and improvements (Xiaoguang Wang)

- Allow SQPOLL setups for CAP_SYS_NICE, and enable regular (non-fixed)
  files to be used.

- Cancelation improvements (Pavel)

- Fixed file reference improvements (Pavel)

- IOPOLL related race fixes (Pavel)

- Lots of other little fixes and cleanups (mostly Pavel)

Please pull!


The following changes since commit 418baf2c28f3473039f2f7377760bd8f6897ae18:

  Linux 5.10-rc5 (2020-11-22 15:36:08 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.11/io_uring-2020-12-14

for you to fetch changes up to 59850d226e4907a6f37c1d2fe5ba97546a8691a4:

  io_uring: fix io_cqring_events()'s noflush (2020-12-09 12:04:02 -0700)

----------------------------------------------------------------
for-5.11/io_uring-2020-12-14

----------------------------------------------------------------
David Laight (1):
      fs/io_uring Don't use the return value from import_iovec().

Hao Xu (1):
      io_uring: add timeout support for io_uring_enter()

Jens Axboe (10):
      io_uring: allow SQPOLL with CAP_SYS_NICE privileges
      net: provide __sys_shutdown_sock() that takes a socket
      io_uring: add support for shutdown(2)
      io_uring: allow non-fixed files with SQPOLL
      io_uring: enable file table usage for SQPOLL rings
      fs: make do_renameat2() take struct filename
      io_uring: add support for IORING_OP_RENAMEAT
      io_uring: add support for IORING_OP_UNLINKAT
      io_uring: only plug when appropriate
      io_uring: use bottom half safe lock for fixed file data

Pavel Begunkov (25):
      io_uring: split poll and poll_remove structs
      io_uring: track link's head and tail during submit
      io_uring: track link timeout's master explicitly
      io_uring: link requests with singly linked list
      io_uring: rearrange io_kiocb fields for better caching
      io_uring: NULL files dereference by SQPOLL
      io_uring: remove duplicated io_size from rw
      io_uring: inline io_import_iovec()
      io_uring: simplify io_task_match()
      io_uring: add a {task,files} pair matching helper
      io_uring: cancel only requests of current task
      io_uring: don't iterate io_uring_cancel_files()
      io_uring: pass files into kill timeouts/poll
      io_uring: always batch cancel in *cancel_files()
      io_uring: don't take fs for recvmsg/sendmsg
      io_uring: replace inflight_wait with tctx->wait
      io_uring: share fixed_file_refs b/w multiple rsrcs
      io_uring: change submit file state invariant
      io_uring: fix miscounting ios_left
      io_uring: fix files cancellation
      io_uring: restructure io_timeout_cancel()
      io_uring: add timeout update
      io_uring: fix racy IOPOLL completions
      io_uring: fix racy IOPOLL flush overflow
      io_uring: fix io_cqring_events()'s noflush

Xiaoguang Wang (6):
      io_uring: refactor io_sq_thread() handling
      io_uring: initialize 'timeout' properly in io_sq_thread()
      io_uring: don't acquire uring_lock twice
      io_uring: only wake up sq thread while current task is in io worker context
      io_uring: check kthread stopped flag when sq thread is unparked
      io_uring: always let io_iopoll_complete() complete polled io

 fs/internal.h                 |    2 +
 fs/io-wq.c                    |   10 -
 fs/io-wq.h                    |    1 -
 fs/io_uring.c                 | 1333 ++++++++++++++++++++++++-----------------
 fs/namei.c                    |   40 +-
 include/linux/socket.h        |    1 +
 include/linux/syscalls.h      |    2 +-
 include/uapi/linux/io_uring.h |   16 +
 net/socket.c                  |   15 +-
 9 files changed, 827 insertions(+), 593 deletions(-)

-- 
Jens Axboe

