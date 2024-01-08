Return-Path: <io-uring+bounces-375-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36CE7827756
	for <lists+io-uring@lfdr.de>; Mon,  8 Jan 2024 19:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEFB31F22311
	for <lists+io-uring@lfdr.de>; Mon,  8 Jan 2024 18:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62E654665;
	Mon,  8 Jan 2024 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iN41nEnA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793FE54BC2
	for <io-uring@vger.kernel.org>; Mon,  8 Jan 2024 18:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-360576be804so1424595ab.0
        for <io-uring@vger.kernel.org>; Mon, 08 Jan 2024 10:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704738264; x=1705343064; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e54DfMFNEZrQuTCzf/OmGwdhzV497nMCiJnQnCLAJl0=;
        b=iN41nEnAlYoyidnCGJEDJb0Ljq/fW/W3acQvTlHbdt3N/jB8kGEOfTc/uRtomF7Hz/
         RSE/q01Xe3NR79g/6tLwlCf4O+7+hkaZVLy6A//bpyLmtMXdSoszEhhr7/f03951v8F2
         YlSWv2ACsQPrtWEymL9CBuXW57n/IhGWGyzEy8TNGAbaAZ1ysRw5z9WmwXDA7XSa9KDe
         f2ZFZ4U4lMblzvL4hD6O2fNCM1hr4Y+Baf2lJyYU2FfwbeC8mxGjjQRA2ug6pEV4XIah
         BtVinyGSJzEzVBtkVW4e/SLINqGJOjLvRVKhKK32HVAuu1B/d0kvkj5mj/YxvyWCR/E2
         0Fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704738264; x=1705343064;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e54DfMFNEZrQuTCzf/OmGwdhzV497nMCiJnQnCLAJl0=;
        b=e3bQUgMjEwUeUlTrJI4TavDJGPDaWQUJUSZwsFzGVCSAyvoShLXAJGqxI9/2CsCJ6j
         spBQBYB0D00kI2OaKT+o4IOHARKXTxdorG37kmzaXqlw3hVtxG5Z4xIvo2bUV3MId4L7
         DHegl+HSUV2K4CJwbHd9e7W26qni7WiM0ZI2bosk4ZnvTpK/waW92v4pl3JAoB6y9WAU
         vTtYxc1iNhAqnzGJF2lOr2FuLMWrCYNINgHniNiU8Rcl2Ys594Psl47IgFKMBryk5QNO
         3y+l1eZ10NygQT20cQxs53tBjIdlte9Bv45K80/txBR870GiFD/KUFu7DFs9OYCeKnsH
         ZPVw==
X-Gm-Message-State: AOJu0Yz3M9JH5kvWmdecB44wlz8SRFuuScu7YTpf+X7eQD/wNnMMJswB
	LHmC+Mt4HGj8j7VPwgZ1tHRNe1mPlXC0gw==
X-Google-Smtp-Source: AGHT+IHdMXGcXyk2hAvkka7C7IzliuFnnrjuEuYpsWC4UIooxGfnWJffGGilHDoZMtP7vK+anbg5Sg==
X-Received: by 2002:a6b:d317:0:b0:7bc:2603:575f with SMTP id s23-20020a6bd317000000b007bc2603575fmr6844976iob.0.1704738264498;
        Mon, 08 Jan 2024 10:24:24 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cq3-20020a056638478300b0046e06f936c7sm106826jab.167.2024.01.08.10.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 10:24:23 -0800 (PST)
Message-ID: <c5c21ccf-201b-486a-b184-a99924f4fc04@kernel.dk>
Date: Mon, 8 Jan 2024 11:24:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.8-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Mostly just come fixes and cleanups, but one feature as well. In detail:

- Harden the check for handling IOPOLL based on return (Pavel)

- Various minor optimizations (Pavel)

- Drop remnants of SCM_RIGHTS fd passing support, now that it's no
  longer supported since 6.7 (me)

- Fix for a case where bytes_done wasn't initialized properly on a
  failure condition for read/write requests (me)

- Move the register related code to a separate file (me)

- Add support for returning the provided ring buffer head (me)

- Add support for adding a direct descriptor to the normal file table
  (me, Christian Brauner)

- Fix for ensuring pending task_work for a ring with DEFER_TASKRUN is
  run even if we timeout waiting (me)

Note that this has Christian's vfs.file branch pulled in, as he renamed
__receive_fd() to receive_fd(). Sending this out now, as I saw Christian
already included this branch in his pull requests sent out last week.

Also note that this will throw a merge conflict with the block branch,
as we killed the IORING_URING_CMD_POLLED flag and associated cookie in
struct io_uring_cmd, and this branch moved those things to a different
file. The resolution is to remove all of the offending hunk in
include/linux/io_uring.h and then edit include/linux/io_uring/cmd.h,
killing IORING_URING_CMD_POLLED in there and getting rid of the union
and cookie field in struct io_uring_cmd. Including my resolution of the
merge at the end of the email.

Please pull!


The following changes since commit 4e94ddfe2aab72139acb8d5372fac9e6c3f3e383:

  file: remove __receive_fd() (2023-12-12 14:24:14 +0100)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.8/io_uring-2024-01-08

for you to fetch changes up to 6ff1407e24e6fdfa4a16ba9ba551e3d253a26391:

  io_uring: ensure local task_work is run on wait timeout (2024-01-04 12:21:08 -0700)

----------------------------------------------------------------
for-6.8/io_uring-2024-01-08

----------------------------------------------------------------
Jens Axboe (8):
      Merge branch 'vfs.file' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs into for-6.8/io_uring
      io_uring/openclose: add support for IORING_OP_FIXED_FD_INSTALL
      io_uring/register: move io_uring_register(2) related code to register.c
      io_uring/unix: drop usage of io_uring socket
      io_uring: drop any code related to SCM_RIGHTS
      io_uring/rw: ensure io->bytes_done is always initialized
      io_uring/kbuf: add method for returning provided buffer ring head
      io_uring: ensure local task_work is run on wait timeout

Pavel Begunkov (5):
      io_uring: don't check iopoll if request completes
      io_uring: optimise ltimeout for inline execution
      io_uring: split out cmd api into a separate header
      io_uring/cmd: inline io_uring_cmd_do_in_task_lazy
      io_uring/cmd: inline io_uring_cmd_get_task
      
 MAINTAINERS                    |   1 +
 drivers/block/ublk_drv.c       |   2 +-
 drivers/nvme/host/ioctl.c      |   2 +-
 include/linux/io_uring.h       |  95 +------
 include/linux/io_uring/cmd.h   |  82 ++++++
 include/linux/io_uring_types.h |  34 ++-
 include/uapi/linux/io_uring.h  |  19 ++
 io_uring/Makefile              |   2 +-
 io_uring/filetable.c           |  11 +-
 io_uring/io_uring.c            | 663 +++-------------------------------------------
 io_uring/io_uring.h            |  19 +-
 io_uring/kbuf.c                |  26 ++
 io_uring/kbuf.h                |   1 +
 io_uring/opdef.c               |   9 +
 io_uring/openclose.c           |  44 +++
 io_uring/openclose.h           |   3 +
 io_uring/register.c            | 605 ++++++++++++++++++++++++++++++++++++++++++
 io_uring/register.h            |   8 +
 io_uring/rsrc.c                | 169 +-----------
 io_uring/rsrc.h                |  15 --
 io_uring/rw.c                  |  12 +-
 io_uring/uring_cmd.c           |  15 +-
 net/core/scm.c                 |   2 +-
 net/unix/scm.c                 |   4 +-
 security/selinux/hooks.c       |   2 +-
 security/smack/smack_lsm.c     |   2 +-
 26 files changed, 895 insertions(+), 952 deletions(-)
 create mode 100644 include/linux/io_uring/cmd.h
 create mode 100644 io_uring/register.c
 create mode 100644 io_uring/register.h


commit 4437f65f37924cdce96bcd687cbe225f175e70da
Merge: aed185852af9 6ff1407e24e6
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Jan 8 11:21:41 2024 -0700

    Merge branch 'for-6.8/io_uring' into test
    
    * for-6.8/io_uring:
      io_uring: ensure local task_work is run on wait timeout
      io_uring/kbuf: add method for returning provided buffer ring head
      io_uring/rw: ensure io->bytes_done is always initialized
      io_uring: drop any code related to SCM_RIGHTS
      io_uring/unix: drop usage of io_uring socket
      io_uring/register: move io_uring_register(2) related code to register.c
      io_uring/openclose: add support for IORING_OP_FIXED_FD_INSTALL
      io_uring/cmd: inline io_uring_cmd_get_task
      io_uring/cmd: inline io_uring_cmd_do_in_task_lazy
      io_uring: split out cmd api into a separate header
      io_uring: optimise ltimeout for inline execution
      io_uring: don't check iopoll if request completes
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --cc include/linux/io_uring/cmd.h
index 000000000000,d69b4038aa3e..e453a997c060
mode 000000,100644..100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@@ -1,0 -1,82 +1,77 @@@
+ /* SPDX-License-Identifier: GPL-2.0-or-later */
+ #ifndef _LINUX_IO_URING_CMD_H
+ #define _LINUX_IO_URING_CMD_H
+ 
+ #include <uapi/linux/io_uring.h>
+ #include <linux/io_uring_types.h>
+ 
+ /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
+ #define IORING_URING_CMD_CANCELABLE	(1U << 30)
 -#define IORING_URING_CMD_POLLED		(1U << 31)
+ 
+ struct io_uring_cmd {
+ 	struct file	*file;
+ 	const struct io_uring_sqe *sqe;
 -	union {
 -		/* callback to defer completions to task context */
 -		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
 -		/* used for polled completion */
 -		void *cookie;
 -	};
++	/* callback to defer completions to task context */
++	void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
+ 	u32		cmd_op;
+ 	u32		flags;
+ 	u8		pdu[32]; /* available inline for free use */
+ };
+ 
+ static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
+ {
+ 	return sqe->cmd;
+ }
+ 
+ #if defined(CONFIG_IO_URING)
+ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+ 			      struct iov_iter *iter, void *ioucmd);
+ void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
+ 			unsigned issue_flags);
+ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
+ 			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+ 			    unsigned flags);
+ 
+ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+ 		unsigned int issue_flags);
+ 
+ #else
+ static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+ 			      struct iov_iter *iter, void *ioucmd)
+ {
+ 	return -EOPNOTSUPP;
+ }
+ static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
+ 		ssize_t ret2, unsigned issue_flags)
+ {
+ }
+ static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
+ 			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+ 			    unsigned flags)
+ {
+ }
+ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
+ 		unsigned int issue_flags)
+ {
+ }
+ #endif
+ 
+ /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
+ static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
+ 			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+ {
+ 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
+ }
+ 
+ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+ 			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+ {
+ 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
+ }
+ 
+ static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
+ {
+ 	return cmd_to_io_kiocb(cmd)->task;
+ }
+ 
+ #endif /* _LINUX_IO_URING_CMD_H */

-- 
Jens Axboe


