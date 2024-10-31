Return-Path: <io-uring+bounces-4266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FBFA9B7BEB
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F9D51F21FB1
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 13:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1576D19DF75;
	Thu, 31 Oct 2024 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aioUJphG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B8113D886;
	Thu, 31 Oct 2024 13:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730382163; cv=none; b=pzCLiM55C7tJfs7lFkeaKzAaWqwptUa2oH4wcE85iH716dRujDIx/YlQUlqybBNY5ZV4zkp/0fb3jXcj8KmFJ2ISEvq4xcZ1CISlwXv9/Wvmx9Oy65Y7m6ZQjoxyGF+DXJNtA7gOc0hRdol1NH4wgaHeKNa7tLLO08KQ7Ce5l88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730382163; c=relaxed/simple;
	bh=CGL+7TVFEN775o/FDiZ1zGZhlsCfi6m3O5t2MrhJHRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f2zaw5dSj3eTerpv0LH0HRNllsjp2WqvCVcfP1baCquNd2Ey/Zc4PfYr//gNk9vberzyevA7YTDqsXLwpJv2OvRsPDcYLwiwAEvUKzPzHKQDPaYIfTn3CmCzkIynT/7LqhgY01rSGqpriguBRoAix7M1rM2pQV8Pt/wDgcIRrMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aioUJphG; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c94c4ad9d8so1249186a12.2;
        Thu, 31 Oct 2024 06:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730382159; x=1730986959; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pX4zcsVxZGwq44kVRTBXx/XCzgKmdkYFkLop4gp3280=;
        b=aioUJphGDUHk1Jhotjx7chQH26uforb/h3zwu20M2aQdjn7ty4AfQq3o9H98cj8sU+
         858OwKeoNajshiE2o3XaQekyycXCO5q9TWjHK55/i9PivEMpOMSuFAdyj6TVrCW9BbtB
         D5D/+zYfTzSnXouMVWAjpYvbcma7wrOrVPrd6ZFGM+sB3SLV59CFCjAXy6Qyh79YS+Hu
         tknrDd24ArjVjwsmHFaqruZiYm98INLyMMTjoXrKbmFNFGordrTGj/Xq05KgYSDZDgCJ
         pO1ZMhc2pyUUtkvubcaIvpp8CJdZB2AfwOtRb7c6fZ9v3p3HjsPV29q1/yKrqKV6VArr
         Amlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730382159; x=1730986959;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pX4zcsVxZGwq44kVRTBXx/XCzgKmdkYFkLop4gp3280=;
        b=bId/hmMvN1RhGMW/KfRG40YCGSeeNgADOPd2Ysds/8TmtyLb8e/GO5hp0UJQqr/YbE
         ZMuKOn4oXd95kRfhdbk4u2zdZJSkrVwJ7xeS+vzUXv4nWVEG4+SUVdJdTizBlKOUfm+C
         mjSw5m+9wROjeRiTe0YkKATndXlZJuadMUh0hBdNvrE/KvVFFyAnDf9CXMaA1Yf4r9Yr
         slVEKBwORcLvYRXKGH1SAMDPhssQtiMmartGRJjJuyXl+b8BETEFE7oQzA0gvHBPaTgx
         dNXxC1guJQsaZxQeEckcxZ/cMKirX9Ubd0Py5Uewj97jwo0pmstv9xniB5WipZzHRBLe
         X+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWY5o6/jHerwKv1LTd4mtKksF8VftGv3HXj1cZijXncPufyEXTah9hjsXlr4eiU+wsHAi5Yv2Ybc4ZMWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlBTXFMcfqBFa5/FFm7y75iC4kTh+N2fhqkxOZAaHy4mkt1I+U
	4uabZEAmAFrDwHgxnb07gkrWrMa9M31Soi7hDUdmcwFA8S2I6koD
X-Google-Smtp-Source: AGHT+IEj5vjkJGn4MjOBNZR5esb7mclsiAhN+/s7YqOrtDD2u/Ui9R49brusCHyMAM0ED7Dv61A1Vg==
X-Received: by 2002:a17:906:c113:b0:a9a:5e3a:641d with SMTP id a640c23a62f3a-a9e50cb0401mr339363266b.59.1730382158840;
        Thu, 31 Oct 2024 06:42:38 -0700 (PDT)
Received: from [192.168.42.141] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564c56acsm70988966b.77.2024.10.31.06.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 06:42:38 -0700 (PDT)
Message-ID: <05a899a1-7edd-45a1-8b1f-d29eaf99c194@gmail.com>
Date: Thu, 31 Oct 2024 13:42:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk> <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk> <ZyGjID-17REc9X3e@fedora>
 <ZyGx4JBPdU4VlxlZ@fedora> <d986221d-7399-4487-9c28-5d6f953510cd@kernel.dk>
 <ZyLxJdn7bboZMAcs@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyLxJdn7bboZMAcs@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 02:53, Ming Lei wrote:
> On Wed, Oct 30, 2024 at 07:20:48AM -0600, Jens Axboe wrote:
>> On 10/29/24 10:11 PM, Ming Lei wrote:
>>> On Wed, Oct 30, 2024 at 11:08:16AM +0800, Ming Lei wrote:
>>>> On Tue, Oct 29, 2024 at 08:43:39PM -0600, Jens Axboe wrote:
>>>
>>> ...
>>>
>>>>> You could avoid the OP dependency with just a flag, if you really wanted
>>>>> to. But I'm not sure it makes a lot of sense. And it's a hell of a lot
>>>>
>>>> Yes, IO_LINK won't work for submitting multiple IOs concurrently, extra
>>>> syscall makes application too complicated, and IO latency is increased.
>>>>
>>>>> simpler than the sqe group scheme, which I'm a bit worried about as it's
>>>>> a bit complicated in how deep it needs to go in the code. This one
>>>>> stands alone, so I'd strongly encourage we pursue this a bit further and
>>>>> iron out the kinks. Maybe it won't work in the end, I don't know, but it
>>>>> seems pretty promising and it's soooo much simpler.
>>>>
>>>> If buffer register and lookup are always done in ->prep(), OP dependency
>>>> may be avoided.
>>>
>>> Even all buffer register and lookup are done in ->prep(), OP dependency
>>> still can't be avoided completely, such as:
>>>
>>> 1) two local buffers for sending to two sockets
>>>
>>> 2) group 1: IORING_OP_LOCAL_KBUF1 & [send(sock1), send(sock2)]
>>>
>>> 3) group 2: IORING_OP_LOCAL_KBUF2 & [send(sock1), send(sock2)]
>>>
>>> group 1 and group 2 needs to be linked, but inside each group, the two
>>> sends may be submitted in parallel.
>>
>> That is where groups of course work, in that you can submit 2 groups and
>> have each member inside each group run independently. But I do think we
>> need to decouple the local buffer and group concepts entirely. For the
>> first step, getting local buffers working with zero copy would be ideal,
>> and then just live with the fact that group 1 needs to be submitted
>> first and group 2 once the first ones are done.
> 
> IMHO, it is one _kernel_ zero copy(_performance_) feature, which often imply:
> 
> - better performance expectation
> - no big change on existed application for using this feature

Yes, the feature doesn't make sense without appropriate performance
wins, but I outright disagree with "there should be no big uapi
changes to use it". It might be nice if the user doesn't have to
change anything, but I find it of lower priority than performance,
clarity of the overall design and so on.

> Application developer is less interested in sort of crippled or immature
> feature, especially need big change on existed code logic(then two code paths
> need to maintain), with potential performance regression.

Then we just need avoid creating a "crippled" feature, I believe
everyone is on the same page here. As for maturity, features don't
get there at the same pace, extra layers of complexity definitely
do make getting into shape much slower. You can argue you like how
the uapi turned to be, though I believe there are still rough edges
if we consider it a generic feature, but the kernel side of things is
fairly complicated.

> With sqe group and REQ_F_GROUP_KBUF, application just needs lines of
> code change for using the feature, and it is pretty easy to evaluate
> the feature since no any extra logic change & no extra syscall/wait
> introduced. The whole patchset has been mature enough, unfortunately
> blocked without obvious reasons.
> 
>>
>> Once local buffers are done, we can look at doing the sqe grouping in a
>> nice way. I do think it's a potentially powerful concept, but we're
>> going to make a lot more progress on this issue if we carefully separate
>> dependencies and get each of them done separately.
> 
> One fundamental difference between local buffer and REQ_F_GROUP_KBUF is
> 
> - local buffer has to be provided and used in ->prep()
> - REQ_F_GROUP_KBUF needs to be provided in ->issue() instead of ->prep()

I'd need to take a look at that local buffer patch to say, but likely
there is a way to shift all of it to ->issue(), which would be more
aligned with fixed file resolution and how links use it.

-- 
Pavel Begunkov

