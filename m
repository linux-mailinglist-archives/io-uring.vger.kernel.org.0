Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D9E42024B
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 17:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhJCPhA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 11:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhJCPhA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 11:37:00 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FBFC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 08:35:13 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g14so12410763pfm.1
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 08:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7oZ3LknRw87TxBE/aHUj1fPe7W0HHxiwQ7+pPkQU93o=;
        b=LMnyb6QV/XgFFB1kdOzmbZwkCcKYYNSP9H68alx1S4EHBR1Gwo4Tf8l/iAJSBIiQ7K
         rMMlXlcwEgEP6xwvIv24avHTlGhGX9bQ0kOFq0bRTYZUnLGELjnQafbTCIJhxHJhLJ1t
         yVnVkQeMZK9083YDqXZZ//SwD16N0pNICYg7+0KzUifFdSeIsbhOWycsHW4A6wUCrh77
         sswfNc0v1iuccprMH2cLTSCvSIHuyk6zWuZx2a/6qYORTqlZSIjfhwuxWeIu+wGOO8fy
         ES+UxngmEakrDRZoZVEGeOl3kFIyVrCIaB6y3iC1YYXw/daOM+m3kXsiS93Wq+rpmIy+
         U1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7oZ3LknRw87TxBE/aHUj1fPe7W0HHxiwQ7+pPkQU93o=;
        b=UXCY/SpXAa7zvge37a39o+E5okuGTrvbZQs9RwbPsjD2mnDG5B3glxRcFhQWFBFpo7
         RRDvNizIhbiwBuxCbN2jLdpIHCqs5xOHij+/+MjsTRHiS13Og6gOEN4fMEvUkXr9t9j/
         egafp+Q+YrME3biWbw8SenQiy0YS3AiKLx6E1+ZyAFquRNUKlCp68AqRNGOMs+xVdhOG
         eFgSspyaQoOHewN6I8IXYkwNTMkiuIhUc5Xe6i9r7Um8zmme9Sjb6B7M0QrugB3R6aez
         m0HiXLW1KjaIajoOMItm0nWUpizKMU4gLEi0AG5sMcqd7ahz50zMB+N2HmLKExjRA5Wd
         WSlg==
X-Gm-Message-State: AOAM530+vwCRZ7pzNe8+pYgMm0h7rX9Gb+vCs1H+gTLlK0j2HdhwBjh/
        ZNp8wb7ZUwaO0vwuV0OucMV9XQ==
X-Google-Smtp-Source: ABdhPJyZwHA+/3HlmG7h55JAFfc/DXiILT4PjWp/ih/3MJ5PUy6OytyM/xDJy4G38r7ZKkVqvGmF7w==
X-Received: by 2002:a65:4008:: with SMTP id f8mr6945172pgp.310.1633275312404;
        Sun, 03 Oct 2021 08:35:12 -0700 (PDT)
Received: from integral.. ([182.2.73.133])
        by smtp.gmail.com with ESMTPSA id y42sm2625075pfa.203.2021.10.03.08.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 08:35:11 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCH v5 liburing 0/3] Implement the kernel style return value
Date:   Sun,  3 Oct 2021 22:34:25 +0700
Message-Id: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

This is the v5 of the kernel style return value implementation for
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

----------------------------------------------------------------

If you want view a git repository, you can take a look at:

  https://github.com/ammarfaizi2/liburing/tree/kernel-style-retval-v5

If you want a git tag, you can pull. The following changes since
commit ce10538688b93dafd257ebfed7faf18844e0052d:

  test: Fix endianess issue on `bind()` and `connect()` (2021-09-27 07:45:03 -0600)

are available in the Git repository at:

  git://github.com/ammarfaizi2/liburing.git tags/kernel-style-retval-v5

for you to fetch changes up to 0c210dbae26a80ee82dbc7430828ab6fd7012548:

  Wrap all syscalls in a kernel style return value (2021-10-03 21:37:25 +0700)

----------------------------------------------------------------
Changes from v1 to v2:
- Make all wrapper functions be `static inline`, so they don't pollute
  the global scope.
- Reduce the number of patches. Now we only have 4 patches (it was 6).

Changes from v2 to v3:
- Remove duplicate Signed-off-by.

Changes from v3 to v4:
- Fix unintentional logic change [1].
- Don't take the kernel header file to have extra helpers (ERR_PTR,
  PTR_ERR, IS_ERR). Write our own helpers with the same principles [2].
- Change the wrapper prefix, it was
  `liburing_{mmap,munmap,madvise,{get,set}rlimit}`, now we use
  `uring_{mmap,munmap,madvise,{get,set}rlimit}` to make it more
  compact and consistent (as we already have `uring_{{un,}likely})`.
- Reduce the number of patches. Now we only have 3 patches (it was 4).

Changes from v4 to v5 (this thread):
- Fix wrong functionality transformation of setrlimit() call [3].
- Fix code style, remove extra new line [3].

Link: [GH Issue] https://github.com/axboe/liburing/issues/443
Link: [v1] https://lore.kernel.org/io-uring/20210929101606.62822-1-ammar.faizi@students.amikom.ac.id/T/
Link: [v2] https://lore.kernel.org/io-uring/20211002012817.107517-1-ammar.faizi@students.amikom.ac.id/T/
Link: [v3] https://lore.kernel.org/io-uring/20211002014829.109096-1-ammar.faizi@students.amikom.ac.id/T/
Link: [v4] https://lore.kernel.org/io-uring/20211003101750.156218-1-ammar.faizi@students.amikom.ac.id/T/

#Ref
Link: [1] https://lore.kernel.org/io-uring/d760c684-8175-6647-01c5-f0107b6685c6@gmail.com/
Link: [2] https://github.com/axboe/liburing/issues/446
Link: [3] https://lore.kernel.org/io-uring/2f6be7db-5764-8a48-ccbd-4a49f522eae2@kernel.dk/
----------------------------------------------------------------
Ammar Faizi (3):
      src/syscall: Wrap `errno` for `__sys_io_uring_{register,setup,enter{2,}}`
      src/{queue,register,setup}: Don't use `__sys_io_uring*`
      Wrap all syscalls in a kernel style return value

 src/queue.c    |  28 +++----
 src/register.c | 197 +++++++++++++++--------------------------------
 src/setup.c    |  57 +++++++-------
 src/syscall.c  |  43 +----------
 src/syscall.h  | 139 +++++++++++++++++++++++++++++++++
 5 files changed, 245 insertions(+), 219 deletions(-)

-- 
Ammar Faizi


