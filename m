Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C600F3D309E
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 02:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhGVXW3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 19:22:29 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:35402 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhGVXW3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jul 2021 19:22:29 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6iea-0031GC-1b; Fri, 23 Jul 2021 00:03:00 +0000
Date:   Fri, 23 Jul 2021 00:03:00 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <YPoHNCGlPl274t2I@zeniv-ca.linux.org.uk>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
 <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
 <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
 <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 22, 2021 at 11:30:35PM +0000, Al Viro wrote:

> IOW, task->files can be NULL *ONLY* after exit_files().  There are two callers
> of that; one is for stillborns in copy_process(), another - in do_exit(),
> well past that call of io_uring_files_cancel().  And around that call we have
> 
>         if (unlikely(tsk->flags & PF_EXITING)) {
> 		pr_alert("Fixing recursive fault but reboot is needed!\n");
> 		futex_exit_recursive(tsk);
> 		set_current_state(TASK_UNINTERRUPTIBLE);
> 		schedule();
> 	}
>         io_uring_files_cancel(tsk->files);
> 	exit_signals(tsk);  /* sets PF_EXITING */
> 
> So how can we possibly get there with tsk->files == NULL and what does it
> have to do with files, anyway?

PS: processes with ->files == NULL can be observed; e.g. access via procfs
can very well race with exit().  If procfs acquires task_struct reference
before exit(), the object won't get freed until we do put_task_struct().
However, the process in question can get through the entire do_exit(),
become a zombie, be successfull reaped, etc., so its state can be very
thoroughly taken apart while procfs tries to access it.

There the checks for tsk->files == NULL are meaningful; doing them for
current, OTOH, is basically asking "am I rather deep into do_exit()?"

	Once upon a time we had exit_files() done kernel threads.
Not for the last 9 years since 864bdb3b6cbd ("new helper:
daemonize_descriptors()"), though (and shortly after that the entire
daemonize() thing has disappeared - kernel threads are spawned by
kthreadd, and inherit ->files from it just fine).

	Should've killed the useless checks for NULL ->files at the same
time, hadn't...  FWIW, the checks in fget_task(), task_lookup_fd_rcu(),
task_lookup_next_fd_rcu(), task_state(), fs/proc/fd.c:seq_show()
and iterate_fd() are there for good reason.  The ones in unshare_fd(),
copy_files(), fs/proc/task_nommu.c:task_mem() and in exit_files() itself
are noise.  I'll throw their removal in vfs.git#work.misc...

	Anyway, if you intended to check for some(?) kernel threads,
that place needs fixing.  If not, I'd suggest just passing a boolean
to that thing (and giving it less confusing name)...
