Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8B23D3E51
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 19:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhGWQfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 12:35:11 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:48686 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGWQfL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 12:35:11 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6yhl-003E8O-EE; Fri, 23 Jul 2021 17:11:21 +0000
Date:   Fri, 23 Jul 2021 17:11:21 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
 <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
 <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
 <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
 <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 23, 2021 at 10:17:27AM -0600, Jens Axboe wrote:
> On 7/22/21 6:10 PM, Al Viro wrote:
> > On Thu, Jul 22, 2021 at 05:42:55PM -0600, Jens Axboe wrote:
> > 
> >>> So how can we possibly get there with tsk->files == NULL and what does it
> >>> have to do with files, anyway?
> >>
> >> It's not the clearest, but the files check is just to distinguish between
> >> exec vs normal cancel. For exec, we pass in files == NULL. It's not
> >> related to task->files being NULL or not, we explicitly pass NULL for
> >> exec.
> > 
> > Er...  So turn that argument into bool cancel_all, and pass false on exit and
> > true on exec? 
> 
> Yes
> 
> > While we are at it, what happens if you pass io_uring descriptor
> > to another process, close yours and then have the recepient close the one it
> > has gotten?  AFAICS, io_ring_ctx_wait_and_kill(ctx) will be called in context
> > of a process that has never done anything io_uring-related.  Can it end up
> > trying to resubmit some requests?> 
> > I rather hope it can't happen, but I don't see what would prevent it...
> 
> No, the pending request would either have gone to a created thread of
> the original task on submission, or it would be sitting in a
> ready-to-retry state. The retry would attempt to queue to original task,
> and either succeed (if still alive) or get failed with -ECANCELED. Any
> given request is tied to the original task.

Hmm...  Sure, you'll be pushing it to the same io_wqe it went through originally,
but you are still in context of io_uring_release() caller, aren't you?

So you call io_wqe_wake_worker(), and it decides that all threads are busy,
but ->nr_workers is still below ->max_workers.  And proceeds to
	create_io_worker(wqe->wq, wqe, acct->index);
which will create a new io-worker thread, but do that in the thread group of
current, i.e. the caller of io_uring_release().  Looks like we'd get
an io-worker thread with the wrong parent...

What am I missing here?
