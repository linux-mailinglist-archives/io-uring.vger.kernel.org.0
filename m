Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA268585F5C
	for <lists+io-uring@lfdr.de>; Sun, 31 Jul 2022 17:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbiGaPDf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jul 2022 11:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbiGaPDe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Jul 2022 11:03:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE74DEE3
        for <io-uring@vger.kernel.org>; Sun, 31 Jul 2022 08:03:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g12so8462022pfb.3
        for <io-uring@vger.kernel.org>; Sun, 31 Jul 2022 08:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=CqarRD0qBma+nkDvEq8uD5MNW2b7at7eSJRZBX+iSRg=;
        b=c+Lg4tTvxwhoOwnitw/8esS0JfRoc7588NH7ZMpcW3trPL7rLOUSI9E/7Fn9wyoTXR
         iqvu1jS9uH0faNEStn9gcKsXTyKXNAgsmqpYhSSGq9GPLziCD8YhniqMqEL1C6pEj1Pc
         x9DXY+9k/GIkN2xA3bfpjoUIqEL1v+nOIPfPx9A9YlQ8ZOTf+/wTMeWJr3nIvhmK/fud
         w0zhCeQpGtOBIYB1QuxuCw0VwqqN8reqSThtHucdOm3MJ+N4+sE+KafHGvTugfal/DqZ
         x1kOttY8idYKSHL64B/VsfAAZl6tTrvgoFWOsuvLGlEz36VhHp0nZOeUxRm7XFFOTKE3
         96PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=CqarRD0qBma+nkDvEq8uD5MNW2b7at7eSJRZBX+iSRg=;
        b=AOAY6eIRGyVwkTpDrFkDwoZuWdu6q5lFgYADfVbaoa280B1qv4aNgRYctT0mlYQqXe
         WlrtLr6YO4e+U3LR8CGnhmRnd4vAcxnN4wR8knnRsjW8aK3EvCmZiWVT45KqKATD5M9/
         3/W9nWObo7zk6oXRR8R1rPs/kce791vDkUeKjs01iL6dzculOPClgfzsz1V2TU/g6poi
         wGX5Ec/F/HuR2M/aYK6crzBvbwCdWAUWMpyqhxFLPeWXNMx3f3uvGm6iphSMf/wlNefY
         omfS6BmTHCMWqaoJkKTjhMSOcF6oEz/wWmQZcR4gZ7nsQ2On3PQt+PBSxulSIPQiZ0q4
         ISPg==
X-Gm-Message-State: AJIora9+pzL5SPkxUyQ0Fy+zGoCIZLea2aOv4B+jWgfxOU2ND5mGJP4x
        Zk1WLG36I2HYj/aArghT7u85MA==
X-Google-Smtp-Source: AGRyM1sbh/JldyhtTyQMu6gVq6HNWLs7pK2HOedzv2yx6vukYAF9/lxIclfHNmb5/Hjseat7ThTgNA==
X-Received: by 2002:a63:eb0d:0:b0:41b:7a15:1fbb with SMTP id t13-20020a63eb0d000000b0041b7a151fbbmr10085682pgh.511.1659279812442;
        Sun, 31 Jul 2022 08:03:32 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u17-20020a170903125100b0016d33b8a231sm7582928plh.270.2022.07.31.08.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 08:03:32 -0700 (PDT)
Message-ID: <c737af00-e879-fe01-380c-ba95b555f423@kernel.dk>
Date:   Sun, 31 Jul 2022 09:03:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring support for buffered writes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

On top of the core io_uring changes for 5.20, this pull request contains
support for buffered writes, specifically for XFS. btrfs is in progress,
will be coming in the next release.

io_uring does support buffered writes on any file type, but since the
buffered write path just always -EAGAIN (or -EOPNOTSUPP) any attempt to
do so if IOCB_NOWAIT is set, any buffered write will effectively be
handled by io-wq offload. This isn't very efficient, and we even have
specific code in io-wq to serialize buffered writes to the same inode to
avoid further inefficiencies with thread offload.

This is particularly sad since most buffered writes don't block, they
simply copy data to a page and dirty it. With this pull request, we can
handle buffered writes a lot more effiently. If balance_dirty_pages()
needs to block, we back off on writes as indicated.

This improves buffered write support by 2-3x.

Jan Kara helped with the mm bits for this, and Stefan handled the
fs/iomap/xfs/io_uring parts of it.

Please pull!


The following changes since commit f6b543fd03d347e8bf245cee4f2d54eb6ffd8fcb:

  io_uring: ensure REQ_F_ISREG is set async offload (2022-07-24 18:39:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-buffered-writes-2022-07-29

for you to fetch changes up to 0dd316ba8692c2374fbb82cce57c0b23144f2977:

  mm: honor FGP_NOWAIT for page cache page allocation (2022-07-24 18:39:32 -0600)

----------------------------------------------------------------
for-5.20/io_uring-buffered-writes-2022-07-29

----------------------------------------------------------------
Jan Kara (3):
      mm: Move starting of background writeback into the main balancing loop
      mm: Move updates of dirty_exceeded into one place
      mm: Add balance_dirty_pages_ratelimited_flags() function

Jens Axboe (2):
      io_uring: fix issue with io_write() not always undoing sb_start_write()
      mm: honor FGP_NOWAIT for page cache page allocation

Stefan Roesch (11):
      iomap: Add flags parameter to iomap_page_create()
      iomap: Add async buffered write support
      iomap: Return -EAGAIN from iomap_write_iter()
      fs: add a FMODE_BUF_WASYNC flags for f_mode
      fs: add __remove_file_privs() with flags parameter
      fs: Split off inode_needs_update_time and __file_update_time
      fs: Add async write file modification handling.
      io_uring: Add support for async buffered writes
      io_uring: Add tracepoint for short writes
      xfs: Specify lockmode when calling xfs_ilock_for_iomap()
      xfs: Add async buffered write support

 fs/inode.c                      | 168 +++++++++++++++++++++++++++++-----------
 fs/iomap/buffered-io.c          |  67 ++++++++++++----
 fs/read_write.c                 |   4 +-
 fs/xfs/xfs_file.c               |  11 ++-
 fs/xfs/xfs_iomap.c              |  11 ++-
 include/linux/fs.h              |   4 +
 include/linux/writeback.h       |   7 ++
 include/trace/events/io_uring.h |  25 ++++++
 io_uring/rw.c                   |  41 ++++++++--
 mm/filemap.c                    |   4 +
 mm/page-writeback.c             |  89 +++++++++++++--------
 11 files changed, 323 insertions(+), 108 deletions(-)

-- 
Jens Axboe

