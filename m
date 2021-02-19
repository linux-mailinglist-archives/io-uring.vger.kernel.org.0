Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBBF31FE83
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 19:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBSSHX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 13:07:23 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:59298 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBSSHV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 13:07:21 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id C7D207F4AC; Fri, 19 Feb 2021 20:06:37 +0200 (EET)
Date:   Fri, 19 Feb 2021 20:06:37 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Laight <David.Laight@aculab.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <20210219180637.GC342512@wantstofly.org>
References: <20210218122640.GA334506@wantstofly.org>
 <20210218122755.GC334506@wantstofly.org>
 <9a6fb59b-be85-c36b-3c83-26cff37bcb87@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a6fb59b-be85-c36b-3c83-26cff37bcb87@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 19, 2021 at 12:05:58PM +0000, Pavel Begunkov wrote:

> > IORING_OP_GETDENTS behaves much like getdents64(2) and takes the same
> > arguments, but with a small twist: it takes an additional offset
> > argument, and reading from the specified directory starts at the given
> > offset.
> > 
> > For the first IORING_OP_GETDENTS call on a directory, the offset
> > parameter can be set to zero, and for subsequent calls, it can be
> > set to the ->d_off field of the last struct linux_dirent64 returned
> > by the previous IORING_OP_GETDENTS call.
> > 
> > Internally, if necessary, IORING_OP_GETDENTS will vfs_llseek() to
> > the right directory position before calling vfs_getdents().
> > 
> > IORING_OP_GETDENTS may or may not update the specified directory's
> > file offset, and the file offset should not be relied upon having
> > any particular value during or after an IORING_OP_GETDENTS call.
> > 
> > Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> > ---
> >  fs/io_uring.c                 | 73 +++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/io_uring.h |  1 +
> >  2 files changed, 74 insertions(+)
> > 
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 056bd4c90ade..6853bf48369a 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -635,6 +635,13 @@ struct io_mkdir {
> >  	struct filename			*filename;
> >  };
> >  
> [...]
> > +static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> > +{
> > +	struct io_getdents *getdents = &req->getdents;
> > +	bool pos_unlock = false;
> > +	int ret = 0;
> > +
> > +	/* getdents always requires a blocking context */
> > +	if (issue_flags & IO_URING_F_NONBLOCK)
> > +		return -EAGAIN;
> > +
> > +	/* for vfs_llseek and to serialize ->iterate_shared() on this file */
> > +	if (file_count(req->file) > 1) {
> 
> Looks racy, is it safe? E.g. can be concurrently dupped and used, or
> just several similar IORING_OP_GETDENTS requests.

I thought that it was safe, but I thought about it a bit more, and it
seems that it is unsafe -- if you IORING_REGISTER_FILES to register the
dirfd and then close the dirfd, you'll get a file_count of 1, while you
can submit concurrent operations.  So I'll remove the conditional
locking.  Thanks!

(If not for IORING_REGISTER_FILES, it seems safe, because then
io_file_get() will hold a(t least one) reference on the file while the
operation is in flight, so then if file_count(req->file) == 1 here,
then it means that the file is no longer referenced by any fdtable,
and nobody else should be able to get a reference to it -- but that's
a bit of a useless optimization.)

(Logic was taken from __fdget_pos, where it is safe for a different
reason, i.e. __fget_light will not bump the refcount iff current->files
is unshared.)


> > +		pos_unlock = true;
> > +		mutex_lock(&req->file->f_pos_lock);
> > +	}
> > +
> > +	if (req->file->f_pos != getdents->pos) {
> > +		loff_t res = vfs_llseek(req->file, getdents->pos, SEEK_SET);
> 
> I may be missing the previous discussions, but can this ever become
> stateless, like passing an offset? Including readdir.c and beyond. 

My aim was to only make the minimally required change initially, but
to make that optimization possible in the future (e.g. by reserving the
right to either update or not update the file position) -- but I'll
try doing the optimization now.


> > +		if (res < 0)
> > +			ret = res;
> > +	}
> > +
> > +	if (ret == 0) {
> > +		ret = vfs_getdents(req->file, getdents->dirent,
> > +				   getdents->count);
> > +	}
> > +
> > +	if (pos_unlock)
> > +		mutex_unlock(&req->file->f_pos_lock);
> > +
> > +	if (ret < 0) {
> > +		if (ret == -ERESTARTSYS)
> > +			ret = -EINTR;
> > +		req_set_fail_links(req);
> > +	}
> > +	io_req_complete(req, ret);
> > +	return 0;
> > +}
> [...]
> 
> -- 
> Pavel Begunkov
