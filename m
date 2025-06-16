Return-Path: <io-uring+bounces-8372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B094AADB70F
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 18:35:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E41B6168F63
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C147269CF0;
	Mon, 16 Jun 2025 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OL7AUP4E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0BA2868AA;
	Mon, 16 Jun 2025 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750091749; cv=none; b=WDcaAOoVZXd49BgPt06S6IzJKtjWMoVGFpmXzWY73CWP4odnlbcGuCUpCd1jHH4c5I8D8IrQ/+wnXdclXAIdKz/MqhegGoCyr3CCfmm+EzkK9r7AltSyPAv8VGx8zODLQWe8+GxTwcoHSCQ0750dOeFE8YgAx1+okHzgLi0OVnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750091749; c=relaxed/simple;
	bh=f//04nA86a2frPrdLvlf59G2O/r7xSN5UM0jMXIiuxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vfa1WZ2o1pFu2hZOg9rjosu1VNYPMZNpLnfrdDNp3K18nNQtUpNXPLlxXkDG9EOgjvvmVEHcjyG0+0T4dzUgQjEKPI/amdHWx6n5BuQa/QFWThQ0zo2cwE4AOIAy5/rn8dq3+HtMLd4DleEJB+g7U48H8zF9RH8PK53DA3hCKH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OL7AUP4E; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-451d7b50815so39843025e9.2;
        Mon, 16 Jun 2025 09:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750091746; x=1750696546; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p95WO1l7RogtvAaExfdpVHlBm0jGWO82lMgNc0hMKck=;
        b=OL7AUP4EPe2KUXh2EN10joQXfUR6H/MEpImeGSREg71O1VpMz5heF8zPOoYxrDzG7E
         +KULryfEasa49qnAf+hYcSkA0GjE/HSU64tN4EfgASezkDCgYWcUg7gryJlJ00cIm5cE
         tk1q1N8doOxIxJel9Nn0XTQV/XQ/htu0VXuvox/urm8sybmpk9ReSTT58/FM1dfhKOT4
         FbBb64zNx1E4k6aJ1bcebYLSXlognMx3iOyR3CxwbA9thWL576LwtIpXXxTnDLcaCdct
         FQ9eEuk7nTyaucahwIi7yeY2jSN44Wk6Ct4nBXHW37mlsbm6qd2wddGdbMmkKDDroLUY
         qIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750091746; x=1750696546;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p95WO1l7RogtvAaExfdpVHlBm0jGWO82lMgNc0hMKck=;
        b=wtMrQuXD2w43gsQEO/QZascAv5uPfmwxFHE7SuzW81dJG+rtEIRNoPs0G/l9Ex0lLr
         fWZGws46YmXLH0JVCGvEpwfcCPk4/RLReZXRVVy07hOXGxasazjWbwBld4aP0EUM5AH0
         fdskonC/zx9bkKgE/FGCc4eshxgoQzmiS+8zkKoY6l4T40PhluJT2lVRAKNeRAOOlD5b
         8XSULib+Nrrz6HBCtqOU//n3gLjtVzHVvfOxf/z9lSgWKZTUiADsKrsxnVg2K3FluQfZ
         RZKo6zKKj4m17E0JF6RIj+DWFJ+fOrDHD5EOKScAYTlhdWOqB6rFY/BLbolQ5skbhLYA
         0Jsw==
X-Forwarded-Encrypted: i=1; AJvYcCWB3T4BmB8ZvJ9vsTTe5UG+iy0ZavbvbbFPeyYKQsQEb4lEFVxRjwpqBL/no9VqgSHL9P63L+DHDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWwfjuFrDEbV+m1TBNQVPxC+TSHVQiiYt8GayHP2us3wkmbKr0
	AOdciTEXXcOmJIDawXw2SrwFsbAUn/LPieYbmTtBqC8dHwQ6yEEm8fQa
X-Gm-Gg: ASbGnct59Cu/z1MSClWxo+5Yt5pd+tY6n6Xm7LshzjfVE+tDxNj3tV6birCakOlOlT5
	s/kuztkBM8VR26pqNaazGrjNyUHdaYTS5Wg/vz1lJn9b29zixHMScstG6pgjeyBG1/OFHwL0Bji
	9mEaCcsbw93U5n9bSypkdBb//7+bAoI6tZaGGadsJE8IvZeIjdLdbvHSjM/tldS8iKgLuM6hkel
	mVCvhjrwYBqHTN+G0kjBCAm6mMOIGKQI0UYgp6GFByg5ju9sqMKO06vDPTXMzcq/EnFcjXO7vcn
	UcLHln+cVPLnh1C5hE/Bj4liYQqjLJB3TEvCE5KnxbR7Qt38Sj4HPhy8OWclj2FYLXM2oQ==
X-Google-Smtp-Source: AGHT+IFAPTIK3NWEph1La8TZ7u5iliYHvGiUwHtrT/yqY1uJDb81dZz062orV4ofhNmW3Oz3uIwG7Q==
X-Received: by 2002:a05:600c:1e1d:b0:453:6ca:16a6 with SMTP id 5b1f17b1804b1-4533cae690dmr118354705e9.10.1750091745437;
        Mon, 16 Jun 2025 09:35:45 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e172b03sm149127985e9.36.2025.06.16.09.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 09:35:44 -0700 (PDT)
Message-ID: <65907669-80cb-4c79-9979-4bd2c159c0ed@gmail.com>
Date: Mon, 16 Jun 2025 17:37:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] net: timestamp: add helper returning skb's tx
 tstamp
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
 <685031d760515_20ce862942c@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <685031d760515_20ce862942c@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/25 16:01, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
>> associated with an error queue skb.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/net/sock.h |  4 ++++
>>   net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 50 insertions(+)
>>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 92e7c1aae3cc..f5f5a9ad290b 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -2677,6 +2677,10 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>>   void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
>>   			     struct sk_buff *skb);
>>   
>> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk);
>> +int skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
>> +			 struct timespec64 *ts);
>> +
>>   static inline void
>>   sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
>>   {
>> diff --git a/net/socket.c b/net/socket.c
>> index 9a0e720f0859..2cab805943c0 100644
>> --- a/net/socket.c
>> +++ b/net/socket.c
>> @@ -843,6 +843,52 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
>>   		 sizeof(ts_pktinfo), &ts_pktinfo);
>>   }
>>   
>> +bool skb_has_tx_timestamp(struct sk_buff *skb, const struct sock *sk)
>> +{
> 
> I forgot to ask earlier, and not a reason for a respin.
> 
> Is the only reason that skb is not const here skb_hwtstamps?

Yes, and also get_timestamp() for skb_get_tx_timestamp(). It's easy to patch,
but I was hoping we can merge it through the io_uring tree without deps on
net-next and add const to the new helpers after. It's definitely less trouble
than orchestrating a separate branch otherwise. FWIW, it'd be fine to add
const to the existing helpers in the meantime as long as the new functions
stay non-const for now. Hope that works

-- 
Pavel Begunkov


