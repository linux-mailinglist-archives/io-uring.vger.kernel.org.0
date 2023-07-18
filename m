Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82997757D43
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 15:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjGRNVw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 09:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjGRNVa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 09:21:30 -0400
Received: from out-55.mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F6019A8
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 06:21:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689686482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xxqfMK2nPb8oOVWsGMCPm9x0Lzb3LRQyVeHyfrKnzW0=;
        b=qNPgFLYY5ahYxyJBCC2Ct0Kg8BZvNZK2Ci5PT/yAXwgKv5KyHPW9F5M3wVlEmg91h27/c0
        SvcNv3MaR1SzKBEaFIPQaz1WaaEbT3tcye5GszSpIXIM4K/2PFr9ndx7wt0wFIJvy7nhfu
        IZnevRZqMlDUxnD7NnpdoHsB/MB21+s=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v4 0/5] io_uring getdents
Date:   Tue, 18 Jul 2023 21:21:07 +0800
Message-Id: <20230718132112.461218-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

This series introduce getdents64 to io_uring, the code logic is similar
with the snychronized version's. It first try nowait issue, and offload
it to io-wq threads if the first try fails.

Tested it with a liburing case:
https://github.com/HowHsu/liburing/blob/getdents/test/getdents2.c

The test is controlled by the below script[2] which runs getdents2.t 100
times and calulate the avg.
The result show that io_uring version is about 3% faster:

python3 run_getdents.py
    Average of sync: 0.1036849
    Average of iouring: 0.1005568

(0.1036849-0.1005568)/0.1036849 = 3.017%

note:
[1] the number of getdents call/request in io_uring and normal sync version
are made sure to be same beforehand.

[2] run_getdents.py

```python3

import subprocess

N = 100
sum = 0.0
args = ["/data/home/howeyxu/tmpdir", "sync"]

for i in range(N):
    output = subprocess.check_output(["./liburing/test/getdents2.t"] + args)
    sum += float(output)

average = sum / N
print("Average of sync:", average)

sum = 0.0
args = ["/data/home/howeyxu/tmpdir", "iouring"]

for i in range(N):
    output = subprocess.check_output(["./liburing/test/getdents2.t"] + args)
    sum += float(output)

average = sum / N
print("Average of iouring:", average)

```

v3->v4:
 - add Dave's xfs nowait code and fix a deadlock problem, with some code
   style tweak.
 - disable fixed file to avoid a race problem for now
 - add a test program.

v2->v3:
 - removed the kernfs patches
 - add f_pos_lock logic
 - remove the "reduce last EOF getdents try" optimization since
   Dominique reports that doesn't make difference
 - remove the rewind logic, I think the right way is to introduce lseek
   to io_uring not to patch this logic to getdents.
 - add Singed-off-by of Stefan Roesch for patch 1 since checkpatch
   complained that Co-developed-by someone should be accompanied with
   Signed-off-by same person, I can remove them if Stefan thinks that's
   not proper.


Dominique Martinet (1):
  fs: split off vfs_getdents function of getdents64 syscall

Hao Xu (4):
  vfs_getdents/struct dir_context: add flags field
  io_uring: add support for getdents
  xfs: add NOWAIT semantics for readdir
  disable fixed file for io_uring getdents for now

 fs/internal.h                  |  8 +++++
 fs/readdir.c                   | 36 ++++++++++++++++-----
 fs/xfs/libxfs/xfs_da_btree.c   | 16 ++++++++++
 fs/xfs/libxfs/xfs_da_btree.h   |  1 +
 fs/xfs/libxfs/xfs_dir2_block.c |  7 ++--
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 +-
 fs/xfs/scrub/dir.c             |  2 +-
 fs/xfs/scrub/readdir.c         |  2 +-
 fs/xfs/xfs_dir2_readdir.c      | 58 +++++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.c             | 17 ++++++++++
 fs/xfs/xfs_inode.h             | 15 +++++----
 include/linux/fs.h             |  8 +++++
 include/uapi/linux/io_uring.h  |  7 ++++
 io_uring/fs.c                  | 57 +++++++++++++++++++++++++++++++++
 io_uring/fs.h                  |  3 ++
 io_uring/opdef.c               |  8 +++++
 16 files changed, 215 insertions(+), 32 deletions(-)

-- 
2.25.1

