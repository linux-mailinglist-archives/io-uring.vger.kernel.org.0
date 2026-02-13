Return-Path: <io-uring+bounces-12191-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPNkAOsbj2kkJAEAu9opvQ
	(envelope-from <io-uring+bounces-12191-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 13:41:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CEA1361A7
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 13:41:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2190300DE16
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 12:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D90E34D4F5;
	Fri, 13 Feb 2026 12:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OJTCt4jg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4E8340286
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 12:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770986471; cv=none; b=WHztz5zhR+8RGfNARxOdv+TGq8Mans0BhrK4MZ+e1vdADMwKmKUFNDNEeepF9abcXIZbwpG1cOUc06k4LkSBun3IEsj/hGArCl7mXoqFsYY27w6V9lEHzHor9bx26WE2fwCBQdOyvWlwQJI64YhdQHOdzK4cedw++ETSCOSGqcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770986471; c=relaxed/simple;
	bh=C3QxlzLnm76HOlE+ksstGgh1DACXGucn/hlzo8CopDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Su3H9U0P+gp4vqUCSD2EgCEKruEoRtgkrDGiA80uejz2Bau6KCNvf7/otPdcxY/D1LKKbxGBtQ03iklrNFIe0sqMvKVD/4Da3l6VWmCymnK4RuFnl/1GIZ9QPbcLkhyNCcIBvG+BA7QdRXY64XmDJyYICal+ZwkIsOud+cMxGAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OJTCt4jg; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8850aa5b56so119381866b.2
        for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 04:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770986468; x=1771591268; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yzeK2Mvd8UNW+VLQJ4AGhR6CR2m1sGVJWg1Xszvoqm4=;
        b=OJTCt4jghdX32Jug5/Jqg0ivWGjN4xuC8l1ZGcyyhS2VEpeEifLWhNhZLigjhvi5hQ
         4mhShYg6zihOg1iUGzC24LyaSpKXAopBd48idhLMAr4mjC8mULGN8ErvUonlfuiQTtWE
         T6AKtVw8Rc6gvpGUxYop48T8b/4rxD2zUff5PyjQhHrYsPRlPn2WXE209A0O8HCd7hii
         8OUEbZlm1aaCFDuGyXlwylGmVjPVtJ8BAq8jZPLpxnZZb0T2dyUWLr6O98vRA6kHKU35
         8wx3oLmvIdj7LTfZtm9eVt8tM7L74T7VgiJyPeoWSPg5Z62P1I7DYky4XC0KoDF4z0k7
         utQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770986468; x=1771591268;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yzeK2Mvd8UNW+VLQJ4AGhR6CR2m1sGVJWg1Xszvoqm4=;
        b=I60LGu+5zAOZ7QJU4mesYBCbCa4xq0wmF3FHOfgahlK0nIPwfM2t/Od4S0N0K+EF+F
         U5tmWM+ifDqFizXWJU9H2pnBJicjf7KkBTF4PoG4x8o/aVk1csVrHSiyUpJ5vsa1868b
         erl6ufwgjCwmxWAUUjOvIZh10noPd7u0cSPGJ6pbUNs2noAIQLIlhw3baBPqHyUuMSPn
         MwdkViRgHdQRiKc2XC2/O7IWk9R9C7wM/iMWe5nFZ2gB/pQVXJjGuv3xsC4p9UkqDsns
         LLYW6RnZTnhhi6OKepuskdAlTwqHfwYvqT01Vm96Nbixdf5Iqkk2e4eLT/+CLJZl0yJw
         8Vxg==
X-Forwarded-Encrypted: i=1; AJvYcCVns4/AiYcaR4kv7xyQPrRqWYpkMweHiGpVz0hMKBsQwJuTEoC7O7iGu59P3kYeLjr96v2ii9sADw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyRlnw3e62wvU78QXRkUa2VP9v/czfZ7HCYyuXnGJ1Ji2tAmJO
	K+ufuRnCG9HDOGn8v2DVovGZBSveHFFhSHLy9mUy1KZKlS8cuDxL2u8T
X-Gm-Gg: AZuq6aLiyMznxwDpn4OZ4MurssUxsGHsIs0ftcl/hOG18Mbg8G8qgpD5PRPz4rvtnTL
	u3YKVIg02AbKScprwgkHgpU5w4YVPqTRop1pUb1pfpOIZDqMGW1jd7Ru2jq8Lyqg9KytPkVADbk
	4Q6CkY2KTa+O+eNt8AlFUx1RcB71kqtFXbU62wWB+r8uw2gd3J7LX0xatb7FpLGadjdBWeXxq83
	5qcEz9fZaAU+Lxz9duoF7UdAA9aytpIgs0VR5x7bP6fOtKGUo544FBmS/sNHlG2GPDgPkHAvAIh
	uk2AjOUsxf8dGw6Ed4SqOFiE1jGABRmd+hJAZkkTev5umknpaGH48Yik4Ysgvr7WBe9LCUalSFA
	oc45MSlAaZswKDyA4pm2dYVw5H6tAYYvVMQIrd/uepY9keRwVVlrOxD2JrRfiwaiKT/cgg5mIss
	oO1y6tF3S4mAInqNUFGQ+9lvivE+eR5YaoMXBrsDLrSDxIvwM4u21YzNG2lReQ42U9nPbqpkcZD
	TEkgnJhPD26BDZUEDLzA6LCOb5mHr5cJTNY8GRV7pCA+xs0AoGgWgEQOw==
X-Received: by 2002:a17:906:fe43:b0:b87:fad:442b with SMTP id a640c23a62f3a-b8facca2fb6mr135128366b.3.1770986468044;
        Fri, 13 Feb 2026 04:41:08 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8b14])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fad57accfsm71602966b.16.2026.02.13.04.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 04:41:07 -0800 (PST)
Message-ID: <34cf24a3-f7f3-46ed-96be-bf716b2db060@gmail.com>
Date: Fri, 13 Feb 2026 12:41:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Christoph Hellwig <hch@infradead.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
 bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <aYykILfX_u9-feH-@infradead.org>
 <bd488a4e-a856-4fa5-b2bb-427280e6a053@gmail.com>
 <aY7QX-BIW-SMJ3h_@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aY7QX-BIW-SMJ3h_@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org,purestorage.com,suse.de,bsbernd.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12191-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47CEA1361A7
X-Rspamd-Action: no action

On 2/13/26 07:18, Christoph Hellwig wrote:
> On Thu, Feb 12, 2026 at 10:44:44AM +0000, Pavel Begunkov wrote:
>>>
>>> Any pages mapped to userspace can be allocated in the kernel as well.
>>
>> pow2 round ups will waste memory. 1MB allocations will never
>> become 2MB huge pages. And there is a separate question of
>> 1GB huge pages. The user can be smarter about all placement
>> decisions.
> 
> Sure.  But if the application cares that much about TLB pressure
> I'd just round up to nice multtiple of PTE levels.
> 
>>
>>> And I really do like this design, because it means we can have a
>>> buffer ring that is only mapped read-only into userspace.  That way
>>> we can still do zero-copy raids if the device requires stable pages
>>> for checksumming or raid.  I was going to implement this as soon
>>> as this series lands upstream.
>>
>> That's an interesting case. To be clear, user provided memory is
>> an optional feature for pbuf rings / regions / etc., and I think
>> the io_uring uapi should leave fields for the feature. However, I
>> have nothing against fuse refusing to bind to buffer rings it
>> doesn't like.
> 
> Can you clarify what you mean with 'pbuf'?  The only fixed buffer API I
> know is io_uring_register_buffers* which always takes user provided
> buffers, so I have a hard time parsing what you're saying there.  But
> that might just be sign that I'm no expert in io_uring APIs, and that
> web searches have degraded to the point of not being very useful
> anymore.

Registered, aka fixed, buffers are the ones you pass to
IORING_OP_[READ,WRITE]_FIXED and some other requests. It's normally
created by io_uring_register_buffers*() / IORING_REGISTER_BUFFERS*
with user memory, but there are special cases when it's installed
internally by other kernel components, e.g. ublk.
This series has nothing to do with them, and relevant parts of
the discussion here don't mention them either.

Provided buffer rings, a.k.a pbuf rings, IORING_REGISTER_PBUF_RING
is a kernel-user shared ring. The entries are user buffers
{uaddr, size}. The user space adds entries, the kernel (io_uring
requests) consumes them and issues I/O using the user addresses.
E.g. you can issue a IORING_OP_RECV request (+IOSQE_BUFFER_SELECT)
and it'll grab a buffer from the ring instead of using sqe->addr.

pbuf rings, IORING_REGISTER_MEM_REGION, completion/submission
queues and all other kernel-user rings/etc. are internally based
on so called regions. All of them support both user allocated
memory and kernel allocations + mmap.

This series essentially creates provided buffer rings, where
1. the ring now contains kernel addresses
2. the ring itself is in-kernel only and not shared with user space
3. it also allocates kernel buffers (as a region), populates the ring
    with them, and allows mapping the buffers into the user space.

Fuse is doing both adding (kernel) buffers to the ring and consuming
them. At which point it's not clear:

1. Why it even needs io_uring provided buffer rings, it can be all
    contained in fuse. Maybe it's trying to reuse pbuf ring code as
    basically an internal memory allocator, but then why expose buffer
    rings as an io_uring uapi instead of keeping it internally.

    That's also why I mentioned whether those buffers are supposed to
    be used with other types of io_uring requests like recv, etc.

2. Why making io_uring to allocate payload memory. The answer to which
    is probably to reuse the region api with mmap and so on. And why
    payload buffers are inseparably created together with the ring
    and via a new io_uring uapi.

    And yes, I believe in the current form it's inflexible, it requires
    a new io_uring uapi. It requires the number of buffers to match
    the number of ring entries, which are related but not the same
    thing. You can't easily add more memory as it's bound to the ring
    object. The buffer memory won't even have same lifetime as the
    ring object -- allow using that km buffer ring with recv requests
    and highly likely I'll most likely give you a way to crash the
    kernel.

But hey, I'm tired. I don't have any beef here and am only trying
to make it a bit cleaner and flexible for fuse in the first place
without even questioning the I/O path. If everyone believes
everything is right, just ask Jens to merge it.

-- 
Pavel Begunkov


