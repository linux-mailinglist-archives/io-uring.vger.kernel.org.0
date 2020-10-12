Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A90928B894
	for <lists+io-uring@lfdr.de>; Mon, 12 Oct 2020 15:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgJLNx5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Oct 2020 09:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgJLNqr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Oct 2020 09:46:47 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C110AC0613D0
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 06:46:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k6so17716949ior.2
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 06:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ED22sYxmXTNHxD5KJzHuAJgagrQ1zg3CPo4Xkaouy0Y=;
        b=A+Nl1hOILTs0JvKjw6ICIck0ko/vIZPvUMMVSHofPuH+sIZ9viM8huqRUkaFQQp937
         m/ndlIkiPZeSCJPUhtdVkCuAMFpnE641/MROjFu5opDmUl11PzZgXSn0Ob641w4/02H8
         GJTMedOuAjbFoHw4dtfpruy8Qj/QY/w9CaviZwd3CuIxUia2Q2QQuCsbJtE7RL1TPZ7F
         CtmlonHxzVShwG1zUfYsyZvDUgGHz96jt3fS6KYQdpglqFO/fWcjyIYzBPQuypLgnplK
         EPtQYa0Z7Q+uRmvWIG5ITCDlylOHpIYS476doYti/8cFHaaQbfJ0C/M+ZmU/po2AQEJe
         z0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ED22sYxmXTNHxD5KJzHuAJgagrQ1zg3CPo4Xkaouy0Y=;
        b=r6mMirYUHiuFdaE/m2ptylNASBkl7uYv25SvOrSNWz4nXcMEjRUWiK1CzJuUma4VZ6
         YHifLnWYsWk+RLFbbf8gSSGuBJ+NgqnizOrYBYAWz/Yb5tkiTKwKPC/h9JjWTYc7lN/A
         0va5mJHAO2Vc+h1adjleYi93d90VMMhwShkKfAgrMY3sUistfSXXyPMtzrjyfSGcbptS
         1CMx8oAb6RuZTjL/pwRUOVvzdfMdqslClZE6fgqS/ilknZYjjIskDtKaS6f5wu2JJiDy
         ii/r9TKe3u+gfTluMHNPFjQ8tksZ68IfW/j3rzj0tNKiG7cEA6ysh5XT2UkcP0G02Xke
         jo4g==
X-Gm-Message-State: AOAM533xhQ4eDrEMpGawF/qPFOzGoVU5ovtiIB0kj8WfiNltyNq7hQkb
        byUKqZwU2QX7igULooAEBAyQGqhXtLMuPg==
X-Google-Smtp-Source: ABdhPJxmqPWnwFggHKOWtiTHh2RWpkrRYAVu+9VhQ7SZDn+Q0ZfoTYdl/GmkYJ4ZMf5ML9vLfRwmZQ==
X-Received: by 2002:a6b:3fd6:: with SMTP id m205mr16224147ioa.80.1602510405975;
        Mon, 12 Oct 2020 06:46:45 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v17sm9037554ilm.48.2020.10.12.06.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 06:46:45 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.10-rc1
Message-ID: <36a6706d-73e1-64e7-f1f8-8f5ef246d3ea@kernel.dk>
Date:   Mon, 12 Oct 2020 07:46:45 -0600
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

Here are the io_uring updates for 5.10. This pull request contains:

- Add blkcg accounting for io-wq offload (Dennis)

- A use-after-free fix for io-wq (Hillf)

- Cancelation fixes and improvements

- Use proper files_struct references for offload

- Cleanup of io_uring_get_socket() since that can now go into our own
  header

- SQPOLL fixes and cleanups, and support for sharing the thread

- Improvement to how page accounting is done for registered buffers and
  huge pages, accounting the real pinned state

- Series cleaning up the xarray code (Willy)

- Various cleanups, refactoring, and improvements (Pavel)

- Use raw spinlock for io-wq (Sebastian)

- Add support for ring restrictions (Stefano)

Please pull!


The following changes since commit c8d317aa1887b40b188ec3aaa6e9e524333caed1:

  io_uring: fix async buffered reads when readahead is disabled (2020-09-29 07:54:00 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-12

for you to fetch changes up to b2e9685283127f30e7f2b466af0046ff9bd27a86:

  io_uring: keep a pointer ref_node in file_data (2020-10-10 12:49:25 -0600)

----------------------------------------------------------------
io_uring-5.10-2020-10-12

----------------------------------------------------------------
Dennis Zhou (1):
      io_uring: add blkcg accounting to offloaded operations

Hillf Danton (1):
      io-wq: fix use-after-free in io_wq_worker_running

Jens Axboe (29):
      Merge branch 'io_uring-5.9' into for-5.10/io_uring
      io_uring: allow timeout/poll/files killing to take task into account
      io_uring: move dropping of files into separate helper
      io_uring: stash ctx task reference for SQPOLL
      io_uring: unconditionally grab req->task
      io_uring: return cancelation status from poll/timeout/files handlers
      io_uring: enable task/files specific overflow flushing
      io_uring: don't rely on weak ->files references
      io_uring: reference ->nsproxy for file table commands
      io_uring: move io_uring_get_socket() into io_uring.h
      io_uring: io_sq_thread() doesn't need to flush signals
      fs: align IOCB_* flags with RWF_* flags
      io_uring: use private ctx wait queue entries for SQPOLL
      io_uring: move SQPOLL post-wakeup ring need wakeup flag into wake handler
      io_uring: split work handling part of SQPOLL into helper
      io_uring: split SQPOLL data into separate structure
      io_uring: base SQPOLL handling off io_sq_data
      io_uring: enable IORING_SETUP_ATTACH_WQ to attach to SQPOLL thread too
      io_uring: mark io_uring_fops/io_op_defs as __read_mostly
      io_uring: provide IORING_ENTER_SQ_WAIT for SQPOLL SQ ring waits
      io_uring: get rid of req->io/io_async_ctx union
      io_uring: cap SQ submit size for SQPOLL with multiple rings
      io_uring: improve registered buffer accounting for huge pages
      io_uring: process task work in io_uring_register()
      io-wq: kill unused IO_WORKER_F_EXITING
      io_uring: kill callback_head argument for io_req_task_work_add()
      io_uring: batch account ->req_issue and task struct references
      io_uring: no need to call xa_destroy() on empty xarray
      io_uring: fix break condition for __io_uring_register() waiting

Joseph Qi (1):
      io_uring: show sqthread pid and cpu in fdinfo

Matthew Wilcox (Oracle) (3):
      io_uring: Fix use of XArray in __io_uring_files_cancel
      io_uring: Fix XArray usage in io_uring_add_task_file
      io_uring: Convert advanced XArray uses to the normal API

Pavel Begunkov (23):
      io_uring: simplify io_rw_prep_async()
      io_uring: refactor io_req_map_rw()
      io_uring: fix overlapped memcpy in io_req_map_rw()
      io_uring: kill extra user_bufs check
      io_uring: simplify io_alloc_req()
      io_uring: io_kiocb_ppos() style change
      io_uring: remove F_NEED_CLEANUP check in *prep()
      io_uring: set/clear IOCB_NOWAIT into io_read/write
      io_uring: remove nonblock arg from io_{rw}_prep()
      io_uring: decouple issuing and req preparation
      io_uring: move req preps out of io_issue_sqe()
      io_uring: don't io_prep_async_work() linked reqs
      io_uring: clean up ->files grabbing
      io_uring: kill extra check in fixed io_file_get()
      io_uring: simplify io_file_get()
      io_uring: improve submit_state.ios_left accounting
      io_uring: use a separate struct for timeout_remove
      io_uring: remove timeout.list after hrtimer cancel
      io_uring: clean leftovers after splitting issue
      io_uring: don't delay io_init_req() error check
      io_uring: clean file_data access in files_register
      io_uring: refactor *files_register()'s error paths
      io_uring: keep a pointer ref_node in file_data

Sebastian Andrzej Siewior (1):
      io_wq: Make io_wqe::lock a raw_spinlock_t

Stefano Garzarella (3):
      io_uring: use an enumeration for io_uring_register(2) opcodes
      io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
      io_uring: allow disabling rings during the creation

Zheng Bin (1):
      io_uring: remove unneeded semicolon

 fs/exec.c                     |    6 +
 fs/file.c                     |    2 +
 fs/io-wq.c                    |  200 +++---
 fs/io-wq.h                    |    4 +
 fs/io_uring.c                 | 2181 ++++++++++++++++++++++++++++++++++++--------------------
 include/linux/fs.h            |   46 +-
 include/linux/io_uring.h      |   58 ++
 include/linux/sched.h         |    5 +
 include/uapi/linux/io_uring.h |   61 +-
 init/init_task.c              |    3 +
 kernel/fork.c                 |    6 +
 net/unix/scm.c                |    1 +
 12 files changed, 1662 insertions(+), 911 deletions(-)
 create mode 100644 include/linux/io_uring.h

-- 
Jens Axboe

