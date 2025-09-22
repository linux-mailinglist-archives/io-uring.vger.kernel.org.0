Return-Path: <io-uring+bounces-9857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8098B8F569
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 09:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C5E4189994C
	for <lists+io-uring@lfdr.de>; Mon, 22 Sep 2025 07:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07822EDD51;
	Mon, 22 Sep 2025 07:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OualqEa+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1692749CF
	for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 07:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758527491; cv=none; b=R/3tA9t1RdxJEIpdsGNo+gXmEJbygEECm6MxKyj2+ObBZpIwihjlfXEbpz0NRgippsW/7InLn/Ep8s9zZ8m+BYNGxH77zoscJLqitqbhGCcRWZDUo92Uv6axfJ4Nv4LLC3WAZ1TnSbFoEEXVo1WBcfNkEZN2yrAASEtyIqPh3Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758527491; c=relaxed/simple;
	bh=7bL4vZ8wHDMTYFga2jUUmL0Tz9uk2jLnXSf5sIiBJZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l6ci9jsUVmt/hgSRHvBp+ZbjYIsLX+GrEoAFgkA7VJiKDmExPAjOJGXvc743CtkUGF0RAdWV2Tl1Ii9TsiYhkq8Lm6FdS4e9II3jKUYoEJkZ+ZEabd+2m12eZqmVRz7vSEs0TlMQ/3r2TaFHEkqz3KfcL/a4aRJpPPXXo2ssxik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OualqEa+; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b07ba1c3df4so761923066b.3
        for <io-uring@vger.kernel.org>; Mon, 22 Sep 2025 00:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758527488; x=1759132288; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AmgncB0lGBpO1mN8xBg425aU0kjbpbJc0WaCZykq0CY=;
        b=OualqEa+cVUqiuRuuWZMMuJq7sTUeAgr5Kx2wpVioiV8/iULxwgfpVCNoMXzvf7QU3
         eP21hsNOPphc4iASl2QqDJff7LsYrvs9dwdqlKaA8tKT+nHcpTkgYeU267VkEgAFI1NS
         xzC9/7urWsmZ1YPjJUT3pR32diV6AQyHm9XZQk2W7oZl2mXGHNhLHrlhaPU3vY3ykC0k
         +oWoc7uIuqaZeNOmPcpgDW4oBnWsaPB1ZLsCJWHtWjyQ929w0izEwy/s9GVzlhWSbvmi
         dYcOB3WVtPpf46VF4ZLafPyVVuMNRaYT5+xAOYZIqLC6/Kiec7kiLZFLV0+OiSbvs/d7
         N/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758527488; x=1759132288;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AmgncB0lGBpO1mN8xBg425aU0kjbpbJc0WaCZykq0CY=;
        b=qTyUR2mFKlgs+tOQ+5UJIZhpvVqj+Z6olKopQ3oXXujT7DzeS0mTHZ+BnuMABaWC8l
         sfOQMzdEOEpZUM2N61ZJGnZXVOLp0+E0EYKihyYy89IhrTBg7JKFhi1pwj2aKfbTUdv/
         7duETRdyiZAWtpj/T/7iCbNWwXHcWGRKjvAlr8ZgUhCrHGZ88nsQ+MOqNWh1dsYXyrck
         AlaTQnNyf0vUO22LvJGbEk9joUELH15y6uVjhDUYLJnmUN2ooP/Vh1LFba2PnedYbUs/
         smvCPOc8Bex1lfhwKyiadv66Rq1UhWz6kUmwMOWqkdE4kmdqiCtlcHNQCvl331j7dMKl
         iVCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf1z18JGt9ksqHCsBkFpNe7Epx+41K9pdXdY2RPs8+F6N5Gl6NNiohSnQAtD+/Mc1MIHD6rYjreA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFuDFmxNQRA3Y4t3u7uvEIH2dUJi+GmEQncYmK8S97h/c1dvDt
	/Pv+7RNDh5KRQa6beaKIok3RP5k8lL0fi5S1SGmATnXdlPBNS7biQjI8
X-Gm-Gg: ASbGncuf5doGUud+oyVab8B86TS96dhbsnopXc8//nSrrtltntOp4LaimjnCVo2VWRU
	iI3s1vLtFeec3ugE2lQET+9hL/btB2Iff8bYze4IchGA5VMLbBt+j2SRL3ktgA83sLISYhpPpS0
	MO4OmnILWP1TNpXY7sXAjojk/4LoY1Ankz412+xkMRcFdKtIm1i/Rrn9IdzFjyah4nwMQMPZsF6
	7EyVy8jqkgyHMo4eAeHNzTqc00Ydhrhvfnsx4KZdeh/DnjfszrHc/9Q7RGljpe0jRMm7EvW60+v
	To9cD/sm5KwdrvK/xfRZRCPqtPSSzqyXuto5+PakqMndO9mdLIc5WSh5dopgcuao3G4ZlX+BDld
	94u0VGWH6zzZOSGt2mrYB8wapZOBvOK58Kg==
X-Google-Smtp-Source: AGHT+IEyZzSnNUh+pw7Fyo3WaWpJeJ67ccl8F7a+h/FyMk6Iy9YRwkcf+0TqNRC1C1hcKQQz59GsKg==
X-Received: by 2002:a17:907:60ce:b0:aff:2ed7:5f11 with SMTP id a640c23a62f3a-b24eedc58b2mr1114621066b.24.1758527487983;
        Mon, 22 Sep 2025 00:51:27 -0700 (PDT)
Received: from [10.135.195.141] ([148.252.132.189])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2928cd318csm461637666b.98.2025.09.22.00.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 00:51:27 -0700 (PDT)
Message-ID: <a85ea039-9cf6-4ea2-b5f5-3049c27fe187@gmail.com>
Date: Mon, 22 Sep 2025 08:52:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix incorrect io_kiocb reference in io_link_skb
To: David Kahurani <k.kahurani@gmail.com>
Cc: Yang Xiuwei <yangxiuwei2025@163.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, Yang Xiuwei <yangxiuwei@kylinos.cn>
References: <20250919090352.2725950-1-yangxiuwei2025@163.com>
 <152d553e-de56-4758-ab34-ba9b9cb08714@gmail.com>
 <CAAZOf24YaETroWiDjmTxu=2b2KVTxA1+rq_p5uxqtJqTVBfsJw@mail.gmail.com>
 <CAAZOf251fh-McW=7xdEQiWyQ-XfOC1tRTUnyTD4EHVaLG-2pvA@mail.gmail.com>
 <1e5ff80d-73f8-4acd-8518-3f10c93b4e40@gmail.com>
 <CAAZOf250CqN67DTXF+74-8q3JbRCAuaW=XbrxqoNaq09RNUOJA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAAZOf250CqN67DTXF+74-8q3JbRCAuaW=XbrxqoNaq09RNUOJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/19/25 15:28, David Kahurani wrote:
> On Fri, Sep 19, 2025 at 5:14 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 9/19/25 12:25, David Kahurani wrote:
>> ...>>>> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
>>>>>>
>>>>>> diff --git a/io_uring/notif.c b/io_uring/notif.c
>>>>>> index 9a6f6e92d742..ea9c0116cec2 100644
>>>>>> --- a/io_uring/notif.c
>>>>>> +++ b/io_uring/notif.c
>>>>>> @@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
>>>>>>                 return -EEXIST;
>>>>>>
>>>>>>         prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
>>>>>> -     prev_notif = cmd_to_io_kiocb(nd);
>>>>>> +     prev_notif = cmd_to_io_kiocb(prev_nd);
>>>>>>
>>>>>>         /* make sure all noifications can be finished in the same task_work */
>>>>>>         if (unlikely(notif->ctx != prev_notif->ctx ||
>>>>>
>>>>> --
>>>>> Pavel Begunkov
>>>>>
>>>>>
>>>
>>> This is something unrelated but just bringing it up because it is in
>>> the same locality.
>>>
>>> It doesn't seem like the references(uarg->refcnt) are well accounted
>>> for io_notif_data. Any node that gets passed to 'io_tx_ubuf_complete'
>>> will gets it's refcnt decremented but assuming there's a list of
>>> nodes, some of the nodes in the list will not get their reference
>>> count decremented and
>>
>> And not supposed to. Children reference the head, and the head dies
>> last.
> 
> I am not sure about the mechanics of this. This is only based on
> analysing the code but it seems, if a child node gets completed, it
> will pull all the other nodes in that link by jumping to the head

It'll put its reference to the head, but nothing is going to
be destroyed until the head refs hit 0.

> node. But, I trust that you know better :-)
> 
> What do you mean it's not supposed to? All the nodes eventually go

I was saying that the head isn't supposed to put the children's
references, it goes the other way around. Children have refs to
head, and everything is destroyed once the head is put down.

> through 'io_notif_tw_complete' to be queued back into request queues,
> if any nodes whose reference was not handled(all nodes get a reference
> of 1 at allocation) goes through the method, then the warning will
> trigger.
-- 
Pavel Begunkov


