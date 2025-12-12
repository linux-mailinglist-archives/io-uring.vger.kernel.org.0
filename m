Return-Path: <io-uring+bounces-11031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9AECB9C18
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 21:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EDE8A30146FB
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 20:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B333101CD;
	Fri, 12 Dec 2025 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Nfnwe+tE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA730E826
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765570948; cv=none; b=oMdqsf3s/YdGmvv3i9xvLp0SBble/uy+Re5xaSUp9/PbwjLJduGUbJzafPxBFTZQwKzqLovi8zrpxTTYNTVWPnA8ZI034KJLkultw2T+GARNd0WV0Yq4eHvU15+TvDe3kit921MyEwa3QgzrBiljTkG8O1A8/icKKnPEReuW+MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765570948; c=relaxed/simple;
	bh=VImwoDqcJByfBcsN9w73MoRjMwuVT3AX7+HeNzvNxu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gBo0wXyTw3fqOQaAvEtHR5pdZl0fh1T3w0jvJBhoZyHZJ1AH3aIa9UgXslmoi95cdeSHYxjZfMR1gCylB1c4y6RaJ/84yCt8PTGYMeN7b4jxhn19//LAkh8WJuaHTL1X7/uA4W2l4zKq+9HAlzeINzt4IBIzWkmNASte/Ehoz98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Nfnwe+tE; arc=none smtp.client-ip=209.85.215.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c0bccb8037eso1311434a12.1
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 12:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765570944; x=1766175744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yRVBXqzKpqer/AL5KR24suRfGkOaLd0tdvd7Xh2UsMY=;
        b=Nfnwe+tEDxbLdz9NAL96fOCMqeN6iD8MzF9uXW4ldxuRdoWLpxq5Sd/MkIEI4o76uR
         1ifkkieD4aIDX7f+FLynBRMSCByY4DqJff2Ili5m0eZ+Dk6Zv7s558TDtHp4DIhHsulf
         7oSJbfrpg0mJ3sH9pQij6lPGAl+nPFSVxx2XI+UlQRKc1wN4XGMLkCB6YOnSGQZbGboS
         2CmncPXmFW9I0lhhvlx07D+uNGJ/MQLSYrP6OWr9xFXO4ntwwHn963hwFlTqftQrmKXD
         4Hbd/m+ryMKeMkTniJTiy377+Ov7wW7FBy3jUt5njdjN4GEULX3IKO3Av9htDtnSN7sB
         CEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765570944; x=1766175744;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yRVBXqzKpqer/AL5KR24suRfGkOaLd0tdvd7Xh2UsMY=;
        b=TNvL6Yw6TDro6IuiCPCUMc71wOXM/nT+Ixfp/EI/A9NhBrF4jZG1dSLzIES0EZdXlc
         fS2eDWB/N5/QpKIHbW4iZKT0RpWQo74VSL7AcGSZPLZNgOP+rdCdP1V4KaUVQ7b/ilbh
         jsj/0WQXJsnCJa3lYEDuXO8pAybTfFjjzBeaVjQLi6nlb9ZQImgX5WjtwaWdAg/dFiPf
         lVDTPxJ+t5jQjrpCbx13Z4q56p3FBJUYyreO5cjff060JpUjpy8E/8cT6p9yAKuXNAzJ
         wprWdZ7/XLdyNjyGV7QFZJIOcnNtQ+usWt9/CL8sLukbbuNsliNj7Mi/cGVgTOI+UUqJ
         NSoA==
X-Forwarded-Encrypted: i=1; AJvYcCWtXAz0l+1tUgURSVoj7FRQYHrx6uqdJbjmwvDHAgoL+zyriaCZ4O8BU0POoaUG4pD5wn+BgiUhyw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi/HO7DefZF6RjAa2inBCnkC4NsJP0nHJM/+To855+JPIHub4n
	g104Le5sMwpRXVGJN9fG7WU/EXAB6egLMufhbCtGGRKhX1ecGXW5/XhgOiu2I9MlkSY=
X-Gm-Gg: AY/fxX7v+y4VezcW6bxyBErtBZBV0mbojKe6vC3R/xByonNms0JoYRMuhw/WnQVJxIU
	CGHK0uyR8fSsK9uk7ZlDHv6y6E+fH1EZfMfISs8GvktlsetBr9W281FHhvWxn28oVzwASH1rthW
	AMj3CQpO8orQLsACq0tnbTHhKAoENZuv1+shloApaHArcO+f4/HH/voWxe9dqrKZPxyTMN68iQm
	h6jokNWNquArDLwEB9pOQQCjHj5n7kf52Hc9p25Ljfut6r1HGz889s50z4DEp96H/0n3K/vrcuM
	K+tB+ZIIIyW6FvvmBTwENOOT4xNxVHICJkW9XKjVlYXdAztQgJej1qER4gnm/AA0BLoDuhpsfX1
	XfJLsSt3GC9CVma4aKIIqkXi2LO+IMkwT4XvR7LJ1dCtGC7RqEmSzCtmnz5EyvwdfMP8sLYSsFj
	qejU0Yl6gDqKGZVeNFUhA4Sb3yEPmTlSMCI79JC6FjSFE+dPHr0RudsOCJ1bnK
X-Google-Smtp-Source: AGHT+IHcPmgk7zwgfbvNA7wyTsnp/0Dc8VVOZQLyMKmoQpnBe+hFonc4sS2XDjOcBrqRSDcqbme+kw==
X-Received: by 2002:a05:7301:1748:b0:2a4:3593:968a with SMTP id 5a478bee46e88-2ac321fe3ddmr1924355eec.7.1765570944306;
        Fri, 12 Dec 2025 12:22:24 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac342eeaaasm5093285eec.6.2025.12.12.12.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 12:22:23 -0800 (PST)
Message-ID: <8035dbf3-8b6c-4a6a-875a-0c59d3800aab@kernel.dk>
Date: Fri, 12 Dec 2025 13:22:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
 <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
 <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com>
 <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
 <38972bbc-fb6f-42c5-bd17-b19db134dfad@kernel.dk>
 <21672cc5-abc2-4595-94b2-3ab0c2d40cf3@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <21672cc5-abc2-4595-94b2-3ab0c2d40cf3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/25 2:49 AM, Fengnan Chang wrote:
> 
> 
> ? 2025/12/12 16:58, Jens Axboe ??:
>> On 12/11/25 10:11 PM, Jens Axboe wrote:
>>> On 12/11/25 7:12 PM, Fengnan Chang wrote:
>>>>
>>>> ? 2025/12/12 09:53, Jens Axboe ??:
>>>>> On 12/11/25 6:41 PM, Fengnan Chang wrote:
>>>>>> Oh, we can't add nr_events == iob.nr_reqs check, if
>>>>>> blk_mq_add_to_batch add failed, completed IO will not add into iob,
>>>>>> iob.nr_reqs will be 0, this may cause io hang.
>>>>> Indeed, won't work as-is.
>>>>>
>>>>> I do think we're probably making a bigger deal out of the full loop than
>>>>> necessary. At least I'd be perfectly happy with just the current patch,
>>>>> performance should be better there than we currently have it. Ideally
>>>>> we'd have just one loop for polling and catching the completed items,
>>>>> but that's a bit tricky with the batch completions.
>>>> Yes, ideally one loop would be enough, but given that there are also
>>>> multi_queue ctx, that doesn't seem to be possible.
>>> It's not removing the double loop, but the below could help _only_
>>> iterate completed requests at the end. Rather than move items between
>>> the current list at the completion callback, have a separate list just
>>> for completed requests. Then we can simply iterate that, knowing all of
>>> them have completed. Gets rid of the ->iopoll_completed as well, and
>>> then we can move the poll_refs. Not really related at all, obviously
>>> this patch should be split into multiple pieces.
>>>
>>> This uses a lockless list. But since the producer and consumer are
>>> generally the same task, that should not add any real overhead. On top
>>> of the previous one I sent. What do you think?
>> Ran some quick testing, as one interesting case is mixing slower and
>> faster devices. Let's take this basic example:
>>
>> t/io_uring -p1 -d128 -b512 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1 -t1 -n2 /dev/nvme32n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
>>
>> where nvme32n1 is about 1.27M IOPS, and the other 3 do about 3.3M IOPS,
>> and we poll 2 devices with each IO thread. With the current kernel, we
>> get:
>>
>> IOPS=5.18M, BW=2.53GiB/s, IOS/call=31/32
>> IOPS=5.19M, BW=2.53GiB/s, IOS/call=31/31
>> IOPS=5.17M, BW=2.53GiB/s, IOS/call=31/31
>>
>> and with the two patches we get:
>>
>> IOPS=6.54M, BW=3.19GiB/s, IOS/call=31/31
>> IOPS=6.52M, BW=3.18GiB/s, IOS/call=31/31
>> IOPS=6.52M, BW=3.18GiB/s, IOS/call=31/31
>>
>> or about a 25% improvement. This is mostly due to the issue you
>> highlighted, where you end up with later completions (that are done)
>> being stuck behind waiting on a slower completion.
>>
>> Note: obviously 1 thread driving multiple devices for polling could
>> still be improved, and in fact it does improve if we simply change -c32
>> to something lower. The more important case is the one you identified,
>> where different completion times on the same device will hold
>> completions up. Multi device polling is just an interesting way to kind
>> of emulate that, to an extent.
>>
>> This effect is (naturally) also apparent in the completion latencies as
>> well, particularly in the higher percentiles.
>>
>> Ran peak testing too, and it's better all around than before.
> I love the patch, I had a similar thought, this addresses my concern,  I simple tested it
> and the performance is a bit better than the previous performance.
> 
> base IOPS is 725K,  previous IOPS is 782K, now 790k.
> It looks like all the problems are solved,I 'll do more testing next week.

Nice, thanks! FWIW, I put the patches in a branch here, just to have
them somewhat organized and easier to iterate/test on:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-iopoll

-- 
Jens Axboe

