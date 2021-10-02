Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5802941F940
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 03:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhJBByb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 21:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhJBByb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 21:54:31 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FF2C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 18:52:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 187so5026059pfc.10
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 18:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJPByiswYIbyzaGtcREaTsHWTi13SpjLcUpOmwR2fl8=;
        b=Q7A9DXEinrz/C1em+Cb3JfiYsOeVWp8PE3FDGqdVo8wo5FHNGxwZTnNyyO83Wh7h0+
         CLDUScsDcVLe+oc2yu3Ej3KoC3q4lVPNSbmvDcngdmnhIxyPx0qRHnkVYBnM6NNBz8ez
         KHHnSU71X2LD/dLj1k22bCHNi7js7afpcqhX7OP/j2BvfwHK7je2gL6H/2NEbc5TCv9b
         bLoIbzeTLpMENqhnoj7eonFiFNB/foxy5IX57Vopnq2Pxc8RTITdOzHYcGpdq+8qWOGN
         /bDtuQh1VzPNX5d8CGmUHGHpajZEzl458IsATfOBqVbSEjdUcgFGimlW7vayMiL+cH8o
         RTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJPByiswYIbyzaGtcREaTsHWTi13SpjLcUpOmwR2fl8=;
        b=Wihy7bJRZtycDZgunH20u4bomlQnh5834E52kLww9kmkb5LHUojFz2oHaZ0OJskpwo
         +DB4xvT4z6fWKUKkSveTwhTBJ/rrxEtHoMllOovWKs87UDzpOLNtxEik+kvgaRAjR0zC
         Lc29MIV85mtVcwT/6AqMckzsToPyoiKzLpj6bgu1ogZZWWPHfxVgmQwmIHMjBA+/BxGV
         /8omd2YL/YRRiLUcN/wJyBSKSzvotAG6jWeFzxXaBNu8l+arvB1wSknK2Kooh35A/BBn
         QUn2eJoHlgT1KO/O4e1qML01OVO1aMZk2kdWy8qQHzWovo4R7aLojpYSfGE7O5WUypBF
         NB6w==
X-Gm-Message-State: AOAM533F3FNurXPOeXPlFk3hl7kbmlnDDQ6W2f8SU2Qf0nn/aA3fbjmz
        dboLYpxkIw120suG2zUtxO8Sow==
X-Google-Smtp-Source: ABdhPJwY/ljEPkfbBliMk1scB5wqY5hZHk7xUw9hUklMifapmX5LmKuwMUuZ4qVbr9x3rJfPfnISCQ==
X-Received: by 2002:a63:530e:: with SMTP id h14mr978790pgb.279.1633139566036;
        Fri, 01 Oct 2021 18:52:46 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id u4sm6989804pfn.190.2021.10.01.18.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:52:45 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCHSET v3 RFC liburing 0/4] Implement the kernel style return value
Date:   Sat,  2 Oct 2021 08:48:25 +0700
Message-Id: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone,

Sorry, v3 just to remove duplicate Signed-off-by.

This is the v3 of RFC to implement the kernel style return value for
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

Changes since v2:
- Remove duplicate Signed-off-by.

Link: https://github.com/axboe/liburing/issues/443
Link: [v1] https://lore.kernel.org/io-uring/20210929101606.62822-1-ammar.faizi@students.amikom.ac.id/T/
Link: [v2] https://lore.kernel.org/io-uring/20211002012817.107517-1-ammar.faizi@students.amikom.ac.id/T
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


