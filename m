Return-Path: <io-uring+bounces-9941-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 904C5BC8004
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 10:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E9A41A60875
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 08:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC1827B335;
	Thu,  9 Oct 2025 08:20:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3808626B97E;
	Thu,  9 Oct 2025 08:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759998038; cv=none; b=cWmqDwSIO66TD1ZBMCMVgwKNRiWvloggY2coS4at9fXePtT8MOw51LxiJ3XQhX92RBO2kvrWeULSy1z11gjjqEX91CtHVp9hyl4m1xDT1NTmCwNYMEusO/TBwx94MyoKt/W2QGQylRwQ9Se7lj6O6UvccDXgDB4BWi7iECcMy7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759998038; c=relaxed/simple;
	bh=r4j7KL3ZDY2ItBlX7tAcF4DYZ7j4P2ykR08zNx+Sdac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pUAvLRyzDeAVWYHKe7DJyGMf6wyYuSYTyZSEMDvDgsCP1+IwyuQ9+Ssk/26PD+pRfNG8XC8eUSzEFd1W0/YGDQEecLLr6zS8P8rnaictPJvLiO1Z56HTtRRundgDFDYU9IMVfjP+mDDcMRos/Py0Xz21XRAFFzIZ+Z+zWmqiIAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cj2Td0Mj6z9sSL;
	Thu,  9 Oct 2025 10:04:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qQ36Dhni13kk; Thu,  9 Oct 2025 10:04:36 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cj2Tc5kJ8z9sSC;
	Thu,  9 Oct 2025 10:04:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id A8FDF8B770;
	Thu,  9 Oct 2025 10:04:36 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id CnXkw3FAfnqR; Thu,  9 Oct 2025 10:04:36 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id AE04F8B76D;
	Thu,  9 Oct 2025 10:04:34 +0200 (CEST)
Message-ID: <faf62f20-8844-42a0-a7a7-846d8ead0622@csgroup.eu>
Date: Thu, 9 Oct 2025 10:04:34 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (bisected) [PATCH v2 08/37] mm/hugetlb: check for unreasonable
 folio sizes when registering hstate
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
> On 09.10.25 09:14, Christophe Leroy wrote:
>> Hi David,
>>
>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 1e777cc51ad04..d3542e92a712e 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>>        BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>>>                __NR_HPAGEFLAGS);
>>> +    BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>>        if (!hugepages_supported()) {
>>>            if (hugetlb_max_hstate || default_hstate_max_huge_pages)
>>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>>>        }
>>>        BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>>        BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>>> +    WARN_ON(order > MAX_FOLIO_ORDER);
>>>        h = &hstates[hugetlb_max_hstate++];
>>>        __mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>>>        h->order = order;
> 
> We end up registering hugetlb folios that are bigger than 
> MAX_FOLIO_ORDER. So we have to figure out how a config can trigger that 
> (and if we have to support that).
> 

MAX_FOLIO_ORDER is defined as:

#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
#define MAX_FOLIO_ORDER		PUD_ORDER
#else
#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
#endif

MAX_PAGE_ORDER is the limit for dynamic creation of hugepages via 
/sys/kernel/mm/hugepages/ but bigger pages can be created at boottime 
with kernel boot parameters without CONFIG_ARCH_HAS_GIGANTIC_PAGE:

   hugepagesz=64m hugepages=1 hugepagesz=256m hugepages=1

Gives:

HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
HugeTLB: registered 64.0 MiB page size, pre-allocated 1 pages
HugeTLB: 0 KiB vmemmap can be freed for a 64.0 MiB page
HugeTLB: registered 256 MiB page size, pre-allocated 1 pages
HugeTLB: 0 KiB vmemmap can be freed for a 256 MiB page
HugeTLB: registered 4.00 MiB page size, pre-allocated 0 pages
HugeTLB: 0 KiB vmemmap can be freed for a 4.00 MiB page
HugeTLB: registered 16.0 MiB page size, pre-allocated 0 pages
HugeTLB: 0 KiB vmemmap can be freed for a 16.0 MiB page


Christophe

