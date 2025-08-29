Return-Path: <io-uring+bounces-9462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D50C0B3BCBF
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 15:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BC6A14E4DE8
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 13:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82F831CA76;
	Fri, 29 Aug 2025 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BcUQemeY"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E9D31B11F
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756475070; cv=none; b=fWSHgj4/lXuAVKfuKIRlL8b6vnWcf9fiNsKq2t1/hsLtaR8eo+aNIQ9tuf6qOwVD5nsm7uZjvLWdfqh1K+ybc9jZUFOkrCIg6TcztTzIGjMNyiUvLHDEVqOw9dFOMaiOVE7Su0KH5hXRNXpVpw0TkAk5vZSqZs8GyqGP10BjZ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756475070; c=relaxed/simple;
	bh=WgrgF64O6SSUQMmouhwkl3f76xx5O2eioDfE/NO9GDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=up4g4tABC/r1hmhpyZrVQS/qMdZtYVtDxVz1WXOoL25OZCixmUvlO1/Oy3o6UelK3ZEJni2Bdfe2WFjxE7xTUIVfHuJTeA0PTCWIf2nViyKeVtGFFgl8PRTdfsxwG3eY7TZrZ6vIZhxPLjhp8sX4VYv77Tk1jptAll9PQCM+2xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BcUQemeY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756475067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qjuXMBMcmzq+emhjc+4nz3INVtnsR/3o1W/HmfSMpGo=;
	b=BcUQemeYhjetjNTJr4lH9pVAIs3KejG+dlTqO360L73SgM1N9S7JketWLWXqEh/E6kDaBp
	ZcUzn4CRRs6DFx2pf+IQxVulP1b0DHh6D5LlFzwWcosekx4TIYp6LuazrnDpeq/rqKSOIF
	aYo2cFultMxxolU+d6+tVCWbGAeyA5A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-O7bJS4qwNYazlehUDhwyzw-1; Fri, 29 Aug 2025 09:44:26 -0400
X-MC-Unique: O7bJS4qwNYazlehUDhwyzw-1
X-Mimecast-MFC-AGG-ID: O7bJS4qwNYazlehUDhwyzw_1756475065
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3cd08f3dfb3so794156f8f.2
        for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 06:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756475065; x=1757079865;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjuXMBMcmzq+emhjc+4nz3INVtnsR/3o1W/HmfSMpGo=;
        b=kNLwQ8I0jRlkGDIcKT6ENvEk/7WxcFHeQ8arZKLYfbz3mPYE0JwV5PjVneJ3KusQGN
         TWxpLoAytXsVAvfSPjJt9JwrPXXkPnjc5KK3suV01oYj4l7AMQX93kJBgJ3p0yyVmFm+
         Lx1SWJ9zC0odETuZoj3JkT8irS5XXY2xmujj6v+XWp/uuBC6FaPLYmk41J9wkRvM6csR
         Ws286I/ladNv7LsyAzZWs/T9LJviZL96YaNwHKIC0urZPzTLrg2bCZdw0aHxzCIIqH/k
         8PzaS0ResaTH7w6cM9BsQ8PtkZ45TBHiwILs40oddu21gD6xfSHI676NwZoBa7w4Xhbd
         QTQw==
X-Forwarded-Encrypted: i=1; AJvYcCWGtw3x/lQeQjASzGPAQcfkdVfTBppqepwLpH3TLeps+mGoWLoqQ0TCi/gq4XkyYlb8ON8uOEf8nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsK4gqGGKLeAba33BGYZOZYt1e0XUWEX+KaxdaAmvNicegIUpy
	6rOUSc5YRM1yQ3hVjTcwdt7vormA+z5yBhfJdAQyaNQioi9PELzssrAeyw73vPFvLq/34Lmk3dV
	50J+s4D9GNnD4dxPSkPUdZ/kM34l0PTpFqLcC21iRkO4v4WsKGPlsPntaUWV0
X-Gm-Gg: ASbGncvCREXtl4C9zQOdQIVyu8o2zcmb5Exli6ZSvU4v3QO7oWDDGtoJB6SrBZYHtg0
	NZEhW2oDEBiBE5LRvAMe4zTBKTmz0IBpq53AiTqujfCvnIL+qkShb411VBBG0jPt5QW/b/OKLPp
	gOyNmiEDmgkp2H7iG/91ktKNiNKg5bqFlGi7Vhm/o7kcTngdVt+IdOI4+mv5v1BqiCoF6ZKku2G
	YjY1OIEDx9B3BY/w3SHYZkFba6HMpbZjkmxz9o1RYxaCfccIt6Anc72g1jNmUKOZCYoPowUR4Ca
	0AmyUuzI6xMxARXMTvW6Wpuqb3k0sTn8CGi+ELz76WeH/HUgwgj06AQaI3MWXo23+rtbHXSy6ub
	zCcvsObMtzWH3tdUzq1yiD39mw8S4AN/hieE6JIkSXSqdMNcEQG8bRzUspOgc6ImN
X-Received: by 2002:a05:6000:4383:b0:3b7:882c:790 with SMTP id ffacd0b85a97d-3c5dc73625cmr21478736f8f.37.1756475064955;
        Fri, 29 Aug 2025 06:44:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+LDG7SGqPVe42ftCg4HBC4EBVhYJgcuG7xRsE/56l9/NNaGo5xTMXjkE7lTdlBAQ5z49MkQ==
X-Received: by 2002:a05:6000:4383:b0:3b7:882c:790 with SMTP id ffacd0b85a97d-3c5dc73625cmr21478675f8f.37.1756475064268;
        Fri, 29 Aug 2025 06:44:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c22sm121018675e9.13.2025.08.29.06.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 06:44:23 -0700 (PDT)
Message-ID: <e877229a-ffd8-4459-a31b-ecabde28e07f@redhat.com>
Date: Fri, 29 Aug 2025 15:44:20 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 20/36] mips: mm: convert __flush_dcache_pages() to
 __flush_dcache_folio_pages()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-21-david@redhat.com>
 <ea74f0e3-bacf-449a-b7ad-213c74599df1@lucifer.local>
 <2be7db96-2fa2-4348-837e-648124bd604f@redhat.com>
 <549a60a6-25e2-48d5-b442-49404a857014@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <549a60a6-25e2-48d5-b442-49404a857014@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.08.25 14:51, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 10:51:46PM +0200, David Hildenbrand wrote:
>> On 28.08.25 18:57, Lorenzo Stoakes wrote:
>>> On Thu, Aug 28, 2025 at 12:01:24AM +0200, David Hildenbrand wrote:
>>>> Let's make it clearer that we are operating within a single folio by
>>>> providing both the folio and the page.
>>>>
>>>> This implies that for flush_dcache_folio() we'll now avoid one more
>>>> page->folio lookup, and that we can safely drop the "nth_page" usage.
>>>>
>>>> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> ---
>>>>    arch/mips/include/asm/cacheflush.h | 11 +++++++----
>>>>    arch/mips/mm/cache.c               |  8 ++++----
>>>>    2 files changed, 11 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
>>>> index 5d283ef89d90d..8d79bfc687d21 100644
>>>> --- a/arch/mips/include/asm/cacheflush.h
>>>> +++ b/arch/mips/include/asm/cacheflush.h
>>>> @@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
>>>>    extern void (*flush_cache_range)(struct vm_area_struct *vma,
>>>>    	unsigned long start, unsigned long end);
>>>>    extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
>>>> -extern void __flush_dcache_pages(struct page *page, unsigned int nr);
>>>> +extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
>>>
>>> NIT: Be good to drop the extern.
>>
>> I think I'll leave the one in, though, someone should clean up all of them
>> in one go.
> 
> This is how we always clean these up though, buuut to be fair that's in mm.
> 

Well, okay, I'll make all the other functions jealous and blame it on 
you! :P

-- 
Cheers

David / dhildenb


