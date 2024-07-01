Return-Path: <io-uring+bounces-2397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F45A91DD94
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 13:11:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD68C1F22ADB
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 11:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9359A12E1EE;
	Mon,  1 Jul 2024 11:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MU2WkEcC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA6A376E7;
	Mon,  1 Jul 2024 11:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719832266; cv=none; b=QUZhlIxQM9YOrZetYLubXRLo3uWwV+ZHqS9c4UFOqX8EWMB8FR2S2E5t1CfY++cr5ogIFOhA+vQyLX6KX8Nk1MjTHABCmFXaUB28iQ816XZ82HrZdAXSk1IowANHSrao/s6YzYTsIuNl4kKqfVYBDy7aJ9J/S5MS9A+u7F1TjNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719832266; c=relaxed/simple;
	bh=mXctZR48kdVKq2W8ysVP5W4s8u6d5ubyVj16x7g6GAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fqe/74uLq/WBTme4CtTjWHLzIf4db5DhBQ+nnz7evnNjDlQul+DnFlGYCMl5Ile2QifOjpipYBwY/BXfa1x1E2+pUD+BYkJM1mLNIjKZlUloONCErtL4E3mh8Zuxw9udeo/fNu5AqRJq//Uv+sG9//yeemhNmC0JS3RDNywxpZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MU2WkEcC; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52ccc40e72eso2027324e87.3;
        Mon, 01 Jul 2024 04:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719832263; x=1720437063; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vFmtlIZ0j1iiZbJIziUHbym8bzY7eoHRHb5V7Y9FQZA=;
        b=MU2WkEcCbcvv78N40jsZBMTumP73IOd9qaNWCabSJSm3BU7QSY3bHhPDidIV8XzytQ
         YipNsRxARbmnkNazbVIgTTrEzWh2M/keQO6bPkQzihmCAbpcBo2locOEM9hoR51pufEG
         7hifKttpiOPD3B1zayfiGqbECVXpmxXSLxjxSsW5wylpDOwwD98CsY6SThHlbGSJDabm
         4HzzZXt+aoQMwPHc3YRDybX++zS431IgQDYSrYboUnphGnGrYlTdrllHCmZmC5MHWRs1
         i3x74IvIZEu9QMqksQuzSliYudcd0ycf7X2NXx7blLaxtfzbLLkP+QougeL3WBp+qlgT
         AkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719832263; x=1720437063;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vFmtlIZ0j1iiZbJIziUHbym8bzY7eoHRHb5V7Y9FQZA=;
        b=ExC7OpLPev1AYXRoNYw5+zMPc8tqP06wgIemT/vk+smL/SskZ715JDP2i3dBWNEYhQ
         PVWVO9jUt1fzmg+Of4EKHnhtRwHW/0Y9vODiYsrMVlAIpr9bbUux6f5C1d0pj5i0oeXv
         IFGAHsuVUWgj/LTrJMDSoj+EkW0Eg/bFKL5NdoRSkYMrE8+XDfmePgAcO5amofsX+It1
         VXnUB4bnylZJXx9CmZ8djFeWBO6P/cz779LoNuNq7RPN2rRPrgIKHs+oReupjhXSxBzy
         134X8QZyi7Y1Pjb+cdQ8Yc6dG/pTXwK1fl1WarXo55Y77AFEUmxKyPSVGL0cLigcuujG
         m2bw==
X-Forwarded-Encrypted: i=1; AJvYcCXuhlVweqMqzSRA6271SVpTv8NTMtNWtQ/YtgD0rGPmEh1RL49gZljNO3wb75pT+poNtEumHK1+8rYiw1ajLd++muu8lPQ5I/cyB/RdVjlqV3JgrfU9fi7u0OPKCiEjkBM=
X-Gm-Message-State: AOJu0Yyj9PzhZt/iyEg+NbzaOq585hueP2Mq0ROCDsrxoUpZMLVm1rrx
	RCjp76aszWdhm30a7DpKelBHB1JFgajPbtkynHMyXJT3QRkAt0Mu
X-Google-Smtp-Source: AGHT+IF2phb79FDLw20KVr7LF4eR7Bgul9QTnbcOTTgFCXe82zMP4UAG31RWnW+py3PWYDn1lLA4pA==
X-Received: by 2002:a05:6512:39c5:b0:52c:842b:c276 with SMTP id 2adb3069b0e04-52e8270914amr4513816e87.53.1719832261886;
        Mon, 01 Jul 2024 04:11:01 -0700 (PDT)
Received: from [192.168.42.253] (82-132-220-46.dab.02.net. [82.132.220.46])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4256af59732sm148347685e9.11.2024.07.01.04.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jul 2024 04:11:01 -0700 (PDT)
Message-ID: <330dbf5b-4022-4ceb-a658-a182c16f9f59@gmail.com>
Date: Mon, 1 Jul 2024 12:11:12 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/5] net: batch zerocopy_fill_skb_from_iter
 accounting
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
 <a916f99aa91bc9066411015835cadd5677a454fb.1719190216.git.asml.silence@gmail.com>
 <667eed8350f89_2185b294e2@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <667eed8350f89_2185b294e2@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/28/24 18:06, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> Instead of accounting every page range against the socket separately, do
>> it in batch based on the change in skb->truesize. It's also moved into
>> __zerocopy_sg_from_iter(), so that zerocopy_fill_skb_from_iter() is
>> simpler and responsible for setting frags but not the accounting.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks for reviews!

>> ---
>>   net/core/datagram.c | 31 ++++++++++++++++++-------------
>>   1 file changed, 18 insertions(+), 13 deletions(-)
>>
>> diff --git a/net/core/datagram.c b/net/core/datagram.c
>> index 7f7d5da2e406..2b24d69b1e94 100644
>> --- a/net/core/datagram.c
>> +++ b/net/core/datagram.c
>> @@ -610,7 +610,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
>>   }
>>   EXPORT_SYMBOL(skb_copy_datagram_from_iter);
>>   
>> -static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
>> +static int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
>>   					struct iov_iter *from, size_t length)
>>   {
>>   	int frag = skb_shinfo(skb)->nr_frags;
>> @@ -621,7 +621,6 @@ static int zerocopy_fill_skb_from_iter(struct sock *sk, struct sk_buff *skb,
>>   		int refs, order, n = 0;
>>   		size_t start;
>>   		ssize_t copied;
>> -		unsigned long truesize;
>>   
>>   		if (frag == MAX_SKB_FRAGS)
>>   			return -EMSGSIZE;
> 
> Does the existing code then incorrectly not unwind sk_wmem_queued_add
> and sk_mem_charge if returning with error from the second or later
> loop..

As long as ->truesize matches what's accounted to the socket,
kfree_skb() -> sock_wfree()/->destructor() should take care of it.
With sk_mem_charge() I assume __zerocopy_sg_from_iter -> ___pskb_trim()
should do it, need to look it up, but if not, it sounds like a temporary
over estimation until the skb is put down. I don't see anything
concerning. Is that the scenario you're worried about?

-- 
Pavel Begunkov

