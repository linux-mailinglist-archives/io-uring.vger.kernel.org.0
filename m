Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E5473D5F1
	for <lists+io-uring@lfdr.de>; Mon, 26 Jun 2023 04:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjFZCjS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Jun 2023 22:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjFZCjQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Jun 2023 22:39:16 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532C8E53
        for <io-uring@vger.kernel.org>; Sun, 25 Jun 2023 19:39:05 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b5466bc5f8so4085745ad.1
        for <io-uring@vger.kernel.org>; Sun, 25 Jun 2023 19:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687747145; x=1690339145;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWklRiY05pMRDsYNTO6Caf0XUDTokTD68J/5QVxtFt0=;
        b=sfhSgI+j3yG+MbzBraHp+WYjucvTJbgJGVs8PdnX0mNiFWukypJxtGGSmXCGkWWu2b
         AtSof/nATHTlL3fOw2TS5VnnhG/ejIlLc07zMAiYC32GIOWURzOtI0foUwLR9+ZmhfWj
         eKGo+W3C8rrf1lWuac7sF2C9MPGjmgu6CKZX42hrykuV+dfja9KQ5MjAsBGk0WtMM3a3
         Na6GelvcQBSQ6AKsfuv2xWBRnTuTUWe0e5qMNO0EKoxpv2FtZnRx3NVY4i/l3e6aAXRQ
         kG1UEKac/IbWchNT6Q5mSj5XGMNOjvRG6FR1NGwRcA4ztqKvu9p01zau98mCHi5W38Ub
         VYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687747145; x=1690339145;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oWklRiY05pMRDsYNTO6Caf0XUDTokTD68J/5QVxtFt0=;
        b=B3uYrfge3r/RrF/NlQupJV6LvtYy7DOblLgtY6sc//wWBcnAfw4TZd1q0hde9nO9Hf
         9Mot48oVTag9bDcedU4VTrJUfIvt4uNndCQ4tc/Cc6sElXbIMBvBVie2VV1gRwizVqmp
         DMiUDhK7a0wVAUpFn68oTVTN5sHx59nNTqYomu2983eFdibO1BLS1vJW5AqjO0X+xWAd
         zLOyBPL84OBgcf42WhF4YTCCMcTZNh2OKBEuumhGiJ1WoUiTGOGl0v1XTrVPnNY8R4fw
         wC5rZcHMaKtllgVPCq+z7TPGncugMnZjC/I3YdobaHtA+kfaRrjSo6blqIa0V6skd5vu
         U0cw==
X-Gm-Message-State: AC+VfDxNHwDM7KEcrw6FQLYQuSvbijDH30kBpZZvMY1W9xVBmJdK1Irw
        2hzUtOVU+23Y4tMPXnC3avkJgEKYJGztZ/5OWIw=
X-Google-Smtp-Source: ACHHUZ67DoUpLO/roY+MpmPq1MMRJ3v4w4pUj/wv+Hh3FM3Actm5YAlJsnFSCYSJRFBeZeUeSTV+yg==
X-Received: by 2002:a17:902:f691:b0:1b3:d4bb:3515 with SMTP id l17-20020a170902f69100b001b3d4bb3515mr34706779plg.0.1687747144775;
        Sun, 25 Jun 2023 19:39:04 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f24-20020a170902ab9800b001a6f7744a27sm3007104plr.87.2023.06.25.19.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jun 2023 19:39:04 -0700 (PDT)
Message-ID: <6e13b6a5-aa10-75f8-973d-023b7aa7f440@kernel.dk>
Date:   Sun, 25 Jun 2023 20:39:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.5
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Nothing major in this release, just a bunch of cleanups and some
optimizations around networking mostly.

Will throw a minor conflict in io_uring/net.c due to the late fixes in
mainline, you'll want to keep the kmsg->msg.msg_inq = -1U; assignment
there.

Please pull!


- Series cleaning up file request flags handling (Christoph)

- Series cleaning up request freeing and CQ locking (Pavel)

- Support for using pre-registering the io_uring fd at setup time (Josh)

- Add support for user allocated ring memory, rather than having the
  kernel allocate it. Mostly for packing rings into a huge page (me)

- Series avoiding an unnecessary double retry on receive (me)

- Maintain ordering for task_work, which also improves performance (me)

- Misc cleanups/fixes (Pavel, me)

The following changes since commit f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6:

  Linux 6.4-rc2 (2023-05-14 12:51:40 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.5/io_uring-2023-06-23

for you to fetch changes up to c98c81a4ac37b651be7eb9d16f562fc4acc5f867:

  io_uring: merge conditional unlock flush helpers (2023-06-23 08:19:40 -0600)

----------------------------------------------------------------
for-6.5/io_uring-2023-06-23

----------------------------------------------------------------
Christoph Hellwig (8):
      io_uring: remove __io_file_supports_nowait
      io_uring: remove the mode variable in io_file_get_flags
      io_uring: remove a confusing comment above io_file_get_flags
      io_uring: remove io_req_ffs_set
      io_uring: return REQ_F_ flags from io_file_get_flags
      io_uring: use io_file_from_index in __io_sync_cancel
      io_uring: use io_file_from_index in io_msg_grab_file
      io_uring: add helpers to decode the fixed file file_ptr

Jens Axboe (16):
      net: set FMODE_NOWAIT for sockets
      block: mark bdev files as FMODE_NOWAIT if underlying device supports it
      io_uring: rely solely on FMODE_NOWAIT
      io_uring: remove sq/cq_off memset
      io_uring: return error pointer from io_mem_alloc()
      io_uring: add ring freeing helper
      io_uring: support for user allocated memory for rings/sqes
      io_uring/net: initialize struct msghdr more sanely for io_recv()
      io_uring/net: initalize msghdr->msg_inq to known value
      io_uring/net: push IORING_CQE_F_SOCK_NONEMPTY into io_recv_finish()
      io_uring/net: don't retry recvmsg() unnecessarily
      io_uring: maintain ordering for DEFER_TASKRUN tw list
      io_uring: avoid indirect function calls for the hottest task_work
      io_uring: cleanup io_aux_cqe() API
      io_uring: get rid of unnecessary 'length' variable
      io_uring: wait interruptibly for request completions on exit

Josh Triplett (1):
      io_uring: Add io_uring_setup flag to pre-register ring fd and never install it

Pavel Begunkov (14):
      io_uring: annotate offset timeout races
      io_uring/cmd: add cmd lazy tw wake helper
      nvme: optimise io_uring passthrough completion
      io_uring: open code io_put_req_find_next
      io_uring: remove io_free_req_tw
      io_uring: inline io_dismantle_req()
      io_uring: move io_clean_op()
      io_uring: don't batch task put on reqs free
      io_uring: remove IOU_F_TWQ_FORCE_NORMAL
      io_uring: kill io_cq_unlock()
      io_uring: fix acquire/release annotations
      io_uring: inline __io_cq_unlock
      io_uring: make io_cq_unlock_post static
      io_uring: merge conditional unlock flush helpers

 block/fops.c                   |   5 +-
 drivers/nvme/host/ioctl.c      |   4 +-
 include/linux/io_uring.h       |  18 +-
 include/linux/io_uring_types.h |  10 +
 include/uapi/linux/io_uring.h  |  16 +-
 io_uring/cancel.c              |   5 +-
 io_uring/filetable.c           |  11 +-
 io_uring/filetable.h           |  28 ++-
 io_uring/io_uring.c            | 497 ++++++++++++++++++++++-------------------
 io_uring/io_uring.h            |  17 +-
 io_uring/msg_ring.c            |   4 +-
 io_uring/net.c                 |  58 ++---
 io_uring/poll.c                |   6 +-
 io_uring/poll.h                |   2 +
 io_uring/rsrc.c                |   8 +-
 io_uring/rw.c                  |   6 +-
 io_uring/rw.h                  |   1 +
 io_uring/tctx.c                |  31 ++-
 io_uring/timeout.c             |   6 +-
 io_uring/uring_cmd.c           |  16 +-
 net/socket.c                   |   1 +
 21 files changed, 416 insertions(+), 334 deletions(-)

-- 
Jens Axboe

