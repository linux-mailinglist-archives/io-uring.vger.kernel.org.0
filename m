Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E83558A13
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 22:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiFWUbS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 16:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWUbR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 16:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB0B54BFE;
        Thu, 23 Jun 2022 13:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3076261D78;
        Thu, 23 Jun 2022 20:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F20CC341C0;
        Thu, 23 Jun 2022 20:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656016275;
        bh=mhbBpzfiGjQReWMLryeOzf/Ld3WAD7o2n+Ighr/JN9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RMBWiMxOhUu2p2rVjEdRIrqcfTesFwk+hKYAL3ug9M1FIO+BxZVwJz6+s6AE3Oiul
         or6ebJz2r2iyh/fSgws2WUZijnSQkPfylrWiaCyOGz6XaHYHC5pt8TKrJj2vTclP3K
         tMiGNhPreZxHPa/WquVz1vUyMETwB/AD3UU0HCW7u5bscDij+TtE0N4QeQMU3lA3pN
         gizgDw5As6CNVAX+KjpDdi15UAOc7GTST9h0Rk9Mm0QiC/5+yG5Z4OiKXZBJrCrmJu
         x7bcyqfuJhJc4ARVTh3bnQ+YMRRYu+YaojRoy194iYpOv5mMurETDknWcisJtVtYf6
         oAKWpllHGwVwA==
Date:   Thu, 23 Jun 2022 13:31:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, willy@infradead.org
Subject: Re: [RESEND PATCH v9 00/14] io-uring/xfs: support async buffered
 writes
Message-ID: <YrTNku0AC80eheSP@magnolia>
References: <20220623175157.1715274-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623175157.1715274-1-shr@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 23, 2022 at 10:51:43AM -0700, Stefan Roesch wrote:
> This patch series adds support for async buffered writes when using both
> xfs and io-uring. Currently io-uring only supports buffered writes in the
> slow path, by processing them in the io workers. With this patch series it is
> now possible to support buffered writes in the fast path. To be able to use
> the fast path the required pages must be in the page cache, the required locks
> in xfs can be granted immediately and no additional blocks need to be read
> form disk.
> 
> Updating the inode can take time. An optimization has been implemented for
> the time update. Time updates will be processed in the slow path. While there
> is already a time update in process, other write requests for the same file,
> can skip the update of the modification time.
>   
> 
> Performance results:
>   For fio the following results have been obtained with a queue depth of
>   1 and 4k block size (runtime 600 secs):
> 
>                  sequential writes:
>                  without patch           with patch      libaio     psync
>   iops:              77k                    209k          195K       233K
>   bw:               314MB/s                 854MB/s       790MB/s    953MB/s
>   clat:            9600ns                   120ns         540ns     3000ns

Hey, nice!

> 
> 
> For an io depth of 1, the new patch improves throughput by over three times
> (compared to the exiting behavior, where buffered writes are processed by an
> io-worker process) and also the latency is considerably reduced. To achieve the
> same or better performance with the exisiting code an io depth of 4 is required.
> Increasing the iodepth further does not lead to improvements.
> 
> In addition the latency of buffered write operations is reduced considerably.
> 
> 
> 
> Support for async buffered writes:
> 
>   To support async buffered writes the flag FMODE_BUF_WASYNC is introduced. In
>   addition the check in generic_write_checks is modified to allow for async
>   buffered writes that have this flag set.
> 
>   Changes to the iomap page create function to allow the caller to specify
>   the gfp flags. Sets the IOMAP_NOWAIT flag in iomap if IOCB_NOWAIT has been set
>   and specifies the requested gfp flags.
> 
>   Adds the iomap async buffered write support to the xfs iomap layer.
>   Adds async buffered write support to the xfs iomap layer.
> 
> Support for async buffered write support and inode time modification
> 
>   Splits the functions for checking if the file privileges need to be removed in
>   two functions: check function and a function for the removal of file privileges.
>   The same split is also done for the function to update the file modification time.
> 
>   Implement an optimization that while a file modification time is pending other
>   requests for the same file don't need to wait for the file modification update. 
>   This avoids that a considerable number of buffered async write requests get
>   punted.
> 
>   Take the ilock in nowait mode if async buffered writes are enabled and enable
>   the async buffered writes optimization in io_uring.
> 
> Support for write throttling of async buffered writes:
> 
>   Add a no_wait parameter to the exisiting balance_dirty_pages() function. The
>   function will return -EAGAIN if the parameter is true and write throttling is
>   required.
> 
>   Add a new function called balance_dirty_pages_ratelimited_async() that will be
>   invoked from iomap_write_iter() if an async buffered write is requested.
>   
> Enable async buffered write support in xfs
>    This enables async buffered writes for xfs.
> 
> 
> Testing:
>   This patch has been tested with xfstests, fsx, fio and individual test programs.

Good to hear.  Will there be some new fstest coming/already merged?

<snip>

Hmm, well, vger and lore are still having stomach problems, so even the
resend didn't result in #5 ending up in my mailbox. :(

For the patches I haven't received, I'll just attach my replies as
comments /after/ each patch subject line.  What a way to review code!

> Jan Kara (3):
>   mm: Move starting of background writeback into the main balancing loop
>   mm: Move updates of dirty_exceeded into one place
>   mm: Add balance_dirty_pages_ratelimited_flags() function

(Yeah, I guess these changes make sense...)

> Stefan Roesch (11):
>   iomap: Add flags parameter to iomap_page_create()
>   iomap: Add async buffered write support

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

>   iomap: Return -EAGAIN from iomap_write_iter()
>   fs: Add check for async buffered writes to generic_write_checks
>   fs: add __remove_file_privs() with flags parameter
>   fs: Split off inode_needs_update_time and __file_update_time
>   fs: Add async write file modification handling.

The commit message references a file_modified_async function, but all I
see is file_modified_flags?  Assuming that's just a clerical error,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

>   io_uring: Add support for async buffered writes

Hm, ok, so the EAGAINs that we sprinkle everywhere get turned into short
writes at the end of iomap_file_buffered_write, and that's what this
picks up?  If so, then...

>   io_uring: Add tracepoint for short writes
>   xfs: Specify lockmode when calling xfs_ilock_for_iomap()
>   xfs: Add async buffered write support

...I guess I'm ok with signing off on the last patch:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
>  fs/inode.c                      | 168 +++++++++++++++++++++++---------
>  fs/io_uring.c                   |  32 +++++-
>  fs/iomap/buffered-io.c          |  71 +++++++++++---
>  fs/read_write.c                 |   4 +-
>  fs/xfs/xfs_file.c               |  11 +--
>  fs/xfs/xfs_iomap.c              |  11 ++-
>  include/linux/fs.h              |   4 +
>  include/linux/writeback.h       |   7 ++
>  include/trace/events/io_uring.h |  25 +++++
>  mm/page-writeback.c             |  89 +++++++++++------
>  10 files changed, 314 insertions(+), 108 deletions(-)
> 
> 
> base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
> -- 
> 2.30.2
> 
