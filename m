Return-Path: <io-uring+bounces-11306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1AA2CDD65D
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 08:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EFAB53016348
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 07:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E3D92E2F14;
	Thu, 25 Dec 2025 07:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bc28Fy4O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618642E1C63
	for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 07:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766646505; cv=none; b=EETbmhAa9rcM8o4XIHFOLYyr27CrNPqxBXaQB6nS+k3yP2VZlvTrdaQj00mw01u+P0vhQhVKtFjWbmqza3ZWmnL2prDJiHKKsXURx3pk2f4NC2a8HRNqCxA0+DvJW1LO9XqhWnaLorEwpy/xYACYRZpBPjT7kIfPsd44LfXEV3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766646505; c=relaxed/simple;
	bh=CG/moFFtL/ZvcK2sU4KPzNBuRMark1gy0LiWEe6P/58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHtAQlGySe5/1T8tTzI4NbNJdDFxJTvJLDNxnMim+ZHeEx4wQo1IQyziuN+SsqjKmJfWeA+dX3t+6kRyakSkGWcuiLRHtVQehlg5bkewAnrAY0hHoXZWFIlTNABdDmBsorSmr3+hYbmdhaynucP6br7WFPrNsdnKcPUMygi07nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bc28Fy4O; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a09d981507so46211375ad.1
        for <io-uring@vger.kernel.org>; Wed, 24 Dec 2025 23:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766646503; x=1767251303; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2trtGlNXZKZVCUn7XC47iovlx+cgHeYtiSGP2VJpxo0=;
        b=bc28Fy4OMFRs88KfIMpN8wemY+w1AVKjojemfWOPH3mB/dTFECX8bni64oj8m+7ayu
         vehgyWFiKeCEw68RlfnEB/o+V1bdPVjA961cNxHnUsmqO5B9IOOH+DROHYNnmzyzcv2l
         +f8eNgijpOolfosH4wU4qgaViX8SBwosdNdA+YsiZGjNY8J5z/szJsR+rHJI5AQQ2a2l
         2vBzwKhcMsZVIvVs0jLQDLsRcanUGNUy5LV3iNpZPrZysp8aXMVeeeGiInQx6ObhHf7Y
         6CD5YIrgvFx7Qjan1IJYdXORz28Fpinwx93zgRv6DSP17yHAJ03HiXgMD6axyahKjPNc
         CjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766646503; x=1767251303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2trtGlNXZKZVCUn7XC47iovlx+cgHeYtiSGP2VJpxo0=;
        b=QWMfYkZ9lw9P5+tcTQOupt3AMVqiDOkqpbEcN5tF6c7xpXPRKE9XEqukYhY2thc6mi
         hcaHKTVKAY845Wi9LMaBhvlnQPH62TDZQFjdoA42ymnWbxaLZmEmbL/KdDIhpE3/IxOI
         rzwUYad5GkMF5xcyfrl7Z30ZYNn7BDIIh8JWRY14uS0KIhBCn783VGU9wAhXNQd32v7D
         t/TKjG7WOe7ft8AQmsX/XtKzH3UIAzVJFpeh5MOlnw3FREjwyYWFUzmzm4P3Q3H30IDm
         Vk8650L6HpjvbLgg3VQMYIXWboTyvg1M4UI+vFiwA2PlzvNnOaNrxkxO4h4Cd3ORLVG+
         +OuQ==
X-Gm-Message-State: AOJu0YwXwG9IDHzK+6Wug/pA8WT3vQ6z2HSVFoZQJuVn7XnEE1a9piG2
	8nf/M+7lNsUoaPSOTJl12vWgs0SJpkNISb1lZy9uUPLi/ozr7bXwgsQ+
X-Gm-Gg: AY/fxX6f4g8rlpvTv1cdxtLs+BgVF1tavz49G25JjWBD9s+K+u1NDOR3008XW96sSKd
	Rs4fTHBcaaq1mnI+MC9608ihY44xFCFeHJ4Ns8cikuM4eO2O4vX9d+rxbT6eiQzBW7O4ylNbsWw
	v3vm0Uy1VBnIcTRQjUw/sGQyMHOlWlLoQpztKdE1V3Pj4CT5rnoyp1dO7lj8VcPY3i9GByvMfd1
	Jtss4SIqXdknNkLfvV88EFQijX7GgXr6LFKXlmovv634YdFQ4dGTjc++iwqomCgH8AlT8JRpf+n
	Iukwl7z11rEFa9F0mw4nG10McDuWwZlVaa3HdMYfBOY6GVe/KPH3j30166lBfld9cFRwihgdV3D
	ktaWQ5Q9Js5wrrHm4O7cZ7U7HwSTToBXCgs6JhPxdzLL7xBKtl39YzIxPhlrI1MgEDLUMMrIEGP
	XLCIlQl5r5N80=
X-Google-Smtp-Source: AGHT+IHj4b0UoCCHB7eZW9m4bhaWfyAyco74NqzkA7/3+8fypn8585Sl5u634QiMVlYAcwKXwYCnGA==
X-Received: by 2002:a17:903:2307:b0:29f:2734:837d with SMTP id d9443c01a7336-2a2cab74c17mr267904165ad.28.1766646503484;
        Wed, 24 Dec 2025 23:08:23 -0800 (PST)
Received: from inspiron ([111.125.235.126])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d6d557sm169812195ad.84.2025.12.24.23.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 23:08:23 -0800 (PST)
Date: Thu, 25 Dec 2025 12:38:15 +0530
From: Prithvi <activprithvi@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix filename leak in __io_openat_prep()
Message-ID: <20251225070815.s5ahm4t7yfd6irjo@inspiron>
References: <20251224164247.103336-1-activprithvi@gmail.com>
 <dc51a709-e404-4515-8023-3597c376aff5@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc51a709-e404-4515-8023-3597c376aff5@kernel.dk>

On Wed, Dec 24, 2025 at 11:01:55AM -0700, Jens Axboe wrote:
> On 12/24/25 9:42 AM, Prithvi Tambewagh wrote:
> > __io_openat_prep() allocates a struct filename using getname(), but
> > it isn't freed in case the present file is installed in the fixed file
> > table and simultaneously, it has the flag O_CLOEXEC set in the
> > open->how.flags field.
> > 
> > This is an erroneous condition, since for a file installed in the fixed
> > file table, it won't be installed in the normal file table, due to which
> > the file cannot support close on exec. Earlier, the code just returned
> > -EINVAL error code for this condition, however, the memory allocated for
> > that struct filename wasn't freed, resulting in a memory leak.
> > 
> > Hence, the case of file being installed in the fixed file table as well
> > as having O_CLOEXEC flag in open->how.flags set, is adressed by using
> > putname() to release the memory allocated to the struct filename, then
> > setting the field open->filename to NULL, and after that, returning
> > -EINVAL.
> > 
> > Reported-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=00e61c43eb5e4740438f
> > Tested-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> > ---
> >  io_uring/openclose.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> > index bfeb91b31bba..fc190a3d8112 100644
> > --- a/io_uring/openclose.c
> > +++ b/io_uring/openclose.c
> > @@ -75,8 +75,11 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
> >  	}
> >  
> >  	open->file_slot = READ_ONCE(sqe->file_index);
> > -	if (open->file_slot && (open->how.flags & O_CLOEXEC))
> > +	if (open->file_slot && (open->how.flags & O_CLOEXEC)) {
> > +		putname(open->filename);
> > +		open->filename = NULL;
> >  		return -EINVAL;
> > +	}
> >  
> >  	open->nofile = rlimit(RLIMIT_NOFILE);
> >  	req->flags |= REQ_F_NEED_CLEANUP;
> 
> You can probably fix it similarly by just having REQ_F_NEED_CLEANUP set
> earlier in the process, then everything that needs undoing will get
> undone as part of ending the request.
> 
> -- 
> Jens Axboe

Sure, I will send v2 patch incorporating this change. Thanks for the 
feedback!

Best Regards, 
Prithvi

