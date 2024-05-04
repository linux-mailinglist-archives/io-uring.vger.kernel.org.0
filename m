Return-Path: <io-uring+bounces-1748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D408C8BBA55
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 11:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17A8728286C
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 09:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B819D17550;
	Sat,  4 May 2024 09:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7yQM5Re"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1D15258;
	Sat,  4 May 2024 09:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714815926; cv=none; b=KQzqBjohwPJruwlALDYXh14/h7TUN24nfBmyYk0bomYmxmvFwh8cUplHcqcIiqfcoOJY/STjLcqGW4rMfyuD83E3ZvyALo0OhELXXo8XD0benOszosSPr259HvSqj9zjZ7RXWp47f28s1pO08hC6pzpuuUIRg3KaoQzUo3i5rn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714815926; c=relaxed/simple;
	bh=Dwww0zXWAYAhVa6+ZHGyGIVbKmD1FELsGL3H8q7Pkgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pm9ofCu744a0nA+hxfdDONCzU7m5DzeumpeHtLG+EA5qkgAtLMJFpBZ5ahWET5Se4CC5vv5O0mdbPfXuh5JXSnuCGvT3jrarQBrTHWWAyP3qXZqbiE+eabHO/bSmCBZ1PHrojeMuRy8vtpGw6cpB/gGLMlGPKWYUD5/wf1kCe7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7yQM5Re; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929ADC072AA;
	Sat,  4 May 2024 09:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714815925;
	bh=Dwww0zXWAYAhVa6+ZHGyGIVbKmD1FELsGL3H8q7Pkgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I7yQM5RebNDlT6Ji4Q7kQ0rodapj147DZMJO0e3q9vs4a0FEuuwzvWPCeddos+jb9
	 CMNS7PyASVi4/B/fiubslZEeZZJy44l05u+sxZIBXI8dvkZq7Wzo0+MKNOVEhmpFal
	 IZkRZpPa+Cz+0zGE7fbC++oIe4AkNyulf6VtYEcuc6kNac7VAVk5h7LwqK7TxOJWNz
	 xniytCEoIc/KtfMmTtk+LvUErYfMRX4Av8+/MuRhmC/+ULLcIVK5ki98Cyeclwo5qO
	 kkMzZfvlouzWohIe35FPZb402zKrXCRi1lo8cFgU6LmSW7o5cdzl9BSLwqyNZhG+Sc
	 qoXDeZj1LZW+A==
Date: Sat, 4 May 2024 11:45:18 +0200
From: Christian Brauner <brauner@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>, 
	axboe@kernel.dk, io-uring@vger.kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Sumit Semwal <sumit.semwal@linaro.org>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	Laura Abbott <laura@labbott.name>
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?]
 [io-uring?] general protection fault in __ep_remove)
Message-ID: <20240504-probanden-wahrsagung-f82cddd37718@brauner>
References: <0000000000002d631f0615918f1e@google.com>
 <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202405031110.6F47982593@keescook>

On Fri, May 03, 2024 at 11:26:32AM -0700, Kees Cook wrote:
> On Fri, May 03, 2024 at 06:54:22PM +0700, Bui Quang Minh wrote:
> > [...]
> > Root cause:
> > AFAIK, eventpoll (epoll) does not increase the registered file's reference.
> > To ensure the safety, when the registered file is deallocated in __fput,
> > eventpoll_release is called to unregister the file from epoll. When calling
> > poll on epoll, epoll will loop through registered files and call vfs_poll on
> > these files. In the file's poll, file is guaranteed to be alive, however, as
> > epoll does not increase the registered file's reference, the file may be
> > dying
> > and it's not safe the get the file for later use. And dma_buf_poll violates
> > this. In the dma_buf_poll, it tries to get_file to use in the callback. This
> > leads to a race where the dmabuf->file can be fput twice.
> > 
> > Here is the race occurs in the above proof-of-concept
> > 
> > close(dmabuf->file)
> > __fput_sync (f_count == 1, last ref)
> > f_count-- (f_count == 0 now)
> > __fput
> >                                     epoll_wait
> >                                     vfs_poll(dmabuf->file)
> >                                     get_file(dmabuf->file)(f_count == 1)
> > eventpoll_release
> > dmabuf->file deallocation
> >                                     fput(dmabuf->file) (f_count == 1)
> >                                     f_count--
> >                                     dmabuf->file deallocation
> > 
> > I am not familiar with the dma_buf so I don't know the proper fix for the
> > issue. About the rule that don't get the file for later use in poll callback
> > of
> > file, I wonder if it is there when only select/poll exist or just after
> > epoll
> > appears.
> > 
> > I hope the analysis helps us to fix the issue.
> 
> Thanks for doing this analysis! I suspect at least a start of a fix
> would be this:
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 8fe5aa67b167..15e8f74ee0f2 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -267,9 +267,8 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
>  
>  		if (events & EPOLLOUT) {
>  			/* Paired with fput in dma_buf_poll_cb */
> -			get_file(dmabuf->file);
> -
> -			if (!dma_buf_poll_add_cb(resv, true, dcb))
> +			if (!atomic_long_inc_not_zero(&dmabuf->file) &&
> +			    !dma_buf_poll_add_cb(resv, true, dcb))
>  				/* No callback queued, wake up any other waiters */
>  				dma_buf_poll_cb(NULL, &dcb->cb);
>  			else
> @@ -290,9 +289,8 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
>  
>  		if (events & EPOLLIN) {
>  			/* Paired with fput in dma_buf_poll_cb */
> -			get_file(dmabuf->file);
> -
> -			if (!dma_buf_poll_add_cb(resv, false, dcb))
> +			if (!atomic_long_inc_not_zero(&dmabuf->file) &&
> +			    !dma_buf_poll_add_cb(resv, false, dcb))
>  				/* No callback queued, wake up any other waiters */
>  				dma_buf_poll_cb(NULL, &dcb->cb);
>  			else
> 
> 
> But this ends up leaving "active" non-zero, and at close time it runs
> into:
> 
>         BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
> 
> But the bottom line is that get_file() is unsafe to use in some places,
> one of which appears to be in the poll handler. There are maybe some
> other fragile places too, like in drivers/gpu/drm/vmwgfx/ttm_object.c:
> 
> static bool __must_check get_dma_buf_unless_doomed(struct dma_buf *dmabuf)
> {
> 	return atomic_long_inc_not_zero(&dmabuf->file->f_count) != 0L;
> }
> 
> Which I also note involves a dmabuf...
> 
> Due to this issue I've proposed fixing get_file() to detect pathological states:
> https://lore.kernel.org/lkml/20240502222252.work.690-kees@kernel.org/
> 
> But that has run into some push-back. I'm hoping that seeing this epoll
> example will help illustrate what needs fixing a little better.
> 
> I think the best current proposal is to just WARN sooner instead of a
> full refcount_t implementation:
> 
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8dfd53b52744..e09107d0a3d6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1040,7 +1040,8 @@ struct file_handle {
>  
>  static inline struct file *get_file(struct file *f)
>  {
> -	atomic_long_inc(&f->f_count);
> +	long prior = atomic_long_fetch_inc_relaxed(&f->f_count);
> +	WARN_ONCE(!prior, "struct file::f_count incremented from zero; use-after-free condition present!\n");
>  	return f;
>  }
>  
> 
> 
> What's the right way to deal with the dmabuf situation? (And I suspect
> it applies to get_dma_buf_unless_doomed() as well...)

No, it doesn't. That's safe afaict as I've explained at lenght in
the other thread.

