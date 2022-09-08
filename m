Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D0C5B19BB
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiIHKOr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiIHKOp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F60613F82;
        Thu,  8 Sep 2022 03:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCCD661C22;
        Thu,  8 Sep 2022 10:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EFFC43470;
        Thu,  8 Sep 2022 10:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632080;
        bh=chin1yqP+a3PD3W/MNXZuD9/CvxMb6UfJVFhWIV/n7Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b9+QVs4EuSf49vXGAOJ5n6GGsNOakTyxHvofNvayFYYCeKPQ7A6ejTWsKrTNBcrM+
         G0eQJZyt7qhuyUTvkY3pRQPvNMIxU22mtbylEsR08UftVLNEQJPyBAZa9l437H9YU4
         MKAhaJl+Wil2XvQ/MDdyCmNlfaAGwMXiggjkC2y4YAtKTc7t6BLn9QOYs+rlvVZEhs
         bOQeiXc+143S1Mooaey2zA3aaItPhEzBmj1/D08C1xrWiqRkE2S4bJ8J7FlWUfUrd4
         3o7x+vXY4e/XUnDpX0ggyMXc+KRWw4oSjCFOnIvMc8ruR0tmGrCL4RvmuJJtYnCayc
         5mZ3ucumzaf5g==
Received: by mail-ot1-f44.google.com with SMTP id y25-20020a056830109900b0063b3c1fe018so12057448oto.2;
        Thu, 08 Sep 2022 03:14:40 -0700 (PDT)
X-Gm-Message-State: ACgBeo35j2yAyBZRs9cV3v1aiG5pqES4Ea+gX9lC0Pwi5vsjtBtB/p5p
        1WClS4zKk01zuOhq2cNeJwC14BE9DdfYCsp+CDM=
X-Google-Smtp-Source: AA6agR6NpOb0/vQp0kiF3fETw2+7x261dgVOJsdmcMujAX6NdtaW2TqokugjbJBzAvUcU5UO+s5BXV52wE89NA4T4ng=
X-Received: by 2002:a9d:6f08:0:b0:638:8a51:2e46 with SMTP id
 n8-20020a9d6f08000000b006388a512e46mr3171593otq.363.1662632079464; Thu, 08
 Sep 2022 03:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com>
In-Reply-To: <20220908002616.3189675-1-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:14:03 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6Ue2Sy2dU_Cqr93R-F2a_n4OoueaORecjyuPeXU__DaQ@mail.gmail.com>
Message-ID: <CAL3q7H6Ue2Sy2dU_Cqr93R-F2a_n4OoueaORecjyuPeXU__DaQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] io-uring/btrfs: support async buffered writes
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 8, 2022 at 1:26 AM Stefan Roesch <shr@fb.com> wrote:
>
> This patch series adds support for async buffered writes when using both
> btrfs and io-uring. Currently io-uring only supports buffered writes (for btrfs)
> in the slow path, by processing them in the io workers. With this patch series
> it is now possible to support buffered writes in the fast path. To be able to use
> the fast path, the required pages must be in the page cache, the required locks
> in btrfs can be granted immediately and no additional blocks need to be read
> form disk.
>
> This patch series makes use of the changes that have been introduced by a
> previous patch series: "io-uring/xfs: support async buffered writes"
>
> Performance results:
>   For fio the following results have been obtained with a queue depth of
>   1 and 4k block size (runtime 600 secs):
>
>                  sequential writes:
>                  without patch           with patch      libaio     psync
>   iops:              55k                    134k          117K       148K
>   bw:               221MB/s                 538MB/s       469MB/s    592MB/s
>   clat:           15286ns                    82ns         994ns     6340ns

This is very interesting information to not have in the git history,
specially because it's
exactly this that motivates all the patches.

I suggest adding this to the changelog of the last patch, and then
mention that those results
are the result of comparing a branch with the patchset versus one
without it, also mentioning
the subject of all the patches that belong to the patchset.

It should also mention how to run the test: i.e. the fio command line
or config file, so
that it's clear to everyone all the details and how to reproduce the results.

The patchset overall looks good to me, I just left a few comments on
most of the individual patches,
all minor things.

Thanks.

>
>
> For an io depth of 1, the new patch improves throughput by over two times
> (compared to the exiting behavior, where buffered writes are processed by an
> io-worker process) and also the latency is considerably reduced. To achieve the
> same or better performance with the exisiting code an io depth of 4 is required.
> Increasing the iodepth further does not lead to improvements.
>
>
> BTRFS changes:
>  -Add option for NOWAIT IOCB's to tell that searches do not wait on locks. This
>   adds the nowait option to btrfs_path.
>
>  -For NOWAIT buffered writes on PREALLOC or NOCOW extents tell can_nocow_extent()
>   that we don't want to wait on any locks or metadata IO.
>
>  -Support no_flush reservations for nowait buffered writes.
>
>  -Add btrfs_try_lock_ordered_range() function.
>
>  -Add nowait flag to btrfs_check_nocow_lock() to use it in write code path.
>
>  -Add nowait parameter to prepare_pages() function.
>
>  -Plumb nowait through the write code path.
>
>  -Enable nowait buffered writes.
>
>
> Testing:
>   This patch has been tested with xfstests, fsx, fio. xfstests shows no new
>   diffs compared to running without the patch series.
>
>
> Changes:
>
> V2:
>  - Replace EWOULDBLOCK with EAGAIN. In Version 1 it was not used consistently
>  - Export function balance_dirty_pages_ratelimited_flags()
>  - Add asserts/warnings for search functions when nowait is set, but we don't
>    expect that they are invoked with nowait set.
>
>
> Josef Bacik (5):
>   btrfs: implement a nowait option for tree searches
>   btrfs: make can_nocow_extent nowait compatible
>   btrfs: add the ability to use NO_FLUSH for data reservations
>   btrfs: add btrfs_try_lock_ordered_range
>   btrfs: make btrfs_check_nocow_lock nowait compatible
>
> Stefan Roesch (7):
>   mm: export balance_dirty_pages_ratelimited_flags()
>   btrfs: make prepare_pages nowait compatible
>   btrfs: make lock_and_cleanup_extent_if_need nowait compatible
>   btrfs: btrfs: plumb NOWAIT through the write path
>   btrfs: make balance_dirty_pages nowait compatible
>   btrfs: add assert to search functions
>   btrfs: enable nowait async buffered writes
>
>  fs/btrfs/block-group.c    |   2 +-
>  fs/btrfs/ctree.c          |  48 ++++++++++++++-
>  fs/btrfs/ctree.h          |   8 ++-
>  fs/btrfs/delalloc-space.c |  13 +++-
>  fs/btrfs/delalloc-space.h |   3 +-
>  fs/btrfs/extent-tree.c    |   5 ++
>  fs/btrfs/file-item.c      |   4 +-
>  fs/btrfs/file.c           | 124 ++++++++++++++++++++++++++++----------
>  fs/btrfs/inode.c          |  22 ++++---
>  fs/btrfs/locking.c        |  23 +++++++
>  fs/btrfs/locking.h        |   1 +
>  fs/btrfs/ordered-data.c   |  28 +++++++++
>  fs/btrfs/ordered-data.h   |   1 +
>  fs/btrfs/relocation.c     |   2 +-
>  fs/btrfs/scrub.c          |   4 +-
>  fs/btrfs/space-info.c     |   3 +-
>  fs/btrfs/tree-log.c       |   6 +-
>  mm/page-writeback.c       |   1 +
>  18 files changed, 239 insertions(+), 59 deletions(-)
>
>
> base-commit: 53e99dcff61e1523ec1c3628b2d564ba15d32eb7
> --
> 2.30.2
>
