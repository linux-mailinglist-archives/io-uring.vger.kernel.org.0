Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2810360B79
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 16:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhDOOKD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 10:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhDOOKD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 15 Apr 2021 10:10:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 190C161153;
        Thu, 15 Apr 2021 14:09:37 +0000 (UTC)
Date:   Thu, 15 Apr 2021 16:09:32 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
Message-ID: <20210415140932.uriiqjx3klzzmluu@wittgenstein>
References: <20210330055957.3684579-1-dkadashev@gmail.com>
 <20210330055957.3684579-2-dkadashev@gmail.com>
 <20210330071700.kpjoyp5zlni7uejm@wittgenstein>
 <CAOKbgA6spFzCJO+L_uwm9nhG+5LEo_XjVt7R7D8K=B5BcWSDbA@mail.gmail.com>
 <CAOKbgA6Qrs5DoHsHgBvrSGbyzHcaiGVpP+UBS5f25CtdBx3SdA@mail.gmail.com>
 <20210415100815.edrn4a7cy26wkowe@wittgenstein>
 <20210415100928.3ukgiaui4rhspiq6@wittgenstein>
 <CAOKbgA6Tn9uLJCAWOzWfysQDmFWcPBCOT6x47D-q-+_tu9z2Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOKbgA6Tn9uLJCAWOzWfysQDmFWcPBCOT6x47D-q-+_tu9z2Hg@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 15, 2021 at 05:41:07PM +0700, Dmitry Kadashev wrote:
> On Thu, Apr 15, 2021 at 5:09 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > On Thu, Apr 15, 2021 at 12:08:20PM +0200, Christian Brauner wrote:
> > > Would something like this help?
> 
> Thanks for the reply, Christian!
> 
> But it's not the AT_EMPTY_PATH / LOOKUP_EMPTY part that is tricky, it's
> the fact that do_linkat() allows AT_EMPTY_PATH only if the process has
> CAP_DAC_READ_SEARCH capability. But AT_EMPTY_PATH is processed during
> getname(), so if do_linkat() accepts struct filename* then there is no
> bullet-proof way to force the capability.
> 
> We could do something like this:
> 
> do_linkat(oldfd, getname_uflags(oldname, flags), newfd,
>           getname(newname), flags);
> 
> I.e. call getname_uflags() without checking the capability and rely on
> the fact that do_linkat() will do the checking. But this is fragile if
> somehow someone passes different flags to getname_uflags and do_linkat.
> And there is no way (that I know of) for do_linkat to actually check
> that AT_EMPTY_PATH was not used if it gets struct filename.
> 
> Or am I creating extra problems and the thing above is OK?

Hm, I get your point but if you e.g. look at fs/exec.c we already do
have that problem today:

 SYSCALL_DEFINE5(execveat,
		int, fd, const char __user *, filename,
		const char __user *const __user *, argv,
		const char __user *const __user *, envp,
		int, flags)
{
	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;

	return do_execveat(fd,
			   getname_flags(filename, lookup_flags, NULL),
			   argv, envp, flags);
}

The new simple flag helper would simplify things because right now it
pretends that it cares about multiple flags where it actually just cares
about whether or not empty pathnames are allowed and it forces callers
to translate between flags too.

(Note, just my opinion this might get shot to hell.)

Christian
