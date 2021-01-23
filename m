Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A05301789
	for <lists+io-uring@lfdr.de>; Sat, 23 Jan 2021 19:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbhAWSRV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 13:17:21 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:40824 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbhAWSRU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 13:17:20 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id E4D257F02B; Sat, 23 Jan 2021 20:16:36 +0200 (EET)
Date:   Sat, 23 Jan 2021 20:16:36 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Message-ID: <20210123181636.GA121842@wantstofly.org>
References: <20210123114152.GA120281@wantstofly.org>
 <b5b978ee-1a56-ead7-43bc-83ae2398b160@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5b978ee-1a56-ead7-43bc-83ae2398b160@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 23, 2021 at 10:37:25AM -0700, Jens Axboe wrote:

> > IORING_OP_GETDENTS64 behaves like getdents64(2) and takes the same
> > arguments.
> > 
> > Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> > ---
> > This seems to work OK, but I'd appreciate a review from someone more
> > familiar with io_uring internals than I am, as I'm not entirely sure
> > I did everything quite right.
> > 
> > A dumb test program for IORING_OP_GETDENTS64 is available here:
> > 
> > 	https://krautbox.wantstofly.org/~buytenh/uringfind.c
> > 
> > This does more or less what find(1) does: it scans recursively through
> > a directory tree and prints the names of all directories and files it
> > encounters along the way -- but then using io_uring.  (The uring version
> > prints the names of encountered files and directories in an order that's
> > determined by SQE completion order, which is somewhat nondeterministic
> > and likely to differ between runs.)
> > 
> > On a directory tree with 14-odd million files in it that's on a
> > six-drive (spinning disk) btrfs raid, find(1) takes:
> > 
> > 	# echo 3 > /proc/sys/vm/drop_caches 
> > 	# time find /mnt/repo > /dev/null
> > 
> > 	real    24m7.815s
> > 	user    0m15.015s
> > 	sys     0m48.340s
> > 	#
> > 
> > And the io_uring version takes:
> > 
> > 	# echo 3 > /proc/sys/vm/drop_caches 
> > 	# time ./uringfind /mnt/repo > /dev/null
> > 
> > 	real    10m29.064s
> > 	user    0m4.347s
> > 	sys     0m1.677s
> > 	#
> > 
> > These timings are repeatable and consistent to within a few seconds.
> > 
> > (btrfs seems to be sending most metadata reads to the same drive in the
> > array during this test, even though this filesystem is using the raid1c4
> > profile for metadata, so I suspect that more drive-level parallelism can
> > be extracted with some btrfs tweaks.)
> > 
> > The fully cached case also shows some speedup for the io_uring version:
> > 
> > 	# time find /mnt/repo > /dev/null
> > 
> > 	real    0m5.223s
> > 	user    0m1.926s
> > 	sys     0m3.268s
> > 	#
> > 
> > vs:
> > 
> > 	# time ./uringfind /mnt/repo > /dev/null
> > 
> > 	real    0m3.604s
> > 	user    0m2.417s
> > 	sys     0m0.793s
> > 	#
> > 
> > That said, the point of this patch isn't primarily to enable
> > lightning-fast find(1) or du(1), but more to complete the set of
> > filesystem I/O primitives available via io_uring, so that applications
> > can do all of their filesystem I/O using the same mechanism, without
> > having to manually punt some of their work out to worker threads -- and
> > indeed, an object storage backend server that I wrote a while ago can
> > run with a pure io_uring based event loop with this patch.
> 
> The results look nice for sure.

Thanks!  And thank you for having a look.


> Once concern is that io_uring generally
> guarantees that any state passed in is stable once submit is done. For
> the below implementation, that doesn't hold as the linux_dirent64 isn't
> used until later in the process. That means if you do:
> 
> submit_getdents64(ring)
> {
> 	struct linux_dirent64 dent;
> 	struct io_uring_sqe *sqe;
> 
> 	sqe = io_uring_get_sqe(ring);
> 	io_uring_prep_getdents64(sqe, ..., &dent);
> 	io_uring_submit(ring);
> }
> 
> other_func(ring)
> {
> 	struct io_uring_cqe *cqe;
> 
> 	submit_getdents64(ring);
> 	io_uring_wait_cqe(ring, &cqe);
> 	
> }
> 
> then the kernel side might get garbage by the time the sqe is actually
> submitted. This is true because you don't use it inline, only from the
> out-of-line async context. Usually this is solved by having the prep
> side copy in the necessary state, eg see io_openat2_prep() for how we
> make filename and open_how stable by copying them into kernel memory.
> That ensures that if/when these operations need to go async and finish
> out-of-line, the contents are stable and there's no requirement for the
> application to keep them valid once submission is done.
> 
> Not sure how best to solve that, since the vfs side relies heavily on
> linux_dirent64 being a user pointer...

No data is passed into the kernel on a getdents64(2) call via user
memory, i.e. getdents64(2) only ever writes into the supplied
linux_dirent64 user pointer, it never reads from it.  The only things
that we need to keep stable here are the linux_dirent64 pointer itself
and the 'count' argument and those are both passed in via the SQE, and
we READ_ONCE() them from the SQE in the prep function.  I think that's
probably the source of confusion here?


Cheers,
Lennert
