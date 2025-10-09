Return-Path: <io-uring+bounces-9938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F5BBC7AFE
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 09:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A467D3B9CE6
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 07:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28462D1F64;
	Thu,  9 Oct 2025 07:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcjEUCxZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8492D0C6C
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 07:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759994547; cv=none; b=WsawWvIyAlyhGJiGz/PpExzRhYLaxf7SHf6z6mzBCa8bFPjNWQT0Jkq4nFVxO/OBhJoAbhkt/Vdmh+gHYXfQkJCUebTRw6wwwVYQufjM+VqKM7+MG9TfeUfg5wyE0nTKmug/51KpU/KXw9lbWjh3nhvYUWu7NZ2Ga0wWp0JPjZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759994547; c=relaxed/simple;
	bh=NoSsNhFoqKTD2GND/uojUC1d3tf5roBQEmoiq+BTOBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dtwU4WbASZG1DxFUyPFTyIKrdeK3LsoaRrJJWQdnb5ydv9v7daEp0f2R7ZmAck7AA+jGsEYnhFhmcklg5TqSiXLSwZaVdX44Y5rxJ1D7LmQPENP3kXaXj1DPKMaZBzyr/9gzCjmq4x/6JYVRuc7hDseG0ketC3VIl7gMxq8+6kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcjEUCxZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759994543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NR0GPPrQth8s1EL9fLV4+qP3WUCAWdzIUfVSZ9j+y5w=;
	b=fcjEUCxZ7cy2E9VIZbQC4f/PlIPi5iBDfiRqsyCRNMduZp6FMvcxmSE7I8kyDBJgj6yLHt
	QCsB9mEqcTz1FC5sxQ7mGW9xOiLvBYo0Jt/+0qXTt1/+MRU4sqiThLy5sVFtTCS7NN2BaL
	gzcghKqCz7QmkqjXQVqNi3f6EfGzEeo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-M-wGyKlgP9W1xmKXNHKZUA-1; Thu, 09 Oct 2025 03:22:22 -0400
X-MC-Unique: M-wGyKlgP9W1xmKXNHKZUA-1
X-Mimecast-MFC-AGG-ID: M-wGyKlgP9W1xmKXNHKZUA_1759994541
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee1365964cso611244f8f.2
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 00:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759994541; x=1760599341;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NR0GPPrQth8s1EL9fLV4+qP3WUCAWdzIUfVSZ9j+y5w=;
        b=FfvZbwQBc/56Tzb7k1OYN6U9khjsccnLp1FKfqJxtZeZu4utjAK98HgL/IVCtODHV7
         KUoesQDtyBveBpnoXLwgSEDX+BWdVUwa0EppqPlt/rci4OAydp/smenfbk2edfSWTpXu
         pm48wdsxZn2il0ry43Z9AdzLXxCLaTqgv3K7jkd+RNEIgEkPwBJ8/l+oQdnmulOR0+pA
         9rRX/6HjtXzdEhhnpVUC9hKpLmQDxlk2IkRil9bpAZWru5kkMvgsYaHKjUdTv2CIwSEY
         AMLeVDNdXtEaS7ZVVHprTjzL7QJISMo7dzOeTd/QwBBmD4otqfppEkNMFS/66z9juVga
         fXJw==
X-Forwarded-Encrypted: i=1; AJvYcCVvFZPAw9Trx3X47rCjuHMbMRn6FUz1MylyE2FMCmd9m9KbmBzZCqjkxRad0f3DC32bw/5FOu/lOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOFJa1GzlIcaWH3XHbkqWPFq+K/F+UzkdZJDmVaMMO+LQGje/c
	zwtLWz+N5jzz8C0p4BE8yVfoToPaWg8D/PqusynQo2lC7hWMasIRf0wdiOcUAM6tDszkB3acdaT
	NSi2t2hO5aEXpxXZiVQGz1g1oRP0uDlNb384xzNW9eT92xb+rJ1UgnulS+XiJ
X-Gm-Gg: ASbGncvxFfEa+SfhbJw/Q/0C0FIWg15V7/usNF5Sgd8+lvzj1oypKDnDshMflpC8i8q
	aoRS+g6aNomyWaRh8g854Mt/EVgwy7gLgSbd0q98bx63dv00ey70ba9cXCz0e+hErMv+tdWhYlH
	ekUYDAGAbsLv7zqzPLw8ZqB0CtNerQQw4eKqRM1aPEKI9B0Ux4Oy+fMpKKZNzut3M1KBy6Hmp7T
	NgCls8PCgtJhnV03Fb9TS99JSnHrBJxy7IRncIx4ljRuaxDqL3EYKHmDqJx4pSyfwrpwB0/fpQW
	BUEdyLdihtb3wkiN2o6HMjtQlL8EggeK+BeamZxc37SLDkxA3Cbm3tlh+d0g/MDPFNUgQPpD4FR
	INNPBwBvx
X-Received: by 2002:a5d:5f84:0:b0:3ee:1578:3181 with SMTP id ffacd0b85a97d-4266e8de444mr4275629f8f.49.1759994540833;
        Thu, 09 Oct 2025 00:22:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3pZJrfQfix+9KKt4WdXWXcZ6zm7mHa+Vng4C8E+STUwzM8VHEo7EV1uD0vgxW+NxE9Pp9bw==
X-Received: by 2002:a5d:5f84:0:b0:3ee:1578:3181 with SMTP id ffacd0b85a97d-4266e8de444mr4275568f8f.49.1759994540323;
        Thu, 09 Oct 2025 00:22:20 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d62890sm68237045e9.14.2025.10.09.00.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 00:22:19 -0700 (PDT)
Message-ID: <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
Date: Thu, 9 Oct 2025 09:22:14 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (bisected) [PATCH v2 08/37] mm/hugetlb: check for unreasonable
 folio sizes when registering hstate
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
 linux-kernel@vger.kernel.org
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
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
 wireguard@lists.zx2c4.com, x86@kernel.org,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-9-david@redhat.com>
 <3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09.10.25 09:14, Christophe Leroy wrote:
> Hi David,
> 
> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>> Let's check that no hstate that corresponds to an unreasonable folio size
>> is registered by an architecture. If we were to succeed registering, we
>> could later try allocating an unsupported gigantic folio size.
>>
>> Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
>> is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
>> to use a BUILD_BUG_ON_INVALID() to make it compile.
>>
>> No existing kernel configuration should be able to trigger this check:
>> either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
>> gigantic folios will not exceed a memory section (the case on sparse).
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> I get following warning on powerpc with linus tree, bisected to commit
> 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when
> registering hstate")

Do you have the kernel config around? Is it 32bit?

That would be helpful.

[...]

>> ---
>>    mm/hugetlb.c | 2 ++
>>    1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 1e777cc51ad04..d3542e92a712e 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>    
>>    	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>>    			__NR_HPAGEFLAGS);
>> +	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>    
>>    	if (!hugepages_supported()) {
>>    		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>>    	}
>>    	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>    	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>> +	WARN_ON(order > MAX_FOLIO_ORDER);
>>    	h = &hstates[hugetlb_max_hstate++];
>>    	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>>    	h->order = order;

We end up registering hugetlb folios that are bigger than 
MAX_FOLIO_ORDER. So we have to figure out how a config can trigger that 
(and if we have to support that).

-- 
Cheers

David / dhildenb


