Return-Path: <io-uring+bounces-8840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9917AB1428C
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 21:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFCF218C1086
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 19:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C1F277804;
	Mon, 28 Jul 2025 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4oWtQAW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888FE1EDA2C;
	Mon, 28 Jul 2025 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753731658; cv=none; b=MZ8PoFOSkRDmAw7f0f6ZQuPjLYMVLnYz+d40L2lDxYdGi3DdZOPdOZvoJ0qUly4NQTq+mQOkPolSlO9XOdSQ7nDE/oF4giGJrevZg7g4IHqXJ2TproElt2WFrrTWLWA7OLgW0UaQeXh1mp4qzZ4QAxfAmt69lRWd1zSvDt/7W2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753731658; c=relaxed/simple;
	bh=LQEBJEvg/DxwaziVJt4WWMRfzfyMu+INXReGmJnxjnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YfrduBxCHuE0XADBqNPqRMTQePeKkSK+UOnbrTDNLKPeh/LMZnDYUhd2gfFTnWwM+aHTjuXN6CIj7eDxb3ma9U9tOuINFzMuhgFahcOa/o8Dnkk9aVRDUfyQdtwqKucFti7k9iw4iDX3vZKFzgDQlp14pLcfonFTcmTGX08ZPkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4oWtQAW; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ae0bc7aa21bso973512766b.2;
        Mon, 28 Jul 2025 12:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753731655; x=1754336455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DxiBf7tyAXHNfhG9eO9KsuATO6gRP/qYcmxm3/mZRY4=;
        b=E4oWtQAWw0RFe+KLdXa93F3MTWWTD20NYfuzCXyPIGfsQ2hOLUgZmC07X8N1Al0ED1
         oxevq8o5ZH/dMGlD9Ph+4SP1zLfbYN1TJLN8jzrgeqwUq2RBkvwZeNXIasnyF/FLEVaJ
         TPvxIt0rNY9S0eDmwC5I/F8zr1F5uiOq7pXqFNi9PsHJit+wk0qL8sK/78rYY09Gj27Q
         cbUd9lTCfSqJ5u9kzB1QllHIommcu1ugGCr/ZlBNeQELjGXadcOBb/jy3RMd/jdPENej
         02LHfE/jJRGVktDV2ro7yD7QaudPZTElG+f527h1NMYeqerNyi3R27Q7/RFie9Zsv1u3
         yoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753731655; x=1754336455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DxiBf7tyAXHNfhG9eO9KsuATO6gRP/qYcmxm3/mZRY4=;
        b=E7YDCYiiSBDO8twYSf0FCSrx2evPMagz81FiTFs/NOGH/rgtgGqee6rVUBIlParwJQ
         OatkBtHYK4lvKkbGs4gNLiYqsTvCctN2y6arYOAGfPf4uQYcDPpVW2WhFuuRsUQ+Hjje
         LQSTfoxn1ar7lgyIQUxBIZRDpdEa2n8FRWmBWn3EXLsoyGcHB3T5TCagg3nrdvA2agvN
         as9lWaqQBOtQyDe2JwKpKzLI78F8hH+MeOmvKIKm9LTzqo7zvn5tKkhwXrxJ/SICGMWj
         AMwcI/1qwRh2WeVnhwBBUxwzVP4/vforCvGZVwGRgv7GWayIbexsfQiKtC9mBCLLTAQZ
         Sn0A==
X-Forwarded-Encrypted: i=1; AJvYcCVkE3dguWrzz8D9zlq2TsG823MU3p4uZwJxsviKSSAzbNGcOheUGgQ7UPxQZpuOQcTt2SzYwZNBwA==@vger.kernel.org, AJvYcCW8xztT8NBlLzN0MET0o1taJMGDLPgSb4psYE8jvuJ+x7Iyr/Ula4FFCnmzUxM0zNlQtAlArXh4@vger.kernel.org
X-Gm-Message-State: AOJu0YxShkZB9aMI7jy8Ht9c8uIo4pJWMokqxIomqW/DYB0gMraRYLhC
	qZDmRXVqz0RO1DNrdgYpXCO8kjy0PIQntf93DqIL8PvNSvYhdPmOeLAy
X-Gm-Gg: ASbGnct7uGBLV/xyB+SMBUFYDOhu26H2FivhqIhguuRgz5oYPJgnXF8W0m7YQwke6Ai
	AE71dX5l8M0QhYV7AqJoIihQsixeuDmyWEkMwuXSYriSbpJQG5KeTLQzIIsY1UAtMIFOla+jcTu
	EDdYUWbA3lnBgwqVvHwoqA8C0vCPlOl2bMf2pwiciOqjpJ1KlM9e6zB1bgAtcmrfzV5PYuAwQh2
	o2lwlXlazXmJjCu6/O/7xU8PYxljCP6V28dYfNBPKmSIndVpNdvl0URACQOWGyR0oXNeD+c+UEH
	08SYxtA7XFnLaGFtVL9nSWIAvFjBjJDOp3qsY7l/eo+IScY+HxmJ8UTvaJWMJRWBbOeuEig+AI2
	bDNZB5rg+RrovB/j3aFDaK/wGPDtVmKw=
X-Google-Smtp-Source: AGHT+IF3+0bEZh2dVSMAS/bLDKD4NocXc+e3aWTBiuwI1szsKZ5Tz9guNCvNTbXxsa7Cfv9ncFoUig==
X-Received: by 2002:a17:907:9728:b0:ae0:d013:8b20 with SMTP id a640c23a62f3a-af61e533d07mr1563073266b.41.1753731654471;
        Mon, 28 Jul 2025 12:40:54 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.164])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61539ab9188sm1849639a12.26.2025.07.28.12.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 12:40:53 -0700 (PDT)
Message-ID: <9922111a-63e6-468c-b2de-f9899e5b95cc@gmail.com>
Date: Mon, 28 Jul 2025 20:42:15 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMyhMFA5DwBmHNJpEfPLE6xUmA453V+tF4pdWAenbrV3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/28/25 19:54, Mina Almasry wrote:
> On Mon, Jul 28, 2025 at 4:03 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> This series implements large rx buffer support for io_uring/zcrx on
>> top of Jakub's queue configuration changes, but it can also be used
>> by other memory providers. Large rx buffers can be drastically
>> beneficial with high-end hw-gro enabled cards that can coalesce traffic
>> into larger pages, reducing the number of frags traversing the network
>> stack and resuling in larger contiguous chunks of data for the
>> userspace. Benchamrks showed up to ~30% improvement in CPU util.
>>
> 
> Very exciting.
> 
> I have not yet had a chance to thoroughly look, but even still I have
> a few high level questions/concerns. Maybe you already have answers to
> them that can make my life a bit easier as I try to take a thorough
> look.
> 
> - I'm a bit confused that you're not making changes to the core net
> stack to support non-PAGE_SIZE netmems. From a quick glance, it seems
> that there are potentially a ton of places in the net stack that
> assume PAGE_SIZE:

The stack already supports large frags and it's not new. Page pools
has higher order allocations, see __page_pool_alloc_page_order. The
tx path can allocate large pages / coalesce user pages. Any specific
place that concerns you? There are many places legitimately using
PAGE_SIZE: kmap'ing folios, shifting it by order to get the size,
linear allocations, etc.

> cd net
> ackc "PAGE_SIZE|PAGE_SHIFT" | wc -l
> 468
> 
> Are we sure none of these places assuming PAGE_SIZE or PAGE_SHIFT are
> concerning?
> 
> - You're not adding a field in the net_iov that tells us how big the
> net_iov is. It seems to me you're configuring the driver to set the rx
> buffer size, then assuming all the pp allocations are of that size,
> then assuming in the rxzc code that all the net_iov are of that size.
> I think a few problems may happen?
> 
> (a) what happens if the rx buffer size is re-configured? Does the
> io_uring rxrc instance get recreated as well?

Any reason you even want it to work? You can't and frankly
shouldn't be allowed to, at least in case of io_uring. Unless it's
rejected somewhere earlier, in this case it'll fail on the order
check while trying to create a page pool with a zcrx provider.

> (b) what happens with skb coalescing? skb coalescing is already a bit
> of a mess. We don't allow coalescing unreadable and readable skbs, but
> we do allow coalescing devmem and iozcrx skbs which could lead to some
> bugs I'm guessing already. AFAICT as of this patch series we may allow
> coalescing of skbs with netmems inside of them of different sizes, but
> AFAICT so far, the iozcrx assume the size is constant across all the
> netmems it gets, which I'm not sure is always true?

It rejects niovs from other providers incl. from any other io_uring
instances, so it only assume a uniform size for its own niovs. The
backing memory is verified that it can be chunked.
  > For all these reasons I had assumed that we'd need space in the
> net_iov that tells us its size: net_iov->size.

Nope, not in this case.

> And then netmem_size(netmem) would replace all the PAGE_SIZE
> assumptions in the net stack, and then we'd disallow coalescing of
> skbs with different-sized netmems (else we need to handle them
> correctly per the netmem_size).
I'm not even sure what's the concern. What's the difference b/w
tcp_recvmsg_dmabuf() getting one skb with differently sized frags
or same frags in separate skbs? You still need to handle it
somehow, even if by failing.

Also, we should never coalesce different niovs together regardless
of sizes. And for coalescing two chunks of the same niov, it should
work just fine even without knowing the length.

skb_can_coalesce_netmem {
	...
	return netmem == skb_frag_netmem(frag) &&
	       off == skb_frag_off(frag) + skb_frag_size(frag);
}

Essentially, for devmem only tcp_recvmsg_dmabuf() and other
devmem specific code would need to know about the niov size.

-- 
Pavel Begunkov


