Return-Path: <io-uring+bounces-884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B0B87785D
	for <lists+io-uring@lfdr.de>; Sun, 10 Mar 2024 21:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD57D1F21100
	for <lists+io-uring@lfdr.de>; Sun, 10 Mar 2024 20:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB6B364D4;
	Sun, 10 Mar 2024 20:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RHu9IGPk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436B03207
	for <io-uring@vger.kernel.org>; Sun, 10 Mar 2024 20:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710100831; cv=none; b=K5x8C13HS0RdA9QoNgecDnWD/7GZlGCaSudi/aWVcYVOflXwp8uODI+lr0LH+1dqm68QnsW0p+h2t81Y0lmDcThUVftM9RYkdTI8OCgQonDiiJwTKwQxi0JEH6wl4WxS4z++aAE89F+1zG1qkn7QU6RswwXCxibwtQoqRr2wdTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710100831; c=relaxed/simple;
	bh=RJUH4yDgl1sCkBl51T7s17I8IbFUN0qF1pI8ueGorTM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=R2exC8Ap9DbVi1ukImJIV5Ot3gQym275Dk2Y/s5ofWUsQRfpX5mHfSYzNtDAMgAFOdlX2kTTuxAJXc+aLnOfpFIskJMeJ7VHgff4BF7As/mZbCPUbIVKqrmswP33veu8eyS3c1jmw3uTsFUX8x4+A+0UqEpek393SstmL0kHAjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RHu9IGPk; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so1528990a12.0
        for <io-uring@vger.kernel.org>; Sun, 10 Mar 2024 13:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710100827; x=1710705627; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYP3KI2HTbJ49+Q4lVjDw6U++lmU7c/us9jFK/pTTWk=;
        b=RHu9IGPkNxGGeXi2x5TGMbc56NyPRVH4LGmEAMTbQ3Wr90kGaCFbfYmYjPzPifn+Yj
         LHxExfPqIKj9P736GgLqG/c5JSE3321xryX04IjdogOGG8TMXwVEEOhMgDlL+CfmM9uo
         8KzIeBL2OAnLtwULNuQjmpE4Cel2OT8mdjTStK1/q4r3ZE0Wab5vRScJGs3901I1GCi7
         FJQsyBCwaTkNxnntxsLumUGGzNAMeVMlAgzDfn59amPEktNnwujza47UX6wMuFJsSx1B
         Fw/Xne6GGNhnSgOeOkDH6T9VuBVuwBqmAr0ng579tfxmLZwgF5G+WlsM0Ksq86kO5gXz
         mtlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710100827; x=1710705627;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vYP3KI2HTbJ49+Q4lVjDw6U++lmU7c/us9jFK/pTTWk=;
        b=J6g7cTens1hjirZG5fJNgg2M/yaDe105eaHYLY8qJHUr56Ipq/fS8jksnqJjnw6gmg
         tdNLd6JBT+UttcpS9IPAE/3n/VwZ6MCSNGBB/z5nY23bcqVMuPJyBEmOIA0nMV22rJ+F
         70cbiOzoprt9smwKS0oMPQpWkLc+RfAwHBWO/B9o/CD4g49Q70jjkS4VBYjbOxBR113O
         KHEpRMvdMUvZ7e4IOl1kPqxtOB3G5JIlB39umbsYsL1ofuju2H9tfKGljOCvg/ct/naL
         rZdXOt/Rw8dbDruqDHxgw/FTtk8HK3FlMBuZUa+NkY5SGfKkOGzg1ZEpmhbtiPg9Q5sm
         amOQ==
X-Gm-Message-State: AOJu0YykRlUJZT3D1X4aBs++bL8l8CFg9J4pzPqPB7aECUIZQdpMjm4a
	vNgOjQ9gAf80cU2puKHtCk4ifeVFeML0fBFnQk9QDdE8csl3w+ISrhmIjxg9FsU/GM3RaWGW6Rh
	v
X-Google-Smtp-Source: AGHT+IHiJwufOw4rN/h86yKkoQXJSFwY9aac81aS9+q0eWRYIC5uRC1Z/co+MT8XLw4i+DOZQi3L5A==
X-Received: by 2002:a05:6a20:9f04:b0:1a1:4534:bc45 with SMTP id mk4-20020a056a209f0400b001a14534bc45mr8098440pzb.6.1710100826990;
        Sun, 10 Mar 2024 13:00:26 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u21-20020a17090ae01500b0029bf9969afbsm759484pjy.53.2024.03.10.13.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Mar 2024 13:00:26 -0700 (PDT)
Message-ID: <08c119f9-de23-47de-98cf-9fd30c614f85@kernel.dk>
Date: Sun, 10 Mar 2024 14:00:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.9-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring changes queued for the 6.9 kernel release. This
pull request contains:

- Make running of task_work internal loops more fair, and unify how the
  different methods deal with them (me)

- Support for per-ring NAPI. The two minor networking patches are in a
  shared branch with netdev. (Stefan)

- Add support for truncate (Tony)

- Export SQPOLL utilization stats (Xiaobing)

- Multishot fixes (Pavel)

- Fix for a race in manipulating the request flags via poll (Pavel)

- Cleanup the multishot checking by making it generic, moving it out of
  opcode handlers (Pavel)

- Various tweaks and cleanups (me, Kunwu, Alexander)

Please pull!


The following changes since commit 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478:

  Linux 6.8-rc3 (2024-02-04 12:20:36 +0000)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.9/io_uring-20240310

for you to fetch changes up to 606559dc4fa36a954a51fbf1c6c0cc320f551fe0:

  io_uring: Fix sqpoll utilization check racing with dying sqpoll (2024-03-09 07:27:09 -0700)

----------------------------------------------------------------
for-6.9/io_uring-20240310

----------------------------------------------------------------
Alexander Mikhalitsyn (1):
      io_uring: use file_mnt_idmap helper

Dan Carpenter (1):
      io_uring/net: fix overflow check in io_recvmsg_mshot_prep()

Gabriel Krisman Bertazi (1):
      io_uring: Fix sqpoll utilization check racing with dying sqpoll

Jens Axboe (34):
      io_uring: expand main struct io_kiocb flags to 64-bits
      io_uring/cancel: don't default to setting req->work.cancel_seq
      io_uring: add io_file_can_poll() helper
      io_uring: mark the need to lock/unlock the ring as unlikely
      io_uring: cleanup io_req_complete_post()
      io_uring/rw: remove dead file == NULL check
      io_uring/kbuf: cleanup passing back cflags
      io_uring: remove looping around handling traditional task_work
      io_uring: remove 'loops' argument from trace_io_uring_task_work_run()
      io_uring: handle traditional task_work in FIFO order
      io_uring: remove next io_kiocb fetch in task_work running
      io_uring: remove unconditional looping in local task_work handling
      io_uring/poll: improve readability of poll reference decrementing
      io_uring: cleanup handle_tw_list() calling convention
      io_uring: pass in counter to handle_tw_list() rather than return it
      io_uring/sqpoll: manage task_work privately
      io_uring: re-arrange struct io_ring_ctx to reduce padding
      Merge branch 'for-io_uring-add-napi-busy-polling-support' of git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux into for-6.9/io_uring
      io_uring/napi: ensure napi polling is aborted when work is available
      io_uring: wake SQPOLL task when task_work is added to an empty queue
      io_uring/sqpoll: use the correct check for pending task_work
      io_uring: kill stale comment for io_cqring_overflow_kill()
      io_uring/napi: enable even with a timeout of 0
      io_uring/net: unify how recvmsg and sendmsg copy in the msghdr
      io_uring/net: move receive multishot out of the generic msghdr path
      io_uring/net: improve the usercopy for sendmsg/recvmsg
      io_uring/kbuf: flag request if buffer pool is empty after buffer pick
      io_uring/net: move recv/recvmsg flags out of retry loop
      io_uring/net: clear REQ_F_BL_EMPTY in the multishot retry handler
      io_uring/net: correctly handle multishot recvmsg retry setup
      io_uring/net: remove dependency on REQ_F_PARTIAL_IO for sr->done_io
      io_uring/kbuf: rename REQ_F_PARTIAL_IO to REQ_F_BL_NO_RECYCLE
      io_uring/net: simplify msghd->msg_inq checking
      io_uring/net: add io_req_msg_cleanup() helper

Kuniyuki Iwashima (1):
      io_uring: Don't include af_unix.h.

Kunwu Chan (1):
      io_uring: Simplify the allocation of slab caches

Muhammad Usama Anjum (1):
      io_uring/net: correct the type of variable

Pavel Begunkov (5):
      io_uring: fix mshot read defer taskrun cqe posting
      io_uring: fix io_queue_proc modifying req->flags
      io_uring: fix mshot io-wq checks
      io_uring: refactor DEFER_TASKRUN multishot checks
      io_uring/net: dedup io_recv_finish req completion

Stefan Roesch (6):
      net: split off __napi_busy_poll from napi_busy_poll
      net: add napi_busy_loop_rcu()
      io-uring: move io_wait_queue definition to header file
      io-uring: add napi busy poll support
      io-uring: add sqpoll support for napi busy poll
      io_uring: add register/unregister napi function

Tony Solomonik (2):
      Add do_ftruncate that truncates a struct file
      io_uring: add support for ftruncate

Xiaobing Li (1):
      io_uring/sqpoll: statistics of the true utilization of sq threads

 fs/internal.h                   |   1 +
 fs/open.c                       |  53 +++---
 include/linux/io_uring_types.h  | 137 ++++++++------
 include/net/busy_poll.h         |   4 +
 include/trace/events/io_uring.h |  30 ++--
 include/uapi/linux/io_uring.h   |  13 ++
 io_uring/Makefile               |   3 +-
 io_uring/cancel.c               |   3 +-
 io_uring/cancel.h               |  10 ++
 io_uring/fdinfo.c               |  18 +-
 io_uring/filetable.h            |   2 +-
 io_uring/io_uring.c             | 249 +++++++++++++-------------
 io_uring/io_uring.h             |  77 +++++++-
 io_uring/kbuf.c                 |  35 ++--
 io_uring/kbuf.h                 |  61 ++++---
 io_uring/napi.c                 | 332 ++++++++++++++++++++++++++++++++++
 io_uring/napi.h                 | 104 +++++++++++
 io_uring/net.c                  | 382 +++++++++++++++++++++-------------------
 io_uring/opdef.c                |  10 ++
 io_uring/poll.c                 |  33 ++--
 io_uring/register.c             |  13 ++
 io_uring/rsrc.h                 |   2 -
 io_uring/rw.c                   |  13 +-
 io_uring/sqpoll.c               |  59 ++++++-
 io_uring/sqpoll.h               |   1 +
 io_uring/truncate.c             |  48 +++++
 io_uring/truncate.h             |   4 +
 io_uring/uring_cmd.c            |   1 +
 io_uring/xattr.c                |   2 +-
 net/core/dev.c                  |  57 ++++--
 30 files changed, 1253 insertions(+), 504 deletions(-)
 create mode 100644 io_uring/napi.c
 create mode 100644 io_uring/napi.h
 create mode 100644 io_uring/truncate.c
 create mode 100644 io_uring/truncate.h

-- 
Jens Axboe


