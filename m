Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0819241C270
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 12:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245434AbhI2KSe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 06:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245399AbhI2KSb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 06:18:31 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34321C06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:16:50 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id oa12-20020a17090b1bcc00b0019f2d30c08fso1548177pjb.0
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=46/0bs843RjvH3rqO8W8WaPNtgmBvV8EfJIwIzqPPM4=;
        b=Qv9oTCtDsx1vPzdl5FLKnMJlV6yReCtifOvL7K3VaNpmXhnroqLCEt6EuF+hw3H8mA
         O9MAMKpeBAGD9GEamIuSwMlnM/Vtiw78x95OvSLpe7P7Xp6AThSitgbVo71SDKvCXpG4
         Pi5eCzrDreZZXH41GY579iWIrapqWhZgBeOT+xI8rh+MHsGw3WAlyXPTKh90H+Zdy9ty
         UGxLjcGbT6HuCurUBtxStfKX8E/TRaPJH2a/Y3mnZehUIbeCjC6U6Axk0eR7UFvmLNcR
         WSn1qPsSt8+IO4Ho+k++nDa6uBBbTVb5eswzSGZsPIZlaKd5oVY8V3WwaCi9M4TCkHFD
         3Phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=46/0bs843RjvH3rqO8W8WaPNtgmBvV8EfJIwIzqPPM4=;
        b=xPPhv3VC9U1sVaL2aYeJ9xKLhdcNRc92uc+Ycz1KLn5W3TJoBfaJKWcG/dzWMV6FeS
         COzFwyDkcn9iVKLv8GZhQh0OPxmI4EBk14d50Gs+YYSehgSYctH8/FpiRWdVlrxRT9ik
         PyuL17VHlGcBOLzJhE3jR+Ukdg1DUuk4Zg3RPggSry1kwk5WLS0KbgbQAziAZjIzO4lr
         wHHFl09FFceuuRvmDjgVeP+asmGskBEJRVjHhRFobiuoHQ2FuM8U44Fp1V70CLtI4lSJ
         2pNNoel0dwIgagrDOqy8yczsVhmDl+4Ziq4jeqZZZhZR7g0fJvuaogRH35K7J955LT0K
         RZWA==
X-Gm-Message-State: AOAM531LJMDLeHlcZPmfwMZ39z1NFNtGII3Ww5PYxmDKMjhU7fc5D90W
        MYCj8/HpbSKrgbhQcKWT+GDJKQ==
X-Google-Smtp-Source: ABdhPJyGcLQcroH4nyjlKAlwivpcsC2txPw8MtEGa1x6iLuPokSh0IsUKp9maehinHIPlOJ3mqO8BQ==
X-Received: by 2002:a17:902:cec2:b0:13b:5916:59e1 with SMTP id d2-20020a170902cec200b0013b591659e1mr9231494plg.76.1632910609566;
        Wed, 29 Sep 2021 03:16:49 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id f16sm2001512pfk.110.2021.09.29.03.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 03:16:48 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCHSET v1 RFC liburing 0/6] Implement the kernel style return value
Date:   Wed, 29 Sep 2021 17:16:00 +0700
Message-Id: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
Hi Pavel,

This is the v1 of RFC to implement the kernel style return value.

Motivation:
Currently liburing depends on libc. We want to make liburing can be
built without libc.

This idea firstly posted as an issue on the liburing GitHub
repository here: https://github.com/axboe/liburing/issues/443

The subject of the issue is: "An option to use liburing without libc?".

On Mon, Sep 27, 2021 at 4:18 PM Mahdi Rakhshandehroo <notifications@github.com> wrote:
> There are a couple of issues with liburing's libc dependency:
> 
>  1) libc implementations of errno, malloc, pthread etc. tend to
>     pollute the binary with unwanted global/thread-local state.
>     This makes reentrancy impossible and relocations expensive.
>  2) libc doesn't play nice with non-POSIX threading models, like
>     green threads with small stack sizes, or direct use of the
>     clone() system call. This makes interop with other
>     languages/runtimes difficult.
> 
> One could use the raw syscall interface to io_uring to address these
> concerns, but that would be somewhat painful, so it would be nice
> for liburing to support this use case out of the box. Perhaps
> something like a NOLIBC macro could be added which, if defined,
> would patch out libc constructs and replace them with non-libc
> wrappers where applicable. A few API changes might be necessary for
> the non-libc case (e.g. io_uring_get_probe/io_uring_free_probe), but
> it shouldn't break existing applications as long as it's opt-in.

----------------------------------------------------------------

### 1) Introduction

We want to make the changes incrementally, start from making it
possible to remove the `errno` variable dependency.

So this RFC aims to make it possible to remove `errno` variable
depedency from the liburing sources by implementing the kernel style
return value.

What we mean by "kernel style return value" is that, we wrap the
syscall API to make it return negative error code when error happens,
like we usually do in the kernel space code. So the caller doesn't
have to check the `errno` variable.

If we can land this "kernel style return value" on liburing, we will
start working on series to support build with no libc. These changes
will not break user land and no functional changes will be visible to
user (only affect liburing internal sources).


### 2) How to deal with __sys_io_uring_{register,setup,enter2,enter}

Currently we expose these functions (**AAA**) to userland:
**AAA**:
  1) `__sys_io_uring_register`
  2) `__sys_io_uring_setup`
  3) `__sys_io_uring_enter2`
  4) `__sys_io_uring_enter`

These functions are used by several tests. As the userland needs to
check the `errno` value to use them properly, this means those
functions always depend on libc. So we cannot change their behavior.

As such, only for the **no libc** environment case, we remove those
functions (**AAA**).

Then we introduce new functions (**BBB**) with the same name (with
extra underscore as prefix, 4 underscores). These functions do not
use `errno` variable on the caller (they use the kernel style return
value) and always exist regardless the libc existence.

**BBB**:
  1) `____sys_io_uring_register`
  2) `____sys_io_uring_setup`
  3) `____sys_io_uring_enter2`
  4) `____sys_io_uring_enter`
    
Summary
  1) **AAA** will only exist for the libc environment.

  2) **BBB** always exists.

  3) Do not use **AAA** for the liburing internal (it's just for the
     userland backward compatibility).

  4) For the libc environment, **BBB** may use `syscall(2)` and
     `errno` variable, only to emulate the kernel style return value.

  5) For the no libc environment, **BBB** will use Assembly interface
     to perform the syscall (arch dependent).

  6) Tests should not be affected, this is because of (1) and (4),
     which keep the compatibility.


### 3) How to deal syscalls

We have 3 patches in this series to wrap the syscalls, they are:
  - Add `liburing_mmap()` and `liburing_munmap()`
  - Add `liburing_madvise()`
  - Add `liburing_getrlimit()` and `liburing_setrlimit()`

For `liburing_{munmap,madvise,getrlimit,setrlimit}`, they will return
negative value of error code if error. They basically just return
an int, so nothing to worry about.

Special case is for pointer return value like `liburing_mmap()`. In
this case we take the `include/linux/err.h` file from the Linux kernel
source tree and use `IS_ERR()`, `PTR_ERR()`, `ERR_PTR()` to deal with
it.

It is implemented in patch:
  - Add kernel error header `src/kernel_err.h`


### 4) How can this help to support no libc environment?

When this kernel style return value gets adapted on liburing, we will
start working on raw syscall directly written in Assembly (arch
dependent).

Me (Ammar Faizi) will start kicking the tires from x86-64 arch.
Hopefully we will get support for other architectures as well.

The example of liburing syscall wrapper may look like this:

```c
void *liburing_mmap(void *addr, size_t length, int prot, int flags,
		    int fd, off_t offset)
{	
#ifdef LIBURING_NOLIBC
	/*
	 * This is when we build without libc.
	 *
	 * Assume __raw_mmap is the syscall written in ASM.
	 *
	 * The return value is directly taken from the syscall
	 * return value.
	 */
	return __raw_mmap(addr, length, prot, flags, fd, offset);
#else
	/*
	 * This is when libc exists.
	 */
	void *ret;

	ret = mmap(addr, length, prot, flags, fd, offset);
	if (ret == MAP_FAILED)
		ret = ERR_PTR(-errno);

	return ret;
#endif
}
```

----------------------------------------------------------------
The following changes since commit ce10538688b93dafd257ebfed7faf18844e0052d:

  test: Fix endianess issue on `bind()` and `connect()` (2021-09-27 07:45:03 -0600)

based on:

  git://git.kernel.dk/liburing.git master

are available as 6 patches in this series, all will be posted as a
response to this one.

If you want to take git tag, it is available in the Git repository at:

  git://github.com/ammarfaizi2/liburing.git tags/nolibc-support-rfc-v1

Please review!

----------------------------------------------------------------
Ammar Faizi (6):
      src/syscall: Implement the kernel style return value
      Add kernel error header `src/kernel_err.h`
      Add `liburing_mmap()` and `liburing_munmap()`
      Add `liburing_madvise()`
      Add `liburing_getrlimit()` and `liburing_setrlimit()`
      src/{queue,register,setup}: Remove `#include <errno.h>`

 src/kernel_err.h |  75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/queue.c      |  28 +++++++++----------------
 src/register.c   | 189 +++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------------------------------
 src/setup.c      |  60 ++++++++++++++++++++++++++++-------------------------
 src/syscall.c    |  92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 src/syscall.h    |  18 ++++++++++++++++
 6 files changed, 284 insertions(+), 178 deletions(-)
 create mode 100644 src/kernel_err.h

--
Ammar Faizi


