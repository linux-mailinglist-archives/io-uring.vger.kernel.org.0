Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA43D3D2F75
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 00:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhGVVU4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 17:20:56 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:33558 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhGVVU4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jul 2021 17:20:56 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6gip-002zZI-Tc; Thu, 22 Jul 2021 21:59:16 +0000
Date:   Thu, 22 Jul 2021 21:59:15 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 20, 2021 at 12:03:33PM +0100, Pavel Begunkov wrote:
> Just a bit of code tossing in io_sq_offload_create(), so it looks a bit
> better. No functional changes.

Does a use-after-free count as a functional change?

>  		f = fdget(p->wq_fd);

Descriptor table is shared with another thread, grabbed a reference to file.
Refcount is 2 (1 from descriptor table, 1 held by us)

>  		if (!f.file)
>  			return -ENXIO;

Nope, not NULL.

> -		if (f.file->f_op != &io_uring_fops) {
> -			fdput(f);
> -			return -EINVAL;
> -		}
>  		fdput(f);

Decrement refcount, get preempted away.  f.file->f_count is 1 now.

Another thread: close() on the same descriptor.  Final reference to
struct file (from descriptor table) is gone, file closed, memory freed.

Regain CPU...

> +		if (f.file->f_op != &io_uring_fops)
> +			return -EINVAL;

... and dereference an already freed structure.

What scares me here is that you are playing with bloody fundamental objects,
without understanding even the basics regarding their handling ;-/

1) descriptor tables can be shared.
2) another thread can close file right under you.
3) once all references to opened file are gone, it gets shut down and
struct file gets freed.
4) inside an fdget()/fdput() pair you are guaranteed that (3) won't happen.
As soon as you've done fdput(), that promise is gone.

	In the above only (1) might have been non-obvious, because if you
accept _that_, you have to ask yourself what the fuck would prevent file
disappearing once you've done fdput(), seeing that it might be the last
thing your syscall is doing to the damn thing.  So either that would've
leaked it, or _something_ in the operations you've done to it must've
made it possible for close(2) to get the damn thing.  And dereferencing
->f_op is unlikely to be that, isn't it?  Which leaves fdput() the
only candidate.  It's common sense stuff...

	Again, descriptor table is a shared resource and threads sharing
it can issue syscalls at the same time.  Sure, I've got fewer excuses
than you do for lack of documentation, but that's really basic...
