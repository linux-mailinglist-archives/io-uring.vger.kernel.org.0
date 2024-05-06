Return-Path: <io-uring+bounces-1774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75ACA8BCE54
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 14:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 991A61C21871
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 12:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EEE2744B;
	Mon,  6 May 2024 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="KQu4Z5zN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4AE3B782
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714999649; cv=none; b=rfRMmjVDUON84QXaY5n9LjAEEbG/O4jgxxfb3TV3X6Tsr9YmQBDKRQzhH3LOghkmKEtWkxXdCuUqcKhxo/7gRxZ/q7ZfGKBOeR2XiWoIUHE3ArcF1sh0Oddb5W7HM2n/SZbDovgVoBhKGRQFV/L1zAEXxnoOfVP4RQBqFYGr48Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714999649; c=relaxed/simple;
	bh=WFB++vRNFt5kSLDzQ1XCDy3jGT+hv6nsVwYz20LDtN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6Xj0p+xR8n5ev3lwi4wplGUzSVV3OiNV3/XW9wTn2l1iAeOwFM86b0+SGnJJnrl2WQSUfVBi0TWilcutv/mkdVRtYLEB1l/97oelcUDH0WtFJiwAidw19Sr5vqtTqBgv9hjYD/hRzml/o1WGiOe6Oq6HBjTmXAmemK8+1st3QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=KQu4Z5zN; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-346407b8c9aso628107f8f.0
        for <io-uring@vger.kernel.org>; Mon, 06 May 2024 05:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1714999646; x=1715604446; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FzcPHN6WlIJ1C164IWBqCbC21dWtLB5dXSLGK/0dvq0=;
        b=KQu4Z5zNywDwxFsNiTrA2dANGza8Nnel1ABebzYPju1B1u48vqKbIUn/uH4Hsuy47q
         +sMLWQdp0Lw6ghydYx/bnHaErfAtls1OIzVBxXcpc8D7HX+Jf/ONAZZW9DITmJOf7s60
         EKMIASncpR9mXywaBd9p6NKJldz71jQg/VfBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714999646; x=1715604446;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FzcPHN6WlIJ1C164IWBqCbC21dWtLB5dXSLGK/0dvq0=;
        b=sroRDLXD5D4gGz1PXaANWZ1Ux4cdekUEAUutkSH4ixOrdOHfqGdMeIAAsTeJls6Ry+
         vUU+67DbHd/OQlR4KDyhzNuALXkc4tTBOseivn3s05qHzN0nJWQVzYLQqEihNPQZJq8G
         fL/l2eaBvjiVolHUKUj8wFc+wPRvhkPEJOWTfTEVuBRUy3upy5FV2KMg1+jCZEpkLr6y
         pjR90WzvT4HHgrMT3RtcE/Q1SpG+mN3CQKt9lNmmlDgbgY2eDLemN6h9CR/GDfDMtocR
         cNxjtb1Z/Qzb3gFycpLervQ9nshacjqjTSiBmntB+xTewj9lHMKe6Y8Cy9ThQmIyp4qL
         0aNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsOUb29UVn2uUEc3N8LP/qQg+cmIW56o8WdHzwyjgkEkHBWw8XIpsv5E008Wj1SpKbantRsPDrAY6feEPDN3gu/SSwBDAWKlY=
X-Gm-Message-State: AOJu0YwpI+ns4xOFkabseJtmqO24382EfGHLChT12sputchCJYHYOOnL
	Jz+Oe0V4ArJ5Quu4WKQYYMNZLbwjU8lY9QM3Ix5qXFWJAATQfPHuo8NlEyOqpD8=
X-Google-Smtp-Source: AGHT+IEcjHlHcMPoNa6JKDX9W5QYo0xQvj2/BGYXVfuM3DvK3Nqva0gT+wcQ0vVg5ycmh5nDVF4Cvw==
X-Received: by 2002:a05:600c:5118:b0:418:9941:ca28 with SMTP id o24-20020a05600c511800b004189941ca28mr7020552wms.2.1714999646201;
        Mon, 06 May 2024 05:47:26 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id p12-20020a05600c1d8c00b0041bcb898984sm16038937wms.31.2024.05.06.05.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 05:47:25 -0700 (PDT)
Date: Mon, 6 May 2024 14:47:23 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, keescook@chromium.org,
	axboe@kernel.dk, christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
	jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <ZjjRWybmAmClMMI9@phenom.ffwll.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, keescook@chromium.org,
	axboe@kernel.dk, christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
	jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
References: <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <CAHk-=whrSSNYVzTHNFDNGag_xcKuv=RaQUX8+n29kkic39DRuQ@mail.gmail.com>
 <20240505194603.GH2118490@ZenIV>
 <CAHk-=wipanX2KYbWvO5=5Zv9O3r8kA-tqBid0g3mLTCt_wt8OA@mail.gmail.com>
 <20240505203052.GJ2118490@ZenIV>
 <CAHk-=whFg8-WyMbVUGW5c0baurGzqmRtzFLoU-gxtRXq2nVZ+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whFg8-WyMbVUGW5c0baurGzqmRtzFLoU-gxtRXq2nVZ+w@mail.gmail.com>
X-Operating-System: Linux phenom 6.6.15-amd64 

On Sun, May 05, 2024 at 01:53:48PM -0700, Linus Torvalds wrote:
> On Sun, 5 May 2024 at 13:30, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > 0.      special-cased ->f_count rule for ->poll() is a wart and it's
> > better to get rid of it.
> >
> > 1.      fs/eventpoll.c is a steaming pile of shit and I'd be glad to see
> > git rm taken to it.  Short of that, by all means, let's grab reference
> > in there around the call of vfs_poll() (see (0)).
> 
> Agreed on 0/1.
> 
> > 2.      having ->poll() instances grab extra references to file passed
> > to them is not something that should be encouraged; there's a plenty
> > of potential problems, and "caller has it pinned, so we are fine with
> > grabbing extra refs" is nowhere near enough to eliminate those.
> 
> So it's not clear why you hate it so much, since those extra
> references are totally normal in all the other VFS paths.
> 
> I mean, they are perhaps not the *common* case, but we have a lot of
> random get_file() calls sprinkled around in various places when you
> end up passing a file descriptor off to some asynchronous operation
> thing.
> 
> Yeah, I think most of them tend to be special operations (eg the tty
> TIOCCONS ioctl to redirect the console), but it's not like vfs_ioctl()
> is *that* different from vfs_poll. Different operation, not somehow
> "one is more special than the other".
> 
> cachefiles and backing-file does it for regular IO, and drop it at IO
> completion - not that different from what dma-buf does. It's in
> ->read_iter() rather than ->poll(), but again: different operations,
> but not "one of them is somehow fundamentally different".
> 
> > 3.      dma-buf uses of get_file() are probably safe (epoll shite aside),
> > but they do look fishy.  That has nothing to do with epoll.
> 
> Now, what dma-buf basically seems to do is to avoid ref-counting its
> own fundamental data structure, and replaces that by refcounting the
> 'struct file' that *points* to it instead.
> 
> And it is a bit odd, but it actually makes some amount of sense,
> because then what it passes around is that file pointer (and it allows
> passing it around from user space *as* that file).
> 
> And honestly, if you look at why it then needs to add its refcount to
> it all, it actually makes sense.  dma-bufs have this notion of
> "fences" that are basically completion points for the asynchronous
> DMA. Doing a "poll()" operation will add a note to the fence to get
> that wakeup when it's done.
> 
> And yes, logically it takes a ref to the "struct dma_buf", but because
> of how the lifetime of the dma_buf is associated with the lifetime of
> the 'struct file', that then turns into taking a ref on the file.
> 
> Unusual? Yes. But not illogical. Not obviously broken. Tying the
> lifetime of the dma_buf to the lifetime of a file that is passed along
> makes _sense_ for that use.
> 
> I'm sure dma-bufs could add another level of refcounting on the
> 'struct dma_buf' itself, and not make it be 1:1 with the file, but
> it's not clear to me what the advantage would really be, or why it
> would be wrong to re-use a refcount that is already there.

So there is generally another refcount, because dma_buf is just the
cross-driver interface to some kind of real underlying buffer object from
the various graphics related subsystems we have.

And since it's a pure file based api thing that ceases to serve any
function once the fd/file is gone we tied all the dma_buf refcounting to
the refcount struct file already maintains. But the underlying buffer
object can easily outlive the dma_buf, and over the lifetime of an
underlying buffer object you might actually end up creating different
dma_buf api wrappers for it (but at least in drm we guarantee there's at
most one, hence why vmwgfx does the atomic_inc_unless_zero trick, which I
don't particularly like and isn't really needed).

But we could add another refcount, it just means we have 3 of those then
when only really 2 are needed.

Also maybe here two: dma_fence are bounded like other disk i/o (including
the option of timeouts if things go very wrong), so it's very much not
forever but at most a few seconds worst case (shit hw/driver excluded, as
usual).
-Sima
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

