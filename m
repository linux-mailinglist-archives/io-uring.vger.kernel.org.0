Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B731A2EA9
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 07:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgDIFAL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 01:00:11 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:59027 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgDIFAL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 01:00:11 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 9B4972000A;
        Thu,  9 Apr 2020 05:00:02 +0000 (UTC)
Date:   Wed, 8 Apr 2020 22:00:00 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
Message-ID: <20200409050000.GE6149@localhost>
References: <cover.1586321767.git.josh@joshtriplett.org>
 <e598110f71a4e2346860b94e91de3e6e75a4b82a.1586321767.git.josh@joshtriplett.org>
 <20200408122330.5vorg2bwtth2dp5k@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408122330.5vorg2bwtth2dp5k@yavin.dot.cyphar.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 08, 2020 at 10:23:30PM +1000, Aleksa Sarai wrote:
> On 2020-04-07, Josh Triplett <josh@joshtriplett.org> wrote:
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Maybe I'm misunderstanding something, but this Signed-off-by looks
> strange -- was it Co-developed-by Jens?

No. I wrote v1, and Jens incorporated some of those patches into a v2
series that added signoffs. So when I took patch 2 from that series and
rebased it into this new series, I kept the signoff.

> > ---
> >  fs/fcntl.c                       |  2 +-
> >  fs/file.c                        | 39 ++++++++++++++++++++++++++++++++
> >  fs/io_uring.c                    |  3 ++-
> >  fs/open.c                        |  6 +++--
> >  include/linux/fcntl.h            |  5 ++--
> >  include/linux/file.h             |  3 +++
> >  include/uapi/asm-generic/fcntl.h |  4 ++++
> >  include/uapi/linux/openat2.h     |  2 ++
> >  8 files changed, 58 insertions(+), 6 deletions(-)

> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -567,6 +567,45 @@ void put_unused_fd(unsigned int fd)
> >  
> >  EXPORT_SYMBOL(put_unused_fd);
> >  
> > +int __get_specific_unused_fd_flags(unsigned int fd, unsigned int flags,
> > +				   unsigned long nofile)
> > +{
> > +	int ret;
> > +	struct fdtable *fdt;
> > +	struct files_struct *files = current->files;
> > +
> > +	if (!(flags & O_SPECIFIC_FD) || fd == -1)
> > +		return __get_unused_fd_flags(flags, nofile);
> 
> This check should just be (flags & O_SPECIFIC_FD) -- see my comment
> below about ->fd being negative.

This was intentional, and I think it makes sense to keep. I'd like to
maintain the same consistent behavior in any call that uses
O_SPECIFIC_FD: an fd of -1 means "go ahead and assign the lowest
available fd". This allows for calls like pipe2, or in the future
socketpair, where you might want to explicitly assign one end, but allow
the kernel to allocate the other end. -1 can never be a valid file
descriptor, since it would be interpreted as an errno instead. mmap
similarly treats -1 as an invalid file descriptor.

As an example use case: in one io_uring batch, you want to allocate a
pipe, send one end over a UNIX socket to another process, and close that
end in your process. So you need *that* end to be a userspace-allocated
file descriptor, so you know what fd to use in the subsequent sendmsg
and close calls. But for the other end that you plan to hold onto, you
don't want to use up one of your small number of preallocated file
descriptors (of which you only need enough for the operations in any one
io_uring batch).

However, in response to your comment below, I've changed this from -1 to
UINT_MAX.

> > +
> > +	if (fd >= nofile)
> > +		return -EBADF;
> > +
> > +	spin_lock(&files->file_lock);
> > +	ret = expand_files(files, fd);
> > +	if (unlikely(ret < 0))
> > +		goto out_unlock;
> > +	fdt = files_fdtable(files);
> > +	if (fdt->fd[fd]) {
> > +		ret = -EBUSY;
> > +		goto out_unlock;
> 
> It would be remiss of me to not mention that this is inconsistent with
> the other way of explicitly picking a file descriptor on Unix -- the dup
> family closes newfd if it's already used.
> 
> But that being said, I do actually prefer this behaviour since it means
> that two threads trying to open a file with the same specific file
> descriptor won't see the file descriptor change underneath them (leading
> to who knows how much head-scratching).

Exactly. I documented that difference explicitly in the commit message:

> The specified file descriptor must not already be open; if it is,
> get_specific_unused_fd_flags will fail with -EBUSY. This helps catch
> userspace errors.

I also intend for that to appear in the manpage.

> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -958,7 +958,7 @@ EXPORT_SYMBOL(open_with_fake_path);
> >  inline struct open_how build_open_how(int flags, umode_t mode)
> >  {
> >  	struct open_how how = {
> > -		.flags = flags & VALID_OPEN_FLAGS,
> > +		.flags = flags & VALID_OPEN_FLAGS & ~O_SPECIFIC_FD,
> 
> This is getting a little ugly, maybe filter out O_SPECIFIC_FD later on
> in build_open_how() -- where we handle O_PATH.

Sure; I'll move it down and add a comment.

> >  		.mode = mode & S_IALLUGO,
> >  	};
> >  
> > @@ -1143,7 +1143,7 @@ static long do_sys_openat2(int dfd, const char __user *filename,
> >  	if (IS_ERR(tmp))
> >  		return PTR_ERR(tmp);
> >  
> > -	fd = get_unused_fd_flags(how->flags);
> > +	fd = get_specific_unused_fd_flags(how->fd, how->flags);
> >  	if (fd >= 0) {
> >  		struct file *f = do_filp_open(dfd, tmp, &op);
> >  		if (IS_ERR(f)) {
> > @@ -1193,6 +1193,8 @@ SYSCALL_DEFINE4(openat2, int, dfd, const char __user *, filename,
> >  	err = copy_struct_from_user(&tmp, sizeof(tmp), how, usize);
> >  	if (err)
> >  		return err;
> > +	if (tmp.pad != 0)
> > +		return -EINVAL;
> 
> This check should be done in build_open_flags(), where the other sanity
> checks are done.

Good idea; done.

> In addition, there must be an additional check like
> 
>   if (!(flags & O_SPECIFIC_FD) && how->fd != 0)
>     return -EINVAL;
> 
> Since we must not allow garbage values to be passed and ignored by us in
> openat2().

Good catch! Added.

> > --- a/include/uapi/asm-generic/fcntl.h
> > +++ b/include/uapi/asm-generic/fcntl.h
> > @@ -89,6 +89,10 @@
> >  #define __O_TMPFILE	020000000
> >  #endif
> >  
> > +#ifndef O_SPECIFIC_FD
> > +#define O_SPECIFIC_FD	01000000000	/* open as specified fd */
> > +#endif
> 
> Maybe you've already done this (since you skipped several bits in the
> O_* flag space), but I would double-check that there is no conflict on
> other architectures. I faintly recall that FMODE_NOTIFY has a different
> value on sparc, and there was some oddness on alpha too... But as long
> as fcntl.c builds on all the arches then it's fine.

I checked other architectures carefully, and yes, I picked this value
because some of the intermediate values conflicted on specific
architectures.

> > --- a/include/uapi/linux/openat2.h
> > +++ b/include/uapi/linux/openat2.h
> > @@ -20,6 +20,8 @@ struct open_how {
> >  	__u64 flags;
> >  	__u64 mode;
> >  	__u64 resolve;
> > +	__s32 fd;
> > +	__u32 pad; /* Must be 0 in the current version */
> 
> I'm not sure I see why the new field is an s32 -- there should be no
> situation where a user specifies O_SPECIFIC_FD and a negative file
> descriptor (if we keep it as an s32, you should get an -EINVAL in that
> case). If you don't want O_SPECIFIC_FD, don't specify it.
>
> But I think this should be a u32.

See my explanation above for why I do want to allow `-1` here.

However, there's no reason I need to make the field signed just because
of that one reserved value. I'll change the field to a __u32.

- Josh Triplett
