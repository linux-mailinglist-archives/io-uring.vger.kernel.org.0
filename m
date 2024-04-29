Return-Path: <io-uring+bounces-1671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4578B5E08
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 17:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25C09282AC4
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 15:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E8282881;
	Mon, 29 Apr 2024 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aF4agWVB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C96982883;
	Mon, 29 Apr 2024 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714405706; cv=none; b=LRTKxU3GkFuplWjl0wNWnYybiAVnbC5bJYWp6AriGy22g53rBkmyb6+DU03NrOWudr9YdtNQtru83avv27seaBZwiK6+TnocAkz8NdBklYwyh3dWwtTUklnDE0Krd16S/VKAKvVRryId3HLdJAknrNt9+uZ6OiVFICEisgC98sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714405706; c=relaxed/simple;
	bh=qPCLeREh/UsNAYopgfH6ctKP/eyQkIqnKa8izDu/Vp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pck7L+KampxMu53TtYcmaekglK+D9blDszXVHAUQmeK2G5vzaLjVMcBjkOFl1eTrNs7KlY2ESGUAJLsctMMcl8lIinGHaAY7vs8jGFobsdbBA8F26yer4YT+MhaT6XW597MFoBumk5NwU2dQ0EYPuqFD04wZwfe2sOu1OIHT7l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aF4agWVB; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-41c011bb920so9117075e9.1;
        Mon, 29 Apr 2024 08:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714405703; x=1715010503; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=auGjB8n+8u0YZ9tP0kG5HRe5tevFQJeUANJT949K2+s=;
        b=aF4agWVBWV7tnho4GZy6PMsziq1L9ofVXKn8hsIqhCzBDAU/J8Vy6ZDdlTxquPTUFC
         dAG3ihzR2XlcRnkfF/7EFQlkOCA8BQ9CaZa5FaO6U67ZmxPt1rpt1VZmxL1q1FOo0Psk
         mJCQVYigTzOgI33e5P86iWbIBxnUT1UVUoldYEX/9kiklHMCj7P7rmVTsXjg3jAkhbFX
         aTuoc0Fsu/jxTaiKJ8pmPoLxzaiejnZV0RdjygnkV+vCsUUmD5cAqWZ16iTubjReJ/ha
         TxT51CtGKRQzuOMPz9uz5HQVToHAWKi+w3YpKUNSnnJOiDfMPI0vLRnRnhq5Gsp7sY07
         afeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714405703; x=1715010503;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=auGjB8n+8u0YZ9tP0kG5HRe5tevFQJeUANJT949K2+s=;
        b=o/Pv7lMSAtasnJk499HXVy6C6KGZxyj77rl+B/tPQXR3wcy9fz97vWE8dmVutDp9ui
         Ng4Q/l8WzfSwW+lXcPlSJjTdVgrfh1JSJOf+8OfAX6A5G0CnL5mDtY12x2BBVf/aNU32
         yLO82y89cNgcUGy3K5oQ6vyT43hhp9s5e6FJQipfgShJjhPju1NJBewOzM2shVLXGePx
         vPmcyDtLXH6Sb+XMSrLxr/06I1qR/kyS2ek9rd9HXrQSxACbaWRkm2nHlSqn6NdV3ZR2
         k4jT+h/01++9O+ddkld+jjlcQ8iGXXS00IgiOazOSFX42RLPkaXMfvxLhEi9uJM2Zm1E
         MU8w==
X-Forwarded-Encrypted: i=1; AJvYcCUB6MbPvjogEmG5u7ZkwQKAkQnJuVNPESweSV/ksuenn5Tb/+LBHPeGlfkn4qBjloJNuM4vfVbEkYT75/MfX7oogPQqbc0SzVDBMJtbjja+GLctCHScxDmsMwsz20dVRTFlAMXwOA==
X-Gm-Message-State: AOJu0YyBN4DQ2d5aOaGDINNLwABEkpV9OQphNTv+nL3OtGs7WUqsOpgA
	FAj07NoEXWN21uAvONWZ9afa2RDWxZShkqNL3z1hD8UzbZIKJQoBG2x1Bw==
X-Google-Smtp-Source: AGHT+IFfM34bs8p6dtR1mnQ7pdgt5BgajEoGID9wg4/j7hPDMdPaiyRMVk37QNSEWmxf3QLwh1609A==
X-Received: by 2002:a05:600c:3ba4:b0:418:9d4a:1ba5 with SMTP id n36-20020a05600c3ba400b004189d4a1ba5mr45758wms.6.1714405702577;
        Mon, 29 Apr 2024 08:48:22 -0700 (PDT)
Received: from [192.168.42.252] (82-132-212-208.dab.02.net. [82.132.212.208])
        by smtp.gmail.com with ESMTPSA id c9-20020a05600c0a4900b0041b43d2d745sm17172235wmq.7.2024.04.29.08.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 08:48:22 -0700 (PDT)
Message-ID: <19de460c-ac83-40ff-8113-3bb7e75f194a@gmail.com>
Date: Mon, 29 Apr 2024 16:48:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>, Kevin Wolf <kwolf@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com> <Zihi3nDAJg1s7Cws@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zihi3nDAJg1s7Cws@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/24 02:39, Ming Lei wrote:
> On Tue, Apr 23, 2024 at 03:08:55PM +0200, Kevin Wolf wrote:
>> Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
>>> On 4/7/24 7:03 PM, Ming Lei wrote:
>>>> SQE group is defined as one chain of SQEs starting with the first sqe that
>>>> has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
>>>> doesn't have it set, and it is similar with chain of linked sqes.
>>>>
>>>> The 1st SQE is group leader, and the other SQEs are group member. The group
>>>> leader is always freed after all members are completed. Group members
>>>> aren't submitted until the group leader is completed, and there isn't any
>>>> dependency among group members, and IOSQE_IO_LINK can't be set for group
>>>> members, same with IOSQE_IO_DRAIN.
>>>>
>>>> Typically the group leader provides or makes resource, and the other members
>>>> consume the resource, such as scenario of multiple backup, the 1st SQE is to
>>>> read data from source file into fixed buffer, the other SQEs write data from
>>>> the same buffer into other destination files. SQE group provides very
>>>> efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
>>>> submitted in single syscall, no need to submit fs read SQE first, and wait
>>>> until read SQE is completed, 2) no need to link all write SQEs together, then
>>>> write SQEs can be submitted to files concurrently. Meantime application is
>>>> simplified a lot in this way.
>>>>
>>>> Another use case is to for supporting generic device zero copy:
>>>>
>>>> - the lead SQE is for providing device buffer, which is owned by device or
>>>>    kernel, can't be cross userspace, otherwise easy to cause leak for devil
>>>>    application or panic
>>>>
>>>> - member SQEs reads or writes concurrently against the buffer provided by lead
>>>>    SQE
>>>
>>> In concept, this looks very similar to "sqe bundles" that I played with
>>> in the past:
>>>
>>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
>>>
>>> Didn't look too closely yet at the implementation, but in spirit it's
>>> about the same in that the first entry is processed first, and there's
>>> no ordering implied between the test of the members of the bundle /
>>> group.
>>
>> When I first read this patch, I wondered if it wouldn't make sense to
>> allow linking a group with subsequent requests, e.g. first having a few
>> requests that run in parallel and once all of them have completed
>> continue with the next linked one sequentially.
>>
>> For SQE bundles, you reused the LINK flag, which doesn't easily allow
>> this. Ming's patch uses a new flag for groups, so the interface would be
>> more obvious, you simply set the LINK flag on the last member of the
>> group (or on the leader, doesn't really matter). Of course, this doesn't
>> mean it has to be implemented now, but there is a clear way forward if
>> it's wanted.
> 
> Reusing LINK for bundle breaks existed link chains(BUNDLE linked to existed
> link chain), so I think it may not work.
> 
> The link rule is explicit for sqe group:
> 
> - only group leader can set link flag, which is applied on the whole
> group: the next sqe in the link chain won't be started until the
> previous linked sqe group is completed
> 
> - link flag can't be set for group members
> 
> Also sqe group doesn't limit async for both group leader and member.
> 
> sqe group vs link & async is covered in the last liburing test code.
> 
>>
>> The part that looks a bit arbitrary in Ming's patch is that the group
>> leader is always completed before the rest starts. It makes perfect
>> sense in the context that this series is really after (enabling zero
>> copy for ublk), but it doesn't really allow the case you mention in the
>> SQE bundle commit message, running everything in parallel and getting a
>> single CQE for the whole group.
> 
> I think it should be easy to cover bundle in this way, such as add one new
> op IORING_OP_BUNDLE as Jens did, and implement the single CQE for whole group/bundle.
> 
>>
>> I suppose you could hack around the sequential nature of the first
>> request by using an extra NOP as the group leader - which isn't any
>> worse than having an IORING_OP_BUNDLE really, just looks a bit odd - but
>> the group completion would still be missing. (Of course, removing the
>> sequential first operation would mean that ublk wouldn't have the buffer
>> ready any more when the other requests try to use it, so that would
>> defeat the purpose of the series...)
>>
>> I wonder if we can still combine both approaches and create some
>> generally useful infrastructure and not something where it's visible
>> that it was designed mostly for ublk's special case and other use cases
>> just happened to be enabled as a side effect.
> 
> sqe group is actually one generic interface, please see the multiple copy(
> copy one file to multiple destinations in single syscall for one range) example
> in the last patch, and it can support generic device zero copy: any device internal
> buffer can be linked with io_uring operations in this way, which can't
> be done by traditional splice/pipe.
> 
> I guess it can be used in network Rx zero copy too, but may depend on actual
> network Rx use case.

I doubt. With storage same data can be read twice. Socket recv consumes
data. Locking a buffer over the duration of another IO doesn't really sound
plausible, same we returning a buffer back. It'd be different if you can
read the buffer into the userspace if something goes wrong, but perhaps
you remember the fused discussion.

-- 
Pavel Begunkov

