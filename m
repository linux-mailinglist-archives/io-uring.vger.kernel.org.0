Return-Path: <io-uring+bounces-3523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C93DA9975E3
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB9AD1C21BAD
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 19:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C36F18132A;
	Wed,  9 Oct 2024 19:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1626Int"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0020D530;
	Wed,  9 Oct 2024 19:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728503219; cv=none; b=DzMbw7ntYTBHzLl3apvfHH/PH4OEPnZXILcsTjggp24DHIAc8Vqg0dW/FL4QU03NVGQLp9/qtnE6YGWE3teZw4KDP+ew98EeoNaH0bs79KHtd9sq/HzTMUge9o4NmVRlI4TFOD6R+hF6VM58CjVnY72ciOdqlaRyEXqySxWicjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728503219; c=relaxed/simple;
	bh=/e9gq8jLxFs4xemZa1muyzFDcvOP1IWNRugid3YAY+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uwd9ePHij0Vu8THHk4aTgSrb3R4Veog+wohIqciP1pwELCh7ITKYLs0CW1QvTdmFeq5RFfasBjAMPy38Ur+WcQ+GlN/Q7J2vW9RxDXnnSY1HZNiigtFhNKEEjhpW/qHZFzK0hlMnP+xbLUEhk5Kyv2Ac7S7V9iD+hwzAoUwUHsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1626Int; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c5bca6603aso94994a12.1;
        Wed, 09 Oct 2024 12:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728503216; x=1729108016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=naCyfnbZ3lW2rvqGklZm40HQYO83mBPK2wwHKg+2b3k=;
        b=L1626IntjVsUf5adOVTFrZ1mB1ighGdVRGYSYF6qUVlkxW8Bkq8sLyOqJsjQUHLtpq
         hFuWBJTL8hJD21vITH/ChQmbE7s9+b4vgy6m65qaT/+KuW4Czjor5E+Ti3hK4ZxAvg9W
         Em/BjTC7mqEOgAz5mqrQ9Onu/bC+KNrbuTpAT+kJy0XyHk0b6hjZr6LLDpmX1oL+zXLn
         FE/IsCpiSAy9WRQZcZ1hnI/PzWS6Y3PmqbA1I/2n39CdZVY6QhwytUysStU5Lk1tBP9A
         fhDd1VGEhXT+bHPw87IgUuczebVMmT0/ucqpRh7VGmdc/YLLUYKKQUb98PXkCEQdR8ZN
         dPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728503216; x=1729108016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=naCyfnbZ3lW2rvqGklZm40HQYO83mBPK2wwHKg+2b3k=;
        b=J0qSDpz3hjfegfmrbLr71kNJ0yi+i8kjOuL5NCDn9KCgjRI+NMYc1WJkzXnVfd5fKc
         HzVRUVSnsP7qu9pr8QYewZQNP2JbjyPbg4r51zAeqjlHfQHFICkOTya1Z852T9a4ClGE
         SS8JhKPVE2DTlP0890BGOz+GQAcAa6AEicxe45RVR/afyjVxR25QYBaXhIqIY6xPdL1a
         GZCEMU5p4WAcvZRmn2DptZqe85T7nNs57vyLosHukuZkWx/+/GBnBY1T8kiAER/yLfpC
         O8nsx1anVyAC5yF4+YB+vwYq6zrw27/OQDu5hArvMvd1wovL92JB9cxV1umGTWz9uRJo
         3Qgg==
X-Forwarded-Encrypted: i=1; AJvYcCU6D9bPchr1pxA0JHFgguwn3SArZ5IC6tfaACa3rNlyWraDrwcaExTZm5QFcHV9dFs7g5WCExBZeA==@vger.kernel.org, AJvYcCX9G6JukftJ2hFIy7gJ4dOlIE6gSoxufFzffypoCj/YuVfRzziTMlpbsaixjQ6oU73sK36/9pgy@vger.kernel.org
X-Gm-Message-State: AOJu0YxSIAyzfT2miCATz6PQ+1EUdnpgl95uVUwJI3PeMm4gekp+xFai
	nO0g0uCVwNByVobQQhDKEK6aiHeaHLKyIsYZYaGb/pcWQwNLgZ5Kdh66aw==
X-Google-Smtp-Source: AGHT+IHOYCzHer9eiP2cFZiMMzEpJbkxJ7Qer5kokaMEGN5OruWHil9Hij0HO41n8jH3zDYm1OFq0A==
X-Received: by 2002:a05:6402:2803:b0:5c7:2131:5d3 with SMTP id 4fb4d7f45d1cf-5c91d57a77dmr2493872a12.12.1728503215537;
        Wed, 09 Oct 2024 12:46:55 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.145.180])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05eccf0sm5849533a12.64.2024.10.09.12.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:46:54 -0700 (PDT)
Message-ID: <d5be304b-0676-4f4e-adbc-eea3f7b161de@gmail.com>
Date: Wed, 9 Oct 2024 20:47:29 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 12/15] io_uring/zcrx: add io_recvzc request
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-13-dw@davidwei.uk>
 <703c9d90-bca1-4ee7-b1f3-0cfeaf38ef8f@kernel.dk>
 <f2ab35ef-ef19-4280-bc39-daf9165c3a51@gmail.com>
 <af74b2db-8cf4-4b5a-9390-e7c1cfd8b409@kernel.dk>
 <7cee82f7-188f-438a-9fe1-086aeda66caf@gmail.com>
 <177d164a-2ebc-483a-ab53-7741974a59c4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <177d164a-2ebc-483a-ab53-7741974a59c4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 20:42, Jens Axboe wrote:
> On 10/9/24 1:27 PM, Pavel Begunkov wrote:
>>>>>> +    /* All data completions are posted as aux CQEs. */
>>>>>> +    req->flags |= REQ_F_APOLL_MULTISHOT;
>>>>>
>>>>> This puzzles me a bit...
>>>>
>>>> Well, it's a multishot request. And that flag protects from cq
>>>> locking rules violations, i.e. avoiding multishot reqs from
>>>> posting from io-wq.
>>>
>>> Maybe make it more like the others and require that
>>> IORING_RECV_MULTISHOT is set then, and set it based on that?
>>
>> if (IORING_RECV_MULTISHOT)
>>      return -EINVAL;
>> req->flags |= REQ_F_APOLL_MULTISHOT;
>>
>> It can be this if that's the preference. It's a bit more consistent,
>> but might be harder to use. Though I can just hide the flag behind
>> liburing helpers, would spare from neverending GH issues asking
>> why it's -EINVAL'ed
> 
> Maybe I'm missing something, but why not make it:
> 
> /* multishot required */
> if (!(flags & IORING_RECV_MULTISHOT))
> 	return -EINVAL;
> req->flags |= REQ_F_APOLL_MULTISHOT;

Right, that's what I meant before spewing a non sensible snippet.

> and yeah just put it in the io_uring_prep_recv_zc() or whatever helper.
> That would seem to be a lot more consistent with other users, no?

-- 
Pavel Begunkov

