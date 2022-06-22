Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E5E556DCE
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 23:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbiFVVZE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 17:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiFVVZD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 17:25:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1480A2E9D2;
        Wed, 22 Jun 2022 14:25:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AF2651F8C1;
        Wed, 22 Jun 2022 21:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655933100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0bFKyfrM9M801rrkq6xT8x/2B6BbBlpC3pmtnbRdHVw=;
        b=ukDoldDbJIPRFYSu2p8UKQTGZ8dkm0JcH/kRotKxU+yAGFXMSis9OHwjruS4sbDfe5nrYY
        2NIrkeX5N6SGhCrynb8raP6HVq0IoP9cpXhZm0fvQ0uuYMu9r0YRT+VlMgKFCHRGLBBE0+
        NDQj/3TFrq46k1Ow/yI+Gfh+P56Beuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655933100;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0bFKyfrM9M801rrkq6xT8x/2B6BbBlpC3pmtnbRdHVw=;
        b=MeQAPmj9dDyf0nKMXElfIATfywWiXOp5GLf565OpdnnFRvnXa3zpcg5dyk0w5LY4+CyWHA
        iVy3RJDb04nw3ZCQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 72A182C141;
        Wed, 22 Jun 2022 21:25:00 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 1F6A1A062B; Wed, 22 Jun 2022 23:24:57 +0200 (CEST)
Date:   Wed, 22 Jun 2022 23:24:57 +0200
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        hch@infradead.org, willy@infradead.org
Subject: Re: [PATCH v9 00/14] io-uring/xfs: support async buffered writes
Message-ID: <20220622212457.lvzdwqth5ci6ynna@quack3.lan>
References: <20220616212221.2024518-1-shr@fb.com>
 <d18ffe14-7dd2-92a7-abd0-673b7da62adb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d18ffe14-7dd2-92a7-abd0-673b7da62adb@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed 22-06-22 11:41:14, Jens Axboe wrote:
> Top posting - are people fine with queueing this up at this point? Will
> need a bit of massaging for io_uring as certain things moved to another
> file, but it's really minor. I'd do a separate topic branch for this.

I have no objections to merging this. The parts I felt confident about
enough look OK to me (and have my reviewed-by tag).

								Honza

> On 6/16/22 3:22 PM, Stefan Roesch wrote:
> > This patch series adds support for async buffered writes when using both
> > xfs and io-uring. Currently io-uring only supports buffered writes in the
> > slow path, by processing them in the io workers. With this patch series it is
> > now possible to support buffered writes in the fast path. To be able to use
> > the fast path the required pages must be in the page cache, the required locks
> > in xfs can be granted immediately and no additional blocks need to be read
> > form disk.
> > 
> > Updating the inode can take time. An optimization has been implemented for
> > the time update. Time updates will be processed in the slow path. While there
> > is already a time update in process, other write requests for the same file,
> > can skip the update of the modification time.
> >   
> > 
> > Performance results:
> >   For fio the following results have been obtained with a queue depth of
> >   1 and 4k block size (runtime 600 secs):
> > 
> >                  sequential writes:
> >                  without patch           with patch      libaio     psync
> >   iops:              77k                    209k          195K       233K
> >   bw:               314MB/s                 854MB/s       790MB/s    953MB/s
> >   clat:            9600ns                   120ns         540ns     3000ns
> > 
> > 
> > For an io depth of 1, the new patch improves throughput by over three times
> > (compared to the exiting behavior, where buffered writes are processed by an
> > io-worker process) and also the latency is considerably reduced. To achieve the
> > same or better performance with the exisiting code an io depth of 4 is required.
> > Increasing the iodepth further does not lead to improvements.
> > 
> > In addition the latency of buffered write operations is reduced considerably.
> > 
> > 
> > 
> > Support for async buffered writes:
> > 
> >   To support async buffered writes the flag FMODE_BUF_WASYNC is introduced. In
> >   addition the check in generic_write_checks is modified to allow for async
> >   buffered writes that have this flag set.
> > 
> >   Changes to the iomap page create function to allow the caller to specify
> >   the gfp flags. Sets the IOMAP_NOWAIT flag in iomap if IOCB_NOWAIT has been set
> >   and specifies the requested gfp flags.
> > 
> >   Adds the iomap async buffered write support to the xfs iomap layer.
> >   Adds async buffered write support to the xfs iomap layer.
> > 
> > Support for async buffered write support and inode time modification
> > 
> >   Splits the functions for checking if the file privileges need to be removed in
> >   two functions: check function and a function for the removal of file privileges.
> >   The same split is also done for the function to update the file modification time.
> > 
> >   Implement an optimization that while a file modification time is pending other
> >   requests for the same file don't need to wait for the file modification update. 
> >   This avoids that a considerable number of buffered async write requests get
> >   punted.
> > 
> >   Take the ilock in nowait mode if async buffered writes are enabled and enable
> >   the async buffered writes optimization in io_uring.
> > 
> > Support for write throttling of async buffered writes:
> > 
> >   Add a no_wait parameter to the exisiting balance_dirty_pages() function. The
> >   function will return -EAGAIN if the parameter is true and write throttling is
> >   required.
> > 
> >   Add a new function called balance_dirty_pages_ratelimited_async() that will be
> >   invoked from iomap_write_iter() if an async buffered write is requested.
> >   
> > Enable async buffered write support in xfs
> >    This enables async buffered writes for xfs.
> > 
> > 
> > Testing:
> >   This patch has been tested with xfstests, fsx, fio and individual test programs.
> > 
> > 
> > Changes:
> >   V9:
> >   - Added comment for function balance_dirty_pages_ratelimited_flags()
> >   - checking return code for iop allocation in iomap_page_create()
> >   
> >   V8:
> >   - Reverted back changes to iomap_write_iter and used Mathew Wilcox code review
> >     recommendation with an additional change to revert the iterator.
> >   - Removed patch "fs: Optimization for concurrent file time updates" 
> >   - Setting flag value in file_modified_flags()
> >   - Removed additional spaces in comment in file_update_time()
> >   - Run fsx with 1 billion ops against the changes (Run passed)
> > 
> >   V7:
> >   - Change definition and if clause in " iomap: Add flags parameter to
> >     iomap_page_create()"
> >   - Added patch "iomap: Return error code from iomap_write_iter()" to address
> >     the problem Dave Chinner brought up: retrying memory allocation a second
> >     time when we are under memory pressure. 
> >   - Removed patch "xfs: Change function signature of xfs_ilock_iocb()"
> >   - Merged patch "xfs: Enable async buffered write support" with previous
> >     patch
> > 
> >   V6:
> >   - Pass in iter->flags to calls in iomap_page_create()
> >   
> >   V5:
> >   - Refreshed to 5.19-rc1
> >   - Merged patch 3 and patch 4
> >     "mm: Prepare balance_dirty_pages() for async buffered writes" and
> >     "mm: Add balance_dirty_pages_ratelimited_flags() function"
> >   - Reformatting long file in iomap_page_create()
> >   - Replacing gfp parameter with flags parameter in iomap_page_create()
> >     This makes sure that the gfp setting is done in one location.
> >   - Moved variable definition outside of loop in iomap_write_iter()
> >   - Merged patch 7 with patch 6.
> >   - Introduced __file_remove_privs() that get the iocb_flags passed in
> >     as an additional parameter
> >   - Removed file_needs_remove_privs() function
> >   - Renamed file_needs_update_time() inode_needs_update_time()
> >   - inode_needs_update_time() no longer passes the file pointer
> >   - Renamed file_modified_async() to file_modified_flags()
> >   - Made file_modified_flags() an internal function
> >   - Removed extern keyword in file_modified_async definition
> >   - Added kiocb_modified function.
> >   - Separate patch for changes to xfs_ilock_for_iomap()
> >   - Separate patch for changes to xfs_ilock_inode()
> >   - Renamed xfs_ilock_xfs_inode()n back to xfs_ilock_iocb()
> >   - Renamed flags parameter to iocb_flags in function xfs_ilock_iocb()
> >   - Used inode_set_flags() to manipulate inode flags in the function
> >     file_modified_flags()
> > 
> >   V4:
> >   - Reformat new code in generic_write_checks_count().
> >   - Removed patch that introduced new function iomap_page_create_gfp().
> >   - Add gfp parameter to iomap_page_create() and change all callers
> >     All users will enforce the number of blocks check
> >   - Removed confusing statement in iomap async buffer support patch
> >   - Replace no_wait variable in __iomap_write_begin with check of
> >     IOMAP_NOWAIT for easier readability.
> >   - Moved else if clause in __iomap_write_begin into else clause for
> >     easier readability
> >   - Removed the balance_dirty_pages_ratelimited_async() function and
> >     reverted back to the earlier version that used the function
> >     balance_dirty_pages_ratelimited_flags()
> >   - Introduced the flag BDP_ASYNC.
> >   - Renamed variable in iomap_write_iter from i_mapping to mapping.
> >   - Directly call balance_dirty_pages_ratelimited_flags() in the function
> >     iomap_write_iter().
> >   - Re-ordered the patches.
> >   
> >   V3:
> >   - Reformat new code in generic_write_checks_count() to line lengthof 80.
> >   - Remove if condition in __iomap_write_begin to maintain current behavior.
> >   - use GFP_NOWAIT flag in __iomap_write_begin
> >   - rename need_file_remove_privs() function to file_needs_remove_privs()
> >   - rename do_file_remove_privs to __file_remove_privs()
> >   - add kernel documentation to file_remove_privs() function
> >   - rework else if branch in file_remove_privs() function
> >   - add kernel documentation to file_modified() function
> >   - add kernel documentation to file_modified_async() function
> >   - rename err variable in file_update_time to ret
> >   - rename function need_file_update_time() to file_needs_update_time()
> >   - rename function do_file_update_time() to __file_update_time()
> >   - don't move check for FMODE_NOCMTIME in generic helper
> >   - reformat __file_update_time for easier reading
> >   - add kernel documentation to file_update_time() function
> >   - fix if in file_update_time from < to <=
> >   - move modification of inode flags from do_file_update_time to file_modified()
> >     When this function is called, the caller must hold the inode lock.
> >   - 3 new patches from Jan to add new no_wait flag to balance_dirty_pages(),
> >     remove patch 12 from previous series
> >   - Make balance_dirty_pages_ratelimited_flags() a static function
> >   - Add new balance_dirty_pages_ratelimited_async() function
> >   
> >   V2:
> >   - Remove atomic allocation
> >   - Use direct write in xfs_buffered_write_iomap_begin()
> >   - Use xfs_ilock_for_iomap() in xfs_buffered_write_iomap_begin()
> >   - Remove no_wait check at the end of xfs_buffered_write_iomap_begin() for
> >     the COW path.
> >   - Pass xfs_inode pointer to xfs_ilock_iocb and rename function to
> >     xfs_lock_xfs_inode
> >   - Replace existing uses of xfs_ilock_iocb with xfs_ilock_xfs_inode
> >   - Use xfs_ilock_xfs_inode in xfs_file_buffered_write()
> >   - Callers of xfs_ilock_for_iomap need to initialize lock mode. This is
> >     required so writes use an exclusive lock
> >   - Split of _balance_dirty_pages() from balance_dirty_pages() and return
> >     sleep time
> >   - Call _balance_dirty_pages() in balance_dirty_pages_ratelimited_flags()
> >   - Move call to balance_dirty_pages_ratelimited_flags() in iomap_write_iter()
> >     to the beginning of the loop
> > 
> > 
> > 
> > Jan Kara (3):
> >   mm: Move starting of background writeback into the main balancing loop
> >   mm: Move updates of dirty_exceeded into one place
> >   mm: Add balance_dirty_pages_ratelimited_flags() function
> > 
> > Stefan Roesch (11):
> >   iomap: Add flags parameter to iomap_page_create()
> >   iomap: Add async buffered write support
> >   iomap: Return -EAGAIN from iomap_write_iter()
> >   fs: Add check for async buffered writes to generic_write_checks
> >   fs: add __remove_file_privs() with flags parameter
> >   fs: Split off inode_needs_update_time and __file_update_time
> >   fs: Add async write file modification handling.
> >   io_uring: Add support for async buffered writes
> >   io_uring: Add tracepoint for short writes
> >   xfs: Specify lockmode when calling xfs_ilock_for_iomap()
> >   xfs: Add async buffered write support
> > 
> >  fs/inode.c                      | 168 +++++++++++++++++++++++---------
> >  fs/io_uring.c                   |  32 +++++-
> >  fs/iomap/buffered-io.c          |  71 +++++++++++---
> >  fs/read_write.c                 |   4 +-
> >  fs/xfs/xfs_file.c               |  11 +--
> >  fs/xfs/xfs_iomap.c              |  11 ++-
> >  include/linux/fs.h              |   4 +
> >  include/linux/writeback.h       |   7 ++
> >  include/trace/events/io_uring.h |  25 +++++
> >  mm/page-writeback.c             |  89 +++++++++++------
> >  10 files changed, 314 insertions(+), 108 deletions(-)
> > 
> > 
> > base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
> 
> 
> -- 
> Jens Axboe
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
