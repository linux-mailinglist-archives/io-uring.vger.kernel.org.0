Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0BA42012A
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 12:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhJCKT6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 06:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhJCKT6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 06:19:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC56C0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 03:18:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso5819318pjb.0
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 03:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NRd5k87jeoyESOMVvVdRpUyRrr0VPTMixAYc+K7E+yU=;
        b=eOoFn26Uhyygnn/7VMTjyCEMf6I22TQtgfsdPlRksKsinzrkKl0s0xrd6F02zaFqRO
         qNgrkbawLKMVhONjJ3eJf1k1dvUWFtwmsrUAhGzOG/2lKiZHTwO7RybnmoWQpU5T+Z8R
         x9OK3Pvm71VO20XpiCqPTi5D2Gl2Qxc2kp11lzDik7/TyiDZY4peCdZ4JlwWxYG6D/+y
         UvES5l2CdNoGVFS1lR5EFt/gDa5j3+vxljn1uXc/cskaW/tgvOZHenyNU2MVB5EwYVUX
         eqeoC5vOPISxT79nGlWoPrZ+3BiWKRGzc71N1kIv9vXKK3W12n+K9gjdB9BVYV7ds8W1
         3OUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NRd5k87jeoyESOMVvVdRpUyRrr0VPTMixAYc+K7E+yU=;
        b=RE2+Zcd0xss2rxm+1FfyDZbMQf3J/FHtCKJ4xmx1RP4UAIDE1bYd/zgB9L4ParfsUr
         KuWPiFICrlhhU6GLvJMUd8/5PCzOTvnqDzU0GOBQUiPD9UHel8ZP/l5Dsi8K4xbMvW8O
         G+CTHKSjaiaXN8lRLHOtL4/i9jvml5RdWJyZKw2rvXBF9DN/q2ND22v2ObKTlHJ1eUvd
         1n3F7yus9UVxx74mAGTOttlHGHe0wqD8MF5K+2iGNcgaUKazPEfwQ6/knpGt8/ZAhQ3C
         AAC0W0LXK2dMTjxmWfh0ZQsCwc+bg+EdmY6rLzXVsmWHcLZa/nkgpjf7eruCICKMrO+6
         I6Pw==
X-Gm-Message-State: AOAM533y5BJOFTiLU5oRMqyCsJnC3v/7kbLE/eJD+i2yyZHJmQcDvy0b
        oyni+iGpup3yMweWRH9+ye/2XQ==
X-Google-Smtp-Source: ABdhPJx8mebHLSAQpThpUUXNAj+4lAl1mpLh34yIL14FK81SJ4NsMDrfWyRMylTfhHdc/kJW4pndBQ==
X-Received: by 2002:a17:90a:4801:: with SMTP id a1mr29844851pjh.156.1633256290552;
        Sun, 03 Oct 2021 03:18:10 -0700 (PDT)
Received: from integral.. ([182.2.36.212])
        by smtp.gmail.com with ESMTPSA id d9sm10677290pgn.64.2021.10.03.03.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 03:18:09 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCHSET v4 RFC liburing 0/4] Implement the kernel style return value
Date:   Sun,  3 Oct 2021 17:17:47 +0700
Message-Id: <20211003101750.156218-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is the v4 of RFC to implement the kernel style return value for
liburing.

The main purpose of these changes is to make it possible to remove
the dependency of `errno` variable in the liburing C sources. If we
can land this on liburing, we will start working on adding support
build liburing without libc.

Currently, we expose these functions to userland:
  1) `__sys_io_uring_register`
  2) `__sys_io_uring_setup`
  3) `__sys_io_uring_enter2`
  4) `__sys_io_uring_enter`

The tests in `test/io_uring_{enter,register,setup}.c` are the examples
of it. Since the userland needs to check the `errno` value to use them
properly, this means those functions always depend on libc. So we
cannot change their behavior. Don't touch them all, this ensures the
changes only affect liburing internal and no visible functionality
changes for the users.

Then we introduce new functions with the same name (with extra
underscore as prefix, 4 underscores):
  1) `____sys_io_uring_register`
  2) `____sys_io_uring_setup`
  3) `____sys_io_uring_enter2`
  4) `____sys_io_uring_enter`

These functions do not use `errno` variable *on the caller*, they use
the kernel style return value (return a negative value of error code
when errors).

These functions are defined as `static inline` in `src/syscall.h`.
They are just a wrapper to make sure liburing internal sources do not
touch `errno` variable from C files directly. We need to make C files
not to touch the `errno` variable to support build without libc.

To completely remove the `errno` variable dependency from liburing C
files. We wrap all syscalls in a kernel style return value as well.

Currently we have 5 other syscalls in liburing. We wrapped all of
them as these 5 functions:
  1) `uring_mmap`
  2) `uring_munmap`
  3) `uring_madvise`
  4) `uring_getrlimit`
  5) `uring_setrlimit`

All of them are `static inline` and will return a negative value of
error code in case error happens.

Extra new helpers:
  1) `ERR_PTR()`
  2) `PTR_ERR()`
  3) `IS_ERR()`

These helpers are used to deal with syscalls that return a pointer.
Currently only `uring_mmap()` that depends on these.

If you want a git repository to test these patches, you can pull from:

    git://github.com/ammarfaizi2/liburing.git tags/kernel-style-retval-v4

Please review and comment.
----------------------------------------------------------------
Changes from v1 to v2:
- Make all wrapper functions be `static inline`, so they don't pollute
  the global scope.
- Reduce the number of patches. Now we only have 4 patches (it was 6).

Changes from v2 to v3:
- Remove duplicate Signed-off-by.

Changes from v3 to v4 (this thread):
- Fix unintentional logic change [1].
- Don't take the kernel header file to have extra helpers (ERR_PTR,
  PTR_ERR, IS_ERR). Write our own helpers with the same principles [2].
- Change the wrapper prefix, it was
  `liburing_{mmap,munmap,madvise,{get,set}rlimit}`, now we use
  `uring_{mmap,munmap,madvise,{get,set}rlimit}` to make it more
  compact and consistent (as we already have `uring_{{un,}likely})`.
- Reduce the number of patches. Now we only have 3 patches (it was 4).

Link: [GH Issue] https://github.com/axboe/liburing/issues/443
Link: [v1] https://lore.kernel.org/io-uring/20210929101606.62822-1-ammar.faizi@students.amikom.ac.id/T/
Link: [v2] https://lore.kernel.org/io-uring/20211002012817.107517-1-ammar.faizi@students.amikom.ac.id/T/
Link: [v3] https://lore.kernel.org/io-uring/20211002014829.109096-1-ammar.faizi@students.amikom.ac.id/T/

#Ref
Link: [1] https://lore.kernel.org/io-uring/d760c684-8175-6647-01c5-f0107b6685c6@gmail.com/
Link: [2] https://github.com/axboe/liburing/issues/446
----------------------------------------------------------------
Ammar Faizi (3):
      src/syscall: Wrap `errno` for `__sys_io_uring_{register,setup,enter{2,}}`
      src/{queue,register,setup}: Don't use `__sys_io_uring*`
      Wrap all syscalls in a kernel style return value

 src/queue.c    |  28 +++----
 src/register.c | 197 +++++++++++++++--------------------------------
 src/setup.c    |  57 +++++++-------
 src/syscall.c  |  43 +----------
 src/syscall.h  | 141 +++++++++++++++++++++++++++++++++
 5 files changed, 247 insertions(+), 219 deletions(-)

-- 
Ammar Faizi


