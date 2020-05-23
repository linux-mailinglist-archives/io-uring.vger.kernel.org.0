Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F351DF3F1
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 03:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387475AbgEWBu6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 21:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387453AbgEWBu6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 21:50:58 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83079C05BD43
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:50:58 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id a13so5119263pls.8
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7l3Vl4XUCnVrv5zLlaIS2TAqW4v3YGdr3s+ckhxwo3k=;
        b=LAvGq9CG4T4SASualjrsfImwFHjrZ23/6PxdRJIQJ4CB67r5pCfVQlfHkmlkhrE17o
         vlrG0IeVUqgfrC0LHjA+Flocnfg3Z03dOs44FH3RPLcrPB9l8he10iFWcqjhkLfP3ZPI
         lkX6+1Gsd1Ny65q3n+Cu5/d2VSd36EV1pcSsbHCqYL0jCoKysJLQTtXwcVHTtO06HjF9
         cr8h4KWHzcRkYb2Fc+NBSvWGcc4/gX6ZqX4d71d/Ybwur2aMHfV+aUt6J4jPxQ+IAS2p
         9I2oqK48BHRVuQH/vFIjLYDuT+t0Ky0uAi5UG2mdfd0qP78H9zQUhHra4ZnPk4cE2L2w
         q+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7l3Vl4XUCnVrv5zLlaIS2TAqW4v3YGdr3s+ckhxwo3k=;
        b=sv8VVNoCdYe/sc4ui4vFNbqc6qYPrGxrd8fhVT14Gg+RuwrYclEDfS8C60PeWz/GjG
         KPVdPUomkvCdQ43/f3qP5hEXsBMRtJ8EwnBh3pIEhNn2WuZnzh1RkzgweAVOOHwxTcJl
         DqmFoSqrCfW/Vn3/iPvLr1oFOULMroQOK7xnAUfk1Du3Y6ZeLLjfAWdXzczCztFpkgFP
         iKiTYyuwf5g4OLdapZiRn723ASgMbWOAZlJjRN8d+YN8P9VixMNek6mzP2zAkTC8fi4V
         4qe14+hVfIbopR/KUedFyn8Qr8c/HuVBlvw6Ep32rqvmACBrQ9NX/g6bgaBqSXRmp9gg
         BkKw==
X-Gm-Message-State: AOAM533i7fzyPNOsrsfC/4lfwMyIF3b8qViBOywA3KvlqArPELwLM9wh
        BE2gW3cFxtg6eeUp7ASVWke7wBYW5s8=
X-Google-Smtp-Source: ABdhPJzbVANbqitIh8v7v51fEGKGFyBynVcF+TbM0Ms1gwAamMyyZ0DbB1Z9x3LfCBk3dayD3vcwSw==
X-Received: by 2002:a17:90b:e0c:: with SMTP id ge12mr8085637pjb.3.1590198657579;
        Fri, 22 May 2020 18:50:57 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id a71sm8255477pje.0.2020.05.22.18.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:50:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCHSET v2 RFC 0/11] Add support for async buffered reads
Date:   Fri, 22 May 2020 19:50:38 -0600
Message-Id: <20200523015049.14808-1-axboe@kernel.dk>
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

https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.2

or pull from:

git://git.kernel.dk/linux-block async-buffered.2

 fs/block_dev.c            |   2 +-
 fs/btrfs/file.c           |   2 +-
 fs/ext4/file.c            |   2 +-
 fs/io_uring.c             | 102 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.c         |   2 +-
 include/linux/blk_types.h |   3 +-
 include/linux/fs.h        |   5 ++
 include/linux/pagemap.h   |  39 +++++++++++++++
 mm/filemap.c              |  83 +++++++++++++++++++++++++------
 9 files changed, 219 insertions(+), 21 deletions(-)

Changes since v1:

- Fix an issue with inline page locking
- Fix a potential race with __wait_on_page_locked_async()
- Fix a hang related to not setting page_match, thus missing a wakeup

-- 
Jens Axboe


