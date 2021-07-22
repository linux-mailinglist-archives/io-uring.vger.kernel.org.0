Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792AA3D3035
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 01:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbhGVWuE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 18:50:04 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:34002 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGVWuE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jul 2021 18:50:04 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6i9D-0030mn-Rr; Thu, 22 Jul 2021 23:30:35 +0000
Date:   Thu, 22 Jul 2021 23:30:35 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
 <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
 <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 22, 2021 at 05:06:24PM -0600, Jens Axboe wrote:

> But yes, that is not great and obviously a bug, and we'll of course get
> it fixed up asap.

Another fun question: in do_exit() you have
        io_uring_files_cancel(tsk->files);

with

static inline void io_uring_files_cancel(struct files_struct *files)
{
        if (current->io_uring)
		__io_uring_cancel(files);
}

and

void __io_uring_cancel(struct files_struct *files)
{
        io_uring_cancel_generic(!files, NULL);
}

What the hell is that about?  What are you trying to check there?

All assignments to ->files:
init/init_task.c:116:   .files          = &init_files,
	Not NULL.
fs/file.c:433:          tsk->files = NULL;
	exit_files(), sets to NULL
fs/file.c:741:          me->files = cur_fds;
	__close_range(), if the value has been changed at all, the new one
	came from if (fds) swap(cur_fds, fds), so it can't become NULL here.
kernel/fork.c:1482:     tsk->files = newf;
	copy_files(), immediately preceded by verifying newf != NULL
kernel/fork.c:3044:                     current->files = new_fd;
	ksys_unshare(), under if (new_fd)
kernel/fork.c:3097:     task->files = copy;
	unshare_files(), with if (error || !copy) return error;
	slightly upstream.

IOW, task->files can be NULL *ONLY* after exit_files().  There are two callers
of that; one is for stillborns in copy_process(), another - in do_exit(),
well past that call of io_uring_files_cancel().  And around that call we have

        if (unlikely(tsk->flags & PF_EXITING)) {
		pr_alert("Fixing recursive fault but reboot is needed!\n");
		futex_exit_recursive(tsk);
		set_current_state(TASK_UNINTERRUPTIBLE);
		schedule();
	}
        io_uring_files_cancel(tsk->files);
	exit_signals(tsk);  /* sets PF_EXITING */

So how can we possibly get there with tsk->files == NULL and what does it
have to do with files, anyway?
