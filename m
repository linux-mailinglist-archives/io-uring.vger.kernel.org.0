Return-Path: <io-uring+bounces-8364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B09ADB39C
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D03AB1734AE
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 14:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B34B2BF00D;
	Mon, 16 Jun 2025 14:18:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from fx.arvanta.net (93-87-244-166.static.isp.telekom.rs [93.87.244.166])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06A01F37A1
	for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.87.244.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750083538; cv=none; b=BGd7ZaKmqH1ODrjIiYXfhF3J8vREJ8VYtii72X1U2BlAxMdccQsrJqiw0f2MirsOPX6uZs15KWG7hWGvLGYy8Z4T8lkJeNexp/fo5TchjgyRytgNKdqa7NLBXm0ttq2SvRpXQMtirUGauI2ZuftT5lWosCgA9zKCduGDgirzVTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750083538; c=relaxed/simple;
	bh=rrE+PMbJugMXjmkoAZ1yGUFhmAabCOSR2/oFF6A7ycg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YclC1nivN+3H4EF7Mv73u91ZvvNBoNEwKRFcKlQ4dHfZhBdmKHpX25U+45/J8Nc+9fvmuoj2SKOW7kcPnARwPaY9lHjLHIbDVXXOAQCvzkCrvwqpZmSQ+XFLgPVxXBM1ZaV+VcvHGwgsY6lGNoIz6QcOC4CmGOO+VAKFTkHk+4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net; spf=pass smtp.mailfrom=arvanta.net; arc=none smtp.client-ip=93.87.244.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arvanta.net
Received: from m1pro.arvanta.net (m1pro.arvanta.net [10.5.1.11])
	by fx.arvanta.net (Postfix) with ESMTP id 2EDCF10A77;
	Mon, 16 Jun 2025 16:18:55 +0200 (CEST)
Date: Mon, 16 Jun 2025 16:18:23 +0200
From: Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: Building liburing on musl libc gives error that errno.h not found
Message-ID: <20250616141823.GA27374@m1pro.arvanta.net>
References: <20250615171638.GA11009@m1pro.arvanta.net>
 <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
 <20250615195617.GA15397@m1pro.arvanta.net>
 <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
 <20250616130612.GA21485@m1pro.arvanta.net>
 <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>

On Mon, 2025-06-16 at 07:59, Jens Axboe wrote:
> On 6/16/25 7:06 AM, Milan P. Stanić wrote:
> > On Mon, 2025-06-16 at 06:34, Jens Axboe wrote:
> >> On 6/15/25 1:56 PM, Milan P. Stani? wrote:
> >>> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
> >>>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
> >>>>> Hi,
> >>>>>
> >>>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
> >>>>> that errno.h is not found when building examples/zcrx.c
> >>>>>
> >>>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
> >>>>> is here:
> >>>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
> >>>>> I commented in merge request that error.h is glibc specific.
> >>>>
> >>>> I killed it, it's not needed and should've been caught during review.
> >>>> We should probably have alpine/musl as part of the CI...
> >>>
> >>> Fine.
> >>>
> >>>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
> >>>>> should I post full log here.
> >>>>
> >>>> Either that or file an issue on GH. Sounds like something is very wrong
> >>>> on the setup if you get failing tests, test suite should generally
> >>>> pass on the current kernel, or any -stable kernel.
> >>>>
> >>> I'm attaching log here to this mail. Actually it is one bug but repeated
> >>> in different tests, segfaults
> >>
> >> Your kernel is ancient, and that will surely account from some of the
> >> failures you see. A 6.6 stable series from January 2024 is not current
> >> by any stretch, should definitely upgrade that. But I don't think this
> >> accounts for all the failures seen, it's more likely there's some musl
> >> related issue as well which is affecting some of the tests.
> > 
> > This happens also on 6.14.8-1 asahi kernel on apple m1pro machine.
> > I forgot to mention this in previous mail, sorry.
> 
> Also on musl, correct?

Yes, correct.

> Guessing it must be some musl oddity. I'll try and setup a vm with
> alpine and see how that goes.

It could be. I can ask on #musl IRC channel on libera.chat

-- 
Kind regards

