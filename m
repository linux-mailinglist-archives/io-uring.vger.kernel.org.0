Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E346A5B6B24
	for <lists+io-uring@lfdr.de>; Tue, 13 Sep 2022 11:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiIMJsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Sep 2022 05:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiIMJsF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Sep 2022 05:48:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF9414D02;
        Tue, 13 Sep 2022 02:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86E4F61375;
        Tue, 13 Sep 2022 09:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E526EC433D6;
        Tue, 13 Sep 2022 09:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663062482;
        bh=t9Ug2HOQaFdh84ntzqnnf0z5mQY39gS1prrI/LxqIbI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pibVL6mvkGejdf8QCNqdcGfcigsHnb2mlo/RdgrgTErqlzCoDrHaB0U71CCCg9lmy
         +sv6uL3IdOJ+645Dli99IwcisFub6QICbLEPFNbQDvsVf3KyICg8MDJjfmy6WwMVpg
         3NWgzFdrTKHGB1xlY8CjisGCKx3zbYC6AMamDmBFAoA9WpcbH13hBTWSeSCxV1Opa4
         o1CwdmcziTbL1IrPV62yXEYJ96hHr/Aogs6KoHNCnZcHee9LSQ7r0iXPph/xYYVnO9
         wvN8HJOGpXqS6V3NOVDyReeUPvvc5wrEPmyARjhLsJY3NvJ3HGu4ugOlsB7+HpE1MB
         0VT7Ve/O0Axcw==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1278a61bd57so30577223fac.7;
        Tue, 13 Sep 2022 02:48:02 -0700 (PDT)
X-Gm-Message-State: ACgBeo3kKYcj0XQyVpJkCx0w2wuYei+kIIvnPFWOMkE1OYnqZpW0Q/9i
        R0fZ0BRw0cvRxk7I6bZ/eatenhOU0t8haV6dhlc=
X-Google-Smtp-Source: AA6agR5QJ7hZE1Cv3VW23fOkvwZBERa+L/ufejRoj5HfwKEzVXNtGGRaFbNU2Kt1m6/VvEydkOrf/9rJMAQcjjuUtA0=
X-Received: by 2002:a05:6870:538c:b0:11b:e64f:ee1b with SMTP id
 h12-20020a056870538c00b0011be64fee1bmr1305902oan.92.1663062482008; Tue, 13
 Sep 2022 02:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220912192752.3785061-1-shr@fb.com>
In-Reply-To: <20220912192752.3785061-1-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 13 Sep 2022 10:47:25 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6AH+1Uc08y3XtgwN5nngoQGyxHLq18jaa+y+QqpK=B5g@mail.gmail.com>
Message-ID: <CAL3q7H6AH+1Uc08y3XtgwN5nngoQGyxHLq18jaa+y+QqpK=B5g@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] io-uring/btrfs: support async buffered writes
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org, axboe@kernel.dk,
        josef@toxicpanda.com
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

On Mon, Sep 12, 2022 at 8:28 PM Stefan Roesch <shr@fb.com> wrote:
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
>
> The new patch improves throughput by over two times (compared to the exiting
> behavior, where buffered writes are processed by an io-worker process) and also
> the latency is considerably reduced. Detailled results are part of the changelog
> of the first commit.

Not in the first, but in the last commit instead.

Looks fine to me now, thanks.

Reviewed-by: Filipe Manana <fdmanana@suse.com>


>
>
> BTRFS changes:
>  -Add option for NOWAIT IOCB's to tell that searches do not wait on locks. This
>   adds the nowait option to btrfs_path.
>  -For NOWAIT buffered writes on PREALLOC or NOCOW extents tell can_nocow_extent()
>   that we don't want to wait on any locks or metadata IO.
>  -Support no_flush reservations for nowait buffered writes.
>  -Add btrfs_try_lock_ordered_range() function.
>  -Add nowait flag to btrfs_check_nocow_lock() to use it in write code path.
>  -Add nowait parameter to prepare_pages() function.
>  -Plumb nowait through the write code path.
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
> V3:
>  - Updated changelog of "btrfs: implement a nowait option for tree searches"
>    to say -EAGAIN.
>  - Use bool return value in signature of btrfs_try_lock_ordered_range
>  - Renamed variable tmp to can_nocow in btrfs_buffered_write
>  - Fixed coding style in get_prepare_fgp_flags
>  - Set pages[i] to NULL in error code path of lock_and_cleanup_extent_if_need()
>  - Added const in definition of "bool nowait"
>  - Removed unlikely from btrfs_buffered_write
>  - Rephrased changelog for "btrfs: add assert to search functions" and used
>    asserts instead of warnings
>  - Explained why enocded writes are not supported in the changelog
>  - Moved performance results to changelog of first commit
>
> V2:
>  - Replace EWOULDBLOCK with EAGAIN. In Version 1 it was not used consistently
>  - Export function balance_dirty_pages_ratelimited_flags()
>  - Add asserts/warnings for search functions when nowait is set, but we don't
>    expect that they are invoked with nowait set.
>
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
>   btrfs: plumb NOWAIT through the write path
>   btrfs: make balance_dirty_pages nowait compatible
>   btrfs: assert nowait mode is not used for some btree search functions
>   btrfs: enable nowait async buffered writes
>
>  fs/btrfs/block-group.c    |   2 +-
>  fs/btrfs/ctree.c          |  43 ++++++++++++-
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
>  18 files changed, 234 insertions(+), 59 deletions(-)
>
>
> base-commit: 80e78fcce86de0288793a0ef0f6acf37656ee4cf
> --
> 2.30.2
>
