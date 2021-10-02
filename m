Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C4341F929
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 03:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhJBBal (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 21:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhJBBak (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 21:30:40 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2FFC061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 18:28:55 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s55so8347658pfw.4
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 18:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wj20u24XpWc7LHuF6SioybL0Cy22FbnTxnMExkxdniA=;
        b=HkK1+m3OFTz/MtQQ+nRjtxX80TfnBqJHPW89H+Jn2Qud+LQ32hrJi2tCUwGRO9p1v7
         RAxkkEeF2WzKMvjAB6zXJy5/L/RcArZVOCVNdm78Tr2ciVoELcfG78XJi+yRsuaWaQvP
         wDcXQbKJE8Yd/MhC94aw1A+BPxuj82U/gKXFGhJDSldMPaL5fRF5M5jy1Bt9bsRgl4s6
         alj8ryajh68s0Jo8BNGeuuHKlKlQ3FPA86wCBHS4cgXPxCz3VX+yX3FBd/ZA4ziJ1WI8
         1+yatXuudge3q5fu8AAl7o4bl+lt5RQwb7wP8BE1aqhECjwPWtoDTXkxQvxUlKdeK5TZ
         v4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wj20u24XpWc7LHuF6SioybL0Cy22FbnTxnMExkxdniA=;
        b=cc4XBTImr3lhd15QafWS2NE5itYDGzsnuVYZfV6MHkUe286aVRzUfEFgACu/Sw5Kt8
         SWtDg0TQeTPCpplo9t5BkBqQNrsxeajGsSVJy2gbfqfI9akmPW7JE2Bk2NmjuGoXMoRe
         4ccRaGRoNyClVCC4h8DrUtHlZZHUxU6xewM14MTAicqCj8wPpjZ3P+MMqlxwBhroqVQJ
         PPCoAFvcXoIZwCSz5lcqIOfxUTNSkUiinAt/LHuyXCU7X8H7ELIj2fPqUtT08Lu5pAd/
         RC9r87a3aqJeblDcVdlmFyXx8B9xg7/gULoeUOj1PnCz+vBCn5eVNw78ronWUSswLmya
         mkUQ==
X-Gm-Message-State: AOAM531pJ+UyK6Y7huVw/+U61L8Sm/kGGLocYPm++NmCBtIlvg+1knRM
        5fOYS9dT5GTacH9VuNV1E0akhg==
X-Google-Smtp-Source: ABdhPJz3YBEDJOH4tD7Ld6Q3yTV6wErFGw3n64sXwxnMgcDaUAaJEh6vK4pSvmR1LEqo+D4c6MoQdQ==
X-Received: by 2002:a63:4607:: with SMTP id t7mr934853pga.332.1633138134541;
        Fri, 01 Oct 2021 18:28:54 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id b13sm867654pjl.15.2021.10.01.18.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:28:53 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCHSET v2 RFC liburing 0/4] Implement the kernel style return value 
Date:   Sat,  2 Oct 2021 08:28:13 +0700
Message-Id: <20211002012817.107517-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone,

This is the v2 of RFC to implement the kernel style return value for
liburing.

The main purpose of these changes is to make it possible to remove
the dependency of `errno` variable. If we can land this on liburing,
we will start working on no libc support with raw system call written
in Assembly (no libc). These changes should not affect the user, only
affect liburing internal sources.

We do not plan to drop the libc dependency, we just want to make it
possible to build liburing without the libc.

Currently, we expose these functions to userland:
  1) `__sys_io_uring_register`
  2) `__sys_io_uring_setup`
  3) `__sys_io_uring_enter2`
  4) `__sys_io_uring_enter`

The tests in `test/io_uring_{enter,register,setup}.c` are the examples
of it. Since the userland needs to check the `errno` value to use them
properly, this means those functions always depend on libc. So we
cannot change their behavior. This ensures the changes only affect
liburing internal and no visible functionality changes for the users.

Then we introduce new functions with the same name (with extra
underscore as prefix, 4 underscores):
  1) `____sys_io_uring_register`
  2) `____sys_io_uring_setup`
  3) `____sys_io_uring_enter2`
  4) `____sys_io_uring_enter`
    
These functions do not use `errno` variable *on the caller*, they use
the kernel style return value (return a negative value of error code
when errors).

These functions are defined as `inline static` in `src/syscall.h`.
They are just a wrapper to make sure liburing internal sources do not
touch `errno` variable from C files directly.

After that, we need to deal with other syscalls. Currently we have 5
wrapper functions for all syscalls used in liburing. They are:
  1) `liburing_mmap`
  2) `liburing_munmap`
  3) `liburing_madvise`
  4) `liburing_getrlimit`
  5) `liburing_setrlimit`

Also add kernel error header `src/kernel_err.h`, this is taken from
the Linux kernel source `include/linux/err.h` with a bit modification.

The purpose of `src/kernel_err.h` file is to use `PTR_ERR()`,
`ERR_PTR()`, etc. to implement the kernel style return value for
pointer return value. Currently only `liburing_mmap()` that depends
on this kernel error header file.

If you want a git repository, you can take a look at:
    
    git://github.com/ammarfaizi2/liburing.git kernel-style-retval

Please review.
----------------------------------------------------------------
Changes since v1:
- Make all wrapper functions be `static inline`, so they don't pollute
  the global scope.
- Reduce the number of patches. Now we only have 4 patches (it was 6).

Link: https://github.com/axboe/liburing/issues/443
Link: [v1] https://lore.kernel.org/io-uring/20210929101606.62822-1-ammar.faizi@students.amikom.ac.id/
----------------------------------------------------------------
Ammar Faizi (4):
      src/syscall: Implement the kernel style return value
      src/{queue,register,setup}: Don't use `__sys_io_uring*`
      Wrap all syscalls in a kernel style return value
      src/{queue,register,setup}: Remove `#include <errno.h>`

 src/kernel_err.h |  75 ++++++++++++++++++
 src/queue.c      |  28 +++----
 src/register.c   | 190 ++++++++++++++-------------------------------
 src/setup.c      |  61 ++++++++-------
 src/syscall.c    |  42 +---------
 src/syscall.h    | 130 +++++++++++++++++++++++++++++++
 6 files changed, 310 insertions(+), 216 deletions(-)
 create mode 100644 src/kernel_err.h

--
Ammar Faizi


