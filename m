Return-Path: <io-uring+bounces-9287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD16BB3473B
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 18:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C192C5E7510
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 16:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB873009F6;
	Mon, 25 Aug 2025 16:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LpdWRuxS"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70B33002BE
	for <io-uring@vger.kernel.org>; Mon, 25 Aug 2025 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756139037; cv=none; b=Jpu7VFw4xF0Wn/RfdM9PxRWSiAG4L9ZrTqUqqXqUMowXcwQcECKk5nTSKZK2AhSIEt8NvYahTMR/yW1v44+j72hQPyN3kIjGu9LM6IuzAERp6jK6uKI8OP9jVvJmXYOg/L0JqndNV7SakBfXZD/3QSIB6Jsoh7q5BxppuN6n4eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756139037; c=relaxed/simple;
	bh=vuP5vePXN8LBSJrLWIvS+y5fUnshvYM/EK4ob3BfHZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rtcO5cUSHnmFT2VSZZtslNk0PozCyP/HhkKvoF8XkS1brDnJ/fd78lDVzeBUgOY4NbMouTOhF6WTK8QnoWwnSMr1r7gHU39KxVDB3+TuX8O3qybPb/EAzjGcQ2FQ6pcY2lqr8feOGAPPhcS1SCHaTVl03vK8FPlAIsMHDLjMb/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LpdWRuxS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756139034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZJ9VR6/AHZevQeWHrHcSWQbnm5iFaXQGfgpXOMo3AYo=;
	b=LpdWRuxSJqX/FwRxyo3Hn4VIOsQN8mLbwH4XJHO5g9zH+CA8+Az+nyATyH7t5hsGmS3KmP
	vWDrKjTu1jigWdw+nvdKmOPS9HTZlrdg1OlK+x8IM60cdz/F61MpuluYVpxq4UusydZSzK
	l5bvmf4RXY9v3NQDNXw8hwX/NeHYjUI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-AVtWiOqCNl2PDErzQSvAgA-1; Mon, 25 Aug 2025 12:23:53 -0400
X-MC-Unique: AVtWiOqCNl2PDErzQSvAgA-1
X-Mimecast-MFC-AGG-ID: AVtWiOqCNl2PDErzQSvAgA_1756139032
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0cb0aaso34959435e9.3
        for <io-uring@vger.kernel.org>; Mon, 25 Aug 2025 09:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756139032; x=1756743832;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJ9VR6/AHZevQeWHrHcSWQbnm5iFaXQGfgpXOMo3AYo=;
        b=HfAQsQcF+7dynrvcgobx+mmGS+ArSUnb9E9iyzwadBiy4CCynGQdN8FjGtkdRfEpE4
         4vW+m6bG9MXKpA6muMs7G3MLtDx1jJSPSk9WDAhKJmkR0eRuIrJ98THzQsQz2P+Sf0N/
         MJxCKEg6SzlNzT6RXsP5eWI69u9F+EnThEN6BGt2KufU8aFqyn96HIxttPB+DXvRdsi9
         i1A9nggshxhMKkwxNPaFKc4GEPm3ukOKe/ECJhMH1a41CYgPvFvd481o6mhwxlDTSD/k
         6PQB5HogmvNwFTfvVxr4bbTexTzKVkQ4wo7FgtafesiPzUBKkjc1Dto4sj9wGeOFxC8g
         CTeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX4qnFONunHY16qLfxfKttlhW+ScfkJ56BdUYmBm11U3CDvoh2Twffwa5I5J+nDX0Aqy7nMzhD/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuIaDScx7Uo8HaLY83uSXpgpN4euh+dvT3rJSyAEjln13DjcXM
	qMmc84Y7yODVqpO+I0rUqh4A5WEYaIMgm/LrmLG8/Tk+A8XHsJMLkSkVZRSs/9p9RNzGeigypPh
	49dyefWIUpOO7Pj+nttphSJd+va/vo6FJV7QqMNrgtzb6Ekzcn3w/NXEDaM+9
X-Gm-Gg: ASbGncvOK9KsQvGFiNNRRT+DxefDUaNqhSGaRqH1lah8lIjPvmAumKZMssJYeIHx+Ps
	05fiWhc++IFZgrUIUXOoqfnkUn4WSvGOA0zuGMGeEimHPn6hiuNH7334aWc1fmUxHuv5CTzzh3L
	NpwqZlgqUOZRhfFMQgKB/oWN1BcWBXxHf35NotovC/WD6w41mwXskcWh4miZ99vK22x1ijZCJhk
	STjsREG58UyMgxt+jOyE89SYrsc6TbFSrB+DEvw3t3eNLH/xh2cdwcGOK5UkeOEduQwk60Q9qf7
	CaOvGwnHJKZrn2TOVCbdFuTwsLE1RjfTA2ri3c2yoQNXRoHLBZRdiHO9UYJMoQrcAN0jRRwfXL5
	i6jZXS8tWCBIq6w4wKvJwYwXoFBsNq7DdoA15Hk6J+C1rW8UfgwDNkUGF57rexO5tAas=
X-Received: by 2002:a05:600c:4685:b0:458:bfe1:4a91 with SMTP id 5b1f17b1804b1-45b517c5551mr109881465e9.20.1756139031858;
        Mon, 25 Aug 2025 09:23:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwiDwmGl/nPb74qkNKdwOJy23XqbHKXC5/+W47v3i62q/hY+QH66S6ZkeqOx/rk3ktbwdSNA==
X-Received: by 2002:a05:600c:4685:b0:458:bfe1:4a91 with SMTP id 5b1f17b1804b1-45b517c5551mr109881195e9.20.1756139031315;
        Mon, 25 Aug 2025 09:23:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5fec8e80sm29037215e9.0.2025.08.25.09.23.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 09:23:50 -0700 (PDT)
Message-ID: <dbd2ec55-0e7f-407a-a8bd-e1ac83ac2a0a@redhat.com>
Date: Mon, 25 Aug 2025 18:23:48 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: Mike Rapoport <rppt@kernel.org>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
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
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
 <aKxz9HLQTflFNYEu@kernel.org>
 <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
 <aKx6SlYrj_hiPXBB@kernel.org>
 <f8140a17-c4ec-489b-b314-d45abe48bf36@redhat.com>
 <aKyMfvWe8JetkbRL@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKyMfvWe8JetkbRL@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>   
>> We should do something like:
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 154f1d73b61f2..ed4c563d72c32 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -1091,13 +1091,16 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
>>   /**
>>    * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
>> - * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
>> - * for this region.
>> + * MEMBLOCK_RSRV_NOINIT which allows for the "struct pages" corresponding
>> + * to this region not getting initialized, because the caller will take
>> + * care of it.
>>    * @base: the base phys addr of the region
>>    * @size: the size of the region
>>    *
>> - * struct pages will not be initialized for reserved memory regions marked with
>> - * %MEMBLOCK_RSRV_NOINIT.
>> + * "struct pages" will not be initialized for reserved memory regions marked
>> + * with %MEMBLOCK_RSRV_NOINIT if this function is called before initialization
>> + * code runs. Without CONFIG_DEFERRED_STRUCT_PAGE_INIT, it is more likely
>> + * that this function is not effective.
>>    *
>>    * Return: 0 on success, -errno on failure.
>>    */
> 
> I have a different version :)
>   
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index b96746376e17..d20d091c6343 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -40,8 +40,9 @@ extern unsigned long long max_possible_pfn;
>    * via a driver, and never indicated in the firmware-provided memory map as
>    * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
>    * kernel resource tree.
> - * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
> - * not initialized (only for reserved regions).
> + * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages don't have
> + * PG_Reserved set and are completely not initialized when
> + * %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled (only for reserved regions).
>    * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
>    * either explictitly with memblock_reserve_kern() or via memblock
>    * allocation APIs. All memblock allocations set this flag.
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 154f1d73b61f..02de5ffb085b 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1091,13 +1091,15 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
>   
>   /**
>    * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
> - * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
> - * for this region.
> + * MEMBLOCK_RSRV_NOINIT
> + *
>    * @base: the base phys addr of the region
>    * @size: the size of the region
>    *
> - * struct pages will not be initialized for reserved memory regions marked with
> - * %MEMBLOCK_RSRV_NOINIT.
> + * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
> + * not have %PG_Reserved flag set.
> + * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flags also
> + * completly bypasses the initialization of struct pages for this region.

s/completly/completely.

I don't quite understand the interaction with PG_Reserved and why 
anybody using this function should care.

So maybe you can rephrase in a way that is easier to digest, and rather 
focuses on what callers of this function are supposed to do vs. have the 
liberty of not doing?

-- 
Cheers

David / dhildenb


