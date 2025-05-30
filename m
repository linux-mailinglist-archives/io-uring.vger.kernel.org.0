Return-Path: <io-uring+bounces-8172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF63CAC95B9
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 20:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF37A1C071FB
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 18:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED701A23A2;
	Fri, 30 May 2025 18:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cbg9LuZC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D871465A1;
	Fri, 30 May 2025 18:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748630577; cv=none; b=cM9ef2SdwM5InCIpqjcO16JVSIATM5z4C2IyNuJEw5LCMSYHbVYiVFhhX0YSnywUkhRRzO9Bujnc0/PrWx1z2SaTyFaAaCeqNU80sjGZZzrd952ywWgcA4vWtwMe3QZSXYap8f1IwxRecg+92Fx0jj4skR/xATR5E/tP04UcVKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748630577; c=relaxed/simple;
	bh=lurCT4soPo9L/GlONSXg2zQ/2rkDd0Ic1U5/P+wBMB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjUVJkFTuqSNxnKd4zx1UBNMPf+Fy7i2ppf6b8iQeWiGR+hf1j/K9feo7lM2k+NCbsuRZwtRKqYPY4VctHz3r3OvXF+0PQR8lLRX4JLAABecxGd1OFDuDdb82mqnI3IRrqAg4CCICZldJiDKt8w+bQkSsQAA7ilbleAOYHGFHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cbg9LuZC; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-60179d8e65fso4350556a12.0;
        Fri, 30 May 2025 11:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748630573; x=1749235373; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zUzsbogSE+xB3VoFzOXKYnCwFMV0vR3iQV6v5XwiLJY=;
        b=Cbg9LuZCxk4LB59Le0KK84dGF3KuyzuP+1ou789Caw/t++0fPCgqJjtsJT3l1BYrd7
         DwP86vro+k1UwnUtz+EZeUNdRvTxEPJqsf7AQcSvxzqcaWNTcI+MlXDxpb40QRrU6F8R
         ssmLxO++2zPW5CXbVkRIUrSP/izxyjd87mwm22YWtsz/iREUa2HZ5Cv+RDEN1lvgPG9S
         0pzLlxWM7NzaUd6e4E75Vmq+tOuxaEkBGHL4yekBPUoYusJCqKLkpNhq0YtFum8SzZpS
         fD07jxwhp+o1egBr+2zJWwmmDeV7wK1UNJSyLylM+61sNIlABt+ZEwNQt6k6FfRkjPb0
         Wc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748630573; x=1749235373;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zUzsbogSE+xB3VoFzOXKYnCwFMV0vR3iQV6v5XwiLJY=;
        b=T3/s827Hgv6B4b0+bFg+FMQE7vPxywWxHphNyPtgtKjvjTKK/6AXoQmjo6CKHkHRSS
         qRP8oC0mP8+exQ9pscfEuWi/fnmHctlQSDRCYW7ju7LrX8m1byefAdx9o9x9OKoNDUAN
         exr/9dupHfQKyA8J5EYY19NKCPbwz/YuvV1Zk1RDoMi3dLNxjPmw5A5O0ZmRJNp5Ghc+
         2POfhVg1DPG1ozGWRx979xbkek512vEMUD4JZB6AJTo9V094VeUMcTErClEh2nqUBznM
         FrlODobEurHbmRz3cLPBL1ZYX3XZQ3S29o2vIfYkALrAvL9XzHWrYaGyNvTnSsmNh02A
         QZiA==
X-Forwarded-Encrypted: i=1; AJvYcCXsqF7DHT8BuK6lXUhiytTfwwlbW88OazehImQ+e4KbUewejUyV+IjFvuVMSC0dxl+sS7f1M9c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrMHsNDpFuUi1uiBMGN5/YXmq2SodyHsHBlVxa2ApuzK109wrV
	3ErWlTHeKKRpW4CNX94InjzxrjFAKvz/4TSLeUFvtptMFWc/W3u4wZPm
X-Gm-Gg: ASbGncvHl+aiouxE7fHXKAvEqnemhXNtoe3Npf9ScCpI86soYKikDlqYiSL/9HsLovf
	BN4hgT9CgfxiuWhB5BBNhdqYOw0jduz6o9sIiomLPNaA15ai7iYoHMfRR/BwcHrAiZj8WYD/AyD
	Tg4Qbc8khmrnZIyRte+xPQLERhqvNoK6GKtieB5Jhz3JT+UNDdb5IIeqxfVbMNt2BiBwIGzg6gl
	kfwN9ZdyBrGfRNcpQ5Nhbfg/Cj37CsxEeTRfbJ7NJgQ1oIY7R7vCCsuX9LUQ2V6/EREuRqLST4x
	KlIRLpK2RdA80+jTEY884KteD46TKcT4HY1+hd9/X7pvWdGA1uNZSZ8stD+dGA==
X-Google-Smtp-Source: AGHT+IHt32XqTGic2A40geL6PgdLmToMt2o3PJ3OqYAV5bUGdd6CZ+ZmpWqto21B6A9W+qL0ihYTqg==
X-Received: by 2002:a17:907:3e13:b0:ad5:78ca:2126 with SMTP id a640c23a62f3a-adb3243e11bmr404822766b.59.1748630572661;
        Fri, 30 May 2025 11:42:52 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39420sm369779666b.136.2025.05.30.11.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 11:42:52 -0700 (PDT)
Message-ID: <2aa5377f-23ea-44b4-a45c-7df1acb39cf0@gmail.com>
Date: Fri, 30 May 2025 19:44:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] net: timestamp: add helper returning skb's tx tstamp
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>,
 netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
 <aDn1fV8D2G90mztp@mini-arch> <aDn5VKgXkYg77Qk_@mini-arch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aDn5VKgXkYg77Qk_@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 19:30, Stanislav Fomichev wrote:
> On 05/30, Stanislav Fomichev wrote:
>> On 05/30, Pavel Begunkov wrote:
>>> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
>>> associated with an skb from an queue queue.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   include/net/sock.h |  4 ++++
>>>   net/socket.c       | 49 ++++++++++++++++++++++++++++++++++++++++++++++
>>>   2 files changed, 53 insertions(+)
>>>
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index 92e7c1aae3cc..b0493e82b6e3 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>>>   void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
>>>   			     struct sk_buff *skb);
>>>   
>>> +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk);
>>> +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
>>> +			  struct timespec64 *ts);
>>> +
>>>   static inline void
>>>   sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
>>>   {
>>> diff --git a/net/socket.c b/net/socket.c
>>> index 9a0e720f0859..d1dc8ab28e46 100644
>>> --- a/net/socket.c
>>> +++ b/net/socket.c
>>> @@ -843,6 +843,55 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
>>>   		 sizeof(ts_pktinfo), &ts_pktinfo);
>>>   }
>>>   
>>> +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk)
>>> +{
>>> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
>>> +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
>>> +
>>> +	if (serr->ee.ee_errno != ENOMSG ||
>>> +	   serr->ee.ee_origin != SO_EE_ORIGIN_TIMESTAMPING)
>>> +		return false;
>>> +
>>> +	/* software time stamp available and wanted */
>>> +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) && skb->tstamp)
>>> +		return true;
>>> +	/* hardware time stamps available and wanted */
>>> +	return (tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
>>> +		skb_hwtstamps(skb)->hwtstamp;
>>> +}
>>> +
>>> +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
>>> +			  struct timespec64 *ts)
>>> +{
>>> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
>>> +	bool false_tstamp = false;
>>> +	ktime_t hwtstamp;
>>> +	int if_index = 0;
>>> +
>>
>> [..]
>>
>>> +	if (sock_flag(sk, SOCK_RCVTSTAMP) && skb->tstamp == 0) {
>>> +		__net_timestamp(skb);
>>> +		false_tstamp = true;
>>> +	}
>>
>> The place it was copy-pasted from (__sock_recv_timestamp) has a comment
>> about a race between packet rx and enabling the timestamp. Does the same
>> race happen here? Worth keeping the comment?

I can add the comment

> Or maybe you don't need this case at all? Since you're skipping the
> tstamp == 0 cases anyway down below... Pass 'false' to skb_is_swtx_tstamp
> instead?

__net_timestamp updates skb->tstamp, so I couldn't prove it's fine to
omit just from looking at code. But I don't know all intricacies of
timestamping, would be great someone knows a way to simplify it further.

-- 
Pavel Begunkov


