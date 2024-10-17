Return-Path: <io-uring+bounces-3756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFFC9A1770
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 02:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4616B22612
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 00:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11AE8625;
	Thu, 17 Oct 2024 00:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HrD+NQy6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B54110F2
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 00:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729126793; cv=none; b=ADLtEQhVv5ssbxEGgoRuyqsCXX7DXcnsbfSdfMZnEGycz+0WkJYH9WE+oWxCgNzQ8ePGi0XmSTltLnIz/fUnbDMkWvAJSOtfe0Gf77Sr4rrJpcpG/GJTbBFbQj3j+uPp2hvmUHTUmJuypJCWVJZYnFMOoEfUCEFKLS3ZRgpJWVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729126793; c=relaxed/simple;
	bh=rO1Ko6HGpyVdjOs8SemPiqdosd15dt4+rPUYbQ6gIts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k6z27uLIl8RJSzWIKhDektpuZ/CTp8YfDQBo6YNBVru8B3kczF0oajzZzGz9Qvcg3fI2HbdXSIezwxG/Hv3HCzRU1PTJWTupLteZkY2xic76W/e+lat8L2IgvEinlvs8ISrJ2Rp0SKychAHD3CCbz5RdagaIlMQCtrLvo/goD5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HrD+NQy6; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20c803787abso3182495ad.0
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 17:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729126789; x=1729731589; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjGnwR9rXYG0Q4YzPlEZMdRH2upbxtv94L916rjcT0o=;
        b=HrD+NQy6RKdEBxE4Q9C0APjzNOpzEB5YE0JmobnogaTX/jLGldkmXbXjSmrDSLYR4G
         /d8ugCNQFgwWzy/wRR08nDAy3b7j5tZ4frbUgGW7Ztm5skHR4j6G/1mHjBG9eE1RaaGi
         bYrbDpDnOujas26o4pia0TXqGQFQ0qycpf0hTOmduUR8vSotweNgksq01gh8noa3KbVd
         d0ezzjMCkB0JM8M10nTOvgwi7Jj5OYmCoUKvXLHoqELXb8RFoBm/3VvtxOPpqoCUpgIa
         vE9WY7/1SdFEV5JMBT50bZJG3/CECnWxsx9gU6VJrYswrFN/9blCiWuF7Imq076zXtai
         fQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729126789; x=1729731589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjGnwR9rXYG0Q4YzPlEZMdRH2upbxtv94L916rjcT0o=;
        b=dNTryoJSvVgJvZVfXkYOMuhpUFoYqQzl5HhhdGIdj7ugUah6wKc8QrYlmdp7eDe2tx
         AKYT9np4Ik4VE8rr5r5PwdDDAYulFjqrrCTJR9tNiOP/qCgtlqTbtSae4wld5Lc7tlFx
         Dn3bytgLf5qr8uaHPqPRI2jDo4OkR0lVNsPukKz88UVPUmsmMGu6oMRirb8EcsWQ3f/S
         nbpBg9lIMUH5C7QeZCKbat9sX/CLZlAu0uryOMZbC/WhobrKZIVr7/cSHjLodTGsDjms
         ML2ye6UQzoDBoA47qxPjJdqgIHt4fvjN0uK2vOgLxoB6MsVvTa0Hx8oavOILq19EMkKG
         M4eA==
X-Forwarded-Encrypted: i=1; AJvYcCWVZ6fzuWWg+YGMM51nsuBP3OE9ZCFlGjHYKsh1QWX+wBbs1f7OHao+32EbnVJidGuUS9+p/h0BlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwN23v9DlSihKJXE8C3ni1wRhWkUmZJ66e7xZX3LOF0+b4xZojn
	zFvC+jW6uYUmcXMcVFml02t6vyKNO6JsQEe1BYUHtNN4TJR2H4/V
X-Google-Smtp-Source: AGHT+IFtXrefGIkA2gSps/l2EClqa+EvRTVwUZw7cPM0H8DNO5wlYBMR9e6XXynCxxQc99Xez/mV0g==
X-Received: by 2002:a17:902:ec8d:b0:20b:51c2:d792 with SMTP id d9443c01a7336-20d471f99c4mr23313675ad.2.1729126789258;
        Wed, 16 Oct 2024 17:59:49 -0700 (PDT)
Received: from fedora ([2001:250:3c1e:503:ffff:ffff:ff2a:4903])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1803661dsm34279555ad.133.2024.10.16.17.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 17:59:48 -0700 (PDT)
Date: Thu, 17 Oct 2024 08:59:44 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: Large CQE for fuse headers
Message-ID: <ZxBhgMpUwAEpQriF@fedora>
References: <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm>
 <ZwyFke6PayyOznP_@fedora>
 <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
 <b284b6a2-8837-4779-b6a2-f31196aea7b9@fastmail.fm>
 <ab2d2f5c-0e76-44a2-8a7e-6f9edcfa5a92@gmail.com>
 <24ee0d07-47cc-4dcb-bdca-2123f38d7219@fastmail.fm>
 <74b0e140-f79d-4a89-a83a-77334f739c92@gmail.com>
 <e30b5268-6958-410f-9647-f7760abdafc3@fastmail.fm>
 <CAJfpegs1fBX6zDeUbzK-NntwhuPkVdCoE386coODjgHuxsBuJA@mail.gmail.com>
 <c2efdcc9-02c0-4937-b545-d0e6f88ee679@fastmail.fm>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2efdcc9-02c0-4937-b545-d0e6f88ee679@fastmail.fm>

On Wed, Oct 16, 2024 at 01:53:00PM +0200, Bernd Schubert wrote:
> 
> 
> On 10/16/24 12:54, Miklos Szeredi wrote:
> > On Mon, 14 Oct 2024 at 23:27, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
> > 
> >> With only libfuse as ring user it is more like
> >>
> >> prep_requests(nr=N);
> >> wait_cq(1); ==> we must not wait for more than 1 as more might never arrive
> >> io_uring_for_each_cqe {
> >> }
> > 
> > Right.
> > 
> > I think the point Pavel is trying to make is that  io_uring queue
> > sizes don't have to match fuse queue size.  So we could have
> > sq_entries=4, cq_entries=4 and have the server queue 64
> > FUSE_URING_REQ_FETCH commands, it just has to do that in batches of 4
> > max.
> 
> Hmm ok, I guess that might matter when payload is small compared to 
> SQ/CQ size and the system is low in memory.
> 
> > 
> >> @Miklos maybe we avoid using large CQEs/SQEs and instead set up our own
> >> separate buffer for FUSE headers?
> > 
> > The only gain from this would be in the case where the uring is used
> > for non-fuse requests as well, in which case the extra space in the
> > queue entries would be unused (i.e. 48 unused bytes in the cacheline).
> > I don't know if this is a realistic use case or not.  It's definitely
> > a challenge to create a library API that allows this.
> > 
> > The disadvantage would be a more complex interface.
> 
> I don't think that complicated. In the end it is just another pointer
> that needs to be mapped. We don't even need to use mmap.
> At least for zero-copy we will need to the ring non-fuse requests. 
> For the DDN use case, we are using another io-uring for tcp requests,
> I would actually like to switch that to the same ring.

I remember the biggest trouble of using same ring in ublk could be exporting
the ring for API users, but it is often per-task, seems not too hard to deal
with.

The pros is you needn't use eventfd to communicate with fuse command
uring(thread) any more, and more uring IOs can be handled in single batch.
Performance is better, with less task switch involved, without extra
communication.


Thanks,
Ming

