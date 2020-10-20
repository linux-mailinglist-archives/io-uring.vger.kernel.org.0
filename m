Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFECE293EE8
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 16:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgJTOku (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 10:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730942AbgJTOkt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 10:40:49 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3239BC061755
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:40:48 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u19so3704361ion.3
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 07:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=B1KXMHL5Z+LnWoNEeMnqmxPn8LcQeg/5iCRDWB8ZmgA=;
        b=CfeJvFmLgsOC+w10H0vETufMq3sgrm7ZsX4f6bPpccElogp7CCTgXGL5kj6U7LrWSo
         5TI7RkWlFyMP+VAu3H+5UJxGjRAeZabCdhmEPAM3I8Z7O2LH0cbOOUs+fyB1HpPvtfjf
         5NcnqsrooV7/NXgI/aO1NtSzmChBeGPr0MiYpV6s5BYq7rafXZX7ZwsAlUZDBj5/E4nP
         1wJIslyR9I68eJgvr3dpDWBQgeeMx/7jFyO5PXEYAynmNMVrI43lcvQtwPfxXqx41DhU
         iAGeImnyYMhuRddyHyyruGevv8Tx/J02lyY7kAwxAMFfAhvf9Sp6yw9pYfzGTXzoJUW2
         zKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=B1KXMHL5Z+LnWoNEeMnqmxPn8LcQeg/5iCRDWB8ZmgA=;
        b=FEOccM6KRtTQD16or5qv9Q6D1URZ6ShRxUPPlChI9MaW6zEZfoQDcmVRvwmWpoGmAd
         wBwHNHC1CAFdHimQkOCWakZNHijWsU6z4SC2utoddbhssnTXYIs/RZtQzA8kHv4PWLNA
         XhEcWvuNjtp5YhokE2tTFNTBrhsPgCVzyHyM4mFE79/iNt3FYVxUjObyAHSTu9QbXlIT
         wM74frVA3u1jzqap0/ezjWpOMWl4ogLDe6+mltBvGqLArz+eV5pl75oWDqKvU9e/vCD8
         Yi4Nz1tG8ZAFcFUVZxS+zb21upWhzXW92epEsfKqLXXpPh4QVz1U9Kb8HU8A0LnZ6xLi
         kYZA==
X-Gm-Message-State: AOAM532A23RvjRICf6F2Jym3o1/DupD/IBddCGUCr01LG/tzAeyQn/Ej
        8AP19A4S2/iCpGXwUxB2MSZMJA==
X-Google-Smtp-Source: ABdhPJyL/2tMViYxqAbN0CYehbSVlZVMDaseRjDbUDl0kvcjlAjAiKBk7JIscYr2Y0AGekt2TzhmRg==
X-Received: by 2002:a05:6638:1651:: with SMTP id a17mr2311779jat.39.1603204847192;
        Tue, 20 Oct 2020 07:40:47 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v90sm2215162ili.75.2020.10.20.07.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 07:40:46 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.9-rc1
Message-ID: <a4cf582e-1f2f-4567-a32d-87736453b0fb@kernel.dk>
Date:   Tue, 20 Oct 2020 08:40:46 -0600
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

A mix of fixes and a few stragglers. In detail:

- Revert the bogus __read_mostly that we discussed for the initial pull
  request.

- Fix a merge window regression with fixed file registration error path
  handling.

- Fix io-wq numa node affinities.

- Series abstracting out an io_identity struct, making it both easier to
  see what the personality items are, and also easier to to adopt more.
  Use this to cover audit logging.

- Fix for read-ahead disabled block condition in async buffered reads,
  and using single page read-ahead to unify what
  generic_file_buffer_read() path is used.

- Series for REQ_F_COMP_LOCKED fix and removal of it (Pavel)

- Poll fix (Pavel)

Please pull!


The following changes since commit 071a0578b0ce0b0e543d1e38ee6926b9cc21c198:

  Merge tag 'ovl-update-5.10' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs (2020-10-16 15:29:46 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-20

for you to fetch changes up to 9ba0d0c81284f4ec0b24529bdba2fc68b9d6a09a:

  io_uring: use blk_queue_nowait() to check if NOWAIT supported (2020-10-19 07:32:36 -0600)

----------------------------------------------------------------
io_uring-5.10-2020-10-20

----------------------------------------------------------------
Colin Ian King (1):
      io_uring: Fix sizeof() mismatch

Jeffle Xu (1):
      io_uring: use blk_queue_nowait() to check if NOWAIT supported

Jens Axboe (13):
      Revert "io_uring: mark io_uring_fops/io_op_defs as __read_mostly"
      io_uring: fix error path cleanup in io_sqe_files_register()
      io-wq: assign NUMA node locality if appropriate
      io_uring: pass required context in as flags
      io_uring: rely solely on work flags to determine personality.
      io_uring: move io identity items into separate struct
      io_uring: COW io_identity on mismatch
      io_uring: store io_identity in io_uring_task
      io_uring: assign new io_identity for task if members have changed
      io_uring: use percpu counters to track inflight requests
      io-wq: inherit audit loginuid and sessionid
      mm: mark async iocb read as NOWAIT once some data has been copied
      mm: use limited read-ahead to satisfy read

Pavel Begunkov (6):
      io_uring: don't set COMP_LOCKED if won't put
      io_uring: don't unnecessarily clear F_LINK_TIMEOUT
      io_uring: don't put a poll req under spinlock
      io_uring: dig out COMP_LOCK from deep call chain
      io_uring: fix REQ_F_COMP_LOCKED by killing it
      io_uring: fix double poll mask init

 fs/io-wq.c               |  51 ++--
 fs/io-wq.h               |  18 +-
 fs/io_uring.c            | 648 ++++++++++++++++++++++++++++-------------------
 fs/proc/base.c           |   4 +
 include/linux/io_uring.h |  27 +-
 mm/filemap.c             |   8 +
 mm/readahead.c           |  20 +-
 7 files changed, 475 insertions(+), 301 deletions(-)

-- 
Jens Axboe

