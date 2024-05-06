Return-Path: <io-uring+bounces-1772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA948BCDC0
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 14:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 908561C23520
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 12:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5794143C4C;
	Mon,  6 May 2024 12:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="J4Sdfzf+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D654143899
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 12:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714998234; cv=none; b=HDJb6rKTmnqeKZHB1tG3t/wVJDAxQ1O4/OqfO0/zxFfNixIIW+9JopgZX+d2vBYpA3jNpvD/ZVYoDbDV8zkVfqPtumKq9NlkCsz0mniHZ518uNAPkGUPnh5EwseWYk7JYsWAkdctxubtKEOIj/NvMIgOlTqyHjSCKIm+n9dFGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714998234; c=relaxed/simple;
	bh=lCeN5/qj6q6vJSmEiKVBWOtCMx5sNu2IArRIsx3u2Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZX8nyCuvVOfJvzExV0jdJ7g6L77fUAez5YG2GhTiD/IuWtpEVKe++8cHnITxEDrBNZc+OsudgI5inTuyGs1nH9K1VSmsrwS/aanz4luU8D894PgJdTQ9jFyQpNlfosB4pgH5nwkelKQ3rRxnbS6s52VM6YpP3G6JJFarAiSr3vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=J4Sdfzf+; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-346407b8c9aso622268f8f.0
        for <io-uring@vger.kernel.org>; Mon, 06 May 2024 05:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1714998231; x=1715603031; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hJvxbNUxeULloPkLJE9SsjERpdsUIXxRxn2yKsRsSwc=;
        b=J4Sdfzf+sNHeQZbjLlHQkxe+vBV/CqtEKZIE21zHs5BZaP4fVUooE839QXHepk/ae4
         POXW3MdM2YM0mL7+kPF0sFDjddZ6ZqJgjPLk5O1FAQ9LQ6NuGoI/6ghK9qafc9p5r5/q
         eIF9aflCGGZxuDwFxBa6ppO8Igf343ne8trek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714998231; x=1715603031;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJvxbNUxeULloPkLJE9SsjERpdsUIXxRxn2yKsRsSwc=;
        b=MyUPVPv+pMR3DmQQ449GDKnhMbI4WRyh6BILjgdm6GCMIxmFmIi+2xfncYEYXl5c3t
         x2vDojpkc70ykbQSccBTawtcdIwBpNxIpw2VqiccFp3YpbgeLPHC9CRawsso1jyOVaXe
         h8pjqB0YLBs8Vj2c5Os2zWza6GJR6/VsY3kF5yLEm2DJ1sCeb8Opf6eCNqtmam51FdLS
         NrodkGA9Y+Z4NonkJ02Q57Yvr5VdW8EGf6uqBjV9qCaG3f3oWYtLbmnMro9mtoDk/nK/
         MBeSj3HygEE+yBcndJsOyknpiX8FjKo67cvHamf+aVPj+Lgx8eDY2jEg5qeAQWjGL+1N
         v5UA==
X-Forwarded-Encrypted: i=1; AJvYcCWwIwVMtxWYt0ct+9LH8SZAkWdCViKYtMXmx3B1+Ndgo11S6GATQf4S+MBxqRb8xWtR7uorYtK0isrslq9ZtXiUfT8xtFqTqDo=
X-Gm-Message-State: AOJu0YyfwW4XIJw3KyCm07F0dUIvk/AwHnZGPo0pIGE4XuJcHuvcC+fo
	r5oTTn2+j7CQHrbeYHfb9+DmAV26rGx9iUF9I111z4AzPbdd6oyhmBvQHbUlzzw=
X-Google-Smtp-Source: AGHT+IGuUvBtI5rIVLpD2XOZICwCS9IQtrXwLWSsF2oFAMcsXQKy2Upppe1zQ4rIa9wWPmT5P5GIew==
X-Received: by 2002:a05:600c:3b02:b0:41a:c4fe:b0a5 with SMTP id m2-20020a05600c3b0200b0041ac4feb0a5mr6970105wms.4.1714998231468;
        Mon, 06 May 2024 05:23:51 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id n17-20020a05600c4f9100b0041668162b45sm19554882wmq.26.2024.05.06.05.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 05:23:50 -0700 (PDT)
Date: Mon, 6 May 2024 14:23:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
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
Message-ID: <ZjjL1GjSMMMcxdsc@phenom.ffwll.local>
Mail-Followup-To: Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
	io-uring@vger.kernel.org, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>
References: <202405031110.6F47982593@keescook>
 <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook>
 <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook>
 <202405031325.B8979870B@keescook>
 <20240503211109.GX2118490@ZenIV>
 <20240503213625.GA2118490@ZenIV>
 <CAHk-=wgRphONC5NBagypZpgriCUtztU7LCC9BzGZDEjWQbSVWQ@mail.gmail.com>
 <20240503215303.GC2118490@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503215303.GC2118490@ZenIV>
X-Operating-System: Linux phenom 6.6.15-amd64 

On Fri, May 03, 2024 at 10:53:03PM +0100, Al Viro wrote:
> On Fri, May 03, 2024 at 02:42:22PM -0700, Linus Torvalds wrote:
> > On Fri, 3 May 2024 at 14:36, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > ... the last part is no-go - poll_wait() must be able to grab a reference
> > > (well, the callback in it must)
> > 
> > Yeah. I really think that *poll* itself is doing everything right. It
> > knows that it's called with a file pointer with a reference, and it
> > adds its own references as needed.
> 
> Not really.  Note that select's __pollwait() does *NOT* leave a reference
> at the mercy of driver - it's stuck into poll_table_entry->filp and
> the poll_freewait() knows how to take those out.
> 
> 
> dmabuf does something very different - it grabs the damn thing into
> its private data structures and for all we know it could keep it for
> a few hours, until some even materializes.

dma_fence must complete in reasonable amount of time, where "reasonable"
is roughly in line with other i/o (including the option that there's
timeouts if the hw's gone busted).

So definitely not hours (aside from driver bugs when things go really
wrong ofc), but more like a few seconds in a worst case scenario.
-Sima
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

