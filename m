Return-Path: <io-uring+bounces-8380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02495ADC497
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 10:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2A4716B4DE
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 08:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEB7291C1D;
	Tue, 17 Jun 2025 08:20:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from fx.arvanta.net (93-87-244-166.static.isp.telekom.rs [93.87.244.166])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C1D293B5C
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 08:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.87.244.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750148427; cv=none; b=u/+l11OejOk5waCXTEEjWBiZpo4/8elFLLNVTcGnqS6KUuC+gfVk/2Fm75NvA/wLOKWXgozMslqBOqbKDHZmWqWm6a7QvJhvDrh/JkN5bx9KdNVRgGG3FPjNhEvals+fC7L9CswyySL7JWKVeufmyq5m0O43aHCifan0HJJWFIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750148427; c=relaxed/simple;
	bh=RCf6A14t2bgZ8qpuzZN05q00//kj8Z+yXiURfd8ToKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ljq0Ga9MjzTLcYI6mMOLq2rc5ih1VLFUfxSsj8ulSC4lmYKkA5N5pYy0WQaYYzg0bIlDIkFnwIm/BWpMt2eRp0XwiA2QEhd6WZGf/ryKOfcNWW9OiLd3vlDeDVEWmUA/EjxhPay9T8Z/sIWLyuD09dx4ffI5WqrpY2L6GjQ5pjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net; spf=pass smtp.mailfrom=arvanta.net; arc=none smtp.client-ip=93.87.244.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arvanta.net
Received: from m1pro.arvanta.net (m1pro.arvanta.net [10.5.1.11])
	by fx.arvanta.net (Postfix) with SMTP id 61BAFFC74;
	Tue, 17 Jun 2025 10:20:19 +0200 (CEST)
Date: Tue, 17 Jun 2025 10:19:47 +0200
From: Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: Building liburing on musl libc gives error that errno.h not found
Message-ID: <20250617081947.GA21947@m1pro.arvanta.net>
References: <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
 <20250615195617.GA15397@m1pro.arvanta.net>
 <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
 <20250616130612.GA21485@m1pro.arvanta.net>
 <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>
 <20250616141823.GA27374@m1pro.arvanta.net>
 <290bfa14-b595-4fea-b1fe-a3f0881f4220@kernel.dk>
 <a3aaaba3-17d6-4d23-8723-2a25526a4587@kernel.dk>
 <20250616163244.GA16126@m1pro.arvanta.net>
 <f5b6a7f1-ecb2-4247-b339-b7a3f51f5216@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b6a7f1-ecb2-4247-b339-b7a3f51f5216@kernel.dk>

On Mon, 2025-06-16 at 10:35, Jens Axboe wrote:
> On 6/16/25 10:32 AM, Milan P. Stani? wrote:
> > On Mon, 2025-06-16 at 09:35, Jens Axboe wrote:
> >> On 6/16/25 9:13 AM, Jens Axboe wrote:
> >>> On 6/16/25 8:18 AM, Milan P. Stani? wrote:
> >>>> On Mon, 2025-06-16 at 07:59, Jens Axboe wrote:
> >>>>> On 6/16/25 7:06 AM, Milan P. Stani? wrote:
> >>>>>> On Mon, 2025-06-16 at 06:34, Jens Axboe wrote:
> >>>>>>> On 6/15/25 1:56 PM, Milan P. Stani? wrote:
> >>>>>>>> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
> >>>>>>>>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
> >>>>>>>>>> Hi,
> >>>>>>>>>>
> >>>>>>>>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
> >>>>>>>>>> that errno.h is not found when building examples/zcrx.c
> >>>>>>>>>>
> >>>>>>>>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
> >>>>>>>>>> is here:
> >>>>>>>>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
> >>>>>>>>>> I commented in merge request that error.h is glibc specific.
> >>>>>>>>>
> >>>>>>>>> I killed it, it's not needed and should've been caught during review.
> >>>>>>>>> We should probably have alpine/musl as part of the CI...
> >>>>>>>>
> >>>>>>>> Fine.
> >>>>>>>>
> >>>>>>>>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
> >>>>>>>>>> should I post full log here.
> >>>>>>>>>
> >>>>>>>>> Either that or file an issue on GH. Sounds like something is very wrong
> >>>>>>>>> on the setup if you get failing tests, test suite should generally
> >>>>>>>>> pass on the current kernel, or any -stable kernel.
> >>>>>>>>>
> >>>>>>>> I'm attaching log here to this mail. Actually it is one bug but repeated
> >>>>>>>> in different tests, segfaults
> >>>>>>>
> >>>>>>> Your kernel is ancient, and that will surely account from some of the
> >>>>>>> failures you see. A 6.6 stable series from January 2024 is not current
> >>>>>>> by any stretch, should definitely upgrade that. But I don't think this
> >>>>>>> accounts for all the failures seen, it's more likely there's some musl
> >>>>>>> related issue as well which is affecting some of the tests.
> >>>>>>
> >>>>>> This happens also on 6.14.8-1 asahi kernel on apple m1pro machine.
> >>>>>> I forgot to mention this in previous mail, sorry.
> >>>>>
> >>>>> Also on musl, correct?
> >>>>
> >>>> Yes, correct.
> >>>>
> >>>>> Guessing it must be some musl oddity. I'll try and setup a vm with
> >>>>> alpine and see how that goes.
> >>>>
> >>>> It could be. I can ask on #musl IRC channel on libera.chat
> >>>
> >>> Probably easier if I just take a look at it, as long as I can get
> >>> an alpine vm image going.
> >>
> >> Pure guesswork, but you are most likely running into default ulimit
> >> limits being tiny. Probably something ala:
> >>
> >> rc_ulimit="-n 524288 -l 262144"
> >>
> >> in /etc/rc.conf would help.
> > 
> > Tried, but didn't help.
> > 
> > I will left it for now and return to test it when new liburing is
> > released. It must pass our builders and CI, so I disabled test earlier.
> > 
> > Thank you for help.
> 
> That's fine, I don't recommend distros attempt to verify it by using
> the test suite anyway, that's not really its intended purpose. Though it
> can be useful in terms of verifying all relevant fixes are backported,
> particular if the distro is one of those oddballs that don't base on or
> pull in -stable.
> 
> I'll be releasing 2.11 shortly, but it likely won't change anything on
> your end, outside of having the examples/zcrx compilation fixed.
> 
> FWIW, I'm on Alpine Linux 3.22 and it passes here.

liburing 2.11 builds fine on Alpine edge and previous bugs (segfaults)
don't appears now with new version.

runtests shows that 4 test failed:
----------------
Test run complete, kernel: 6.6.14-0-lts #1-Alpine SMP PREEMPT_DYNAMIC Fri, 26 Jan 2024 11:08:07 +0000
Tests failed (4): <accept.t> <nop.t> <sqwait.t> <timeout.t>
make[1]: *** [Makefile:331: runtests] Error 1
make[1]: Leaving directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.11/test'
make: *** [Makefile:21: runtests] Error 2
----------------

but I think this is not blocker to update liburing to 2.11 on alpine.

-- 
Kind regards

