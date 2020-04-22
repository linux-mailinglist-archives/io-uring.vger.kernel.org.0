Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0E21B371D
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 08:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgDVGF5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 02:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVGF4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 02:05:56 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DBCC03C1A6;
        Tue, 21 Apr 2020 23:05:56 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d16so624235edv.8;
        Tue, 21 Apr 2020 23:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=0J7wpqIPjekpSgyN4c8bsABWOF449xYPFoLT/PLxb3g=;
        b=KEcbAmkM1enSx18mTQFJO+BTAUOuXkxB3/JCDOXSHjdsdipjTSoW0TFJ/b4uS7hF+6
         w7G+V+SNgJOEHFrfCF++XAO7Tqvmk5EIgWmJpPyjiF8Ek7DIqxeQMjBhT6nSxwrsTIWa
         4cIfNCYEQOQ53L/IuIdGVm1XNzoJPur7l5jGbbd4BHx3y4VHjzLn278Z3CMNY1RoC6pJ
         wwWoza8cfCH4RJzHlmXRweOfhgZ5gdqHzy5lIuIfLId9iM4suxPN7+5mmxXuA8Ri7ecF
         W1kQMqEzIvesvl8Eg9iqqOfuAh1Omi0Pvd104kNfi5vQl4FfqGsgWGJlWM48ahLKN/N6
         gFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=0J7wpqIPjekpSgyN4c8bsABWOF449xYPFoLT/PLxb3g=;
        b=XnOIIqyL/PSy98NkGnz9lZ/c60mkQRu3b7V8emrOWwCQ9fVFYRmLsWhroiMDaJMQ3u
         YG7T+8xFa9HNKfDFMFqOntwPN3JfXz1XWwbOYMm0HqLDH6NgQcRQ6f2hUAcfMJFKZkt+
         5phxGTYGB006D3wCc9AvyHU4bI1+7JPHZCdKPln5p3k9QnTvXrGyywdSC4V5WU3NJKLk
         8tWWh6N+bnm9ApIKbUcs1oBG0XnP9d4kktS4ttkKJpyu3WSh5HedjaQc8OqkDcSOJxGU
         SINB38xNpHhM3hjhV9uN0Y8Zj7u4cTb/okTuti1RZzi2J8XD2bknFXm1htaGS/A54K/1
         fzHQ==
X-Gm-Message-State: AGi0PubnxFPoTIFeFfBZqqiNCNlkgkeL2Axg3yOmURKTncsQFqw5lvF1
        +24YHAKN93Jukz0oLQlDPCdT+dZjr264DjOLyPE=
X-Google-Smtp-Source: APiQypJ+7lYBwuZOO0LKN5zF0UxsyS0mJHjcIoytsS3GDCjhJgfkdcUx0mzFBypChkJuW2x8po6k9cFV5nG0u0eOPeE=
X-Received: by 2002:a50:ec0c:: with SMTP id g12mr15990711edr.140.1587535554646;
 Tue, 21 Apr 2020 23:05:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587531463.git.josh@joshtriplett.org>
In-Reply-To: <cover.1587531463.git.josh@joshtriplett.org>
Reply-To: mtk.manpages@gmail.com
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date:   Wed, 22 Apr 2020 08:05:43 +0200
Message-ID: <CAKgNAkjMH6YvHa3LavDo4udDS4CxtJL80uenQN-SVd+Ef0-3Kg@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] Support userspace-selected fds
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[CC += linux-api]

On Wed, 22 Apr 2020 at 07:19, Josh Triplett <josh@joshtriplett.org> wrote:
>
> 5.8 material, not intended for 5.7. Now includes a patch for man-pages,
> attached to this cover letter.
>
> Inspired by the X protocol's handling of XIDs, allow userspace to select
> the file descriptor opened by a call like openat2, so that it can use
> the resulting file descriptor in subsequent system calls without waiting
> for the response to the initial openat2 syscall.
>
> The first patch is independent of the other two; it allows reserving
> file descriptors below a certain minimum for userspace-selected fd
> allocation only.
>
> The second patch implements userspace-selected fd allocation for
> openat2, introducing a new O_SPECIFIC_FD flag and an fd field in struct
> open_how. In io_uring, this allows sequences like openat2/read/close
> without waiting for the openat2 to complete. Multiple such sequences can
> overlap, as long as each uses a distinct file descriptor.
>
> The third patch adds userspace-selected fd allocation to pipe2 as well.
> I did this partly as a demonstration of how simple it is to wire up
> O_SPECIFIC_FD support for any fd-allocating system call, and partly in
> the hopes that this may make it more useful to wire up io_uring support
> for pipe2 in the future.
>
> v5:
>
> Rename padding field to __padding.
> Add tests for non-zero __padding.
> Include patch for man-pages.
>
> v4:
>
> Changed fd field to __u32.
> Expanded and consolidated checks that return -EINVAL for invalid arguments.
> Simplified and commented build_open_how.
> Add documentation comment for fd field.
> Add kselftests.
>
> Thanks to Aleksa Sarai for feedback.
>
> v3:
>
> This new version has an API to atomically increase the minimum fd and
> return the previous minimum, rather than just getting and setting the
> minimum; this makes it easier to allocate a range. (A library that might
> initialize after the program has already opened other file descriptors
> may need to check for existing open fds in the range after reserving it,
> and reserve more fds if needed; this can be done entirely in userspace,
> and we can't really do anything simpler in the kernel due to limitations
> on file-descriptor semantics, so this patch series avoids introducing
> any extra complexity in the kernel.)
>
> This new version also supports a __get_specific_unused_fd_flags call
> which accepts the limit for RLIMIT_NOFILE as an argument, analogous to
> __get_unused_fd_flags, since io_uring needs that to correctly handle
> RLIMIT_NOFILE.
>
> Thanks to Jens Axboe for review and feedback.
>
> v2:
>
> Version 2 was a version incorporated into a larger patch series from Jens Axboe
> on io_uring.
>
> Josh Triplett (3):
>   fs: Support setting a minimum fd for "lowest available fd" allocation
>   fs: openat2: Extend open_how to allow userspace-selected fds
>   fs: pipe2: Support O_SPECIFIC_FD
>
>  fs/fcntl.c                                    |  2 +-
>  fs/file.c                                     | 62 +++++++++++++++++--
>  fs/io_uring.c                                 |  3 +-
>  fs/open.c                                     |  8 ++-
>  fs/pipe.c                                     | 16 +++--
>  include/linux/fcntl.h                         |  5 +-
>  include/linux/fdtable.h                       |  1 +
>  include/linux/file.h                          |  4 ++
>  include/uapi/asm-generic/fcntl.h              |  4 ++
>  include/uapi/linux/openat2.h                  |  3 +
>  include/uapi/linux/prctl.h                    |  3 +
>  kernel/sys.c                                  |  5 ++
>  tools/testing/selftests/openat2/helpers.c     |  2 +-
>  tools/testing/selftests/openat2/helpers.h     | 21 +++++--
>  .../testing/selftests/openat2/openat2_test.c  | 35 ++++++++++-
>  15 files changed, 150 insertions(+), 24 deletions(-)
>
> --
> 2.26.2
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
