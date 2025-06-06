Return-Path: <io-uring+bounces-8243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8AA7ACFDFF
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 10:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC4B41893DF6
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 08:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6426528468B;
	Fri,  6 Jun 2025 08:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwSX3p5g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972AD24EF6B;
	Fri,  6 Jun 2025 08:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749197486; cv=none; b=eH7KScQaGFeDKFvgmKBxH5PddO3zWXv9NtgOo1wziamq5k3qvnNPLvNYLJElVFl3j97WD8SO+HSFFFrRzD91b4a08PEcLd9eHjISoPL8KLFZT33GAWkPAk2b0MuUTS6Nk/esyK4Ytu/odDSkDngAcKxJLNBa7ReFwIznhdLsF6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749197486; c=relaxed/simple;
	bh=pwZOfGiJt/s7Oge9X/SgMEhL5+DQd75nbQ6SFA1txnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hQM77DuLyNwiqZlyc3FhOUjcwKpM2DmhueZ6/j44mL9uBTW1LoqyvXEhH8ABmdnuMZCEh+NvRUPmXTD4Lf/9LI41cMBOg/1rwjJnO5Wc+KMdeYKePQ9eSIyyOcjDVewObnG/R0ymMSI2jOw0xM1/4EOjiZx7x/8oNnT3KFWRNb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fwSX3p5g; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-452f9735424so688705e9.3;
        Fri, 06 Jun 2025 01:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749197483; x=1749802283; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UzBVGZZU0P4i5ZwPSQTCBiEjH3K0NW/99S1seOitdw0=;
        b=fwSX3p5gj2Nx6J4/F5QAe3t6+p0u5cBf6AOZjn1yuO/U9acc8RNiZqFailAZvl5neE
         tlQEFl5mEZzr6UJtzi7BjysOwymMuqORl3lLfoS0snNWzkiGerlgzE9UTUZ2x2Az8EOi
         paYvpJ7JgEkwfPTw7XJREOlwup8dy0vYTjE2pQ1th93K38E3AtlkcOgzCajuybYR702A
         juhezyVP1v/lMJ7ypHaXpr2zxnqI87+z9p/rOXTt62UYOM/gV2JN4CJ27O16DNvebVNQ
         dtLP276X0b1GUoUyxtEfqx3XBNWnXZBsPaww2Wj83ulBrk+y6sunLN9wTYBnDNDEWKbt
         /R8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749197483; x=1749802283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UzBVGZZU0P4i5ZwPSQTCBiEjH3K0NW/99S1seOitdw0=;
        b=gCXXq8Lu+Jb1fsZcab9MXjSEzIDt4mzC+Rahh34fOF9kvX9mbf6x/iLDTHGYlDBflb
         UPEYODdR8mIYxTBf9fF9d9QwoY1U7VgRKii8f+0pLl82zF0n8ELwFUJ7ysMVViYdg9sl
         HMs+dUBU2kwBL/5x5toEWAxGPWldeC6QGOu3e3IO65rVlb7qQNMmnR4WKEOR9gSRC9FU
         thiZKx0/aBP+FE3EriQbW+h+ggFFN9FYL2wfbRZy9yY+lrXyCaQLdj4nPz79vwLdVbYO
         cYXQlI6hKrTzDBctPtE2Yp2Gci8+VBUqCEu9L1nf0UHpeJAEbovg6hA2fMsli8neOSJO
         JjCg==
X-Forwarded-Encrypted: i=1; AJvYcCV3nES2DAfzFor27v0Wq5k7cWVIhVADSqCOu79/OkLsqlhw1b2cANDja0yRI4nuzr2IKhv8ZlwO@vger.kernel.org, AJvYcCXCcnB6UA+xlPYY51hMtRVyyNbcAvqG4gi/+PXh7kw4SlCIc9dikYRi8EnaCuA8L5xzae7N0rzr3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAOB+7lq66AXPDNms56mQOGI7IvY5TFumaIl8+gIt4jt/mMPY/
	9A6B1Fh4ms4Enpbj82snjUE5BKd6irlyNyomicl0H9Eex50oAhXeFjYf
X-Gm-Gg: ASbGncv6RS4o0ZMMRFijxUMGy+DmKt7o5PNiPiPrXrFI00DYlF83RTFmK5AbN82PJJz
	+71ubZNBqSFD+Vfv+QyP3NXfmY8kP3dtuxmrL+oFahTl1wW/xSdhnfc6tpCcQbhDV9NBBaio1vu
	nmn0+sz2xnXxTfJ6PyLHvYj75TXi3rYB/b6oBB6Ile02OtEJwzpGpDWdGVKsZaFjsp95ZurdUUj
	MCLYIGcIwPyNLrNlzcwAUXXn2+B3K/KZItyThZt1YaC/TikBUhjfDxbRgwNKHtEeqNzfmqDnZ+r
	/EI/xC8Ns6vhCZ6gng1pjNZorFcrOgj9x0wLP62dOoUBoxegw7HRJwAta5wGPAKrkPDp8bOI
X-Google-Smtp-Source: AGHT+IGf2jh/0R53RduPJ/tEH+Vx7xIZ9YJ9JXIiNdXSgon6H4ecW4DYZegQ3GxVXUfR2VuT5QJyxg==
X-Received: by 2002:a05:600c:8b72:b0:441:d43d:4f68 with SMTP id 5b1f17b1804b1-45201450b88mr26891065e9.15.1749197482402;
        Fri, 06 Jun 2025 01:11:22 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.145.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45209bc6905sm16074265e9.8.2025.06.06.01.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 01:11:21 -0700 (PDT)
Message-ID: <449d5c82-7af5-42ce-bd69-00c2bb135a21@gmail.com>
Date: Fri, 6 Jun 2025 09:12:47 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Jason Xing <kerneljasonxing@gmail.com>,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch>
 <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
 <CAL+tcoAPV03jr6p2=XyRhdC1KiZBojtqn-frBdKjh+0=f=G2Qw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAL+tcoAPV03jr6p2=XyRhdC1KiZBojtqn-frBdKjh+0=f=G2Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 01:02, Jason Xing wrote:
...>>>>                                 optlen);
>>>>    }
>>>>
>>>> +static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
>>>> +                                 struct sk_buff *skb, unsigned issue_flags)
>>>> +{
>>>> +    struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
>>>> +    struct io_uring_cqe cqe[2];
>>>> +    struct io_timespec *iots;
>>>> +    struct timespec64 ts;
>>>> +    u32 tskey;
>>>> +
>>>> +    BUILD_BUG_ON(sizeof(struct io_uring_cqe) != sizeof(struct io_timespec));
>>>> +
>>>> +    if (!skb_get_tx_timestamp(skb, sk, &ts))
>>>> +            return false;
>>>> +
>>>> +    tskey = serr->ee.ee_data;
>>>> +
>>>> +    cqe->user_data = 0;
>>>> +    cqe->res = tskey;
>>>> +    cqe->flags = IORING_CQE_F_MORE;
>>>> +    cqe->flags |= (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
>>>> +
>>>> +    iots = (struct io_timespec *)&cqe[1];
>>>> +    iots->tv_sec = ts.tv_sec;
>>>> +    iots->tv_nsec = ts.tv_nsec;
>>>
>>> skb_get_tx_timestamp loses the information whether this is a
>>> software or a hardware timestamp. Is that loss problematic?
>>>
>>> If a process only requests one type of timestamp, it will not be.
>>>
>>> But when requesting both (SOF_TIMESTAMPING_OPT_TX_SWHW) this per cqe
>>> annotation may be necessary.
>>
>> skb_has_tx_timestamp() helper has clear priority of software timestamp,
>> if enabled for the socket. Looks like SOF_TIMESTAMPING_OPT_TX_SWHW case
>> won't produce both timestamps with the current implementation. Am I
>> missing something?
> 
> Sorry that I don't know how iouring works at a high level, so my
> question could be naive and unrelated to what Willem said.
> 
> Is it possible that applications set various tx sw timestamp flags
> (like SOF_TIMESTAMPING_TX_SCHED, SOF_TIMESTAMPING_TX_SOFTWARE)? If it

io_uring takes timestamps from the error queue, just like the socket
api does it. There should be different skbs in the queue for different
SCM_TSTAMP_{SND,SCHED,ACK,*} timestamps, io_uring only passes the
type it got in an skb's serr->ee.ee_info to user without changes.
Hope it answers it

> might happen, then applications can get lost on which type of tx
> timestamp it acquires without explicitly specifying in cqe.

-- 
Pavel Begunkov


