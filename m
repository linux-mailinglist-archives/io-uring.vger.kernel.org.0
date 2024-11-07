Return-Path: <io-uring+bounces-4547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3228A9C0CCD
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:23:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FB9D1C22600
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690E52161FA;
	Thu,  7 Nov 2024 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zykuer6S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E4DDBE;
	Thu,  7 Nov 2024 17:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731000216; cv=none; b=PM2GmhySn9ObzmZ9/VaebOexBTZ6Njvg9mg4tx/8wiitjH/Gy1c8XEhqlMMRqsQm8/LotKFbCNWK7LpNR1n/XuZDOBYoqt2ZOSCX8SeGzl12j+yZ4H+voh2vhShi3wOk3ljCuGUcWS5L/3NA/eNz4G1bH8f5vhEf/fxrvoAmJpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731000216; c=relaxed/simple;
	bh=GiEBH3vCaFny3F9wCmysPBdsf2lj75atnrwXemAxTp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EqzW7wq2YUhoAhpdMQqUHrphAS3pibqIiJZt34UFLxxOZx7qRdmlFHL8ArL1AsBKZSZIFWHUhMum1nCSSbuZYwkzHBFZTGo5izGkRwvAmOo/ScgUrUu5aSpVi5Ksqxx/O07/csRG+UT5t1ZxgPb+4YkVKgYWmd5HwQht70LcCKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zykuer6S; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9a16b310f5so195511366b.0;
        Thu, 07 Nov 2024 09:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731000212; x=1731605012; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9FOmBpO65NUUZbynSIJljWcZSxtJSzr/BEmXGDAexTM=;
        b=Zykuer6S6yeP15AYrU1FHU5KLcR1LBtunF5SopQRn4gZvKgwoSTO+hCiYQ7qzL+SeE
         YMS/c3Hq5Zu6GOhdbKHnBlXg3wdj/UIWX4u7ngBrXICa9/ZSx11iYqFt7wfrv8cEz5il
         dyYY1V2N/hcJEWbXjjyN7InwL8C7otYyiYETWaKbdpjRGgkLu3lauQE6pJbx0TXXJgJU
         1QiQyO7QxySfqvCc8RbVDlitO4om2MESy5Qsz1AFAQ9rEck+quzH67pXGY3U56quUUNA
         KaoTXFWPkEvCkICzgtxdZiw6BzqOSt8Au65f5anpTJbQFxmKe2l3r3ltxxdctTYFVmZh
         OIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731000212; x=1731605012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9FOmBpO65NUUZbynSIJljWcZSxtJSzr/BEmXGDAexTM=;
        b=swsP+TUpTVxmeVr13oxfrvqwRLc8e1uIcBiyuAr4zm6CgKMgOgkk/wOWGNDwCtHUM+
         D04Z9RbZHdVFiJ8RmTfoerZu6DKeMO7EiOchgmWd14fMPZ2scCgGS7QlOieZdaOg0E+2
         fv+BLAw8s6UfR3EgcK6CYNIQpAb+W3hEFdLd6RI635BhV921djNIL1o5lubLS2c8+JZr
         bvruR7AwEqMd6tgXf+IUf+KGtYmIR6G7zKD5GuZY7C7WThSbAGzRQsZOJtR8kB+vO4RU
         D3d2WJciJ+Dh9rz+YuYNeSK2BBj3HkDYq7PAAuXkTKDWufPFr7sHWi3hjS1Q6PQYsg92
         ovxg==
X-Forwarded-Encrypted: i=1; AJvYcCV9YW/e+sgRVDYWTacfs6HJaJFAr+z6Z5NG+9SffD27+i7Kj4W2lsfJ+GQKrcREliRkjL+YUZoGPw==@vger.kernel.org, AJvYcCVt63zz0U1aUvPXkH5ClJ62LV5E6ZTJHt5+BAvqfzncp4yXxB7y40nZ4lnSAE0Y8XVFn5r17lTJv02Z7/8=@vger.kernel.org, AJvYcCWDRoqlgMxFrFPFeAaJ/275ygzvuF8ohCIgQVLSpIQ7yQXHwJP01AGOXBywPUFj6++rm5jKwSdOGJLKiQ==@vger.kernel.org, AJvYcCXQKsxlzOqpn9tSrRQhsBTEzsuvBr4EEey/zX0FXf0J+8avmyCyYa0tWgr4LKN2SBGMdivfy1iSjeSUMyku9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhMBow1XKz8E08JiuvwlQ+EFg0z8td6RgexZvxMXqMQEjDXTD4
	NakwF7b7G8VOE4tL/5xk9IzcyHz7NT6WIoOcwvKu/vYonVZj3Am+
X-Google-Smtp-Source: AGHT+IGjmKySyNTN/8QcAW8bxivaq94CNWApyrUQEWFwxsq+VaX7hSp+J5pWWeh6pYc6mWGzASLRLw==
X-Received: by 2002:a17:907:6ea4:b0:a9a:dc3:c86e with SMTP id a640c23a62f3a-a9eeb36c852mr77812166b.11.1731000211235;
        Thu, 07 Nov 2024 09:23:31 -0800 (PST)
Received: from [192.168.42.11] (82-132-217-53.dab.02.net. [82.132.217.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0def54asm122435866b.157.2024.11.07.09.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 09:23:30 -0800 (PST)
Message-ID: <b11cc81d-08b7-437d-85b4-083b84389ff1@gmail.com>
Date: Thu, 7 Nov 2024 17:23:29 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] io_uring/rw: add support to send metadata along
 with read/write
To: Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
 anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
References: <20241030180112.4635-1-joshi.k@samsung.com>
 <CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com>
 <20241030180112.4635-7-joshi.k@samsung.com>
 <ZyKghoCwbOjAxXMz@kbusch-mbp.dhcp.thefacebook.com>
 <914cd186-8d15-4989-ad4e-f7e268cd3266@gmail.com>
 <ceb58d97-b2e3-4d36-898d-753ba69476be@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ceb58d97-b2e3-4d36-898d-753ba69476be@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/24 17:54, Kanchan Joshi wrote:
> On 10/31/2024 8:09 PM, Pavel Begunkov wrote:
>> On 10/30/24 21:09, Keith Busch wrote:
>>> On Wed, Oct 30, 2024 at 11:31:08PM +0530, Kanchan Joshi wrote:
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/
>>>> io_uring.h
>>>> index 024745283783..48dcca125db3 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -105,6 +105,22 @@ struct io_uring_sqe {
>>>>             */
>>>>            __u8    cmd[0];
>>>>        };
>>>> +    /*
>>>> +     * If the ring is initialized with IORING_SETUP_SQE128, then
>>>> +     * this field is starting offset for 64 bytes of data. For meta io
>>>> +     * this contains 'struct io_uring_meta_pi'
>>>> +     */
>>>> +    __u8    big_sqe[0];
>>>> +};
>>
>> I don't think zero sized arrays are good as a uapi regardless of
>> cmd[0] above, let's just do
>>
>> sqe = get_sqe();
>> big_sqe = (void *)(sqe + 1)
>>
>> with an appropriate helper.
> 
> In one of the internal version I did just that (i.e., sqe + 1), and
> that's fine for kernel.
> But afterwards added big_sqe so that userspace can directly access
> access second-half of SQE_128. We have the similar big_cqe[] within
> io_uring_cqe too.
> 
> Is this still an eyesore?

Yes, let's kill it as well please, and I don't think the feature
really cares about it, so should be easy to do if not already in
later revisions.

>>>> +
>>>> +/* this is placed in SQE128 */
>>>> +struct io_uring_meta_pi {
>>>> +    __u16        pi_flags;
>>>> +    __u16        app_tag;
>>>> +    __u32        len;
>>>> +    __u64        addr;
>>>> +    __u64        seed;
>>>> +    __u64        rsvd[2];
>>>>    };
>>>
>>> On the previous version, I was more questioning if it aligns with what
>>
>> I missed that discussion, let me know if I need to look it up
> 
> Yes, please take a look at previous iteration (v5):
> https://lore.kernel.org/io-uring/e7aae741-c139-48d1-bb22-dbcd69aa2f73@samsung.com/

"But in general, this is about seeing metadata as a generic term to
encode extra information into io_uring SQE."

Yep, that's the idea, and it also sounds to me that stream hints
is one potential user as well. To summarise, the end goal is to be
able to add more meta types/attributes in the future, which can be
file specific, e.g. pipes don't care about integrity data, and to
be able to pass an arbitrary number of such attributes to a single
request.

We don't need to implement it here, but the uapi needs to be flexible
enough to be able to accommodate that, or we should have an
understanding how it can be extended without dirty hacks.

> Also the corresponding code, since my other answers will use that.
> 
>>> Pavel was trying to do here. I didn't quite get it, so I was more
>>> confused than saying it should be this way now.
>>
>> The point is, SQEs don't have nearly enough space to accommodate all
>> such optional features, especially when it's taking so much space and
>> not applicable to all reads but rather some specific  use cases and
>> files. Consider that there might be more similar extensions and we might
>> even want to use them together.
>>
>> 1. SQE128 makes it big for all requests, intermixing with requests that
>> don't need additional space wastes space. SQE128 is fine to use but at
>> the same time we should be mindful about it and try to avoid enabling it
>> if feasible.
> 
> Right. And initial versions of this series did not use SQE128. But as we
> moved towards passing more comprehensive PI information, first SQE was
> not enough. And we thought to make use of SQE128 rather than taking
> copy_from_user cost.

Do we have any data how expensive it is? I don't think I've ever
tried to profile it. And where the overhead comes from? speculation
prevention?

If it's indeed costly, we can add sth to io_uring like pre-mapping
memory to optimise it, which would be useful in other places as
well.
  
>   > 2. This API hard codes io_uring_meta_pi into the extended part of the
>> SQE. If we want to add another feature it'd need to go after the meta
>> struct. SQE256?
> 
> Not necessarily. It depends on how much extra space it needs for another
> feature. To keep free space in first SQE, I chose to place PI in the
> second one. Anyone requiring 20b (in v6) or 18b (in v5) space, does not
> even have to ask for SQE128.
> For more, they can use leftover space in second SQE (about half of
> second sqe will still be free). In v5, they have entire second SQE if
> they don't want to use PI.
> If contiguity is a concern, we can move all PI bytes (about 32b) to the
> end of second SQE.
> 
> 
>   > And what if the user doesn't need PI but only the second
>> feature?
> 
> Not this version, but v5 exposed meta_type as bit flags.

There has to be a type, I assume it's being added back.

> And with that, user will not pass the PI flag and that enables to use
> all the PI bytes for something else. We will have union of PI with some
> other info that is known not to co-exist.

Let's say we have 3 different attributes META_TYPE{1,2,3}.

How are they placed in an SQE?

meta1 = (void *)get_big_sqe(sqe);
meta2 = meta1 + sizeof(?); // sizeof(struct meta1_struct)
meta3 = meta2 + sizeof(struct meta2_struct);

Structures are likely not fixed size (?). At least the PI looks large
enough to force everyone to be just aliased to it.

And can the user pass first meta2 in the sqe and then meta1?

meta2 = (void *)get_big_sqe(sqe);
meta1 = meta2 + sizeof(?); // sizeof(struct meta2_struct)

If yes, how parsing should look like? Does the kernel need to read each
chunk's type and look up its size to iterate to the next one?

If no, what happens if we want to pass meta2 and meta3, do they start
from the big_sqe?

How do we pass how many of such attributes is there for the request?

It should support arbitrary number of attributes in the long run, which
we can't pass in an SQE, bumping the SQE size is not scalable in
general, so it'd need to support user pointers or sth similar at some
point. Placing them in an SQE can serve as an optimisation, and a first
step, though it might be easier to start with user pointer instead.

Also, when we eventually come to user pointers, we want it to be
performant as well and e.g. get by just one copy_from_user, and the
api/struct layouts would need to be able to support it. And once it's
copied we'll want it to be handled uniformly with the SQE variant, that
requires a common format. For different formats there will be a question
of perfomance, maintainability, duplicating kernel and userspace code.

All that doesn't need to be implemented, but we need a clear direction
for the API. Maybe we can get a simplified user space pseudo code
showing how the end API is supposed to look like?

-- 
Pavel Begunkov

