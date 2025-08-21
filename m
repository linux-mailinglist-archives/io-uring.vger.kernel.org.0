Return-Path: <io-uring+bounces-9230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 355CEB307C4
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 23:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B5121D02D77
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5A1393DFC;
	Thu, 21 Aug 2025 20:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWEvV7MD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51025393DF4
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755809357; cv=none; b=V8WzwBAU5DZ2dIRlHY4COzu+ull7wIbnOG8Rud0GWySdUOc3JEno5dZ+VF+akRw5owyocGrE6dnjoU7nPgjqD3tdRXGSl9iFgAVVf6IgtaQYZl+74ArVaOnWRiJnLcO+ZPd1vNIAUiQaD7DoRaLnHw8EdPZXxWNN/Z9XN7mxa8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755809357; c=relaxed/simple;
	bh=ttpRgX2WRarIZ7BHjDHCFpaBA1Eb2Zd4JhuxGrxMq2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jnK5hYmNtvAv+g4/79NcGEo2Zp3WPejUyttJUz34e1KIhZoagc2bPH/JRqTnFtK27P4MAe8VVdaqwJfNokPy/oeFGlmHq7xofibdTRo0czjPVhXtZp+WVrgtkpXdj47q4Mc/dpMlVqPqNHw6fo5S37/JPqFaOHa3AkL1lgXoAN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hWEvV7MD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755809354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OQbfbvrWDouK+ZcKIphQE1nervr1PSIMFSTWfTxDfjA=;
	b=hWEvV7MD47f0ckOqJ+Bg2hychSLIMcXncfFRqKpgBxhCmdhyNUzOUTh9uoqrjrivMpO+UV
	R/ZSwbmY+iS4vfMmw6SFUxGsqNvY0JQJOppSXW4BpIQLdhz5Jp9sz+pZ6fCRx9eRfwN9y0
	A8MUm5vNaNxszqhG4MlbOhJogCbEXzo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-n7OB-uM4MQO4XBMNqmYDnQ-1; Thu, 21 Aug 2025 16:49:12 -0400
X-MC-Unique: n7OB-uM4MQO4XBMNqmYDnQ-1
X-Mimecast-MFC-AGG-ID: n7OB-uM4MQO4XBMNqmYDnQ_1755809352
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0098c0so8586545e9.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755809351; x=1756414151;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OQbfbvrWDouK+ZcKIphQE1nervr1PSIMFSTWfTxDfjA=;
        b=nLH6MlR/DTjUrLSK5AwHqLrDgVH+7IkCE+LH5KO9oWndZp4QVzNVo8Ya6dMCDelB6P
         q4Llh1vTA5SrW8KkSdT8wLHdPSxqjtJN1/zuJFlfTQhduF0cK+DkBpMWf5ekC2SiIQwu
         4v1qdt6lQiukS31hIb9ggP3x/h03qJP26BaoDdQhTJwOGHj/ReGLqEHHpH1LlP7R3QX5
         vi1AIVql3bzpVmFwCdiQeu+Vmc9g36zt4lOrh3x2T5J8Ltc2oNgIsTS+skX8vK0gSuVi
         O8ADFcJ6RPoTeh+CaOGuLu0ZHcO83Ql104UHRC5ozZuP1/hTLXrW8u5yMSfkaJrtFQKk
         xF5w==
X-Forwarded-Encrypted: i=1; AJvYcCXhspkgsX3VcddOA/ZvjC7t1kjLv7p2lxx+DX/4B9QMdSOyWnRn00BgWPJHm6i7mHEEB4Nc4zH1DA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9WY9B2YdUOddl4Xxmvfr1qh24QMSDw3FWaLtkp4Rf5a8rS51z
	QRq39N681knChICR/kP1OBDB3W8Z8x6a2YKBynj6OviF10DN9dXiigC2dWTZf1ED/FBDl0uoVqh
	0wcl0/1PxldqvMOfqT2cUx4Tr+db3Tuzgg7nRKl9+mP8edFgSrU3yChNHbyiq
X-Gm-Gg: ASbGncsKFjf+SMt1jJFW3jzU8IyEQHKJEGlvq5ZRbPBd/iEHKN0aH9siL7E2a4mTuym
	iykrZ2RklxFeKqZTQG3WI3Qxhxa2G7cIjxWPUh0e3Og3t1yk+1yoDrYy/QWlKVFxICjpxRDKjZF
	CfGGo0NwcYMfQH1T+JhOJ/lkva+j3Kuq6r/dzLztPt/ugEHEnt7EvtUraxXLORNJ5vAd6dcNbw/
	mQoSFOAEFjSllVXbFAZ0/bcDZEAw8jnqgr+m5aoE35j52zuVfG1aNgXutn6IwTilYrgP1HlqFTo
	rzkDGIAWTHGQs2aWCI4u8YGgtt0V1D79shXEG5oLpt1xqmTADnxqndcv/FqRItBGmmJ3TgYqHe3
	Q85fBS1SpzZyEY81T+wWVwecPZvCiPMdWDYpwrqEW2FBVq6Vs/zftqwskknNoww==
X-Received: by 2002:a05:600c:3584:b0:459:a1c7:99ad with SMTP id 5b1f17b1804b1-45b517c5dc0mr2898005e9.22.1755809351423;
        Thu, 21 Aug 2025 13:49:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQxIz6cJmjwdOB6bO2j0uv4baEhvDU693i3u6jJ5B08S4e/6/ILSJ1Cj5B/IwK2GJTi24SIA==
X-Received: by 2002:a05:600c:3584:b0:459:a1c7:99ad with SMTP id 5b1f17b1804b1-45b517c5dc0mr2897695e9.22.1755809350879;
        Thu, 21 Aug 2025 13:49:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f26:ba00:803:6ec5:9918:6fd? (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c4c218c599sm3550158f8f.67.2025.08.21.13.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:49:10 -0700 (PDT)
Message-ID: <835b776a-4e15-4821-a601-1470807373a1@redhat.com>
Date: Thu, 21 Aug 2025 22:49:07 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 12/35] mm: limit folio/compound page sizes in
 problematic kernel configs
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
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
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-13-david@redhat.com>
 <FFF22E91-6CA5-4C8F-92DE-89C22DB3EAD7@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <FFF22E91-6CA5-4C8F-92DE-89C22DB3EAD7@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21.08.25 22:46, Zi Yan wrote:
> On 21 Aug 2025, at 16:06, David Hildenbrand wrote:
> 
>> Let's limit the maximum folio size in problematic kernel config where
>> the memmap is allocated per memory section (SPARSEMEM without
>> SPARSEMEM_VMEMMAP) to a single memory section.
>>
>> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
>> but not SPARSEMEM_VMEMMAP: sh.
>>
>> Fortunately, the biggest hugetlb size sh supports is 64 MiB
>> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
>> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
>>
>> As folios and memory sections are naturally aligned to their order-2 size
>> in memory, consequently a single folio can no longer span multiple memory
>> sections on these problematic kernel configs.
>>
>> nth_page() is no longer required when operating within a single compound
>> page / folio.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   include/linux/mm.h | 22 ++++++++++++++++++----
>>   1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 77737cbf2216a..48a985e17ef4e 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
>>   	return folio_large_nr_pages(folio);
>>   }
>>
>> -/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>> -#define MAX_FOLIO_ORDER		PUD_ORDER
>> -#else
>> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
>> +/*
>> + * We don't expect any folios that exceed buddy sizes (and consequently
>> + * memory sections).
>> + */
>>   #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>> +#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>> +/*
>> + * Only pages within a single memory section are guaranteed to be
>> + * contiguous. By limiting folios to a single memory section, all folio
>> + * pages are guaranteed to be contiguous.
>> + */
>> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
>> +#else
>> +/*
>> + * There is no real limit on the folio size. We limit them to the maximum we
>> + * currently expect.
> 
> The comment about hugetlbfs is helpful here, since the other folios are still
> limited by buddy allocator’s MAX_ORDER.

Yeah, but the old comment was wrong (there is DAX).

I can add here "currently expect (e.g., hugetlfs, dax)."

-- 
Cheers

David / dhildenb


