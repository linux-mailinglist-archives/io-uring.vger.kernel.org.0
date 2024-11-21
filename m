Return-Path: <io-uring+bounces-4906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8789D44DB
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 01:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96F831F220AF
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA70923098D;
	Thu, 21 Nov 2024 00:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3JL7GIJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043D2230985
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 00:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147980; cv=none; b=hl58EAx0VG+nakrw0HEhoccMWvxUMikHWCa41haqw8TMY+POcpiZdFxJLHnZ3nWK/NCBgmwahr0LWTjIwMAuXkEFIChPElFgjCUSq5a3u5p9KCGFL+5DfRtdgDI3fhhL+9nlCHx11ccU9EoF0ebydYxarBi7MyR9WQ7CmWrPlgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147980; c=relaxed/simple;
	bh=wIB39EikXUsdhX65Gjrm9jXaXgHEz45TCqfjJUwtH0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d7aJlsV4IcKWAKiuNOPcQKDjetY0KfH3OvHzrF2vG46/H2IS4rdb0OpyqQQa0mXcKO6qFcTEQTaXY1PYeWikHyePNGQO8R6AClFYoWA0WNcqxyxlt7WUlXSh0dnaLbsyfuxKsc/WGhv9G9XgauNNBNZq6kUHlLxcKlj+JMyqbfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M3JL7GIJ; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5cfddc94c83so355064a12.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 16:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732147977; x=1732752777; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4F8TQEkTusA6sS5yxcg2vIRTHfhrNSs4Au+kbn0/eL4=;
        b=M3JL7GIJL0bwAZ2BUnZK39kWXc2wIj5zu0MVuuxPP8K7+xDSI5p445O3Wc/FGWMw0P
         y7txHPoolCn7KfDz+7lLscpoxYEDlCFRq9OLEocOYy5tvczi0+ANKe/hWZI+SqxETN2H
         47tZtqkslqJdUfOdaMor1MYHcRaVse2O6DCJ0YTQjEI7vhLSdPkNA98rN5uc/+JR8EtH
         HUvVXSUo7Q2vD0oZ1CX2SrkECo5PBo7722/NKZTgh/iTXG4fzwHiMZkDZteVfbIfED+F
         Puf/ewHUeZM+VuUZ0cCJymgsgwPht2rzLtbtOeOoXxf/iy9m74z5qdMyt1SjOc3ETtZ+
         1WbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732147977; x=1732752777;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4F8TQEkTusA6sS5yxcg2vIRTHfhrNSs4Au+kbn0/eL4=;
        b=RH67MmHzS5rDrmiVNuE4ZnDmHopPFXDi0Ky9gqioTUh++qjL/a/qzyo+/tmNdHVuYD
         4AZ4As5169iyFQ39TJxEXU+s5DfOFQ+YOblQUKXIY/k4bFiMICjJuTj98HJLS7qHkRyV
         2fGSmP18tx1tq6M+/Ic4SOO84d8gwDcEnsMJ9VDBX8EThOVAUSxmeknltANAQ9EPZDZL
         GlmEZ2McqJZDz0ftgRcpn9ylDk8Q0pG/zRRrRHbSJ9E2WxdiXXfTjtSQmrAworwK74N1
         VfNhzF9mvKE+XHcxzX1Er1hXxVbXwnWUf9y2ip1yk1d77g6tAStCxIx2WZhEweiNbIBC
         fOqw==
X-Forwarded-Encrypted: i=1; AJvYcCUyuGEbTn2bQEg5ZVR81492r/7RSSkHQ7q3MqTawwOb591XkBw/QEwsHf3DIwJRWi/Sa0a/1zFr7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGm8S9VfJy8CfjQElmT9BXg+ZSFABMQ5g05JQPMpTzzlJXFfYB
	1cCynOLROtI618nd+vu2aOXlrkGeNu50k+zUoIeIrhWIBNQNZV5urQFJjA==
X-Google-Smtp-Source: AGHT+IH01ByFjRvkpeNMQpRo0E0nqz6tMrXxx/dbpT1kT45aEVHYX3imuLSIVqv+4Ic3NypjGTrCGA==
X-Received: by 2002:a17:906:7952:b0:a99:dde6:9f42 with SMTP id a640c23a62f3a-aa4dd7209cdmr456006466b.47.1732147977125;
        Wed, 20 Nov 2024 16:12:57 -0800 (PST)
Received: from [192.168.42.89] ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f41818d0sm14815766b.80.2024.11.20.16.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 16:12:56 -0800 (PST)
Message-ID: <8bc3b927-b7f0-425f-8874-a3905b30759d@gmail.com>
Date: Thu, 21 Nov 2024 00:13:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: prevent reg-wait speculations
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: jannh@google.com
References: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
 <0dfd1032-6ddd-49b3-a422-569af2307d3b@kernel.dk>
 <d5e9c79f-d571-4f3a-9145-f7e349e532ae@gmail.com>
 <278a1964-b795-4146-8f24-19f112af75b0@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <278a1964-b795-4146-8f24-19f112af75b0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 01:59, Jens Axboe wrote:
> On 11/18/24 6:43 PM, Pavel Begunkov wrote:
>> On 11/19/24 01:29, Jens Axboe wrote:
>>> On 11/18/24 6:29 PM, Pavel Begunkov wrote:
>>>> With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
>>>> for the waiting loop the user can specify an offset into a pre-mapped
>>>> region of memory, in which case the
>>>> [offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
>>>> argument.
>>>>
>>>> As we address a kernel array using a user given index, it'd be a subject
>>>> to speculation type of exploits.
>>>>
>>>> Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
>>>> Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    io_uring/io_uring.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index da8fd460977b..3a3e4fca1545 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -3207,6 +3207,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
>>>>                 end > ctx->cq_wait_size))
>>>>            return ERR_PTR(-EFAULT);
>>>>    +    barrier_nospec();
>>>>        return ctx->cq_wait_arg + offset;
>>>
>>> We need something better than that, barrier_nospec() is a big slow
>>> hammer...
>>
>> Right, more of a discussion opener. I wonder if Jann can help here
>> (see the other reply). I don't like back and forth like that, but if
>> nothing works there is an option of returning back to reg-wait array
>> indexes. Trivial to change, but then we're committing to not expanding
>> the structure or complicating things if we do.
> 
> Then I think it should've been marked as a discussion point, because we
> definitely can't do this. Soliciting input is perfectly fine. And yeah,
> was thinking the same thing, if this is an issue then we just go back to
> indexing again. At least both the problem and solution is well known
> there. The original aa00f67adc2c0 just needed an array_index_nospec()
> and it would've been fine.
> 
> Not a huge deal in terms of timing, either way.
> 
> I suspect we can do something similar here, with just clamping the
> indexing offset. But let's hear what Jann thinks.

That what I hope for, but I can't say I entirely understand it. E.g.
why can_do_masked_user_access() exists and guards mask_user_address().

IIRC, with invalid argument the mask turns the index into 0. A complete
speculation from my side of how it works is that you then able to
"inspect" or what's the right word the value of array[0] but not a
address of memory of choice. Then in our case, considering that
mappings are page sized, array_index_nospec() would clamp it to either
first 32 bytes of the first page or to absolute addresses [0, 32)
in case size==0 and the mapping is NULL. But that could be just my
fantasy.

-- 
Pavel Begunkov

