Return-Path: <io-uring+bounces-8843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DFEBB143A4
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 22:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6183B3A653B
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 20:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD3F22FE11;
	Mon, 28 Jul 2025 20:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dK4IYFWf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C1D22F774;
	Mon, 28 Jul 2025 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753736192; cv=none; b=mxPKSz4iZpfdFbq8vYrJZiL2/+2dYbFHoTKwvRo1z/WziGrfCFfKBeciAyK2E2cdY1gwAuzHdXmHGSYHBuSUUHUXSihH4izA+jvzlTKu0/hDdta/qz/bKy+dQyKqxT5Zhoq/26Ll/ICeJIl/5jUxzbxr1WrZy4ZcQRQD90pSFlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753736192; c=relaxed/simple;
	bh=mrhL5z+dRL/7LvIUNMoZmvlwGP2IeJz0gt4A9ZDu5u8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GT6WkYxVIiGv2tTrg/bx++YrtdATWa69N6qfW6mJihzZahgYdH7zqep19SBfRruU6Zd/bJGBJR0K26DsWf1G/MDijAkyR/jbqKM9tLM5udNH337xb5cCkIggp8Lutn1LFfAUUvcU0DVycnyE0YuDukHUP3X/1zDDwZxZn/Kdyns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dK4IYFWf; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-615398dc162so2628999a12.3;
        Mon, 28 Jul 2025 13:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753736189; x=1754340989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=axn7/c9oWY5F4rHdVczmAizhZThb4BFLNBto3xGrMc8=;
        b=dK4IYFWfOmulevZz6KULg7pyQ0BHQWg5N7TvK0Bpn/yuClovVrZBPXEMYyvAG6ISGv
         xdYCXGc4u2f1qb5Z6v6ozZAHRp4s8P2b9bZ+AT9qgzmeqKwlMaz4HcbNmPsJwHrMnK6i
         qhqmetmS1NeMC95OkdbTCy1Ba4f4cEsApaXLP5TM959WEtgCELcmtp6J7wOBNaEtmwzm
         aRgERFRiJK4YPXlmjA/EygK1YtM2dK/VR8EbO0AJrK709uc8kXW5rpr4SEAVnnQdZ+8b
         4tM6W2zgarphnMWFQVOuKQ+A9I3lcYW65PuT0y9GgW6w6zhfiH8hdhei2m/k+VWl8sVP
         kpnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753736189; x=1754340989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=axn7/c9oWY5F4rHdVczmAizhZThb4BFLNBto3xGrMc8=;
        b=fMKbtE2P8OS1I01/RkUP22CxJA2GvvS3DCp/Sei27sBdeKg2zvVb+4EIfJLGdlf7WT
         D3AhstxW7GWl48qWf9EEklbBwUs72MvK2Mql/Jv13MQOHBslowzBgiMz4L1Mb6a+uPP/
         9TzE5qyxYSaD4Rvy2wU0IByJITlRuFrYuyC2sPkt6QWUSoznaUZ966vOAnwD7/NjWRel
         49M+ft2GyG+9Yjs6WBimKCI2A64XWhdQNaY6O2xxPTDKg+EXjskVBC+A4a1HSnKq6Inv
         CRSZMkY8ITYXtE34Tve0uLlb1RGUNze7rbh+MzlEf2OM9pnAoM/zThH3LPHg5Ug23uXF
         OZDA==
X-Forwarded-Encrypted: i=1; AJvYcCVNNMnwMzJ7IQS81RG2UZvBHbb9l/OPJ9GdrDlj5inzvO/N8oK1+OPxv6SnSVOV+/Fzgz+UUHU3@vger.kernel.org, AJvYcCVb/qYIkN1NahG+rGIauJEjFpFizj7OyxYmblEgjwMvVpfeuARVC6lhi2nyx6R3reG4Nw8qy48/Lg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHUjrBri2orKB1o+SPahyiLFhO7rzrdiBQZ22Oh3SghIAZYcRx
	jIIY7PUe19vAQNiTWUXDpbtPRxb2QpBVA2rDi1gLqnWw3V6irPPrt/oJ
X-Gm-Gg: ASbGnctvl1OJBg8OmRRq8hXzu/k/dDq9JVcTZyhJoss40eJXBjaXDuHmcI3QpFLwYXP
	GoX4cmtLR1lM65bruN1QGjOD/RwZ2QKmJH5Za7jiTEqe0gKZvnSBi5KWIp2YfxvDyuIwNqXK5Kd
	pZbt22L8P5Q90pXw8Rz/chXzWvvdsTaJm1I24E6oZ3mDHnIoBCkjXyeXBAYPjBjnfblMvoD2+rU
	83XmITnNn0PuOXyu/37KuvhxEvkdgWXlNSTGYWgAs9ZRZK1s1WtzqjiBFn+vtSsRiVN/4xXb5Y4
	zqsiJy3J3zfXkvpuIAASVtm71BWGHoGlRNK/54tA/63U7WMPEgazhs+HxZTvRAycgqKiqP/WNI+
	7rFImP7rlKEyITZLuunNYDWk2aeaJXSk=
X-Google-Smtp-Source: AGHT+IF+KtZY7J9joZ+spRy/zMGlBvv4wyq7UggxbrnVCWhIj6oMdZpb9o8KiF3qvzAPavzu5ghYHw==
X-Received: by 2002:a17:907:60cd:b0:af2:4257:fa1e with SMTP id a640c23a62f3a-af617d00e58mr1582521666b.25.1753736188447;
        Mon, 28 Jul 2025 13:56:28 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.164])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635aa4e7dsm480429666b.108.2025.07.28.13.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 13:56:27 -0700 (PDT)
Message-ID: <8c90f485-192f-4f7a-ac94-8171d78f3c4a@gmail.com>
Date: Mon, 28 Jul 2025 21:57:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Mina Almasry <almasrymina@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, dw@davidwei.uk, michael.chan@broadcom.com,
 dtatulea@nvidia.com, ap420073@gmail.com
References: <cover.1753694913.git.asml.silence@gmail.com>
 <CAHS8izMyhMFA5DwBmHNJpEfPLE6xUmA453V+tF4pdWAenbrV3w@mail.gmail.com>
 <9922111a-63e6-468c-b2de-f9899e5b95cc@gmail.com>
 <CAHS8izMR+PsD12BA+Rq2yixKn=656V1jQhryiVZrC6z05Kq1SQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMR+PsD12BA+Rq2yixKn=656V1jQhryiVZrC6z05Kq1SQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/25 21:23, Mina Almasry wrote:
...>>>
>>> - I'm a bit confused that you're not making changes to the core net
>>> stack to support non-PAGE_SIZE netmems. From a quick glance, it seems
>>> that there are potentially a ton of places in the net stack that
>>> assume PAGE_SIZE:
>>
>> The stack already supports large frags and it's not new. Page pools
>> has higher order allocations, see __page_pool_alloc_page_order. The
>> tx path can allocate large pages / coalesce user pages.
> 
> Right, large order allocations are not new, but I'm not sure they
> actually work reliably. AFAICT most drivers set pp_params.order = 0;
> I'm not sure how well tested multi-order pages are.
> 
> It may be reasonable to assume multi order pages just work and see
> what blows up, though.
> 
>> Any specific
>> place that concerns you? There are many places legitimately using
>> PAGE_SIZE: kmap'ing folios, shifting it by order to get the size,
>> linear allocations, etc.
>>
> 
>  From a 5-min look:
> 
> - skb_splice_from_iter, this line: size_t part = min_t(size_t,
> PAGE_SIZE - off, len);

It does it for pages that it got from
iov_iter_extract_pages() a few lines above, those are PAGE_SIZE'd.

> - skb_pp_cow_data, this line: max_head_size =
> SKB_WITH_OVERHEAD(PAGE_SIZE - headroom);

This one should be about the linear part, not frags

> - skb_seq_read, this line: pg_sz = min_t(unsigned int, pg_sz -
> st->frag_off, PAGE_SIZE - pg_off

That's kmap handling, it can iterate a frag multiple times
in PAGE_SIZE chunks for high mem archs.

> - zerocopy_fill_skb_from_iter, this line: int size = min_t(int,
> copied, PAGE_SIZE - start);

Pages from iov_iter_get_pages2(), same as with
skb_splice_from_iter()

> I think the `PAGE_SIZE -` logic in general assumes the memory is
> PAGE_SIZEd. Although in these cases it seems page specifics, i.e.
> net_iovs wouldn't be exposed to these particular call sites.
> 
> I spent a few weeks acking the net stack for all page-access to prune
> all of them to add unreadable netmem... are you somewhat confident
> there are no PAGE_SIZE assumptions in the net stack that affect
> net_iovs that require a deep look? Or is the approach here to merge

The difference is that this one is already supported and the
stack is large page aware, while unreadable frags was a new
concept.

> this and see what/if breaks?

No reason for it not to work. Even if breaks somewhere on that,
it should be a pre-existent problem, which needs to be fixed
either way.

>>> cd net
>>> ackc "PAGE_SIZE|PAGE_SHIFT" | wc -l
>>> 468
>>>
>>> Are we sure none of these places assuming PAGE_SIZE or PAGE_SHIFT are
>>> concerning?
>>>
>>> - You're not adding a field in the net_iov that tells us how big the
>>> net_iov is. It seems to me you're configuring the driver to set the rx
>>> buffer size, then assuming all the pp allocations are of that size,
>>> then assuming in the rxzc code that all the net_iov are of that size.
>>> I think a few problems may happen?
>>>
>>> (a) what happens if the rx buffer size is re-configured? Does the
>>> io_uring rxrc instance get recreated as well?
>>
>> Any reason you even want it to work? You can't and frankly
>> shouldn't be allowed to, at least in case of io_uring. Unless it's
>> rejected somewhere earlier, in this case it'll fail on the order
>> check while trying to create a page pool with a zcrx provider.
>>
> 
> I think it's reasonable to disallow rx-buffer-size reconfiguration
> when the queue is memory-config bound. I can check to see what this
> code is doing.

Right, it doesn't make sense to reconfigure zcrx, and we can
only fail the operation one way or another.

>>> (b) what happens with skb coalescing? skb coalescing is already a bit
>>> of a mess. We don't allow coalescing unreadable and readable skbs, but
>>> we do allow coalescing devmem and iozcrx skbs which could lead to some
>>> bugs I'm guessing already. AFAICT as of this patch series we may allow
>>> coalescing of skbs with netmems inside of them of different sizes, but
>>> AFAICT so far, the iozcrx assume the size is constant across all the
>>> netmems it gets, which I'm not sure is always true?
>>
>> It rejects niovs from other providers incl. from any other io_uring
>> instances, so it only assume a uniform size for its own niovs.
> 
> Thanks. What is 'it' and where is the code that does the rejection?

zcrx does, you're familiar with this chunk:

io_uring/zcrx.c:

io_zcrx_recv_frag() {
	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
	    io_pp_to_ifq(niov->pp) != ifq)
		return -EFAULT;
}

>> The
>> backing memory is verified that it can be chunked.
>>    > For all these reasons I had assumed that we'd need space in the
>>> net_iov that tells us its size: net_iov->size.
>>
>> Nope, not in this case.
>>
>>> And then netmem_size(netmem) would replace all the PAGE_SIZE
>>> assumptions in the net stack, and then we'd disallow coalescing of
>>> skbs with different-sized netmems (else we need to handle them
>>> correctly per the netmem_size).
>> I'm not even sure what's the concern. What's the difference b/w
>> tcp_recvmsg_dmabuf() getting one skb with differently sized frags
>> or same frags in separate skbs? You still need to handle it
>> somehow, even if by failing.
>>
> 
> Right, I just wanted to understand what the design is. I guess the
> design is allowing the netmems in the same skb to have different max
> frag lens, yes?

Yeah, and it's already allowed for higher order pages.

> I am guessing that it works, even in tcp_recvmsg_dmabuf. I guess the

And you won't see it unless adds support for that, that's why
I added this:

if (!net_is_devmem_iov(niov)) {
	err = -ENODEV;
	goto out;
}

> frag len is actually in frag->len, so already it may vary from frag to
> frag. Even if coalescing happens, some frags would have a frag->len =
> PAGE_SIZE and some > PAGE_SIZE. Seems fine to me off the bat.
> 
>> Also, we should never coalesce different niovs together regardless
>> of sizes. And for coalescing two chunks of the same niov, it should
>> work just fine even without knowing the length.
>>
> 
> Yeah, we should probably not coalesce 2 netmems together, although I
> vaguely remember reading code in a net stack hepler that does that
> somewhere already. Whatever.

Let know if that turns out to be true, because it should already
be broken. You shouldn't coalesce pages from different folios,
and to check that you need to get the head page / etc., which
niovs obviously don't have.

-- 
Pavel Begunkov


