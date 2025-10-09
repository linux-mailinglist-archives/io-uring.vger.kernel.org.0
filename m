Return-Path: <io-uring+bounces-9940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A195BC7F92
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 10:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5942B1A60576
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 08:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89FAA2D193B;
	Thu,  9 Oct 2025 08:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfesaZvl"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B8F2D0C9A
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 08:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759997659; cv=none; b=geS/DyAxpwILaZ0YyCbDfLxGB2b0JRX0e/UHxEf5vi38A8fKQoqTqRGi8T1HXZQFZHTYOwqtxlm4k70qgMiJNO+XqiJLuP1PBels6niI4a/TgJ1BLnJ++TsayRKimvtEn7e08AEKx+R8sMpzaEt+iSB/ZxQCQlDRxCwy79Xi6OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759997659; c=relaxed/simple;
	bh=V+JAWiJg2U6kE1ohoWIw0uVFkG7IaGFYvp2AU1nrZ3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mhijp975XsSMDgM/KT7lU8qo2UOnJamNPz/fQcMHnQbcHG10TcoF1jDSLVkruXVeo47/9vwXNsulV8XVET5cfoukCXJ8ZUrh5Srbm+nvAJU8wuN8IWk16Q9IuUoSVmxo4bYezizEpc/BCbyvyFdqTfLmK06SDvl9ftOK8FGxAuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfesaZvl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759997653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z/B31lhY4bVYeZNnk+dMlfOVrRbTYtHHzwgcdMMaTVE=;
	b=dfesaZvlsQUtr0U58MS8V+R5ClgquCeqxooEl/2t5bVBYTplzY5cRC/FXZo/gf4iDd6x3z
	5wP5oxNppzcxtkWI9zdEgHWL99pLF6xDxtKxkWxSwNPeRQ3NgXIaru35skPzrl26Lx2t4s
	ynvXvKIEawwU5DrX1FdaEZlIFEIF8gk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-yt8zzBxZNeOAhJj_Btxfyw-1; Thu, 09 Oct 2025 04:14:12 -0400
X-MC-Unique: yt8zzBxZNeOAhJj_Btxfyw-1
X-Mimecast-MFC-AGG-ID: yt8zzBxZNeOAhJj_Btxfyw_1759997648
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso4511895e9.2
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 01:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759997648; x=1760602448;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z/B31lhY4bVYeZNnk+dMlfOVrRbTYtHHzwgcdMMaTVE=;
        b=S+NZGfSRhUcBuBuhWTut/Gcf51hbRFF7a2ooRavj8do7a3ebqE3JEDD1LImk+shRk5
         vOdxTKmPEu1hX2KSgF6803Wc04rd1wSoq1LOhYRBBCRMyAiRLzqJMpcEL3ak0YFBnzUi
         YpymslNjRnhkrsCoY2clOaZEjORaA9qfGrnHcN/5ZSQ+iUOdjb1DnE9Pu6Cy2JuNQc2Q
         U8WkAQ6CaJp/Ea3orAb5QP80Co8UK5/LumBWqyxHtZfizm4X5tbwuO1zDJjC8hHDTpDN
         DoEByYrYq9sSHkjMUsxTnREcPx/Gnvn/Hgg/OD7vfXgkb7o5HAWgKY+qUYb6eVeB2FWX
         zg/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMUVki3rsFKHvu6CxFa5QYMnXElGli1nVopIGmx6sulUs6LpCgnzVVHJXBxljePGA/HZvYv5N/Ug==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzumgkmxoR0a31Eh64USI7sgMwkT+NfnFMb3y0ViOzUJT8d+cI
	QjnA0Ixrz+v9EZirL1UpOFNaNV+7D2c13QiwcyiwTyVL9guPF5zGBKvONMDfD73J8unA+k/rHh8
	/udVDgcjYHMSb3HJAbj4Lp+q0v3CPQFNba+UfZUFzbaelbG5M79QnFC8uloO8
X-Gm-Gg: ASbGnctpE2u0V69oDTnBP2JMb9LwL5/zG7hbfRoXIDjFmcDxmmTxjYjFLY4rBoJkw0c
	Lo2exbPxBZezVODtScdgWBwuIoNOrFXttR97jWMblE89EvytlTYebdd5IYSq6WsfDzL1P0JKGVf
	U6XX65zCNykgsvdrkBFFz8VLVkQhG9HeANFizgcch4/HFeCPcDlxlWcfXmERSRvrmeqnxp+uyLb
	lGxNBRggnlVyZvdudJQjBBMWkkLjhqQ3yOPQvtUMCrMIRgcKq8l51jukwC2MygFuTaTPLuyxB8a
	jrwDw3LeNG38a2pLvrM1o9ioItTtsfAhcwbYnMU/yGZar2Yudz5hahGprmTPeoos1ELp2a4c2Zq
	wHGRE6tQH
X-Received: by 2002:a05:600c:4750:b0:45f:28d2:bd38 with SMTP id 5b1f17b1804b1-46fa9af3095mr47092745e9.18.1759997648089;
        Thu, 09 Oct 2025 01:14:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGo93r/upxlN0XWroa/gVbVuSE1HI9H4cBHGhOGnkYv+FuHkp7MlpzQ4ByJt+h+2JF6rzGBiQ==
X-Received: by 2002:a05:600c:4750:b0:45f:28d2:bd38 with SMTP id 5b1f17b1804b1-46fa9af3095mr47092215e9.18.1759997647608;
        Thu, 09 Oct 2025 01:14:07 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d6fb41sm71628175e9.17.2025.10.09.01.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 01:14:07 -0700 (PDT)
Message-ID: <9361c75a-ab37-4d7f-8680-9833430d93d4@redhat.com>
Date: Thu, 9 Oct 2025 10:14:02 +0200
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
 <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
 <faf62f20-8844-42a0-a7a7-846d8ead0622@csgroup.eu>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <faf62f20-8844-42a0-a7a7-846d8ead0622@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09.10.25 10:04, Christophe Leroy wrote:
> 
> 
> Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
>> On 09.10.25 09:14, Christophe Leroy wrote:
>>> Hi David,
>>>
>>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 1e777cc51ad04..d3542e92a712e 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>>>         BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>>>>                 __NR_HPAGEFLAGS);
>>>> +    BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>>>         if (!hugepages_supported()) {
>>>>             if (hugetlb_max_hstate || default_hstate_max_huge_pages)
>>>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>>>>         }
>>>>         BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>>>         BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>>>> +    WARN_ON(order > MAX_FOLIO_ORDER);
>>>>         h = &hstates[hugetlb_max_hstate++];
>>>>         __mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>>>>         h->order = order;
>>
>> We end up registering hugetlb folios that are bigger than
>> MAX_FOLIO_ORDER. So we have to figure out how a config can trigger that
>> (and if we have to support that).
>>
> 
> MAX_FOLIO_ORDER is defined as:
> 
> #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> #define MAX_FOLIO_ORDER		PUD_ORDER
> #else
> #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
> #endif
> 
> MAX_PAGE_ORDER is the limit for dynamic creation of hugepages via
> /sys/kernel/mm/hugepages/ but bigger pages can be created at boottime
> with kernel boot parameters without CONFIG_ARCH_HAS_GIGANTIC_PAGE:
> 
>     hugepagesz=64m hugepages=1 hugepagesz=256m hugepages=1
> 
> Gives:
> 
> HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
> HugeTLB: registered 64.0 MiB page size, pre-allocated 1 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 64.0 MiB page
> HugeTLB: registered 256 MiB page size, pre-allocated 1 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 256 MiB page
> HugeTLB: registered 4.00 MiB page size, pre-allocated 0 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 4.00 MiB page
> HugeTLB: registered 16.0 MiB page size, pre-allocated 0 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 16.0 MiB page

I think it's a violation of CONFIG_ARCH_HAS_GIGANTIC_PAGE. The existing 
folio_dump() code would not handle it correctly as well.

See how snapshot_page() uses MAX_FOLIO_NR_PAGES.

-- 
Cheers

David / dhildenb


