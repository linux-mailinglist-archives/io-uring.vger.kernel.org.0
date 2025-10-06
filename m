Return-Path: <io-uring+bounces-9898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F49BBCEDB
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 03:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CF283B3998
	for <lists+io-uring@lfdr.de>; Mon,  6 Oct 2025 01:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D8A519E99F;
	Mon,  6 Oct 2025 01:25:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from vultr155 (pcfhrsolutions.pyu.ca [155.138.137.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90B779CD
	for <io-uring@vger.kernel.org>; Mon,  6 Oct 2025 01:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.137.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759713907; cv=none; b=cG9ICvPaRhSyBlsRUtyKk3C/oAoFDlCUcBTjcibu20P62Id6ZT8gC8663Fu4W4fTbwbLmTgRQpvp738EW5Y6wF8esK1FO/R3iAjYXxt2JU6zwUcO06sbjjj1QZl25kTLcf72AnF/V/Z/27bPYQSCVlIgcjvr29dCBgQnvTbufj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759713907; c=relaxed/simple;
	bh=BbD5IAX83jnprgTtOX+O7RC1v2gyEwRd+sV48Ys9tk0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoDqNMzh+b6JlyTdz6JBJfcLfWjxb0BV+CAVVQpwusg4RwRX60F0i2dLCE4SrToW+B5MLGujn/YBsD3/NWG/29QadMWGHnc93pJIxs6eslHVKfI6Ed85hOPFn8sr2Wu0oCtzFMHUrxOFclpzUSo4zHyJ2FkF0dcjhfLdxwG0S98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca; spf=pass smtp.mailfrom=beta.pyu.ca; arc=none smtp.client-ip=155.138.137.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beta.pyu.ca
Received: by vultr155 (Postfix, from userid 1001)
	id 448DB140681; Sun,  5 Oct 2025 21:25:03 -0400 (EDT)
Date: Sun, 5 Oct 2025 21:25:03 -0400
From: Jacob Thompson <jacobT@beta.pyu.ca>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: CQE repeats the first item?
Message-ID: <20251006012503.GA849@vultr155>
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
 <20251005215437.GA973@vultr155>
 <57de87e9-eac2-4f91-a2b4-bd76e4de7ece@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57de87e9-eac2-4f91-a2b4-bd76e4de7ece@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sun, Oct 05, 2025 at 07:09:53PM -0600, Jens Axboe wrote:
> On 10/5/25 3:54 PM, Jacob Thompson wrote:
> > On Sun, Oct 05, 2025 at 02:56:05PM -0600, Jens Axboe wrote:
> >> On 10/5/25 2:21 PM, Jacob Thompson wrote:
> >>> I'm doing something wrong and I wanted to know if anyone knows what I
> >>> did wrong from the description I'm using syscalls to call
> >>> io_uring_setup and io_uring_enter. I managed to submit 1 item without
> >>> an issue but any more gets me the first item over and over again. In
> >>> my test I did a memset -1 on cqes and sqes, I memset 0 the first ten
> >>> sqes with different user_data (0x1234 + i), and I used the opcode
> >>> IORING_OP_NOP. I called "io_uring_enter(fd, 10, 0,
> >>> IORING_ENTER_SQ_WAKEUP, 0)" and looked at the cq. Item 11 has the
> >>> user_data as '18446744073709551615' which is correct, but the first 10
> >>> all has user_data be 0x1234 which is weird AF since only one item has
> >>> that user_data and I submited 10 I considered maybe the debugger was
> >>> giving me incorrect values so I tried printing the user data in a
> >>> loop, I have no idea why the first one repeats 10 times. I only called
> >>> enter once
> >>>
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 4660
> >>> Id is 18446744073709551615
> >>
> >> You're presumably not updating your side of the CQ ring correctly, see
> >> what liburing does when you call io_uring_cqe_seen(). If that's not it,
> >> then you're probably mishandling something else and an example would be
> >> useful as otherwise I'd just be guessing. There's really not much to go
> >> from in this report.
> >>
> >> -- 
> >> Jens Axboe
> > 
> > I tried reproducing it in a smaller file. Assume I did everything wrong but somehow I seem to get results and they're not correct.
> > 
> > The codebase I'd like to use this in has very little activity (could go seconds without a single syscall), then execute a few hundreds-thousand (which I like to be async).
> > SQPOLL sounds like the one best for my usecase. You can see I updated the sq tail before enter and I used IORING_ENTER_SQ_WAKEUP + slept for a second.
> > The sq tail isn't zero which means I have results? and you can see its 10 of the same user_data
> > 
> > cq head is 0 enter result was 10
> > 1234 0
> > 1234 0
> > 1234 0
> > 1234 0
> > 1234 0
> > 1234 0
> > 1234 0
> > 1234 0
> > 1234 0
> > 1234 0
> > FFFFFFFF -1
> 
> I looked at your test code, and you're setting up 10 NOP requests with
> userdata == 0x1234, and hence you get 10 completions with that userdata.
> For some reason you iterate 11 CQEs, which means your last one is the one
> that you already filled with -1.
> 
> In other words, it very much looks like it's working as it should. Any
> reason why you're using the raw interface rather than liburing? All of
> this seems to be not understanding how the ring works, and liburing
> helps isolate you from that. The SQ ring doesn't tell you anything about
> whether you have results (CQEs?), the difference between the SQ head and
> tail just tell you if there's something to submit. The CQ ring head and
> tail would tell you if there are CQEs to reap or not.
> 
> -- 
> Jens Axboe

You must be seeing something that I'm not. I had a +i in the line, should the user_data not increment every item?
The line was 'sqes[i].user_data = 0x1234+i;'. The 11th iteration is intentional to see the value of the memset earlier.

> I'd encourage you to read and understand liburing, even if you aren't going to use it. That will tell you how to reap and iterate CQE events.

I did. I didn't try to compile and step through but I'm in the middle of rereading the manual. I want to finish it before I look at the lib again


