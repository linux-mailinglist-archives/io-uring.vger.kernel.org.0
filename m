Return-Path: <io-uring+bounces-1746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D092C8BBA39
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 11:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BC6F1F22272
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 09:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A279C1429E;
	Sat,  4 May 2024 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcnyJ70+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDE863A5;
	Sat,  4 May 2024 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714814355; cv=none; b=QeFaThp+so6i6YUG4uqAXh+OZmqWDP6uSBnFZVkEB6c8KGG9bbseXzMM9cLo1ih7cDCuld4du5QkFcOr9XDzHkv8+gUzfuoFqVinMjH0PwD7KPkCVMMn+D7y7caJyEwm/k63l738U1w4C8wQNZ6KbR41ezI4b2sGLiWPQOXNRWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714814355; c=relaxed/simple;
	bh=pIwJZ1VsyyitpQ3+UHGFYiivhVpEez/xWNzoLxCtMqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VG9CspSbVUWm+O4ixuDATbW5JoLyxLvzRl1UOTrkVR4v7TYRH0gs+Hkv385kAmQRt+sBXXod0/fONNANJxPGUM23647AjhkWDe7b7aCUoOIZCNvHulp821/xKjV8oohVClo+GrwXTScv4srLtGdkiSMTTp65ne8lTfy2JFjyDAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcnyJ70+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FE0C072AA;
	Sat,  4 May 2024 09:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714814355;
	bh=pIwJZ1VsyyitpQ3+UHGFYiivhVpEez/xWNzoLxCtMqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZcnyJ70+mGZmEpcFtCrdDNK2gUkMdCD80W9jLCJy1lLImlz2hwL+78p9lG2MZIpPT
	 L8qL+btsjQbyCZgHhWpYVAx3GhyG7otgDT5oIT2+B1EzIPFS5QOrXubzps13+ksvIO
	 ijyyViCv5jzhPRI8UCyGmQY2NwmPMM3nMPoPhaId/8y63145jrkq32DEKtNZmlxl0F
	 2tVcMdXbKRjcP7KvQ8Zg+yskxSCxsy8xMXQDHTKILuarxTf09JAJ8e8l0JBcCJKiL6
	 wxNNhlZi/U/n17GkUcJpjdEyIXCCqUWr+SGkl2x8Jf0Hy8+Ts5+IsumVsB1jcaUWXc
	 D9hxvDG3tc8Iw==
Date: Sat, 4 May 2024 11:19:08 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240504-fotowettbewerb-dornen-8a297cec3cfc@brauner>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV>
 <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
 <202405031529.2CD1BFED37@keescook>
 <20240503230318.GF2118490@ZenIV>
 <202405031616.793DF7EEE@keescook>
 <CAHk-=wjoXgm=j=vt9S2dcMk3Ws6Z8ukibrEncFZcxh5n77F6Dg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjoXgm=j=vt9S2dcMk3Ws6Z8ukibrEncFZcxh5n77F6Dg@mail.gmail.com>

On Fri, May 03, 2024 at 04:41:19PM -0700, Linus Torvalds wrote:
> On Fri, 3 May 2024 at 16:23, Kees Cook <keescook@chromium.org> wrote:
> >
> > static bool __must_check get_dma_buf_unless_doomed(struct dma_buf *dmabuf)
> > {
> >         return atomic_long_inc_not_zero(&dmabuf->file->f_count) != 0L;
> > }
> >
> > If we end up adding epi_fget(), we'll have 2 cases of using
> > "atomic_long_inc_not_zero" for f_count. Do we need some kind of blessed
> > helper to live in file.h or something, with appropriate comments?
> 
> I wonder if we could try to abstract this out a bit more.
> 
> These games with non-ref-counted file structures *feel* a bit like the
> games we play with non-ref-counted (aka "stashed") 'struct dentry'
> that got fairly recently cleaned up with path_from_stashed() when both
> nsfs and pidfs started doing the same thing.
> 
> I'm not loving the TTM use of this thing, but at least the locking and
> logic feels a lot more straightforward (ie the
> atomic_long_inc_not_zero() here is clealy under the 'prime->mutex'
> lock

The TTM stuff is somewhat wild though and I've commented on that in
https://lore.kernel.org/r/20240503-mitmachen-redakteur-2707ab0cacc3@brauner
another thread that it can just use get_active_file().

Afaict, there's dma_buf_export() that allocates a new file and sets:

file->private_data = dmabuf;
dmabuf->file = file;
dentry->d_fsdata = dmabuf;

The file has f_op->release::dma_buf_file_release() as it's f_op->release
method. When that's called the file's refcount is already zero but the
file has not been freed yet. This will remove the dmabuf from some
public list but it won't free it.

dmabuf dentries have dma_buf_dentry_ops which use
dentry->d_release::dma_buf_release() to release the actual dmabuf
stashed in dentry->d_fsdata.

So that ends up with:

__fput()
-> f_op->release::dma_buf_file_release() // handles file specific freeing
-> dput()
   -> d_op->d_release::dma_buf_release() // handles dmabuf freeing
                                         // including the driver specific stuff.

If you fput() the file then the dmabuf will be freed as well immediately
after it when the dput() happens in __fput().

So that TTM thing does something else then in ttm_object_device_init().
It copies the dma_buf_ops into tdev->ops and replaces the dma_buf_ops
release method with it's own ttm_prime_dmabuf_release() and stashes the
old on in tdev->dma_buf_release.

And it uses that to hook into the release path so that @dmabuf will
still be valid for get_dma_buf_unless_doomed() under prime->mutex.

But again, get_dma_buf_unless_doomed() can just be replaced with
get_active_file() and then we're done with that part.

> IOW, the tty use looks correct to me, and it has fairly simple locking
> and is just catching the the race between 'fput()' decrementing the
> refcount and and 'file->f_op->release()' doing the actual release.
> 
> You are right that it's similar to the epoll thing in that sense, it
> just looks a _lot_ more straightforward to me (and, unlike epoll,
> doesn't look actively buggy right now).

It's not buggy afaict. It literally can just switch to get_active_file()
instead of open-coding it and we're done imho.

