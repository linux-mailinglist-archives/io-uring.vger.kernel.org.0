Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD875F31D9
	for <lists+io-uring@lfdr.de>; Mon,  3 Oct 2022 16:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiJCOSf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 10:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJCOSd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 10:18:33 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077AB4CA33
        for <io-uring@vger.kernel.org>; Mon,  3 Oct 2022 07:18:32 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id r134so8162156iod.8
        for <io-uring@vger.kernel.org>; Mon, 03 Oct 2022 07:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=wklYeRriaUI9glP1/BnSrfGqhwqVPO2V018P4nQqqTo=;
        b=FvMTczLT/O1niS7hH1oEK5aQXm+ps9ljD+j1WXcdweJEalu5WFz5cUcXKzTS2g995q
         dW1cG8SZeq6TuIo32vNFYno3dtumHdutmHUOL8gctaFWZ+aRv5N0m7LyO851TzSQqnPK
         FYwREqjK4RCN7H9jnaGdtC+8A6iLWdNhxgnyx9NYa7sNvzI6GHCXIhA0FDA51D5PZM3S
         2PxDVjiMeNMQYqsM24VVdL17pgUs0M3yiHKMaaIVUvvIEcZcVkBoP1+Mm9jBNQYyWczF
         vUQtcWyBGJw/5FkboG2Uvp8Xg+25S/Ig6QSCOPnU9XEnC2yVlTIjpbaM+BMVfod/W2D/
         7C+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=wklYeRriaUI9glP1/BnSrfGqhwqVPO2V018P4nQqqTo=;
        b=oGyyxMnBjoBHGy7SjmlgEN2PDy0PPm1ygldPsSK5RLqByKbfErkSQN85tsdVYi/Z8M
         9qxvihr7B3MHaaphIntfL2GHPIrX/V3l+6T8duR9WwK6LoJVcbVdBsFYgmDjze4fBUVh
         pK1uw+KPDGnLlcBUhnC8M8Ywsv4QzKDPuaMikr+NtC+7EQS8J2YwuYM68i5hxCAoiLm+
         yi2R1lp0jo4Tm+D65Gb52+2jWtpJsxTZZBJy5IE1F5tGUw3Ok9B+MmAmOLJU8waWyFJ6
         NlvYCCFUXjo/BUV+n0vLbRcQ3baA+Z/kPXAqHC8pT7QBuiwlu7N2Nl/ilMi79/91I5Z9
         kycQ==
X-Gm-Message-State: ACrzQf2rGjCva3E9jvPplGDRMtY0ok/uuJwr3UmMeWzEbpD+dWurpS46
        uFgxHrtG/y4FqIBDi4uOIClPEzba+Q3ZMw==
X-Google-Smtp-Source: AMsMyM5Y3jJfgIpY++40tKUBgdKt5sCo7fXZinxBvDLuol0AuvPgQYfQ7Dlq0OHlebrU2wtW2CdlsQ==
X-Received: by 2002:a05:6602:399a:b0:6a1:c3fc:9909 with SMTP id bw26-20020a056602399a00b006a1c3fc9909mr8942003iob.28.1664806711369;
        Mon, 03 Oct 2022 07:18:31 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p185-20020a0229c2000000b003572ae30370sm4181552jap.145.2022.10.03.07.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 07:18:30 -0700 (PDT)
Message-ID: <2fad8156-a3ad-5532-aee6-3f872a84e9c2@kernel.dk>
Date:   Mon, 3 Oct 2022 08:18:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.1-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Here are the io_uring updates and fixes that should go into this
release:

- Series that adds supported for more directly managed task_work
  running. This is beneficial for real world applications that end up
  issuing lots of system calls as part of handling work. Normal
  task_work will always execute as we transition in and out of the
  kernel, even for "unrelated" system calls. It's more efficient to
  defer the handling of io_uring's deferred work until the application
  wants it to be run, generally in batches. As part of ongoing work to
  write an io_uring network backend for Thrift, this has been shown to
  greatly improve performance. (Dylan)

- Series adding IOPOLL support for passthrough (Kanchan)

- Improvements and fixes to the send zero-copy support (Pavel)

- Partial IO handling fixes (Pavel)

- CQE ordering fixes around CQ ring overflow (Pavel)

- Support sendto() for non-zc as well (Pavel)

- Support sendmsg for zerocopy (Pavel)

- Networking iov_iter fix (Stefan)

- Misc fixes and cleanups (Pavel, me)

Please pull!


The following changes since commit 521a547ced6477c54b4b0cc206000406c221b4d6:

  Linux 6.0-rc6 (2022-09-18 13:44:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.1/io_uring-2022-10-03

for you to fetch changes up to 108893ddcc4d3aa0a4a02aeb02d478e997001227:

  io_uring/net: fix notif cqe reordering (2022-09-29 17:46:04 -0600)

----------------------------------------------------------------
for-6.1/io_uring-2022-10-03

----------------------------------------------------------------
Dylan Yudaken (9):
      eventfd: guard wake_up in eventfd fs calls as well
      io_uring: remove unnecessary variable
      io_uring: introduce io_has_work
      io_uring: do not run task work at the start of io_uring_enter
      io_uring: add IORING_SETUP_DEFER_TASKRUN
      io_uring: move io_eventfd_put
      io_uring: signal registered eventfd to process deferred task work
      io_uring: trace local task work run
      io_uring: allow buffer recycling in READV

Jens Axboe (9):
      io_uring: cleanly separate request types for iopoll
      io_uring: add local task_work run helper that is entered locked
      io_uring: ensure iopoll runs local task work as well
      fs: add batch and poll flags to the uring_cmd_iopoll() handler
      io_uring/fdinfo: get rid of unnecessary is_cqe32 variable
      io_uring/fdinfo: fix sqe dumping for IORING_SETUP_SQE128
      io_uring: ensure local task_work marks task as running
      io_uring/rw: defer fsnotify calls to task context
      io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL

Kanchan Joshi (4):
      fs: add file_operations->uring_cmd_iopoll
      io_uring: add iopoll infrastructure for io_uring_cmd
      block: export blk_rq_is_poll
      nvme: wire up async polling for io passthrough commands

Pavel Begunkov (33):
      io_uring: kill an outdated comment
      io_uring: use io_cq_lock consistently
      io_uring/net: reshuffle error handling
      io_uring/net: use async caches for async prep
      io_uring/net: io_async_msghdr caches for sendzc
      io_uring/net: add non-bvec sg chunking callback
      io_uring/net: refactor io_sr_msg types
      io_uring/net: use io_sr_msg for sendzc
      io_uring: further limit non-owner defer-tw cq waiting
      io_uring: disallow defer-tw run w/ no submitters
      io_uring/iopoll: fix unexpected returns
      io_uring/iopoll: unify tw breaking logic
      io_uring: add fast path for io_run_local_work()
      io_uring: remove unused return from io_disarm_next
      io_uring: add custom opcode hooks on fail
      io_uring/rw: don't lose partial IO result on fail
      io_uring/net: don't lose partial send/recv on fail
      io_uring/net: don't lose partial send_zc on fail
      io_uring/net: refactor io_setup_async_addr
      io_uring/net: support non-zerocopy sendto
      io_uring/net: rename io_sendzc()
      io_uring/net: combine fail handlers
      io_uring/net: zerocopy sendmsg
      selftest/net: adjust io_uring sendzc notif handling
      io_uring/net: fix UAF in io_sendrecv_fail()
      io_uring: fix CQE reordering
      io_uring/net: fix cleanup double free free_iov init
      io_uring/rw: fix unexpected link breakage
      io_uring/rw: don't lose short results on io_setup_async_rw()
      io_uring/net: don't skip notifs for failed requests
      io_uring/net: fix non-zc send with address
      io_uring/net: don't update msg_name if not provided
      io_uring/net: fix notif cqe reordering

Stefan Metzmacher (1):
      io_uring/net: fix fast_iov assignment in io_setup_async_msg()

 block/blk-mq.c                                     |   3 +-
 drivers/nvme/host/core.c                           |   1 +
 drivers/nvme/host/ioctl.c                          |  77 +++++-
 drivers/nvme/host/multipath.c                      |   1 +
 drivers/nvme/host/nvme.h                           |   4 +
 fs/eventfd.c                                       |  10 +-
 include/linux/blk-mq.h                             |   1 +
 include/linux/eventfd.h                            |   2 +-
 include/linux/fs.h                                 |   2 +
 include/linux/io_uring.h                           |   8 +-
 include/linux/io_uring_types.h                     |   4 +
 include/linux/sched.h                              |   2 +-
 include/trace/events/io_uring.h                    |  29 ++
 include/uapi/linux/io_uring.h                      |   8 +
 io_uring/cancel.c                                  |   2 +-
 io_uring/fdinfo.c                                  |  48 ++--
 io_uring/io_uring.c                                | 304 ++++++++++++++++----
 io_uring/io_uring.h                                |  62 ++++-
 io_uring/kbuf.h                                    |  12 -
 io_uring/net.c                                     | 308 +++++++++++++++------
 io_uring/net.h                                     |  12 +-
 io_uring/opdef.c                                   |  44 ++-
 io_uring/opdef.h                                   |   1 +
 io_uring/rsrc.c                                    |   2 +-
 io_uring/rw.c                                      | 189 +++++++------
 io_uring/rw.h                                      |   1 +
 io_uring/timeout.c                                 |  13 +-
 io_uring/timeout.h                                 |   2 +-
 io_uring/uring_cmd.c                               |  11 +-
 tools/testing/selftests/net/io_uring_zerocopy_tx.c |  22 +-
 30 files changed, 859 insertions(+), 326 deletions(-)

-- 
Jens Axboe
