Return-Path: <io-uring+bounces-6132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9535FA1CF10
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2025 23:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2A731886AA6
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2025 22:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD5A4F218;
	Sun, 26 Jan 2025 22:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=charbonnet.com header.i=@charbonnet.com header.b="jA3DZRhb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.charbonnet.com (2024.charbonnet.com [96.126.120.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3415672;
	Sun, 26 Jan 2025 22:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.126.120.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737932245; cv=none; b=ibJmp8CMM3HJNj9MU/7QhC9sDAnSsO38sreX9EW1YhGwPcQ8p+jvnRgo7+FwFLNMfeaFYYul2cB0gQRp72fV2ngOEAjW1QeR2+9r1HqCQw/gU9MTm9jTowl4Pb3T9ipHNCuLnCJflk500S9dklhelOgTZPlaOy8gAD82bz7UXjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737932245; c=relaxed/simple;
	bh=yx7SHhHWK9Lw5CC2KqCTNCpn80eR5UVm53gvGlBGmM4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=e9ke1yjBnvDF7XOWN92gOdAz43fqI+nngXCf7WcJOCBZoe2qjCdTx27NPHnReaFuTTtmknlrxAUQymcTpAAztQ7ua6IuAoNNCNm3gDbP69Z5ePwJniFqFFJuwyazxQTyF0l6W7NBIpM3RYqTN7kQhv7sboZEwqXA98wEGv6H+tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=charbonnet.com; spf=pass smtp.mailfrom=charbonnet.com; dkim=pass (1024-bit key) header.d=charbonnet.com header.i=@charbonnet.com header.b=jA3DZRhb; arc=none smtp.client-ip=96.126.120.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=charbonnet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=charbonnet.com
Received: from [192.168.1.91] (unknown [136.49.120.240])
	by mail.charbonnet.com (Postfix) with ESMTPSA id 5637182553;
	Sun, 26 Jan 2025 16:48:58 -0600 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=charbonnet.com;
	s=2024121401; t=1737931741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qZNtCZ5u4Huw6JMS0aSdWhqmVcj52WkMxglgye6aiXY=;
	b=jA3DZRhbxOzy0hQo2UJvYEv+NRqa5VzUWoGwHXyvz7ezFFDe9gJ7JtJAPpuV3tKY7JluO5
	k5olgaFh/5tkR+m7alGXuQzJYTf6zQxJcyH48wuRNYHKW8+87j7kg3rQ+Bwq9ACA7x8LS5
	NbIZEoSQ7D7Ml9aPwmnUw142WOSnwQ8=
Message-ID: <a2f5ea66-7506-4256-b69c-a2d6c2f72eb4@charbonnet.com>
Date: Sun, 26 Jan 2025 16:48:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Xan Charbonnet <xan@charbonnet.com>
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Jens Axboe <axboe@kernel.dk>, Salvatore Bonaccorso <carnil@debian.org>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: 1093243@bugs.debian.org, Bernhard Schmidt <berni@debian.org>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
 <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
 <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
 <8af1733b-95a8-4ac9-b931-6a403f5b1652@gmail.com>
 <Z5P5FNVjn9dq5AYL@eldamar.lan>
 <13ba3fc4-eea3-48b1-8076-6089aaa978fb@kernel.dk>
Content-Language: en-US
In-Reply-To: <13ba3fc4-eea3-48b1-8076-6089aaa978fb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Since applying the final patch on Friday, I have seen no problems with 
either the backup snapshot or catching up with replication.  It sure 
seems like things are all fixed.  I haven't yet tried it on our 
production Galera cluster, but I expect to on Monday.

Here are Debian packages containing the modified kernel.  Use at your 
own risk of course.  Any feedback about how this works or doesn't work 
would be very helpful.

https://charbonnet.com/linux-image-6.1.0-29-with-proposed-1093243-fix_amd64.deb
https://charbonnet.com/linux-image-6.1.0-30-with-proposed-1093243-fix_amd64.deb




On 1/24/25 14:51, Jens Axboe wrote:
> On 1/24/25 1:33 PM, Salvatore Bonaccorso wrote:
>> Hi Pavel,
>>
>> On Fri, Jan 24, 2025 at 06:40:51PM +0000, Pavel Begunkov wrote:
>>> On 1/24/25 16:30, Xan Charbonnet wrote:
>>>> On 1/24/25 04:33, Pavel Begunkov wrote:
>>>>> Thanks for narrowing it down. Xan, can you try this change please?
>>>>> Waiters can miss wake ups without it, seems to match the description.
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index 9b58ba4616d40..e5a8ee944ef59 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>>>>>         io_commit_cqring(ctx);
>>>>>         spin_unlock(&ctx->completion_lock);
>>>>>         io_commit_cqring_flush(ctx);
>>>>> -    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>>>>> +    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
>>>>> +        smp_mb();
>>>>>             __io_cqring_wake(ctx);
>>>>> +    }
>>>>>     }
>>>>>     void io_cq_unlock_post(struct io_ring_ctx *ctx)
>>>>>
>>>>
>>>>
>>>> Thanks Pavel!  Early results look very good for this change.  I'm now running 6.1.120 with your added smp_mb() call.  The backup process which had been quickly triggering the issue has been running longer than it ever did when it would ultimately fail.  So that's great!
>>>>
>>>> One sour note: overnight, replication hung on this machine, which is another failure that started happening with the jump from 6.1.119 to 6.1.123.  The machine was running 6.1.124 with the __io_cq_unlock_post_flush function removed completely.  That's the kernel we had celebrated yesterday for running the backup process successfully.
>>>>
>>>> So, we might have two separate issues to deal with, unfortunately.
>>>
>>> Possible, but it could also be a side effect of reverting the patch.
>>> As usual, in most cases patches are ported either because they're
>>> fixing sth or other fixes depend on it, and it's not yet apparent
>>> to me what happened with this one.
>>
>> I researched bit the lists, and there was the inclusion request on the
>> stable list itself. Looking into the io-uring list I found
>> https://lore.kernel.org/io-uring/CADZouDRFJ9jtXHqkX-PTKeT=GxSwdMC42zEsAKR34psuG9tUMQ@mail.gmail.com/
>> which I think was the trigger to later on include in fact the commit
>> in 6.1.120.
> 
> Yep indeed, was just looking for the backstory and that is why it got
> backported. Just missed the fact that it should've been an
> io_cqring_wake() rather than __io_cqring_wake()...
> 


