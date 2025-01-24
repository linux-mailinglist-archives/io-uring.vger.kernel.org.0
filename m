Return-Path: <io-uring+bounces-6115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2DAA1BA5D
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 17:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D8423A49CD
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 16:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34FC155352;
	Fri, 24 Jan 2025 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=charbonnet.com header.i=@charbonnet.com header.b="jakE6DCX"
X-Original-To: io-uring@vger.kernel.org
Received: from h5.fbrelay.privateemail.com (h5.fbrelay.privateemail.com [162.0.218.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A131A45016;
	Fri, 24 Jan 2025 16:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.0.218.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737736246; cv=none; b=JH+vhL8tGvqPKMi6BEYaORbD6cvL/WZMGkNeOwvF1VHtF7aXay2Alo7FU1XOxd0ArjD2B4mmIRxWvOv2aPF61Eb9klh06ZNGuzqn/URGIvTH84Al48qgdIxGKNkaGfpH1Ff2Fg/Yvjso4kJJzEa4fw2sQNdTyrTRMAjv9Lk7NQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737736246; c=relaxed/simple;
	bh=www1XGD6vX+enfGJCQJ8r3Eaffu76oKwdIN6jkMDBtI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=iXmDKlFkBkSKvea6lojrRX37Jh34NG8LHfci/L9C4DRQdUR8IY5r/hlgoRfM9aXb3o1qIjif1YqDaG03tkJndaAAToy2lNOPajjq0XvLMZpLjANIfDM7GdQAKzO/ZnFg6Y8Z/l7WVqPUe9BhW1EMrcaNgXh4pqyZ/Cf84fvEiek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=charbonnet.com; spf=pass smtp.mailfrom=charbonnet.com; dkim=pass (2048-bit key) header.d=charbonnet.com header.i=@charbonnet.com header.b=jakE6DCX; arc=none smtp.client-ip=162.0.218.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=charbonnet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=charbonnet.com
Received: from MTA-13-4.privateemail.com (mta-13-1.privateemail.com [198.54.122.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by h5.fbrelay.privateemail.com (Postfix) with ESMTPSA id 4Yfjwb5SCnz31bs;
	Fri, 24 Jan 2025 16:30:39 +0000 (UTC)
Received: from mta-13.privateemail.com (localhost [127.0.0.1])
	by mta-13.privateemail.com (Postfix) with ESMTP id 4YfjwQ58zYz3hhXy;
	Fri, 24 Jan 2025 11:30:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=charbonnet.com;
	s=default; t=1737736230;
	bh=www1XGD6vX+enfGJCQJ8r3Eaffu76oKwdIN6jkMDBtI=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=jakE6DCXJjVkLWxcNgnCW8XKRl2TiS3SziuUpTu9i2yHFLmfpxlOLChLD16exMwMj
	 b+ORQtbNMqrODulZTXyTjHhh75bJJDmG/HAq272WGfTl/9aBBYZCFOf72zGQTGiEEi
	 L+jF42Gw+H/apqUDIsqFPHHc1BVifU+6eEZ1NUDg5CaE0aGivdyRYTInze+Rm08CpY
	 1MMOVINtCVkPCvnxAIyNtqeVnZrrzKCy7aCW8+93tcz0ljm40ccr0PuXt/qRb4Qvjr
	 0+7gqg5td+aVwXZpTIJ4/os2rhsc4HNgPkRDUWkXwm2XWv6himDgnDzspgyAsmlmCo
	 QhQMh45oo+FQw==
Received: from [192.168.1.91] (2019.charbonnet.com [69.30.239.106])
	by mta-13.privateemail.com (Postfix) with ESMTPA;
	Fri, 24 Jan 2025 11:30:23 -0500 (EST)
Message-ID: <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
Date: Fri, 24 Jan 2025 10:30:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Xan Charbonnet <xan@charbonnet.com>
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Pavel Begunkov <asml.silence@gmail.com>,
 Salvatore Bonaccorso <carnil@debian.org>
Cc: 1093243@bugs.debian.org, Jens Axboe <axboe@kernel.dk>,
 Bernhard Schmidt <berni@debian.org>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
 <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
Content-Language: en-US
In-Reply-To: <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP

On 1/24/25 04:33, Pavel Begunkov wrote:
> Thanks for narrowing it down. Xan, can you try this change please?
> Waiters can miss wake ups without it, seems to match the description.
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 9b58ba4616d40..e5a8ee944ef59 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>    	io_commit_cqring(ctx);
>    	spin_unlock(&ctx->completion_lock);
>    	io_commit_cqring_flush(ctx);
> -	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
> +		smp_mb();
>    		__io_cqring_wake(ctx);
> +	}
>    }
>    
>    void io_cq_unlock_post(struct io_ring_ctx *ctx)
> 


Thanks Pavel!  Early results look very good for this change.  I'm now 
running 6.1.120 with your added smp_mb() call.  The backup process which 
had been quickly triggering the issue has been running longer than it 
ever did when it would ultimately fail.  So that's great!

One sour note: overnight, replication hung on this machine, which is 
another failure that started happening with the jump from 6.1.119 to 
6.1.123.  The machine was running 6.1.124 with the 
__io_cq_unlock_post_flush function removed completely.  That's the 
kernel we had celebrated yesterday for running the backup process 
successfully.

So, we might have two separate issues to deal with, unfortunately.

This morning, I found that replication had hung and was behind by some 
35,000 seconds.  I attached gdb and then detached it, which got things 
moving again (which goes the extra mile to prove that this is a very 
closely related issue).  Then it hung up again at about 25,000 seconds 
behind.  At that point I rebooted into the new kernel, the 6.1.120 
kernel with the added smp_mb() call.  The lag is now all the way down to 
5,000 seconds without hanging again.

It looks like there are 5 io_uring-related patches in 6.1.122 and 
another 1 in 6.1.123.  My guess is the replication is hitting a problem 
with one of those.

Unfortunately, a replication hang is much harder for me to reproduce 
than the issue with the backup procedure, which always failed within 15 
minutes.  It certainly looks to me like the patched 6.1.120 does not 
have the hang (but it's hard to be 100% certain).  Perhaps the next step 
is to apply the extra smp_mb() call to 6.1.123 and see if I can get 
replication to hang.


