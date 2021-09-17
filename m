Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AEF40FAA3
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 16:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhIQOqp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 10:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhIQOp5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 10:45:57 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAF3C061766
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 07:44:35 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w1so10579898ilv.1
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 07:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nT0wb+iMCYQquzTa1VuwWnQ3IB+TB6x0u16S2BpGClQ=;
        b=Bv2d9S9GJdU2BUMnjv+DuzuOnB0gRJgyca+rQboP1rZ4RrZ8NPLKXsDDC/4nSbuih8
         aYej11l4CXh79v8s0DOr84Y4QuMlpuRUtwf8cssOWCkgvUOpskFPsZiFL8pqXICHx0a3
         ucZWRBDmmJLGyysMGYaNSy2xT9BcDjV9K457c19tqS1qgFYACRJH97aCciKgYiHy+4Dt
         FZpA5It2GrUhEer8s9b6xWnpxwKuvNH7gWN1zd4a4ca9B67Xayzg1P19w1WBw+EmuU46
         2vVBGbRLqtl6R7toIb6uawxbTcmv5adbkFn9AKM6YRTK3HfKb5XPWb4eMW7qQ5208jlB
         HDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nT0wb+iMCYQquzTa1VuwWnQ3IB+TB6x0u16S2BpGClQ=;
        b=D8cfpweyholegdUzlTXDdqjQQT5sJyOWfXYv2Gwi5fq/DgBZLVTnWcIRM4TRJiD2d3
         DXIhdiuA9+oMDDbRsazKrND6FPwssIXS6VOVFJSjnqoN+0DywD5IRSiMCn9N9Jsf9a1m
         4b4ZYfJl900ASOaIp7CAvN6SrWyAOtlWE7z5w+Ic68REsnwC3l9IHdTCZpK7/TdQho5t
         OlibYORuullcYfuXwLS+kos66VatnR1Vtb4mPQueS4zW+c1bPlx47bkLzxe1JY6iET5M
         5iCAyrbK0FeXj8oNB+0zN3jhnGN57hgbxcLNZo8dZtXogDhidG//lQq6jCvItM43bWh+
         kOuA==
X-Gm-Message-State: AOAM532uIOxI/aI46C+LBooeoCxVkINM3aZ0hli0MHgg92zaXLc2u1+2
        r4MOi8WBJuVhPm0CLclKJqEeIO+7/zzFh0cGZBE=
X-Google-Smtp-Source: ABdhPJxzk9T/i4NTbMfmR5FE17w43hzyL4kAmCit10hENyWGjlXF2a0c3qeBz7T6QkiBOrqFB/XERA==
X-Received: by 2002:a92:d0d2:: with SMTP id y18mr8450585ila.80.1631889874802;
        Fri, 17 Sep 2021 07:44:34 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 9sm3680215ily.9.2021.09.17.07.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 07:44:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] iov_iter retry fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Message-ID: <9460dc73-e471-d664-7610-a10812a4da24@kernel.dk>
Date:   Fri, 17 Sep 2021 08:44:32 -0600
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

This adds a helper to save/restore iov_iter state, and modifies io_uring
to use it. After that is done, we can kill the iter->truncated addition
that we added for this release. The io_uring change is being overly
cautious with the save/restore/advance, but better safe than sorry and
we can always improve that and reduce the overhead if it proves to be of
concern. The only case to be worried about in this regard is huge IO,
where iteration can take a while to iterate segments.

I spent some time writing test cases, and expanded the coverage quite a
bit from the last posting of this. liburing carries this regression test
case now:

https://git.kernel.dk/cgit/liburing/tree/test/file-verify.c

which exercises all of this. It now also supports provided buffers, and
explicitly tests for end-of-file/device truncation as well.

On top of that, Pavel sanitized the IOPOLL retry path to follow the
exact same pattern as normal IO.

Please pull!


The following changes since commit d6c338a741295c04ed84679153448b2fffd2c9cf:

  Merge tag 'for-linus-5.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml (2021-09-09 13:45:26 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/iov_iter.3-5.15-2021-09-17

for you to fetch changes up to b66ceaf324b394428bb47054140ddf03d8172e64:

  io_uring: move iopoll reissue into regular IO path (2021-09-15 09:22:35 -0600)

----------------------------------------------------------------
iov_iter.3-5.15-2021-09-17

----------------------------------------------------------------
Jens Axboe (3):
      iov_iter: add helper to save iov_iter state
      io_uring: use iov_iter state save/restore helpers
      Revert "iov_iter: track truncated size"

Pavel Begunkov (1):
      io_uring: move iopoll reissue into regular IO path

 fs/io_uring.c       | 116 ++++++++++++++++++++++++++++++++++------------------
 include/linux/uio.h |  21 +++++++---
 lib/iov_iter.c      |  36 ++++++++++++++++
 3 files changed, 128 insertions(+), 45 deletions(-)

-- 
Jens Axboe

