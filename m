Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AE51DF09E
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgEVUYP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731018AbgEVUXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:23:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86BAC08C5C0
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:18 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y18so5666546pfl.9
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ab5UacrWfMxKEXoTvw+r9z4XQbT+Q8YnFiaJgTUI+4I=;
        b=eqDNPpx4Yx8kNVwfnScgWQcHCBoZ7c5VUXgFz6LhgOr5p2F74g+oGbfecIsGYaSdQs
         cN0iE1NTgsEPLNpzJivRdEWhg9BW19nqRF8lhW9X5Fq7xSEuRwCK62gHH2vV1cnEQw8B
         W81tcC2QqdCxFrXjlmBBiYa6tgTT0IPQmvfa70K5s6O0NQLRGU5zVc9XZuoU5sU7I1QY
         IUkS4AjhttnQaz0cBpR1uhjgCorl4QNOUjv5pKZdqcReX/1aWYc7/JAaMp8Skg6SVml4
         hTZecBKBZqHFzZGr1DxRlwnPkzB9Ptgt/1WHt4IqANo3U5t7g1faSXe8aQH9d8vwp66g
         qR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ab5UacrWfMxKEXoTvw+r9z4XQbT+Q8YnFiaJgTUI+4I=;
        b=uEgaqwEymIjQvRuuzhhWYkc331hDI6q+NNVNXYGmW/2LYQeV+QNjbu8EAT28CBdh8e
         oiNkM1OkTB1iJ8kJCmECh/4O3Y8hBEpVz/uJojoaAigYuVUj4PCttTYGJBUq8pZ5NVqC
         wmz1q0FDVLqWuDzFVuzIGHHFNUlXmEc47hGXFt7kfCWDWWdzNr7AOoJlq3U40pImkOnD
         6tjr+1uDrkDQEnYTUdwnDDDyPlt2TQp9dpmesX/PNYC3UcW4qCSYlZ1lU7uwAvBlK+DX
         DltJp9zXbZGyCxeeBJBX0jEMNnDZqY0QrTmk9SNADKkg/5OPZo2uD8O2tJAuqxRF3QMz
         OfHg==
X-Gm-Message-State: AOAM530D/r7dUs3YyoK7hsP2/Bf6utTsu0O7M5BUzMIZL0OIBxZSZtJi
        Xc/viU0dmvA1l+ORSjeWFXGBomaDYKk=
X-Google-Smtp-Source: ABdhPJxtEjcPbn/EzO8+oMsGHO+DVMqdzYGBQ9GPRAGdMGqIhRdRmBv87H0lkbc7rIesvLYkkBKQ6g==
X-Received: by 2002:a63:2f41:: with SMTP id v62mr15278765pgv.178.1590178997595;
        Fri, 22 May 2020 13:23:17 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id e19sm7295561pfn.17.2020.05.22.13.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 13:23:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCHSET RFC 0/11] Add support for async buffered reads
Date:   Fri, 22 May 2020 14:23:00 -0600
Message-Id: <20200522202311.10959-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We technically support this already through io_uring, but it's
implemented with a thread backend to support cases where we would
block. This isn't ideal.

After a few prep patches, the core of this patchset is adding support
for async callbacks on page unlock. With this primitive, we can simply
retry the IO operation. With io_uring, this works a lot like poll based
retry for files that support it. If a page is currently locked and
needed, -EIOCBQUEUED is returned with a callback armed. The callers
callback is responsible for restarting the operation.

With this callback primitive, we can add support for
generic_file_buffered_read(), which is what most file systems end up
using for buffered reads. XFS/ext4/btrfs/bdev is wired up, but probably
trivial to add more.

The file flags support for this by setting FMODE_BUF_RASYNC, similar
to what we do for FMODE_NOWAIT. Open to suggestions here if this is
the preferred method or not.

In terms of results, I wrote a small test app that randomly reads 4G
of data in 4K chunks from a file hosted by ext4. The app uses a queue
depth of 32.

preadv for comparison:
	real    1m13.821s
	user    0m0.558s
	sys     0m11.125s
	CPU	~13%

Mainline:
	real    0m12.054s
	user    0m0.111s
	sys     0m5.659s
	CPU	~32% + ~50% == ~82%

This patchset:
	real    0m9.283s
	user    0m0.147s
	sys     0m4.619s
	CPU	~52%
	
The CPU numbers are just a rough estimate. For the mainline io_uring
run, this includes the app itself and all the threads doing IO on its
behalf (32% for the app, ~1.6% per worker and 32 of them). Context
switch rate is much smaller with the patchset, since we only have the
one task performing IO.

The goal here is efficiency. Async thread offload adds latency, and
it also adds noticable overhead on items such as adding pages to the
page cache. By allowing proper async buffered read support, we don't
have X threads hammering on the same inode page cache, we have just
the single app actually doing IO.

Series can also be found here:

https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered

or pull from:

git://git.kernel.dk/linux-block async-buffered

 fs/block_dev.c            |   2 +-
 fs/btrfs/file.c           |   2 +-
 fs/ext4/file.c            |   2 +-
 fs/io_uring.c             | 101 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.c         |   2 +-
 include/linux/blk_types.h |   3 +-
 include/linux/fs.h        |   5 ++
 include/linux/pagemap.h   |  40 +++++++++++++++
 mm/filemap.c              |  71 +++++++++++++++++++++------
 9 files changed, 207 insertions(+), 21 deletions(-)

-- 
Jens Axboe


