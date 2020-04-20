Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2191B1823
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2020 23:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgDTVOn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Apr 2020 17:14:43 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:49317 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgDTVOn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Apr 2020 17:14:43 -0400
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 7894D200002;
        Mon, 20 Apr 2020 21:14:36 +0000 (UTC)
Date:   Mon, 20 Apr 2020 14:14:34 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
Message-ID: <20200420211434.GC3515@localhost>
References: <cover.1586830316.git.josh@joshtriplett.org>
 <f969e7d45a8e83efc1ca13d675efd8775f13f376.1586830316.git.josh@joshtriplett.org>
 <20200419104404.j4e5gxdn2duvmu6s@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419104404.j4e5gxdn2duvmu6s@yavin.dot.cyphar.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 19, 2020 at 08:44:04PM +1000, Aleksa Sarai wrote:
> On 2020-04-13, Josh Triplett <josh@joshtriplett.org> wrote:
> > Inspired by the X protocol's handling of XIDs, allow userspace to select
> > the file descriptor opened by openat2, so that it can use the resulting
> > file descriptor in subsequent system calls without waiting for the
> > response to openat2.
> > 
> > In io_uring, this allows sequences like openat2/read/close without
> > waiting for the openat2 to complete. Multiple such sequences can
> > overlap, as long as each uses a distinct file descriptor.
> 
> I'm not sure I understand this explanation -- how can you trigger a
> syscall with an fd that hasn't yet been registered (unless you're just
> hoping the race goes in your favour)?

See the response from Jens for an explanation of how this works in
io_uring.

> > Add a new O_SPECIFIC_FD open flag to enable this behavior, only accepted
> > by openat2 for now (ignored by open/openat like all unknown flags). Add
> > an fd field to struct open_how (along with appropriate padding, and
> > verify that the padding is 0 to allow replacing the padding with a field
> > in the future).
> > 
> > The file table has a corresponding new function
> > get_specific_unused_fd_flags, which gets the specified file descriptor
> > if O_SPECIFIC_FD is set (and the fd isn't -1); otherwise it falls back
> > to get_unused_fd_flags, to simplify callers.
> > 
> > The specified file descriptor must not already be open; if it is,
> > get_specific_unused_fd_flags will fail with -EBUSY. This helps catch
> > userspace errors.
> > 
> > When O_SPECIFIC_FD is set, and fd is not -1, openat2 will use the
> > specified file descriptor rather than finding the lowest available one.
> 
> I still don't like that you can enable this feature with O_SPECIFIC_FD
> but then disable it by specifying fd as -1. I understand why this is
> needed for pipe2() and socketpair() and that's totally fine, but I don't
> think it makes sense for openat2() or other interfaces where there's
> only one fd being returned -- what does it mean to say "give me a
> specific fd, but actually I don't care what it is"?
> 
> I know this is a trade-off between consistency of O_SPECIFIC_FD
> interfaces and having wart-less interfaces for each syscall, but I don't
> think it breaks consistency to say "syscalls that only give you one fd
> don't have a second way of disabling the feature -- just don't pass
> O_SPECIFIC_FD".

I think there's value in the orthogonality, and -1 can never be a valid
file descriptor. If this becomes a sticking point, it could certainly be
changed (just modify pipe2 to remove the O_SPECIFIC_FD flag if passed
-1), but at the same time, I'd rather have this logic implemented once
with a uniform semantic no matter what syscall uses it.

> >  struct open_how {
> >  	__u64 flags;
> >  	__u64 mode;
> >  	__u64 resolve;
> > +	__u32 fd;
> > +	__u32 pad; /* Must be 0 in the current version */
> 
> Small nit: This field should be called __padding to make it more
> explicit it's something internal and shouldn't be looked at by
> userspace. And the comment should just be "must be zeroed".

Good point. Done in v5.

> > --- a/tools/testing/selftests/openat2/openat2_test.c
> > +++ b/tools/testing/selftests/openat2/openat2_test.c
> > @@ -40,7 +40,7 @@ struct struct_test {
> >  	int err;
> >  };
> >  
> > -#define NUM_OPENAT2_STRUCT_TESTS 7
> > +#define NUM_OPENAT2_STRUCT_TESTS 8
> >  #define NUM_OPENAT2_STRUCT_VARIATIONS 13
> >  
> >  void test_openat2_struct(void)
> > @@ -52,6 +52,9 @@ void test_openat2_struct(void)
> >  		{ .name = "normal struct",
> >  		  .arg.inner.flags = O_RDONLY,
> >  		  .size = sizeof(struct open_how) },
> > +		{ .name = "v0 struct",
> > +		  .arg.inner.flags = O_RDONLY,
> > +		  .size = OPEN_HOW_SIZE_VER0 },
> >  		/* Bigger struct, with zeroed out end. */
> >  		{ .name = "bigger struct (zeroed out)",
> >  		  .arg.inner.flags = O_RDONLY,
> > @@ -155,7 +158,7 @@ struct flag_test {
> >  	int err;
> >  };
> >  
> > -#define NUM_OPENAT2_FLAG_TESTS 23
> > +#define NUM_OPENAT2_FLAG_TESTS 29
> >  
> >  void test_openat2_flags(void)
> >  {
> > @@ -223,6 +226,24 @@ void test_openat2_flags(void)
> >  		{ .name = "invalid how.resolve and O_PATH",
> >  		  .how.flags = O_PATH,
> >  		  .how.resolve = 0x1337, .err = -EINVAL },
> > +
> > +		/* O_SPECIFIC_FD tests */
> > +		{ .name = "O_SPECIFIC_FD",
> > +		  .how.flags = O_RDONLY | O_SPECIFIC_FD, .how.fd = 42 },
> > +		{ .name = "O_SPECIFIC_FD if fd exists",
> > +		  .how.flags = O_RDONLY | O_SPECIFIC_FD, .how.fd = 2,
> > +		  .err = -EBUSY },
> > +		{ .name = "O_SPECIFIC_FD with fd -1",
> > +		  .how.flags = O_RDONLY | O_SPECIFIC_FD, .how.fd = -1 },
> > +		{ .name = "fd without O_SPECIFIC_FD",
> > +		  .how.flags = O_RDONLY, .how.fd = 42,
> > +		  .err = -EINVAL },
> > +		{ .name = "fd -1 without O_SPECIFIC_FD",
> > +		  .how.flags = O_RDONLY, .how.fd = -1,
> > +		  .err = -EINVAL },
> > +		{ .name = "existing fd without O_SPECIFIC_FD",
> > +		  .how.flags = O_RDONLY, .how.fd = 2,
> > +		  .err = -EINVAL },
> 
> It would be good to add a test to make sure that a non-zero value of
> how->__padding also gives -EINVAL.

Done in v5.

- Josh Triplett
