Return-Path: <io-uring+bounces-8374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02779ADB741
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 18:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42F26188A3B1
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C002877E4;
	Mon, 16 Jun 2025 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SuL5ocsI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548F32868BE;
	Mon, 16 Jun 2025 16:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750092225; cv=none; b=YZTL+X0ylY3pFAvZb+pXswOgISLhTri4YRSA92ejRPECbIRacagnYyI7V3A7aDbebJn9BwSBlXAMMc2gZAbyA1tmFrUM1zYBPsxV8mALmFy+2VSOKEM0RVOPeH8sOhLc7Zv6KEG8addX8HQRE47FtsFD1z/iUcZ2yaEXm4pFheI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750092225; c=relaxed/simple;
	bh=t/rcOgrqV4GUMhRY/s8qMXwRBu0gGDxETR85eeBHoxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nmUBYMOhnG/ePkumkEbnU2K0k29VthbseE5q3hxfCEe9YuIUN0ejTcSdJ+xTn0q06UP9PpSA1FMZrxv+7c4v/2gFAII1q7sxiOCrM2fbqZLHrnOaVW/DkPhk86o4DcQto6lIHkcAN6EUUFU5X5QTs6bMui/bS82Q3G2MgeA9V1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SuL5ocsI; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45310223677so38861265e9.0;
        Mon, 16 Jun 2025 09:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750092221; x=1750697021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MJu/DRgKxbvGWmrmMICOxRmLs/eFEaqIfRF424VViBo=;
        b=SuL5ocsIU1theeMGlhz3+K4XCVwXXVKX3uX6J1zPIYehq56nYWN5K3X/e380/tMUYE
         1rxg0TkFq2I8QlCRRFoSRlNs0EY7d2XUuECDQ+3kyrR4j1RkhfgPFqqb2BXfS/VY2fFf
         HdDofRz2frFJvXHMAVQP6qz5PbB9YqhKkuuwBUTLKa306JnmFA4tpRFgmwet4kAt3bSJ
         rim/Z4/sWs+4NMSvDD3rEoznN0BdetGoVCKFRbH4ddyS4k83xPUqHN2r6l+XqbC5t0uV
         tqMOd75TNi4d8ZvOSeMWJiMb3VSTdPK8luvIXvtuyWIk+o+6rgHnz3Xmxc57cAMYSITh
         N3hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750092221; x=1750697021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MJu/DRgKxbvGWmrmMICOxRmLs/eFEaqIfRF424VViBo=;
        b=kB/WF8YsO9HlN1mUiex0yi57X7z1BdkT3Gp2oBxRRKXhUO78lhqKzuTzCjQ2QIjbNV
         jTRN6OOWO1AMt6vYEtu8Hz39ZNPEOHbRVZwOjpkhOcIeSeOzDwhKwjvYmLRZUrDOhlPg
         upIT1yh4VBApPHL3X8TYZpLz9xYgH3ZtOxLxDRFIdVU6YdeJgTaxZ0ug7bFC0KIwTWKn
         ENzL++3KQw0L36CrTUVPMEQucYBC8xjLZHySoFq6yDiJAJ7dHAJqYK/bgznZSqfyFueL
         uDf5k1l4NqLxWvYwQbJXflxSUknymlhOWuclwE9LdGxJq1QeE/naUOA2R4d6xZm3ilBl
         zKyw==
X-Forwarded-Encrypted: i=1; AJvYcCWcfZkc77U0W0ZNEU5BgPPVRSgDi5qNXhnXdiaCS86NSSySoyAtRuuK2FmrSph2Ek+a4TqzrU6iyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmwQzaklkNWv2L3pc57pCXMvXoAuE9ADeVqM3njUd/dis07Rsr
	6HV8THFADp2E5HSJ5RGHxlVqXWaf31PItUVSgRJg6WN4MJXwOVEp7WfM
X-Gm-Gg: ASbGncst+O8/dBHzuv5pXkJMf/xobObJ53Lp4XBgw9MCp2Xtnf17ofaMx/7bXqdyQZ+
	Uedi0ghAB0GCEuw3S94JE4Ncb+vm65HVcplbOva7iT5hSelu3QMt0K4ZMzBZQq4/YyFlu4CGmg1
	QeBu+WEidsXMTS999dCecxMWuPHPtb2XPnuclfoGtNiIRh6Nwm/3TdVvZgO0ZMhW1WuUsWWvWhV
	Xm31hiEOx+gh9rfE3AVX2yRO+Kh/Fe0HNPwrjuNwY2wjmxm1cgwL7o9OvRbjgk1WbSYqSrFzA+N
	/RFg/fBFpsuC8o5YsEqZrHo6ak0jUEJyKY1Uv8gWJb7NcueMH9ZvYFrs2R3SrxJJ/A0vHQ==
X-Google-Smtp-Source: AGHT+IFgBj38TtIwuUXZqKCW9/IRbWhyd/rx6Z7YVLb5wsrzaOAK3EnCZ4cxViz3ola/pveQOmj5aQ==
X-Received: by 2002:a05:600c:3496:b0:442:f4d4:522 with SMTP id 5b1f17b1804b1-4533ca9467emr91887555e9.5.1750092221378;
        Mon, 16 Jun 2025 09:43:41 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4531febf905sm180848865e9.0.2025.06.16.09.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 09:43:40 -0700 (PDT)
Message-ID: <e96805aa-2ce8-46c0-b136-4781cf4092ce@gmail.com>
Date: Mon, 16 Jun 2025 17:44:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] net: timestamp: add helper returning skb's tx
 tstamp
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1749839083.git.asml.silence@gmail.com>
 <766c5e599bc94296fe58087e4c30226260cddff8.1749839083.git.asml.silence@gmail.com>
 <684f8218f2e39_1e2690294dd@willemb.c.googlers.com.notmuch>
 <560f6cd7-f66e-43ca-b458-ae362d0779de@gmail.com>
 <685031054a4b2_20ce86294c8@willemb.c.googlers.com.notmuch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <685031054a4b2_20ce86294c8@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/25 15:58, Willem de Bruijn wrote:
> Pavel Begunkov wrote:
>> On 6/16/25 03:31, Willem de Bruijn wrote:
>>> Pavel Begunkov wrote:
>>>> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
>>>> associated with an error queue skb.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    include/net/sock.h |  9 +++++++++
>>>>    net/socket.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>    2 files changed, 55 insertions(+)
>>>>
>>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>>> index 92e7c1aae3cc..0b96196d8a34 100644
>>>> --- a/include/net/sock.h
>>>> +++ b/include/net/sock.h
>>>> @@ -2677,6 +2677,15 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>>>>    void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
>>>>    			     struct sk_buff *skb);
>>>>    
>>>> +enum {
>>>> +	NET_TIMESTAMP_ORIGIN_SW		= 0,
>>>> +	NET_TIMESTAMP_ORIGIN_HW		= 1,
>>>> +};
>>>
>>> Can you avoid introducing a new enum, and instead just return
>>> SOF_TIMESTAMPING_TX_HARDWARE (1) or SOF_TIMESTAMPING_TX_SOFTWARE (2)?
>>
>> I can't say I like it more because TX_{SW,HW} is just a small
>> subset of SOF_TIMESTAMPING_* flags and the caller by default
>> could assume that there might be other values as well, but let
>> me send v5 and we'll see which is better.
> 
> This is quite a lot of new timestamping logic for only io_uring as
> user, and I don't see any other user of it coming soon. I also see no
> easy way to make it more concise, so it's fine. But this at least
> avoids one extra new enum.

enums are free :) Anyway, I don't have plans for further changes,
so I agree, SOF_TIMESTAMPING_* shouldn't be a problem.

-- 
Pavel Begunkov


