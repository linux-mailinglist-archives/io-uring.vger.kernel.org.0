Return-Path: <io-uring+bounces-1833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 014F18C0147
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 17:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F3381F21F46
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 15:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A9B127E37;
	Wed,  8 May 2024 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="dYcN+kxw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD81E82D6D
	for <io-uring@vger.kernel.org>; Wed,  8 May 2024 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715183143; cv=none; b=NyTYKH/+QyF/BTqKPLGMcyz6s849DzZKrqNCZw44/Hk471CXqypmr8uXqChO9x7Oaas8K/WQgJgVwQMxmxC0KQlYJgyBKa0L3+pX8I4amzZ1OD7UVPJQ6L3ODVKyx/WECVCgZET7yHgWCBsqU3RHIFeKltyLJbqq1j+/2Jb8Ouc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715183143; c=relaxed/simple;
	bh=Y3tAYnJhvWIsSCmSdE6nAn4Ex+kbs5Wn07R+879JUgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMtp+cX+YoWKiAeQoxZ5m7XWNFgK7AqS4n6J8sinKuLKteUWoig5OfuL6y38b2g7O0JsRDDbWeMNMTqmfCSBZLaXK9tE9ngdeT7y4hmUwSpySvEuBk9V8LKWhQmccPdMftKdFx6G9nFh3q613X8zSrJOJDryBOB+fGlTl2RiCB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=dYcN+kxw; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52037782978so113853e87.3
        for <io-uring@vger.kernel.org>; Wed, 08 May 2024 08:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1715183140; x=1715787940; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zQT930nNUV1vsHVoX3P+3mBNNldXqcqQMqEjZfBnVWc=;
        b=dYcN+kxwyl/LDgV8q+OrMUejOE3sF4If55u6Q4DDQuO14gEOV55VGR/v3fLGfCE3rl
         lw2rtPdcATyCKO5vaNaFY08OhDf16opdJ+PsszPFheeppq49YFnXbBqayOigcfrNHsFH
         s/B6i7hj0yh0wRUjuBjMjimgYxE6AmkVgfGFc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715183140; x=1715787940;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zQT930nNUV1vsHVoX3P+3mBNNldXqcqQMqEjZfBnVWc=;
        b=kD0i5WF1VLs4TZdILloB7c5FcTLI9eUFo8mDZi0rSQ9grgJuHva0Cv6hdMB8Mc4s3T
         XBXeg6KKFeIQ7lyPu+7+JEQQM5pKqwH4enNqRMs/RBuqMBfLKMSLw+j8lBxmjrdA7517
         4JXEi8JYCD+G3qyFXaVr8OxiEKeQxNG/C6GadjLVXLkYKa/Kz3ymYglsyKd9eJqpBYAN
         aYBvkn8CP88V1UEMG5ZLvMDVU1H6iUmIk4S6r9ZMC5XWhnxc2pjK4O8i0ZZNatGNAwcS
         +EX9TV/3CcXwfS2YfG3/6/OceG+muHbTfhwFf2uXvOXeVhZNsA6z99+UVYwh/JOYzSI+
         T9Og==
X-Forwarded-Encrypted: i=1; AJvYcCU+OXlCytkUmTcd9FaROcIDxfII49L27AcBfV8HfZbe57Sa61bnRLYKoxWHTlCeCMN3U1uopk8oHApESTYrnaKJGutCeL7JSbY=
X-Gm-Message-State: AOJu0Yx1sLkaEY431t0IByPCSj/B7Sil0C4QcQ0nAjDsuA8UkkhuVpn4
	CMZbkJFqEzG776ghBNqH+KFgu93CT2yFx26dAB/EfwyCjw4iqjHIhZdURTHAVyE=
X-Google-Smtp-Source: AGHT+IElEidDiVjInarsAR7F2JpjTofgrb5PfDM8hUsyo09wsdL7lGXij8WK5Ptcrp9hokZm7DJwxg==
X-Received: by 2002:ac2:5b84:0:b0:51f:6d6d:57b with SMTP id 2adb3069b0e04-5217d6346e2mr2041007e87.6.1715183139855;
        Wed, 08 May 2024 08:45:39 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id cq27-20020a056402221b00b005727eb1ed6asm7672318edb.68.2024.05.08.08.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 08:45:39 -0700 (PDT)
Date: Wed, 8 May 2024 17:45:37 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian Brauner <brauner@kernel.org>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <ckoenig.leichtzumerken@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org,
	axboe@kernel.dk, christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
	jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better
 about file lifetimes
Message-ID: <ZjueITUy0K8TP1WO@phenom.ffwll.local>
Mail-Followup-To: Christian Brauner <brauner@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <ckoenig.leichtzumerken@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org,
	axboe@kernel.dk, christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
	jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <20240508-risse-fehlpass-895202f594fd@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240508-risse-fehlpass-895202f594fd@brauner>
X-Operating-System: Linux phenom 6.6.15-amd64 

On Wed, May 08, 2024 at 12:08:57PM +0200, Christian Brauner wrote:
> On Mon, May 06, 2024 at 04:29:44PM +0200, Christian König wrote:
> > Am 04.05.24 um 20:20 schrieb Linus Torvalds:
> > > On Sat, 4 May 2024 at 08:32, Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > > Lookie here, the fundamental issue is that epoll can call '->poll()'
> > > > on a file descriptor that is being closed concurrently.
> > > Thinking some more about this, and replying to myself...
> > > 
> > > Actually, I wonder if we could *really* fix this by simply moving the
> > > eventpoll_release() to where it really belongs.
> > > 
> > > If we did it in file_close_fd_locked(),  it would actually make a
> > > *lot* more sense. Particularly since eventpoll actually uses this:
> > > 
> > >      struct epoll_filefd {
> > >          struct file *file;
> > >          int fd;
> > >      } __packed;
> > > 
> > > ie it doesn't just use the 'struct file *', it uses the 'fd' itself
> > > (for ep_find()).
> > > 
> > > (Strictly speaking, it should also have a pointer to the 'struct
> > > files_struct' to make the 'int fd' be meaningful).
> > 
> > While I completely agree on this I unfortunately have to ruin the idea.
> > 
> > Before we had KCMP some people relied on the strange behavior of eventpoll
> > to compare struct files when the fd is the same.
> > 
> > I just recently suggested that solution to somebody at AMD as a workaround
> > when KCMP is disabled because of security hardening and I'm pretty sure I've
> > seen it somewhere else as well.
> > 
> > So when we change that it would break (undocumented?) UAPI behavior.
> 
> I've worked on that a bit yesterday and I learned new things about epoll
> and ran into some limitations.
> 
> Like, what happens if process P1 has a file descriptor registered in an
> epoll instance and now P1 forks and creates P2. So every file that P1
> maintains gets copied into a new file descriptor table for P2. And the
> same file descriptors refer to the same files for both P1 and P2.

So this is pretty similar to any other struct file that has resources
hanging off the struct file instead of the underlying inode. Like drm
chardev files, where all the buffers, gpu contexts and everything else
hangs off the file and there's no other way to get at them (except when
exporting to some explicitly meant-for-sharing file like dma-buf).

If you fork() that it's utter hilarity, which is why absolutely everyone
should set O_CLOEXEC on these. Or EPOLL_CLOEXEC for epoll_create.

For the uapi issue you describe below my take would be that we should just
try, and hope that everyone's been dutifully using O_CLOEXEC. But maybe
I'm biased from the gpu world, where we've been hammering it in that
"O_CLOEXEC or bust" mantra since well over a decade. Really the only valid
use-case is something like systemd handing open files to a service, where
it drops priviledges even well before the exec() call. But we can't switch
around the defaults for any of these special open files with anything more
than just a current seek position as state, since that breaks uapi.
-Sima

> 
> So there's two interesting cases here:
> 
> (1) P2 explicitly removes the file descriptor from the epoll instance
>     via epoll_ctl(EPOLL_CTL_DEL). That removal affects both P1 and P2
>     since the <fd, file> pair is only registered once and it isn't
>     marked whether it belongs to P1 and P2 fdtable.
> 
>     So effectively fork()ing with epoll creates a weird shared state
>     where removal of file descriptors that were registered before the
>     fork() affects both child and parent.
> 
>     I found that surprising even though I've worked with epoll quite
>     extensively in low-level userspace.
> 
> (2) P2 doesn't close it's file descriptors. It just exits. Since removal
>     of the file descriptor from the epoll instance isn't done during
>     close() but during last fput() P1's epoll state remains unaffected
>     by P2's sloppy exit because P1 still holds references to all files
>     in its fdtable.
> 
>     (Sidenote, if one ends up adding every more duped-fds into epoll
>     instance that one doesn't explicitly close and all of them refer to
>     the same file wouldn't one just be allocating new epitems that
>     are kept around for a really long time?)
> 
> So if the removal of the fd would now be done during close() or during
> exit_files() when we call close_files() and since there's currently no
> way of differentiating whether P1 or P2 own that fd it would mean that
> (2) collapses into (1) and we'd always alter (1)'s epoll state. That
> would be a UAPI break.
> 
> So say we record the fdtable to get ownership of that file descriptor so
> P2 doesn't close anything in (2) that really belongs to P1 to fix that
> problem.
> 
> But afaict, that would break another possible use-case. Namely, where P1
> creates an epoll instance and registeres fds and then fork()s to create
> P2. Now P1 can exit and P2 takes over the epoll loop of P1. This
> wouldn't work anymore because P1 would deregister all fds it owns in
> that epoll instance during exit. I didn't see an immediate nice way of
> fixing that issue.
> 
> But note that taking over an epoll loop from the parent doesn't work
> reliably for some file descriptors. Consider man signalfd(2):
> 
>    epoll(7) semantics
>        If a process adds (via epoll_ctl(2)) a signalfd file descriptor to an epoll(7) instance,
>        then epoll_wait(2) returns events only for signals sent to that process.  In particular,
>        if  the process then uses fork(2) to create a child process, then the child will be able
>        to read(2) signals that  are  sent  to  it  using  the  signalfd  file  descriptor,  but
>        epoll_wait(2)  will  not  indicate  that the signalfd file descriptor is ready.  In this
>        scenario, a possible workaround is that after the fork(2), the child process  can  close
>        the  signalfd  file descriptor that it inherited from the parent process and then create
>        another signalfd file descriptor and add it to the epoll instance.   Alternatively,  the
>        parent and the child could delay creating their (separate) signalfd file descriptors and
>        adding them to the epoll instance until after the call to fork(2).
> 
> So effectively P1 opens a signalfd and registers it in an epoll
> instance. Then it fork()s and creates P2. Now both P1 and P2 call
> epoll_wait(). Since signalfds are always relative to the caller and P1
> did call signalfd_poll() to register the callback only P1 can get
> events. So P2 can't take over signalfds in that epoll loop.
> 
> Honestly, the inheritance semantics of epoll across fork() seem pretty
> wonky and it would've been better if an epoll fd inherited across
> would've returned ESTALE or EINVAL or something. And if that inheritance
> of epoll instances would really be a big use-case there'd be some
> explicit way to enable this.

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

