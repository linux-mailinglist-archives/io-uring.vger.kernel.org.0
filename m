Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8034669A40A
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 03:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjBQCyA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 21:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQCx7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 21:53:59 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A13A5382B
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 18:53:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id bg2so3873568pjb.4
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 18:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAg1qGilqwGQMuRfh2DIfNrzzVG14j98Q4VWMPRDNnM=;
        b=0v9aoe1OVmmjbQx3Z+ChaPQ6YRslO3u0armnL8saGuShhAYqgnNwzBJi0pWvGgWiKo
         gPLPNVH8TTZrmc8IkkWQ87EcODRvIhKUGLN/2x6tsDWymjYPsHu8HRKcSvM8gfcomnEY
         TlItIOhWbplyMQcTC/v9albRQGwWuEY6sx4q93fcsfndziXBvWSkOsRRd/iQ/j09OMI4
         XEW1U9Lr0Q2yaozz3EndBUKSnoHwM62kOKEc1kkH0MklbGsXnYtE9Qh8fB4kehnRQLUL
         dCzAG6SBgl6mwdHcEtpWOLDx74R5omdLNaoAFKiB3vqPcY5CczUeD7oflE1CfsjV1cIJ
         MtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TAg1qGilqwGQMuRfh2DIfNrzzVG14j98Q4VWMPRDNnM=;
        b=5EenYetP/Z4H4REm94UrKZrxDHgb7Ha2U9yjSzexlnvoaqJ2JI+QQpmpMMl8nKlNNy
         tJ1je1LWlZr5SgqZ7+3dhYAE8Zi3i127LK7g7ffDrNv6HBVgX0T53xWhl1FVq+F97Cnf
         Ci8zRTIUMBwVImMDJhBiEMKAmu5A7OiU0RvbjhWnOl1NZM/IZ+w4plwhvdlnhA9Qcpnz
         PBXdpVZOMAiHPv0cY0Ne3IKjWwdPilqTZckJc3mreN5nVDNWjoT3keak2o92EEvf7Ugf
         uvF8J64bR6eYPhGQzK0swoxgGqCrL61JTq87BQWVBxFC3xxzOciueiWLsgGBLM19ki+V
         rqdw==
X-Gm-Message-State: AO0yUKWH5UahVIq1wfA7U3QJCs+ZjP1KDPfGgIDuIAXoZo5+BTlpJ3SG
        OTsBPtTubSK9nfVNzI2ZFjhA72+Tum7OcW6h
X-Google-Smtp-Source: AK7set+KDZUwLfp3qucAhmPcHNZICwSI6mdEiqRtA4ozjo6r6GPtaQC7He8QYWLU9cCQwtsx+A6kfQ==
X-Received: by 2002:a17:902:d501:b0:19a:7217:32af with SMTP id b1-20020a170902d50100b0019a721732afmr9663684plg.5.1676602437927;
        Thu, 16 Feb 2023 18:53:57 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z20-20020a170902ee1400b0019a7d6a9a76sm1975720plb.111.2023.02.16.18.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 18:53:57 -0800 (PST)
Message-ID: <c4dcf46e-43c6-debf-ea74-a2de91d846de@kernel.dk>
Date:   Thu, 16 Feb 2023 19:53:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL for-6.3] io_uring updates for 6.3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
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

Sending pull requests early, as I'm mostly out-of-town and unavailable
next week.

Here are the io_uring updates for the 6.3 merge window. Nothing really
major in here for this round. In detail:

- Cleanup series making the async prep and handling of REQ_F_FORCE_ASYNC
  easier to follow and verify (Dylan)

- Enable specifying specific flags for OP_MSG_RING (Breno)

- Enable use of KASAN with the internal request cache (Breno)

- Split the opcode definition structs into a hot and cold part (Breno)

- OP_MSG_RING fixes (Pavel, me)

- Fix an issue with IOPOLL cancelation and PREEMPT_NONE (me)

- Handle TIF_NOTIFY_RESUME for the io-wq threads that never return to
  userspace (me)

- Add support for using io_uring_register() with a registered ring fd
  (Josh)

- Improve handling of poll on the ring fd (Pavel)

- Series improving the task_work handling (Pavel)

- Misc cleanups, fixes, improvements (Dmitrii, Quanfa, Richard, Pavel, me)

Please pull!


The following changes since commit 6d796c50f84ca79f1722bb131799e5a5710c4700:

  Linux 6.2-rc6 (2023-01-29 13:59:43 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.3/io_uring-2023-02-16

for you to fetch changes up to 7d3fd88d61a41016da01889f076fd1c60c7298fc:

  io_uring: Support calling io_uring_register with a registered ring fd (2023-02-16 06:09:30 -0700)

----------------------------------------------------------------
for-6.3/io_uring-2023-02-16

----------------------------------------------------------------
Breno Leitao (4):
      io_uring/msg_ring: Pass custom flags to the cqe
      io_uring: Rename struct io_op_def
      io_uring: Split io_issue_def struct
      io_uring: Enable KASAN for request cache

Dmitrii Bundin (1):
      io_uring: remove excessive unlikely on IS_ERR

Dylan Yudaken (4):
      io_uring: if a linked request has REQ_F_FORCE_ASYNC then run it async
      io_uring: for requests that require async, force it
      io_uring: always go async for unsupported fadvise flags
      io_uring: always go async for unsupported open flags

Jens Axboe (6):
      io_uring/msg-ring: ensure flags passing works for task_work completions
      io_uring: handle TIF_NOTIFY_RESUME when checking for task_work
      io_uring: pass in io_issue_def to io_assign_file()
      io_uring: add a conditional reschedule to the IOPOLL cancelation loop
      io_uring: add reschedule point to handle_tw_list()
      io_uring: mark task TASK_RUNNING before handling resume/task work

Josh Triplett (1):
      io_uring: Support calling io_uring_register with a registered ring fd

Pavel Begunkov (33):
      io_uring: rearrange defer list checks
      io_uring: don't iterate cq wait fast path
      io_uring: kill io_run_task_work_ctx
      io_uring: move defer tw task checks
      io_uring: parse check_cq out of wq waiting
      io_uring: mimimise io_cqring_wait_schedule
      io_uring: simplify io_has_work
      io_uring: set TASK_RUNNING right after schedule
      io_uring: optimise non-timeout waiting
      io_uring: keep timeout in io_wait_queue
      io_uring: move submitter_task out of cold cacheline
      io_uring: refactor io_wake_function
      io_uring: don't set TASK_RUNNING in local tw runner
      io_uring: mark io_run_local_work static
      io_uring: move io_run_local_work_locked
      io_uring: separate wq for ring polling
      io_uring: add lazy poll_wq activation
      io_uring: wake up optimisations
      io_uring: waitqueue-less cq waiting
      io_uring: add io_req_local_work_add wake fast path
      io_uring: optimise deferred tw execution
      io_uring: return back links tw run optimisation
      io_uring: don't export io_put_task()
      io_uring: simplify fallback execution
      io_uring: optimise ctx flags layout
      io_uring: refactor __io_req_complete_post
      io_uring: use user visible tail in io_uring_poll()
      io_uring: kill outdated comment about overflow flush
      io_uring: improve io_get_sqe
      io_uring: refactor req allocation
      io_uring: refactor io_put_task helpers
      io_uring: refactor tctx_task_work
      io_uring: return normal tw run linking optimisation

Quanfa Fu (1):
      io_uring: make io_sqpoll_wait_sq return void

Richard Guy Briggs (1):
      io_uring,audit: don't log IORING_OP_MADVISE

 include/linux/io_uring_types.h |  21 +-
 include/uapi/linux/io_uring.h  |   8 +-
 io_uring/advise.c              |  29 +--
 io_uring/fs.c                  |  20 +-
 io_uring/io_uring.c            | 474 +++++++++++++++++++++++++++--------------
 io_uring/io_uring.h            |  97 ++++-----
 io_uring/msg_ring.c            |  31 ++-
 io_uring/net.c                 |   4 +-
 io_uring/notif.c               |   3 +-
 io_uring/opdef.c               | 340 +++++++++++++++++++----------
 io_uring/opdef.h               |  13 +-
 io_uring/openclose.c           |  18 +-
 io_uring/poll.c                |   2 +-
 io_uring/rw.c                  |   4 +-
 io_uring/splice.c              |   7 +-
 io_uring/sqpoll.c              |   3 +-
 io_uring/sqpoll.h              |   2 +-
 io_uring/statx.c               |   4 +-
 io_uring/sync.c                |  14 +-
 io_uring/xattr.c               |  14 +-
 20 files changed, 699 insertions(+), 409 deletions(-)

-- 
Jens Axboe

