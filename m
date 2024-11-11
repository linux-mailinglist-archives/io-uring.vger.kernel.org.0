Return-Path: <io-uring+bounces-4614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6D49C48DF
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 23:14:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3A0FB23E1E
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 22:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923611BC06E;
	Mon, 11 Nov 2024 22:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="qIqOn48Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1528B15887C
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 22:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731362556; cv=none; b=FlnU7QOMjOStv1wmGyxA4J0t5SYMGJoabwjQ797CC49CPa//qcAYolx45QrZGD2JoGU7Fs468DOWq9iYGPDtVIUYoEwH3vuTG4YsdDQl+mwfCfTgjGe1QHmcKLFcycmB1mJCadYw3joWL9q+hN3Y6vrWrS/Ov5cXB46MGCBig2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731362556; c=relaxed/simple;
	bh=MkmXdLCur2g63HaeuU5lItYe9iF32HUWPE5MqmOr0DA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fgzvHljlIKMLqA7hi+B91eXo5/qaMrNDOKG58AgMTEsl4F83veeVJPg8MQQagoEpcdCaeNuyVgjbaei6uzrAVTjSHCZ0bL0O6PtW6aaZKSUDVJiy1IK7iUAd8vVsGXfks+8wqzFPsExNvFKg6PCCU8sB5DP7SorV3jdSav4yhxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=qIqOn48Z; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20cdbe608b3so49981725ad.1
        for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 14:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1731362554; x=1731967354; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G45ANN/KHbgTu/kZxFQWIYWlzKdk+/aJNBH16qEROuw=;
        b=qIqOn48ZXbH7ymnU9SclWsPaMDHXMFgWWaRd69ptkOwz5q3Pd7D1uFYDZs56vvWEnh
         kMZcGE8lTgrnnpyUw+gtOvNGU5eEkXJoJj8j7uGfXW03Gl6w97hV+kuqNabh4kFv1ehg
         WrIRfB6v8ZBwsXZ1SrlgZFcsFOcbRpcf/iiwu0TEl+bkn4g8wV8XW6w8BQXx340kZAUk
         Qfdg2IMmZCcyps00t9VxqxHGFIlYTqWe6V8mjj4JvE/dsAmnA5EKywUDNtRaKe2ibvDC
         UJbJ+BPexIE5uTPHL6U2TeOK5d9XgGC+Q7fxQX8JIZsftxQ5v8YlPq2otNUBEUaIA/o2
         iPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731362554; x=1731967354;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G45ANN/KHbgTu/kZxFQWIYWlzKdk+/aJNBH16qEROuw=;
        b=vKUCbMBTehmsOkgKMwnFoT1WwWh670bhNfPWuESIJaFKncV6anobKpDWXjFe50nrdp
         g40UAvtgdXnoa6K3HGb6XH+TEBp9Mc3hubO2s+w2V3rqxXLP9wXDtRICYKAQBUWC8ijW
         27OldyCRHOUAVBrcDQcrm71ZNaUyhYyrzQp3YHprT5zy+Vkazo2WJL+XtAO/7fvhBfDg
         ZwOp/9E3Ozbn76c9IQfCIuAN9DIW7gUukehhNIJX8kdA5Lf4B14tLATpSSSpS4KtAZTY
         qMr3+PwiknAqwnO2ErcUnXYi+mfk845e+EaYivv0A2rMzJZ49llQJw4nujTUonEp+sE5
         OFUg==
X-Gm-Message-State: AOJu0Yx95ZltwpGO43h3mnSdKRS9itQb3BwzQeOpNff7XB+rJfF9ei12
	lgf+hyAzxI35t2ly0pHk1fSdF4MTrHkDdUtSJXBT9T8nX9wndBMUmGHRjcc7IMU=
X-Google-Smtp-Source: AGHT+IFYcnZfGk4NN1GTJsmPYeOYd0OklHfCESVe08lY9folizL3FTMYdJVrKAw4DyZwNav+iQVm0A==
X-Received: by 2002:a17:902:cecf:b0:20c:b606:d014 with SMTP id d9443c01a7336-211ab9e5b8amr3277985ad.44.1731362554278;
        Mon, 11 Nov 2024 14:02:34 -0800 (PST)
Received: from [192.168.1.10] (71-212-14-56.tukw.qwest.net. [71.212.14.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177dc8264sm81288365ad.33.2024.11.11.14.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 14:02:33 -0800 (PST)
Message-ID: <838c4bd4-1e35-4b43-add3-f84a773798da@davidwei.uk>
Date: Mon, 11 Nov 2024 14:02:32 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/15] io_uring/zcrx: add io_recvzc request
Content-Language: en-GB
To: Mina Almasry <almasrymina@google.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-13-dw@davidwei.uk>
 <CAHS8izP=S8nEk77A+dfBzOyq7ddcGUNYNkVGDhpfJarzdx3vGw@mail.gmail.com>
 <f675b3ec-d2b3-4031-8c6e-f5e544faedc2@gmail.com>
 <CAHS8izNfBEHQea3EHU7BSYKmKL9py2esROySvgpCO48CxijRmw@mail.gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <CAHS8izNfBEHQea3EHU7BSYKmKL9py2esROySvgpCO48CxijRmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-11-05 15:09, Mina Almasry wrote:
> On Fri, Nov 1, 2024 at 2:16 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 11/1/24 20:11, Mina Almasry wrote:
>>> On Tue, Oct 29, 2024 at 4:06 PM David Wei <dw@davidwei.uk> wrote:
>>>>
>>> ...
>>>> +static void io_zcrx_get_buf_uref(struct net_iov *niov)
>>>> +{
>>>> +       atomic_long_add(IO_ZC_RX_UREF, &niov->pp_ref_count);
>>>> +}
>>>> +
>>>
>>> This is not specific to io_rcrx I think. Please rename this and put it
>>> somewhere generic, like netmem.h.
>>>
>>> Then tcp_recvmsg_dmabuf can use the same helper instead of the very
>>> ugly call it currently does:
>>>
>>> - atomic_long_inc(&niov->pp_ref_count);
>>> + net_iov_pp_ref_get(niov, 1);
>>>
>>> Or something.
>>>
>>> In general I think io_uring code can do whatever it wants with the
>>> io_uring specific bits in net_iov (everything under net_area_owner I
>>> think), but please lets try to keep any code touching the generic
>>> net_iov fields (pp_pagic, pp_ref_count, and others) in generic
>>> helpers.
>>
>> I'm getting confused, io_uring shouldn't be touching these
>> fields, but on the other hand should export net/ private
>> netmem_priv.h and page_pool_priv.h and directly hard code a bunch
>> of low level setup io_uring that is currently in page_pool.c
>>
> 
> The only thing requested from this patch is to turn
> io_zcrx_get_buf_uref into something more generic. I'm guessing your
> confusion is following my other comments in "[PATCH v7 06/15] net:
> page pool: add helper creating area from pages". Let me take a closer
> look at my feedback there.
> 

Sounds good, I'll rename io_zcrx_get_buf_uref() to something more
generic. But I'll leave changing the existing calls for a future patch.

