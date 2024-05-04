Return-Path: <io-uring+bounces-1747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9118BBA4D
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 11:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFF66B21336
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 09:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F1211C83;
	Sat,  4 May 2024 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uMavHk//"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB315221;
	Sat,  4 May 2024 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714815458; cv=none; b=ZhDE/acWuc9YzLR0FpIauf0YtgwjwU2zS5OdNLnVO0aMBOsVd9styMdgtynPrro4ZlEnPjcpatzK6/FALw9RUzuOUm3Rh42XAvF0iaFAx4FYz6ua97d49HkqkW8DRcXYDGGRTo3JOL5LE66jTG7h3SJ3wa9KwMr7XymSUYg+3qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714815458; c=relaxed/simple;
	bh=iBRxGQJjRoROFxKq58LLxfgM50Q+YDQejQATifgx5Mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRBAYuHAzvS9zoPgNbI4V1erLg+gSjqb6p3iBo1Ut5mrtkxz8ncsrZqQwnQ+k40280FC0m52exyBSBPOinbK2NpSjFi2VBnJV/JP76p7PYlU1bBmUqfT+UMmY/keWzf+4QZ8eQ4AnNRBTrm+9HyRNv9uSXLmpSwHBKwZxweeYhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uMavHk//; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A037C072AA;
	Sat,  4 May 2024 09:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714815458;
	bh=iBRxGQJjRoROFxKq58LLxfgM50Q+YDQejQATifgx5Mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uMavHk//UYBlcW8RF+QF3+ZaD+R7GOT79sK90E6pyBxxoEp742dLivqK3dkPq715a
	 dU8PE7fABkGVbY8i1D8DCAoPk5gogBaWjAaUK707J9DXBS4Oge68+2bgVfN3lyfivp
	 OIS5ZtNlbDvXRdQivUMKYhbZ1F7HohjvG2fS3YqHE11Kl23ulvUw3LELqAfcmZgxE9
	 +IcZDIyYUvoI2NiQZGo+g79bnPNlMYTRFgki6Xyt7dbB3KHA0omA07pvxCT5rFfzTv
	 tWqFqvW309XZ7kIR0csaSLmkTuYfL1c2OLLbOglGYu9QyHzC9UOVwJ7VT0zi5KkgTt
	 fe/wh2z4c+AEQ==
Date: Sat, 4 May 2024 11:37:31 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>

On Fri, May 03, 2024 at 02:33:37PM -0700, Linus Torvalds wrote:
> On Fri, 3 May 2024 at 14:24, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Can we get to ep_item_poll(epi, ...) after eventpoll_release_file()
> > got past __ep_remove()?  Because if we can, we have a worse problem -
> > epi freed under us.
> 
> Look at the hack in __ep_remove(): if it is concurrent with
> eventpoll_release_file(), it will hit this code
> 
>         spin_lock(&file->f_lock);
>         if (epi->dying && !force) {
>                 spin_unlock(&file->f_lock);
>                 return false;
>         }
> 
> and not free the epi.
> 
> But as far as I can tell, almost nothing else cares about the f_lock
> and dying logic.
> 
> And in fact, I don't think doing
> 
>         spin_lock(&file->f_lock);
> 
> is even valid in the places that look up file through "epi->ffd.file",
> because the lock itself is inside the thing that you can't trust until
> you've taken the lock...
> 
> So I agree with Kees about the use of "atomic_dec_not_zero()" kind of
> logic - but it also needs to be in an RCU-readlocked region, I think.

Why isn't it enough to just force dma_buf_poll() to use
get_file_active()? Then that whole problem goes away afaict.

So the fix I had yesterday before I had to step away from the computer
was literally just that [1]. It currently uses two atomic incs
potentially but that can probably be fixed by the dma folks to be
smarter about when they actually need to take a file reference.

> 
> I wish epoll() just took the damn file ref itself. But since it relies
> on the file refcount to release the data structure, that obviously
> can't work.
> 
>                 Linus

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 8fe5aa67b167..7149c45976e1 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -244,13 +244,18 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
        if (!dmabuf || !dmabuf->resv)
                return EPOLLERR;

+       if (!get_file_active(&dmabuf->file))
+               return EPOLLERR;
+
        resv = dmabuf->resv;

        poll_wait(file, &dmabuf->poll, poll);

        events = poll_requested_events(poll) & (EPOLLIN | EPOLLOUT);
-       if (!events)
+       if (!events) {
+               fput(file);
                return 0;
+       }

        dma_resv_lock(resv, NULL);

@@ -268,7 +273,6 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
                if (events & EPOLLOUT) {
                        /* Paired with fput in dma_buf_poll_cb */
                        get_file(dmabuf->file);
-
                        if (!dma_buf_poll_add_cb(resv, true, dcb))
                                /* No callback queued, wake up any other waiters */
                                dma_buf_poll_cb(NULL, &dcb->cb);
@@ -301,6 +305,7 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
        }

        dma_resv_unlock(resv);
+       fput(file);
        return events;
 }

