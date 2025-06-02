Return-Path: <io-uring+bounces-8178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B650ACAC22
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 11:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 060C417BC31
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 09:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34DA1E7C07;
	Mon,  2 Jun 2025 09:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C0fUU9Ek"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ED31EA7C8;
	Mon,  2 Jun 2025 09:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748858155; cv=none; b=IkL0xmpTxHKtPvs9eRABP7mBozMvEsnIZFwEYpgM7XdQGhQq8anjpvG/T3zFMy8hYnBsP7NAluJqQnwsEYECLJo6VRH1mpXAv19f4H5gaTIZ+uiMetxOKD3bOW5Ut8fXkQZmJHXznx6t25HL8dqWk1AhzD+9U6391TUDFjBqLvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748858155; c=relaxed/simple;
	bh=A+M090s6y/FkUze6dqrWEApKVyNHPhmYBplsruVR8mA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JG6DIi59vwk2nmkK30gWdaO07tjI48uZCHkGUSkpwrlmkM3UTpsARkNML1/9dfuvPkQ/UfNZ1xZQSjMMe2uGK4HDWmCot2di3wmx1Ga/Z2NLkZc7oGl5UQF/3JBGU/BknNFLyGjtkaDtielB2MpmjW6lgmBcBhz9QRzU7i3fz94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C0fUU9Ek; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-604e2a2f200so8113667a12.1;
        Mon, 02 Jun 2025 02:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748858152; x=1749462952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L32aD4icTbCMjwqseHCI65RbsfdW97ibXzddDKuitas=;
        b=C0fUU9EkqBkV1f5RR5QJqq2fS/gJNb3Lx2ctml0CuauLMcicuvmgEBbvYpjeB4SQeq
         oVAh+nHzTlqNtvxLqHZHRFdLsiybJiov91Xwa7NwU2TXNHzAJhYpZ1Zl7TTa8UchhBiO
         +gY4UfD4czxv7KzTWV3sSzMVaF3z7kL3hk+Nm42qC6PYciIQqtrGmZz9Z/9J0cCW5DBm
         p/g1McM+eAiFlLVp0DNlIWGvKavwq624Tvgbkd1jNFBzX58HFVYcqOF0kuMRF+PBI+yS
         Klfqd9uKOPNnQZ8jJTOlqW4sYPY2J3wxsaMUoSCWWSHIvRfsxR17G/n6mKZ/lHsRVewR
         /aBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748858152; x=1749462952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L32aD4icTbCMjwqseHCI65RbsfdW97ibXzddDKuitas=;
        b=pXereRYZeKUJbCt8w/7biNsu4WRNZ7/CcRSmf3KKnvvJ4jIpmmpU+NFNgoreZvEuZi
         zGwfWdwVqqjIfZn4y+rNhlaHgVUcl7X56bzzlprjXMG5C61wIja2/zOQ3ZNwcisqLOdT
         fvzAKXZjdSP4h860e5lslgJqv36+VHNjmD7/6vkGNp+M7EE9fHbgUY9FkrEE8IREB0Qm
         gfrw6plgzOGa2mWmb1F/Tt3izIi+m2q7qso9V5VJMKBSJRPUm0gKRcD93+X0cgYJeVSm
         efZhrrefHojEvQLRt1+vxB6rgNRZzeomx1V8KSWHvmNDzzOYin+3cpgy17dtvzuNDLyX
         +bHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJXbKtW7BB5Et8E0m/lG+VqzMdPrbRSNIOXu9yZw7cPhow4rSBeOYydX1DUcApC33FUVP+gRqLFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcT/wS0gNtOIPSwhT+dAcbe1be1mS3TbDEW+0V4uF8m3h7hOUF
	KQl+/pHHBw6gRRGuoo3vdA9LFYLocCFRii6QpLJ8SwcuopNQXb2g5uPy
X-Gm-Gg: ASbGncvrLey2CXUtalO52Ji9xdhCKK5sal7D4QQUkVThvqLFCMDToEYJoaDKuQk9J/d
	hj62IWKK2rGIA9oOnlTljLW6pdKdbtuvoW2DRyrjv5ld9OoALKGdkMyLBa21kt8cDLK7wSWAXa+
	upRf8tdMb+u9kodWGA6bN+O1TrWLXDnnQTrqHtfeRP374DzY/aieHL2YDOC43Mhgbh7//ubIC4k
	ZB/vLFMcyTca4mUoURia011G5SKtgnQ8Wue4VQF6FbfP/FnXLZ7F+tTq3cPxdyHS16uJJlRqpgG
	aICnkmqVTep71ucASiJivAlUe0DQPjTFIm9QjkObGOahI0UqvCwVpGWTLjSylwfT
X-Google-Smtp-Source: AGHT+IGT8vfwT2qQLzIyjlQJgFBh4Xri1ghGgicTwGXas/SaewiS6YcEjchae2r3aVfPUkypHw+H2A==
X-Received: by 2002:a17:907:2d08:b0:ad8:9b5d:2c2f with SMTP id a640c23a62f3a-adb493ac0f5mr802100666b.4.1748858151987;
        Mon, 02 Jun 2025 02:55:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:8317])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39e58sm777967766b.146.2025.06.02.02.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 02:55:51 -0700 (PDT)
Message-ID: <07d408c8-c816-4997-ab87-1a6521d0bacd@gmail.com>
Date: Mon, 2 Jun 2025 10:57:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] net: timestamp: add helper returning skb's tx tstamp
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
 <683c5b38ed614_232d4429431@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <683c5b38ed614_232d4429431@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/25 14:52, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
>> associated with an skb from an queue queue.
> 
> Just curious: why a timestamp specific operation, rather than a
> general error queue report?

Timestamps still need custom code, not like we can do a generic
implementation just by copying sock_extended_err to user. And then
it'll be a problem to fit it into completions, it's already tight
after placing the timeval directly into cqe, there are only
few bits left.

Either way, I guess it can be extended if there are more use cases,
or might be better introducing and new command to cover that and
share some of the handling.

...>> diff --git a/net/socket.c b/net/socket.c
>> index 9a0e720f0859..d1dc8ab28e46 100644
>> --- a/net/socket.c
>> +++ b/net/socket.c
>> @@ -843,6 +843,55 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
>>   		 sizeof(ts_pktinfo), &ts_pktinfo);
>>   }
>>   
>> +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk)
> 
> Here and elsewhere: consider const pointers where possible

will do

> 
>> +{
>> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
>> +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
>> +
>> +	if (serr->ee.ee_errno != ENOMSG ||
>> +	   serr->ee.ee_origin != SO_EE_ORIGIN_TIMESTAMPING)
>> +		return false;
>> +
>> +	/* software time stamp available and wanted */
>> +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) && skb->tstamp)
>> +		return true;
>> +	/* hardware time stamps available and wanted */
>> +	return (tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
>> +		skb_hwtstamps(skb)->hwtstamp;
>> +}
>> +
>> +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
>> +			  struct timespec64 *ts)
>> +{
>> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
>> +	bool false_tstamp = false;
>> +	ktime_t hwtstamp;
>> +	int if_index = 0;
>> +
>> +	if (sock_flag(sk, SOCK_RCVTSTAMP) && skb->tstamp == 0) {
>> +		__net_timestamp(skb);
>> +		false_tstamp = true;
>> +	}
> 
> This is for SO_TIMESTAMP, not SO_TIMESTAMPING, and intended in the
> receive path only, where net_enable_timestamp may be too late for
> initial packets.

Got it, I'll drop that chunk if you think it's fine. Thanks
for review

>> +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
>> +	    ktime_to_timespec64_cond(skb->tstamp, ts))
>> +		return true;
>> +
>> +	if (!(tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) ||
>> +	    skb_is_swtx_tstamp(skb, false_tstamp))
>> +		return false;
>> +
>> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
>> +		hwtstamp = get_timestamp(sk, skb, &if_index);
>> +	else
>> +		hwtstamp = skb_hwtstamps(skb)->hwtstamp;
>> +
>> +	if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
>> +		hwtstamp = ptp_convert_timestamp(&hwtstamp,
>> +						READ_ONCE(sk->sk_bind_phc));
>> +	return ktime_to_timespec64_cond(hwtstamp, ts);
> 
> This duplicates code in __sock_recv_timestamp. Perhaps worth a helper.

I couldn't find a good way for doing that. There are rx checks in
every if, there is also pkt info handling nested. And
scm_timestamping_internal has 3 timeouts , so
__sock_recv_timestamp() would need to duplicate some checks to
choose the right place for the timeout or so.

-- 
Pavel Begunkov


