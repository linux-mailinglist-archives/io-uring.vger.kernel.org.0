Return-Path: <io-uring+bounces-1719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FBD8BB46F
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 22:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23842B20B66
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 20:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E767158D6E;
	Fri,  3 May 2024 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="b3im61za"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93B7158D62
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 19:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714766396; cv=none; b=N0TIWXbxB0eJ4mqKa4cRIESeQc1W503zB3gX625PjctZxMPcyirYwsc1Iv0VJdCpo7Q8jP3xCT0te1L7dri9Pe1JdoCFkKz+pT2+LshtDaI3bO9x+PRPsKnot2p8MWeOJoE8u1rE12Wc6yth7Nig8gwx8VmYgF7IVd+20sdYrHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714766396; c=relaxed/simple;
	bh=beW2GRBusmoKiQrMjaKiQjjBpA89CRgNEN6X1/xF3ns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PaDwInTQv93XwSjyNCJbTjk3ttQkDtCLz9QB2lArKAvabEc0LpsOPBK3gStcIPjcXF5LeuB9jfCkwKLcJUA7P1NWayaWtw11Yz214fwGveSpAL4yebYAAbnAmav1+dLLPAq3DF3jrfTFtF0oUR6uLl04RQdJb0NGUw0fdOhD0Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=b3im61za; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ed41eb3382so388245ad.0
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 12:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714766394; x=1715371194; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kXbuS/Hft89FN1tBWD1yXoLgj43aVjsF859uRSyCcO8=;
        b=b3im61zadIpLdYujeNcd402k760wCKJlgp5Z4gp5IuPQRgxicPEVayx5/K9nRO8la0
         NheO2zb4JRXkL7gAxEcZyZNdGNaHsiHbLRmhpZWpMzQFBMbvq4kTFUDqL684mIK15WIK
         O8BvDXW1eGqkwDCn+evRLRFiGhxw8o9k/E/6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714766394; x=1715371194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kXbuS/Hft89FN1tBWD1yXoLgj43aVjsF859uRSyCcO8=;
        b=BFQCXPna8nfbhlZf/FumQ07a/mvHKLd8DjWQbWeF+AMxofc2JQ+bqCfSry7V84GP9S
         M4ItQ7JUj9Ej8h9UNooHIshlbBxxLUdEebvVhfQ3WX10BqknJf71GhWl+otRQda7M5d+
         AIn9f0eVvn8KBAYh0TFkeARlN2P0iIwuB9bJnIeDJPe/5pHJ6C33g1JLXm48L8EzL1sP
         SSzgTobHiuehdwodH4PIEtg25mRfjz32KeVU3TGB+Kqng57YS47UQ50yEhv5hWXOmDMf
         2Rp0LG06xn3z6jn1NQ6kzz7KXWVHQXwIJhRllJtoWAU1UU/uA2Y9ZQnVjiQ/MZnMVykC
         UATA==
X-Forwarded-Encrypted: i=1; AJvYcCU/EsqPnsK63qNaP933TJukH/+SRDqjytsNHLyf2WpbWX4UxFSkIEX2UeptQVTi4unWpBSqUHZd+v61UZilJyZfhlu8XCTCqCQ=
X-Gm-Message-State: AOJu0YwOwlHVGi73u6xv+/R6tNlhK6nqLrbGcn5C2BHHS2YGrlkyPrcr
	bFx+nYYqMKGwCfxxpwCPpMiFejjFWF+n3jU43FlvHzeAahRu1Mp3nLWPRUMcndsPWK/isUS2fhg
	=
X-Google-Smtp-Source: AGHT+IF7CJaHehS47rwSXtmiD/0Qq2/Az5cGhZ/XA6S28lF8JjtukRtodBuIYdyT740U/+9Oz5YhZA==
X-Received: by 2002:a17:902:d58d:b0:1eb:d79a:c111 with SMTP id k13-20020a170902d58d00b001ebd79ac111mr5316118plh.4.1714766394020;
        Fri, 03 May 2024 12:59:54 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j12-20020a170903024c00b001eb51a46f5bsm3651440plh.43.2024.05.03.12.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 12:59:52 -0700 (PDT)
Date: Fri, 3 May 2024 12:59:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
	io-uring@vger.kernel.org, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?]
 [io-uring?] general protection fault in __ep_remove)
Message-ID: <202405031237.B6B8379@keescook>
References: <0000000000002d631f0615918f1e@google.com>
 <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook>
 <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook>
 <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>

On Fri, May 03, 2024 at 01:35:09PM -0600, Jens Axboe wrote:
> On 5/3/24 1:22 PM, Kees Cook wrote:
> > On Fri, May 03, 2024 at 12:49:11PM -0600, Jens Axboe wrote:
> >> On 5/3/24 12:26 PM, Kees Cook wrote:
> >>> Thanks for doing this analysis! I suspect at least a start of a fix
> >>> would be this:
> >>>
> >>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> >>> index 8fe5aa67b167..15e8f74ee0f2 100644
> >>> --- a/drivers/dma-buf/dma-buf.c
> >>> +++ b/drivers/dma-buf/dma-buf.c
> >>> @@ -267,9 +267,8 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
> >>>  
> >>>  		if (events & EPOLLOUT) {
> >>>  			/* Paired with fput in dma_buf_poll_cb */
> >>> -			get_file(dmabuf->file);
> >>> -
> >>> -			if (!dma_buf_poll_add_cb(resv, true, dcb))
> >>> +			if (!atomic_long_inc_not_zero(&dmabuf->file) &&
> >>> +			    !dma_buf_poll_add_cb(resv, true, dcb))
> >>>  				/* No callback queued, wake up any other waiters */
> >>
> >> Don't think this is sane at all. I'm assuming you meant:
> >>
> >> 	atomic_long_inc_not_zero(&dmabuf->file->f_count);
> > 
> > Oops, yes, sorry. I was typed from memory instead of copy/paste.
> 
> Figured :-)
> 
> >> but won't fly as you're not under RCU in the first place. And what
> >> protects it from being long gone before you attempt this anyway? This is
> >> sane way to attempt to fix it, it's completely opposite of what sane ref
> >> handling should look like.
> >>
> >> Not sure what the best fix is here, seems like dma-buf should hold an
> >> actual reference to the file upfront rather than just stash a pointer
> >> and then later _hope_ that it can just grab a reference. That seems
> >> pretty horrible, and the real source of the issue.
> > 
> > AFAICT, epoll just doesn't hold any references at all. It depends,
> > I think, on eventpoll_release() (really eventpoll_release_file())
> > synchronizing with epoll_wait() (but I don't see how this happens, and
> > the race seems to be against ep_item_poll() ...?)
> >
> > I'm really confused about how eventpoll manages the lifetime of polled
> > fds.
> 
> epoll doesn't hold any references, and it's got some ugly callback to
> deal with that. It's not ideal, nor pretty, but that's how it currently
> works. See eventpoll_release() and how it's called. This means that
> epoll itself is supposedly safe from the file going away, even though it
> doesn't hold a reference to it.

Right -- what remains unclear to me is how struct file lifetime is
expected to work in the struct file_operations::poll callbacks. Because
using get_file() there looks clearly unsafe...

> Except that in this case, the file is already gone by the time
> eventpoll_release() is called. Which presumably is some interaction with
> the somewhat suspicious file reference management that dma-buf is doing.
> But I didn't look into that much, outside of noting it looks a bit
> suspect.

Not yet, though. Here's (one) race state from the analysis. I added lines
for the dma_fence_add_callback()/dma_buf_poll_cb() case, since that's
the case that would escape any eventpoll_release/epoll_wait
synchronization (if it exists?):

close(dmabuf->file)
__fput_sync (f_count == 1, last ref)
f_count-- (f_count == 0 now)
__fput
                                     epoll_wait
                                     vfs_poll(dmabuf->file)
                                     get_file(dmabuf->file)(f_count == 1)
                                     dma_fence_add_callback()
eventpoll_release
dmabuf->file deallocation
                                     dma_buf_poll_cb()
                                     fput(dmabuf->file) (f_count == 1)
                                     f_count--
                                     dmabuf->file deallocation

Without fences to create a background callback, we just do a double-free:

close(dmabuf->file)
__fput_sync (f_count == 1, last ref)
f_count-- (f_count == 0 now)
__fput
                                     epoll_wait
                                     vfs_poll(dmabuf->file)
                                     get_file(dmabuf->file)(f_count == 1)
                                     dma_buf_poll_cb()
                                     fput(dmabuf->file) (f_count == 1)
                                     f_count--
                                     eventpoll_release
                                     dmabuf->file deallocation
eventpoll_release
dmabuf->file deallocation


get_file(), via epoll_wait()->vfs_poll()->dma_buf_poll(), has raised
f_count again. Then eventpoll_release() is doing things to remove
dmabuf->file from the eventpoll lists, but I *think* this is synchronized
so that an epoll_wait() will only call .poll handlers with a valid
(though possibly f_count==0) file, but I can't figure out where that
happens. (If it's not happening, we have a much bigger problem, but I
imagine we'd see massive corruption all the time, which we don't.)

So, yeah, I can't figure out how eventpoll_release() and epoll_wait()
are expected to behave safely for .poll handlers.

Regardless, for the simple case: it seems like it's just totally illegal
to use get_file() in a poll handler. Is this known/expected? And if so,
how can dmabuf possibly deal with that?

-- 
Kees Cook

