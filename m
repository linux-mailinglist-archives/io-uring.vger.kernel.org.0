Return-Path: <io-uring+bounces-5923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF83A13FC8
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 17:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 053923A9CC8
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 16:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F80146A6F;
	Thu, 16 Jan 2025 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBSykcYI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E6B2AE96;
	Thu, 16 Jan 2025 16:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737045934; cv=none; b=OjA4e2sjudGaVjwVBWyQB05amT6/sjLEOqCDGsRU4oAK1XTuznLSVEWJ5bSLFMFU9r258kbwWz31VoFqgXrc23+gxkOK0VFsi01q9970e2hwCGQ9s5GpW0xZMBLRzRJbnhwmLh0cbAscNz5sidM1aQtJ0xC/qILyKhyx4WCEOv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737045934; c=relaxed/simple;
	bh=sAS0VdKLNk8eIMGx0WjrqPsB1SLDTXfV71olEi+i44Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkE2TqWFiTjmCZMKdMMJidDGDbAS/e+5FUfLzryUqq7+Zw3KkTBoRLl5dUKth6TX5sp5/DSiPdHaINW4OeZ60tP3lh7IBOM3CuL0nXMi3wMocQiDe8wI+mb6NLBdhfVECZK++NuDdX45O9u9R0aQwIaRnCHzjWTwu/HxrvLRDbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBSykcYI; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ab34a170526so162208666b.0;
        Thu, 16 Jan 2025 08:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737045931; x=1737650731; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cvv/8ZB/4SNAeAvoW1keBQdrcF/HRB+QnWVHmCSqeRk=;
        b=OBSykcYIciqUkdCQjmFMK19WQdUbDM7m7o1YOcAQjhfGtjoQLEh1SBO+4pHBj4heFr
         QWDjBD4j5gzeI5PnpfNJamrecqn7Z279Qhar7ei7JlTNfcrMy7jFbvyEMCBJJP8o7rsJ
         GPM4pRfa2oUi3PUtfIoWgC9bpKR+FqEhjjCCraYJD00WJUZdwhmgmqewoJK4cMPdL4rh
         3vst2s+OyP+pqRpJZVRBaeVnSiOpJefPi4XzVJrgCxpLPflu3s4wIyFXeAlABy8MyHnQ
         4u2vUB3a9hB9zpekkFt2SPU4OZj9+aZ2NtLmRMcOWebX1oAbZwBW+6uGHHV3BM28xGNQ
         VfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737045931; x=1737650731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cvv/8ZB/4SNAeAvoW1keBQdrcF/HRB+QnWVHmCSqeRk=;
        b=Wo4i9ZsP+BL41WdxnJOvV6jKFEolU+mxPCYLrvbEpQiuCD04XGXosgILjg8+fqSjBA
         8ylNpZDero4tP8p7rgBj+01DepcxQkZl0Vah9i1eX+jDAeTaFyNbJKxcWAxehujq61ms
         fCEdKdsEWhFYzP2Xjy05pMOVv/sRw5wgjwZBWdFr0PtSVOFCk29SDgXr6fEHWeRa6Eoj
         sXPNrY3A8wIQUozo4sx4i5FhJmy7Z8Coh6mQhiMRDBlM/xp4ufgyTFrqSTm2FxoY4AeR
         AjGOl1WKrJ1rK9T1aWyiDUhN5q9tX1vauil13anirzsSaCOKv0onQeYOil2rocf/9J+a
         USQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPGtHn95GQCJkIy1ZvYpiMQx29s0zvGUlp2PKhIvBnqGm1kmO3REbDEsV2Nkk3rclEzM1l4lrm@vger.kernel.org, AJvYcCX3MjrrjMUJi/pcGbUigQ43NJd4GbNTp3sD77bOX4jeaWEDfO9DOS1eZ0Ho/dtilA2rtoBjQa0wxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzoab7UyuC6nvNuwvv+RaazOwvsLh9EKdyvk1GAsuGFtUz9w0BY
	1speN0lmWtjEUN5niO6v3HCx6c4U8J02ZPBQpzqJD6qp90vSbvvk
X-Gm-Gg: ASbGncv27iK5DMWYKLEiPg1cmpT5DJUMiu+Tq8pnxk/V6mAbrMIx7n3G0xr1effSgPC
	ozym1YhzdJrEfASdt+lcBKzudmZAP94gt/JcZJczFjkCKPi239WlGCpC68yQXXlA6ac6NcGm1Gn
	aH9+8XFXljNDrOh3+jxy+0VY4qLkNgis7Wn48fT630QnVyetvcE7bZUJkY+oOlRGKb9LRc5B7iu
	5GR6kGKs1AzTq+c5jQahXctIumjBGVlhDIYr4ja4uDEmYNcg+aMg8HQZeHEgt+6/x8=
X-Google-Smtp-Source: AGHT+IE8xauxeUR4R/E7pUeYOxpcsegqjQzv/5CA2Fh7K/+v+1xFb95U4AnweQmM4HD9h0L4NexKzQ==
X-Received: by 2002:a17:907:3e9e:b0:aaf:86a2:651f with SMTP id a640c23a62f3a-ab2abdc0a2emr3546309666b.38.1737045930834;
        Thu, 16 Jan 2025 08:45:30 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384fcb262sm17991066b.169.2025.01.16.08.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 08:45:30 -0800 (PST)
Message-ID: <87b9fc41-e166-4779-aabf-2f541922df97@gmail.com>
Date: Thu, 16 Jan 2025 16:46:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 14/22] io_uring/zcrx: grab a net device
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-15-dw@davidwei.uk>
 <20250115170644.57409b2f@kernel.org>
 <bb19ef4d-6871-4ae9-b478-34dd2efcb361@gmail.com>
 <20250115191217.5ab89aa3@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250115191217.5ab89aa3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/25 03:12, Jakub Kicinski wrote:
> On Thu, 16 Jan 2025 02:33:06 +0000 Pavel Begunkov wrote:
>> On 1/16/25 01:06, Jakub Kicinski wrote:
>>> On Wed,  8 Jan 2025 14:06:35 -0800 David Wei wrote:
>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>
>>>> Zerocopy receive needs a net device to bind to its rx queue and dma map
>>>> buffers. As a preparation to following patches, resolve a net device
>>>> from the if_idx parameter with no functional changes otherwise.
>>>
>>> How do you know if someone unregisters this netdevice?
>>> The unregister process waits for all the refs to be released,
>>> for *ekhm* historic reasons. Normally ref holders subscribe
>>> to netdev events and kill their dependent objects. Perhaps
>>> it is somewhere else/later in the series...
>>
>> Ok, I can pin the struct device long term instead and kill
>> netdev in the uninstall callback off
>> unregister_netdevice_many_notify(), if that works with you.
> 
> I think that would work. You mean the "underlying" device, right,
> netdev->dev.parent ? Like page_pool itself does. SG.

Right, that one

-- 
Pavel Begunkov


