Return-Path: <io-uring+bounces-8778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3D4B0DE73
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 16:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D320583D90
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 14:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58421D7E37;
	Tue, 22 Jul 2025 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mev.co.uk header.i=@mev.co.uk header.b="zL1SBL5N"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp87.iad3b.emailsrvr.com (smtp87.iad3b.emailsrvr.com [146.20.161.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6052EA49E
	for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.20.161.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193730; cv=none; b=P+Gvg51AmIpxP/V4e/5Uypy5qVaJZMH53sliC3x6RfNqGjGgy2Gk5DSRpSj1cxflXlNbKRk+JqfXKfmbhJ6apVzYzfAy3t925cFbBk69ZknkDKafcFBFBRG0IN8zw68C1qgg0zAtPoK62PpxNTkjHY0IObdkDeTrs5k2yIW4rGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193730; c=relaxed/simple;
	bh=32pIRkzV4n+K4q/AZ2pGxE0sg38YoX8IIHochykUVCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OISKZ3eWABXn5irIqz6SPkUsDrRM227KA0srDz7NMQP9VsCtUZSCPRrWIHVunfFsod5OzKmlGk5W/00PZ2M5u369m06uc39Dvy2i0MoR4kVjhDa5Nyob0SvdM20TJuJs1rVk5iRINY7ZYNspyPFczG4w8fsAuA+wxgljXTjrKSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mev.co.uk; spf=pass smtp.mailfrom=mev.co.uk; dkim=pass (1024-bit key) header.d=mev.co.uk header.i=@mev.co.uk header.b=zL1SBL5N; arc=none smtp.client-ip=146.20.161.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mev.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mev.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
	s=20221208-6x11dpa4; t=1753193728;
	bh=32pIRkzV4n+K4q/AZ2pGxE0sg38YoX8IIHochykUVCk=;
	h=Date:Subject:To:From:From;
	b=zL1SBL5NyhP0JUu4nNNOOnwS4ok3flukRKp2/ZLInvsCqNwCv3+E0qvGdzfp67aCb
	 hbEn9zZR4uugKWSqX3yk8CJ1uiqh8MGTIUwwORMYhYumlBj0gc1KMLPwl9t/zJJejr
	 8sSNw4Er8t6gXCsDLyYDI5ReBs7+BQgfCpTvCs3Q=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp3.relay.iad3b.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 277D94011A;
	Tue, 22 Jul 2025 10:15:27 -0400 (EDT)
Message-ID: <2f78d094-275d-4134-ba50-6769c191e96e@mev.co.uk>
Date: Tue, 22 Jul 2025 15:15:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_poll_remove_entries
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, hsweeten@visionengravers.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
 <9385a1a6-8c10-4eb5-9ab9-87aaeb6a7766@kernel.dk>
 <ede52bb4-c418-45c0-b133-4b5fb6682b04@kernel.dk>
 <d407c9f1-e625-4153-930f-6e44d82b32b5@kernel.dk>
 <20250722134724.6671e45b@ian-deb>
 <8320bd2b-b6d2-4ed8-84c6-cb04999e9f53@kernel.dk>
Content-Language: en-GB
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
In-Reply-To: <8320bd2b-b6d2-4ed8-84c6-cb04999e9f53@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 42e97f67-1fb7-4d94-9323-749955c81092-1-1

On 22/07/2025 14:53, Jens Axboe wrote:
>> Thanks for your investigation and initial fix. I think dev->attach_lock
>> needs to be write-locked before calling is_device_busy() and released
>> after comedi_device_detach() (although that also write-locks it, so we
>> need to refactor that). Otherwise, someone could get added to the
>> wait_head after is_device_busy() returns.
> 
> Looked at this one post coffee, and this looks good to me. If the
> ->cancel() part is all fine with attach_lock being held, this looks like
> the simplest solution to the issue.
> 
> I still think the whole busy notion etc needs rethinking in comedi, it
> should follow a more idiomatic approach rather than be special. But
> that's really separate from this fix.
> 

The reason for the separate dev->attach_lock and dev->mutex is to reduce 
the latency for read() and write() operations because dev->mutex can 
sometimes be locked for quite a while when processing the 
COMEDI_INSNLIST ioctl command, for example.  (At some point, I want to 
make the COMEDI_BUFINFO ioctl use dev->attach_lock instead of 
dev->mutex, because that is used when using mmap() instead of 
read()/write().)

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-

