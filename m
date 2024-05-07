Return-Path: <io-uring+bounces-1799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 340548BE086
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 12:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50762B2151C
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 10:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 360B6152170;
	Tue,  7 May 2024 10:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="Qt/CLGYh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6178153811
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 10:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715079501; cv=none; b=tN2jyJl/ZX3PyDwrbv8Udu0xJNAgE2fdjPsyaGU391Th1VGY+bsxRi6l04vHgbXBsjXDoOgDsxO8avUjXN8YHjWlti47EOkBwp+dZ44vjETQMKug1vB7Sn4ZTaPQ9GVLuemu6TE0ndcP0VYS+K66z06H9gxKVXIgeNYXEwYR61s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715079501; c=relaxed/simple;
	bh=HQQCU2SqHpn7oarMB8sAK46Z9lpLwcJtTOH+NSAWM+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=daCv6p0eWpUhBAGHYIVCEcOI1SyclvvfCZ8o247Bww4D9uMiIE8S10ImUCbiorhYo0nAbYhZTmt4wNEKnB9bTLdIaNmJjqAo30nqGmSAsYlg1QFDB7oqaVyDClmt0ZH14W21xEPnATJhhwAe01jeI1pzw/m2OLiR4FVh3sq5J1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=Qt/CLGYh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-41c26dcc3ecso4037875e9.2
        for <io-uring@vger.kernel.org>; Tue, 07 May 2024 03:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1715079497; x=1715684297; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ViRc7GAJZffBJpcUFJE5upGd7xOjgKlPDNKALV639RY=;
        b=Qt/CLGYhMHja3Z3BsMvCu5iffoxXDgiITJ0JOohuYDaJ4AM/YaRKd2q5AVG8AVgP8r
         PFfpZYrRPIkWAvU4irBlp5N1il0NlVoKEE9Z/x401EJhdKy1DtgKci1VeqZFtBMTn28C
         qQ3I3LCGj9gNyNmFvBosclttGSMpYp2u3WJwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715079497; x=1715684297;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ViRc7GAJZffBJpcUFJE5upGd7xOjgKlPDNKALV639RY=;
        b=J4jVogftD/CrCV8N2Gi11gH0q+CSp0vhJkiNHDcezlK68XAeLIBIHAlLkQi3DHm65/
         YSzh5XYRgtN8shlivfh82FyEF6ISTouig8vULNNu/Kay9wFNi8JTJxt1FzqIVEsamOmt
         9UQHUv9RriJJygOOg250uhsu6IevwiKPG+ya96wkkSazcZp5X+70pmkIATioWevRxOTi
         ouJgAEBAP4BLH4uBew4Hfj+DjTOqFyMb83fHlP8o4Gox7S1uv0HDfjIUQ4RPJvo5cjc3
         c8bDN/C66FahGLvec0NfLD+Eg1vurXtcbC0+RgkT1mM51lB5J3jVZx+qLNstuTi3Go5w
         ypkg==
X-Forwarded-Encrypted: i=1; AJvYcCUNGkiCQVWy4rwsQeeiu1uJLrFdS8wRKVy9dKK5uhDGwiJK47PGG7fZaj2owhOpRSzwp7J5JLvFt7AMuSGtp5atktZ7cJurPuM=
X-Gm-Message-State: AOJu0YxAu0qzpfQMGzu7HzfzFkyKuz9A+GqrueDY+sxQBmhXe9xstuGU
	xelCnBF0ms5XMUu/p+tucxjYNldNH05ZFpEbHI9zQdUB5OBUCY/8byi1NjzCRBw=
X-Google-Smtp-Source: AGHT+IGmmpohUZWli41FI/bjCKJyuoxp80jtwfSXh1Ej1JbzBOZ7sdqvyBNDvL8g4N9bnXZUMYG4Hg==
X-Received: by 2002:a05:600c:3b21:b0:419:f0a8:9801 with SMTP id m33-20020a05600c3b2100b00419f0a89801mr10223677wms.0.1715079497175;
        Tue, 07 May 2024 03:58:17 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id j15-20020a05600c190f00b0041bf512f85bsm22775381wmq.14.2024.05.07.03.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 03:58:16 -0700 (PDT)
Date: Tue, 7 May 2024 12:58:14 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian Brauner <brauner@kernel.org>
Cc: Daniel Vetter <daniel@ffwll.ch>,
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
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <ZjoJRs0Svrb9ELDu@phenom.ffwll.local>
Mail-Followup-To: Christian Brauner <brauner@kernel.org>,
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
References: <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <CAHk-=whrSSNYVzTHNFDNGag_xcKuv=RaQUX8+n29kkic39DRuQ@mail.gmail.com>
 <20240505194603.GH2118490@ZenIV>
 <CAHk-=wipanX2KYbWvO5=5Zv9O3r8kA-tqBid0g3mLTCt_wt8OA@mail.gmail.com>
 <20240505203052.GJ2118490@ZenIV>
 <CAHk-=whFg8-WyMbVUGW5c0baurGzqmRtzFLoU-gxtRXq2nVZ+w@mail.gmail.com>
 <ZjjRWybmAmClMMI9@phenom.ffwll.local>
 <20240506-zweisamkeit-zinsniveau-615a2e6d7c67@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506-zweisamkeit-zinsniveau-615a2e6d7c67@brauner>
X-Operating-System: Linux phenom 6.6.15-amd64 

On Mon, May 06, 2024 at 04:46:54PM +0200, Christian Brauner wrote:
> On Mon, May 06, 2024 at 02:47:23PM +0200, Daniel Vetter wrote:
> > On Sun, May 05, 2024 at 01:53:48PM -0700, Linus Torvalds wrote:
> > > On Sun, 5 May 2024 at 13:30, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > >
> > > > 0.      special-cased ->f_count rule for ->poll() is a wart and it's
> > > > better to get rid of it.
> > > >
> > > > 1.      fs/eventpoll.c is a steaming pile of shit and I'd be glad to see
> > > > git rm taken to it.  Short of that, by all means, let's grab reference
> > > > in there around the call of vfs_poll() (see (0)).
> > > 
> > > Agreed on 0/1.
> > > 
> > > > 2.      having ->poll() instances grab extra references to file passed
> > > > to them is not something that should be encouraged; there's a plenty
> > > > of potential problems, and "caller has it pinned, so we are fine with
> > > > grabbing extra refs" is nowhere near enough to eliminate those.
> > > 
> > > So it's not clear why you hate it so much, since those extra
> > > references are totally normal in all the other VFS paths.
> > > 
> > > I mean, they are perhaps not the *common* case, but we have a lot of
> > > random get_file() calls sprinkled around in various places when you
> > > end up passing a file descriptor off to some asynchronous operation
> > > thing.
> > > 
> > > Yeah, I think most of them tend to be special operations (eg the tty
> > > TIOCCONS ioctl to redirect the console), but it's not like vfs_ioctl()
> > > is *that* different from vfs_poll. Different operation, not somehow
> > > "one is more special than the other".
> > > 
> > > cachefiles and backing-file does it for regular IO, and drop it at IO
> > > completion - not that different from what dma-buf does. It's in
> > > ->read_iter() rather than ->poll(), but again: different operations,
> > > but not "one of them is somehow fundamentally different".
> > > 
> > > > 3.      dma-buf uses of get_file() are probably safe (epoll shite aside),
> > > > but they do look fishy.  That has nothing to do with epoll.
> > > 
> > > Now, what dma-buf basically seems to do is to avoid ref-counting its
> > > own fundamental data structure, and replaces that by refcounting the
> > > 'struct file' that *points* to it instead.
> > > 
> > > And it is a bit odd, but it actually makes some amount of sense,
> > > because then what it passes around is that file pointer (and it allows
> > > passing it around from user space *as* that file).
> > > 
> > > And honestly, if you look at why it then needs to add its refcount to
> > > it all, it actually makes sense.  dma-bufs have this notion of
> > > "fences" that are basically completion points for the asynchronous
> > > DMA. Doing a "poll()" operation will add a note to the fence to get
> > > that wakeup when it's done.
> > > 
> > > And yes, logically it takes a ref to the "struct dma_buf", but because
> > > of how the lifetime of the dma_buf is associated with the lifetime of
> > > the 'struct file', that then turns into taking a ref on the file.
> > > 
> > > Unusual? Yes. But not illogical. Not obviously broken. Tying the
> > > lifetime of the dma_buf to the lifetime of a file that is passed along
> > > makes _sense_ for that use.
> > > 
> > > I'm sure dma-bufs could add another level of refcounting on the
> > > 'struct dma_buf' itself, and not make it be 1:1 with the file, but
> > > it's not clear to me what the advantage would really be, or why it
> > > would be wrong to re-use a refcount that is already there.
> > 
> > So there is generally another refcount, because dma_buf is just the
> > cross-driver interface to some kind of real underlying buffer object from
> > the various graphics related subsystems we have.
> > 
> > And since it's a pure file based api thing that ceases to serve any
> > function once the fd/file is gone we tied all the dma_buf refcounting to
> > the refcount struct file already maintains. But the underlying buffer
> > object can easily outlive the dma_buf, and over the lifetime of an
> > underlying buffer object you might actually end up creating different
> > dma_buf api wrappers for it (but at least in drm we guarantee there's at
> > most one, hence why vmwgfx does the atomic_inc_unless_zero trick, which I
> > don't particularly like and isn't really needed).
> > 
> > But we could add another refcount, it just means we have 3 of those then
> > when only really 2 are needed.
> 
> Fwiw, the TTM thing described upthread and in the other thread really
> tries hard to work around the dma_buf == file lifetime choice by hooking
> into the dma-buf specific release function so it can access the dmabuf
> and then the file. All that seems like a pretty error prone thing to me.
> So a separate refcount for dma_buf wouldn't be the worst as that would
> allow that TTM thing to benefit and remove that nasty hacking into your
> generic dma_buf ops. But maybe I'm the only one who sees it that way and
> I'm certainly not familiar enough with dma-buf.

So the tricky part is the uniqueness requirement drm has for buffer
objects (and hence dma_buf wrappers), which together with the refcounting
makes dma_buf quite tricky:

- dma_buf needs to hold some reference onto the underlying object, or it
  wont work

- but you're not allowed to just create a new dma_buf every time someone
  exports an underlying object to a dma_buf, because that would break the
  uniqueness requirement. Which means the underlying object must also hold
  some kind of reference to its dma_buf, if it exists. So that on buffer
  export it can just increment the refcount for that and return it,
  instead of creating a new one.

Which would be a reference loop that never gets freed, so you need one of
two tricks:

- Either a weak reference, i.e. just a pointer plus
  atomic_inc_unless_zero trickery like ttm does. Splitting that refcount
  into more refcounts doesn't fundamentally solve the problem, it just
  adds even more refcounts.

- Or you do what all other drm drivers do in drm_prime.c do and careful
  clean up the dma_buf re-export cache when the userspace references (but
  not all kernel internal ones) disappear, to unbreak that reference loop.
  This needs to be done with extreme care and took a lot of screaming to
  get right, because if you have a race you might end up breaking the
  uniqueness requirement and have two dma_buf floating around.

So neither of these solutions really are simple, but I agree with you that
the atomic_inc_unless_zero trickery is less simple. It's definitely not
cool that it's done by digging around in struct file internals.
-Sima
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

