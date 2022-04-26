Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A34510C19
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 00:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355881AbiDZWkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 18:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355856AbiDZWkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 18:40:19 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24C4C2D1E9;
        Tue, 26 Apr 2022 15:37:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 43ABA10E5E1A;
        Wed, 27 Apr 2022 08:37:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njTns-004vCT-K6; Wed, 27 Apr 2022 08:37:04 +1000
Date:   Wed, 27 Apr 2022 08:37:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 00/18] io-uring/xfs: support async buffered writes
Message-ID: <20220426223704.GP1544202@dread.disaster.area>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62687413
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=Fim2rnFP4wQaNHKEyb0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 26, 2022 at 10:43:17AM -0700, Stefan Roesch wrote:
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
>                  without patch                 with patch
>   iops:              80k                          269k
> 
> 
>                  random writes:
>                  without patch                 with patch
>   iops:              76k                          249k

What's the results when you enable the lazytime mount option to
elide almost all the timestamp updates from buffered writes?

As it is, on my test setup:

# fio --readwrite=write --filesize=5g --filename=/mnt/scratch/foo --runtime=30s --time_based --ioengine=libaio --direct=0 --bs=4k --iodepth=1 --numjobs=1 -name=/mnt/scratch/foobar --group_reporting --fallocate=none
.....
write: IOPS=296k, BW=1157MiB/s (1213MB/s)(33.9GiB/30001msec); 0 zone resets

So buffered IO is getting ~295k IOPS on a default kernel config.
Using --ioengine=psync gets ~325k IOPS. However, using
--ioengine=io_uring I only get:

.....
write: IOPS=58.5k, BW=229MiB/s (240MB/s)(6861MiB/30001msec); 0 zone resets

~60k IOPS. IOWs, normal buffered IO is 5x faster than the io_uring
slow path.

To summarise:

		seq IOPS	rand IOPS
libaio		~295k		~220k
psync		~325k		~255k
io_uring	 ~60k		 ~45k

IOWs, there's nothing wrong with the normal blocking IO path and it
easily reaches full single CPU performance on this machine. However,
there is a massive increase in overhead in using the io_uring slow
path.

Oh, wow, an average of 5 context switches per buffered write IO with
io_uring? There's zero context switches with psync or libaio. That
blocking path overhead seems like a general candidate for io_uring
optimisation, especially as most buffered writes are going to
require blocking for one reason or another regardless of whether we
add a NOWAIT fast path or not...

> For an io depth of 1, the new patch improves throughput by over three times
> (compared to the exiting behavior, where buffered writes are processed by an
> io-worker process) and also the latency is considerably reduced. To achieve the
> same or better performance with the exisiting code an io depth of 4 is required.
> Increasing the iodepth further does not lead to any further improvements.
> 
> Especially for mixed workloads this is a considerable improvement.

Improving the slow path so it's only half as slow as the existing
psync/libaio IO paths would also be a major improvement for mixed
workloads...

> Support for async buffered writes:
> 
>   Patch 1: block: add check for async buffered writes to generic_write_checks
>     Add a new flag FMODE_BUF_WASYNC so filesystems can specify that they support
>     async buffered writes and include the flag in the check of the function
>     generic_write_checks().
>     
>   Patch 2: mm: add FGP_ATOMIC flag to __filemap_get_folio()
>     This adds the FGP_ATOMIC flag. This allows to specify the gfp flags
>     for memory allocations for async buffered writes.

I haven't even looked at the patches yet, but this gets a hard NACK.
Unbound GFP_ATOMIC allocations in a user controlled context is a
total non-starter.

>   Patch 3: iomap: add iomap_page_create_gfp to allocate iomap_pages
>     Add new function to allow specifying gfp flags when allocating and
>     initializing the structure iomap_page.
> 
>   Patch 4: iomap: use iomap_page_create_gfp() in __iomap_write_begin
>     Add a gfp flag to the iomap_page_create function.
>   
>   Patch 5: iomap: add async buffered write support
>     Set IOMAP_NOWAIT flag if IOCB_NOWAIT is set. Also use specific gfp flags if
>     the iomap_page structure is allocated for an async buffered page.
> 
>   Patch 6: xfs: add iomap async buffered write support
>     Add async buffered write support to the xfs iomap layer.
> 
> Support for async buffered write support and inode time modification
> 
> 
>   Patch 7: fs: split off need_remove_file_privs() do_remove_file_privs()
>     Splits of a check and action function, so they can later be invoked
>     in the nowait code path.

I don't like the sound of that. Separating the stripping of
SUID/SGID bits and other important things from the check opens a
potential window between the check and action where state changes
can be made that the check/action haven't taken into account...

This seems like a dangerous architectural direction to be headed as
it introduces an uncloseable race window where things can change
between checks and actions. Especially as it's likely easily
controllable from userspace because of the locking involved in
filesystem modification operations....

>   Patch 8: fs: split off need_file_update_time and do_file_update_time
>     Splits of a check and action function, so they can later be invoked
>     in the nowait code path.
>     
>   Patch 9: fs: add pending file update time flag.
>     Add new flag so consecutive write requests for the same inode can
>     proceed without waiting for the inode modification time to complete.

Isn't this exactly what the lazytime mount option already gives us?

>   Patch 10: xfs: enable async write file modification handling.
>     Enable async write handling in xfs for the file modification time
>     update. If the file modification update requires logging or removal
>     of privileges that needs to wait, -EAGAIN is returned.
> 
>   Patch 11: xfs: add async buffered write support
>     Take the ilock in nowait mode if async buffered writes are enabled.
> 
>   Patch 12: io_uring: add support for async buffered writes
>     This enables the async buffered writes optimization in io_uring.
>     Buffered writes are enabled for blocks that are already in the page
>     cache.
> 
>   Patch 13: io_uring: Add tracepoint for short writes
> 
> Support for write throttling of async buffered writes:
> 
>   Patch 14: sched: add new fields to task_struct
>     Add two new fields to the task_struct. These fields store the
>     deadline after which writes are no longer throttled.
> 
>   Patch 15: mm: support write throttling for async buffered writes
>     This changes the balance_dirty_pages function to take an additional
>     parameter. When nowait is specified the write throttling code no
>     longer waits synchronously for the deadline to expire. Instead
>     it sets the fields in task_struct. Once the deadline expires the
>     fields are reset.

How have you tested this? How does it interact with non io-uring
writers to files on the same fs/backing device? How does it interact
with other devices when they are at full writeback speed and
throttling writes on the dirty limits, too?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
