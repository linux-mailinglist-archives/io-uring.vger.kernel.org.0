Return-Path: <io-uring+bounces-8371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E43CDADB705
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 18:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7489F3A763C
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3041D264A85;
	Mon, 16 Jun 2025 16:33:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from fx.arvanta.net (93-87-244-166.static.isp.telekom.rs [93.87.244.166])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61EF61DE2BF
	for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 16:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.87.244.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750091600; cv=none; b=d6XdWm8YaU/+6/FS6nmoTjwpnUFG8OH53XpAzByHvMqTt94gn8WPBnbqjKYELUbFIMud63qMlJrIV7ah91T48yMztPb8+4St0pg/OKm6PavkteJs3rSbbJMqqUWjqVLRt8YzY/Z02W3eqTS0Kebh7uUksc5Bbru8SusxIjGSnj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750091600; c=relaxed/simple;
	bh=ZG8M/aTjMabnVYQeetS838mezXJYmsWHxbJWgO97gzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgSqse+geL3K8IPaMMhlT6VTJV5PP5FbQlbn1NImRoo6/7X+LkPvhI3jdcXYu44oJdPARimUjU9qy8jlhJ9jW+11MSduUB1tFhDT/gdeFuggvnhUwwD036SCD40bMkbfNLVMkl62/YMsOFCYXPJZ4e6jvZaH3FBaOybhVEjLISs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net; spf=pass smtp.mailfrom=arvanta.net; arc=none smtp.client-ip=93.87.244.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arvanta.net
Received: from m1pro.arvanta.net (m1pro.arvanta.net [10.5.1.11])
	by fx.arvanta.net (Postfix) with SMTP id EA42810A7B;
	Mon, 16 Jun 2025 18:33:16 +0200 (CEST)
Date: Mon, 16 Jun 2025 18:32:44 +0200
From: Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: Building liburing on musl libc gives error that errno.h not found
Message-ID: <20250616163244.GA16126@m1pro.arvanta.net>
References: <20250615171638.GA11009@m1pro.arvanta.net>
 <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
 <20250615195617.GA15397@m1pro.arvanta.net>
 <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
 <20250616130612.GA21485@m1pro.arvanta.net>
 <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>
 <20250616141823.GA27374@m1pro.arvanta.net>
 <290bfa14-b595-4fea-b1fe-a3f0881f4220@kernel.dk>
 <a3aaaba3-17d6-4d23-8723-2a25526a4587@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3aaaba3-17d6-4d23-8723-2a25526a4587@kernel.dk>

On Mon, 2025-06-16 at 09:35, Jens Axboe wrote:
> On 6/16/25 9:13 AM, Jens Axboe wrote:
> > On 6/16/25 8:18 AM, Milan P. Stani? wrote:
> >> On Mon, 2025-06-16 at 07:59, Jens Axboe wrote:
> >>> On 6/16/25 7:06 AM, Milan P. Stani? wrote:
> >>>> On Mon, 2025-06-16 at 06:34, Jens Axboe wrote:
> >>>>> On 6/15/25 1:56 PM, Milan P. Stani? wrote:
> >>>>>> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
> >>>>>>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
> >>>>>>>> that errno.h is not found when building examples/zcrx.c
> >>>>>>>>
> >>>>>>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
> >>>>>>>> is here:
> >>>>>>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
> >>>>>>>> I commented in merge request that error.h is glibc specific.
> >>>>>>>
> >>>>>>> I killed it, it's not needed and should've been caught during review.
> >>>>>>> We should probably have alpine/musl as part of the CI...
> >>>>>>
> >>>>>> Fine.
> >>>>>>
> >>>>>>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
> >>>>>>>> should I post full log here.
> >>>>>>>
> >>>>>>> Either that or file an issue on GH. Sounds like something is very wrong
> >>>>>>> on the setup if you get failing tests, test suite should generally
> >>>>>>> pass on the current kernel, or any -stable kernel.
> >>>>>>>
> >>>>>> I'm attaching log here to this mail. Actually it is one bug but repeated
> >>>>>> in different tests, segfaults
> >>>>>
> >>>>> Your kernel is ancient, and that will surely account from some of the
> >>>>> failures you see. A 6.6 stable series from January 2024 is not current
> >>>>> by any stretch, should definitely upgrade that. But I don't think this
> >>>>> accounts for all the failures seen, it's more likely there's some musl
> >>>>> related issue as well which is affecting some of the tests.
> >>>>
> >>>> This happens also on 6.14.8-1 asahi kernel on apple m1pro machine.
> >>>> I forgot to mention this in previous mail, sorry.
> >>>
> >>> Also on musl, correct?
> >>
> >> Yes, correct.
> >>
> >>> Guessing it must be some musl oddity. I'll try and setup a vm with
> >>> alpine and see how that goes.
> >>
> >> It could be. I can ask on #musl IRC channel on libera.chat
> > 
> > Probably easier if I just take a look at it, as long as I can get
> > an alpine vm image going.
> 
> Pure guesswork, but you are most likely running into default ulimit
> limits being tiny. Probably something ala:
> 
> rc_ulimit="-n 524288 -l 262144"
> 
> in /etc/rc.conf would help.

Tried, but didn't help.

I will left it for now and return to test it when new liburing is
released. It must pass our builders and CI, so I disabled test earlier.

Thank you for help.

-- 
Kind regards

