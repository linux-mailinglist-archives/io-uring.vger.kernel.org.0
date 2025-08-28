Return-Path: <io-uring+bounces-9431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18389B3AC0E
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 22:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E79E1C85331
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 20:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFEF62BE7A7;
	Thu, 28 Aug 2025 20:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7E22cw+"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE9929BDB6
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 20:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756414440; cv=none; b=okBXok5+hyztdA/PBHjG3Weq0sgYR+DN+2ZW4jnPSxHJhcmhAvkkAndmcojPSVcXp9W/rOYVTAafY0GoWnOBPw1gV0CehX0q/LuUGflAiHKBHgMk4teTFJRg9JfshcVHCyhwLoFMJATs7K0ZAlBY1JtqwQHWmhaHQc4Hpu4CK5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756414440; c=relaxed/simple;
	bh=2ucm0soIRFTqQyMyRZNn1dLd48MxmtIvrqQi2CirSwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVHRP/jky7whzvtvq2JWNw5tnd5TDkdNkgapnVcz1cK7YGhc7U9BSaWJtOICGmxLTt7Pl3Jg4N+FbPOMJcRtUkjORmTzVCuzL2BaowtNQ8SzY+aLWdSzx/ON+PVQgZr3NA1wqKCCvo9YLdCm5lVcq8+m2dJbvLQz0u6OkGBC9i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7E22cw+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756414438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TWFVCA1eidbRWe4Mvk+B7obYKckT+mqN7M8LbBoJEjM=;
	b=Q7E22cw+5Aga/QMvhtV3KMtUFOEm6qOHJLNhOLj7+MRGJnq5TETY9cmLON9YFfpYRi9GYo
	66AkD/xOd4HD32aDJOJPHyuo04GkDIhmrlbV5eHCMb2tnHPfCR5tRE8OdRcA7gBgSC8OSI
	ANNfkSdvT1eZ70wrtl+gjq49ugtg7x0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-oS0pQ-ZUNHaz1atxl092Cw-1; Thu, 28 Aug 2025 16:51:52 -0400
X-MC-Unique: oS0pQ-ZUNHaz1atxl092Cw-1
X-Mimecast-MFC-AGG-ID: oS0pQ-ZUNHaz1atxl092Cw_1756414311
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b612dbc28so9257955e9.0
        for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 13:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756414311; x=1757019111;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TWFVCA1eidbRWe4Mvk+B7obYKckT+mqN7M8LbBoJEjM=;
        b=vSN7KMC5569xFvvTq2H2lKNcn1ceto49G597KC2yTjIKV0Rr6lg+0qPzd+wAG3U7+L
         kARGFOIA+OpPxFvxO7TgQ7sn/wFcHUnETkUqf9SkkUNuzvhen92Y7JrnGMf+DJ0LDq8M
         OzslS4MqPkXFt/o5nzIiVSLVkVRQrgJNLi4ar9DTHenFlzMB5WrXLR123swJE2xk6q4Q
         t0x50z2K4Lx7c3inq2AEumvPpN5dXRzSYERuTObywMlwZDHeg/+BFjeG0rfG8Vf1f7Ox
         bOiLYCDyyc0KvK7KSY1kVz77vJt1bsSGlfJOJ8jWc6NYxvp+byy3CUFwujKECBPrQhZx
         yTNw==
X-Forwarded-Encrypted: i=1; AJvYcCVHujaN6zE7Z1i6MDpTo6Koj3F0UUqoO/sQNYQAWLviRK0gwSUkrFv9dnwpoI959caKbKf7SOt+Ww==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFE0aKcpz4e6OjE5enp1a1Uk2n77cj18xrxPFjzfQg7D2ZLaCm
	VhnhMLaiZqbU+0LvTO407qE5slDYc7wdYWfrilTv+MGyK3yyS2iBdoZkgpXBypDw41P56tQcx5q
	+Wdy6TyVzjizh6j0a+CIIh353ibmWxPXfzjKckOciceCHRVyaUISSgmuxohc6
X-Gm-Gg: ASbGncs1KG5qaOfSO6wqr0aNKZ1j+XBmNAL66spItkC2dCqmW3J0FrNQqsRDmJZESUi
	rdHc/JCjheb/EzNWSLfu6Ng+QrUacQPJepk5rcuRgtfg/WMhzKmfk+FKYjDY5l700lb4iUq3FeQ
	dty/5vLOpXDnSwy1quCLRjUAX2RfHFfPoOkga4jrEq/DXojZ+8IUv3VV1XsJ9pSu6d3GQ1ZH8y3
	6KxCFXzoWbwnfMEDXlDqUcwm5wlQV+EXBC6m/0JN9a7JBPUWrixuQjHOLz+1bk2Y5aeuEWdwGTK
	5gOoyMxxNT8dPCxKZ92Angt9hoaqTsquTFuRV+HIZlvDPdqn79XHqahrgURufjSjOPTCAUC2moI
	wSta6OOTaG6CswMuXPwBouPXcRCj0gnaQTYz7wUjxHUSPHFewfSD2WfB4XuKebTsPKPU=
X-Received: by 2002:a05:600c:c491:b0:45b:4d47:5559 with SMTP id 5b1f17b1804b1-45b517dadd6mr212975725e9.36.1756414310762;
        Thu, 28 Aug 2025 13:51:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBxEpIi+OizhCOrvRivNgDFtglg6ujTEy6gKjCh35xHRfgibjOrf5BEosBm4/LLfFcliwoKA==
X-Received: by 2002:a05:600c:c491:b0:45b:4d47:5559 with SMTP id 5b1f17b1804b1-45b517dadd6mr212975405e9.36.1756414310334;
        Thu, 28 Aug 2025 13:51:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7df3ff72sm8506805e9.1.2025.08.28.13.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 13:51:49 -0700 (PDT)
Message-ID: <2be7db96-2fa2-4348-837e-648124bd604f@redhat.com>
Date: Thu, 28 Aug 2025 22:51:46 +0200
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
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <ea74f0e3-bacf-449a-b7ad-213c74599df1@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 18:57, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:24AM +0200, David Hildenbrand wrote:
>> Let's make it clearer that we are operating within a single folio by
>> providing both the folio and the page.
>>
>> This implies that for flush_dcache_folio() we'll now avoid one more
>> page->folio lookup, and that we can safely drop the "nth_page" usage.
>>
>> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/mips/include/asm/cacheflush.h | 11 +++++++----
>>   arch/mips/mm/cache.c               |  8 ++++----
>>   2 files changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
>> index 5d283ef89d90d..8d79bfc687d21 100644
>> --- a/arch/mips/include/asm/cacheflush.h
>> +++ b/arch/mips/include/asm/cacheflush.h
>> @@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
>>   extern void (*flush_cache_range)(struct vm_area_struct *vma,
>>   	unsigned long start, unsigned long end);
>>   extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
>> -extern void __flush_dcache_pages(struct page *page, unsigned int nr);
>> +extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
> 
> NIT: Be good to drop the extern.

I think I'll leave the one in, though, someone should clean up all of 
them in one go.

Just imagine how the other functions would think about the new guy 
showing off here. :)

> 
>>
>>   #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
>>   static inline void flush_dcache_folio(struct folio *folio)
>>   {
>>   	if (cpu_has_dc_aliases)
>> -		__flush_dcache_pages(&folio->page, folio_nr_pages(folio));
>> +		__flush_dcache_folio_pages(folio, folio_page(folio, 0),
>> +					   folio_nr_pages(folio));
>>   	else if (!cpu_has_ic_fills_f_dc)
>>   		folio_set_dcache_dirty(folio);
>>   }
>> @@ -64,10 +65,12 @@ static inline void flush_dcache_folio(struct folio *folio)
>>
>>   static inline void flush_dcache_page(struct page *page)
>>   {
>> +	struct folio *folio = page_folio(page);
>> +
>>   	if (cpu_has_dc_aliases)
>> -		__flush_dcache_pages(page, 1);
>> +		__flush_dcache_folio_pages(folio, page, folio_nr_pages(folio));
> 
> Hmmm, shouldn't this be 1 not folio_nr_pages()? Seems that the original
> implementation only flushed a single page even if contained within a larger
> folio?

Yes, reworked it 3 times and messed it up during the last rework. Thanks!

-- 
Cheers

David / dhildenb


