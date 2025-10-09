Return-Path: <io-uring+bounces-9944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A2EBC8724
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 12:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3E9D3A75BE
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 10:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF642D9487;
	Thu,  9 Oct 2025 10:20:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DC3275844;
	Thu,  9 Oct 2025 10:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760005237; cv=none; b=WIvcQ2t4cCQeAjdmm06rO8P8/i52z7+xLaegywcqXizPePR+pTGm41zfNVGBkOJULoFddUYzha9TveyLIsdlMS9LiYi+DgmhJwzrUp2kehcshQbURqm8C4InVNOvZrwVKlMFncX0EtdyJ8Wn6ykwMvGm5PjwAsHFdT4+lkpmn+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760005237; c=relaxed/simple;
	bh=lUs8p2fW3v1l2sBrZO8lIJGpAyvrMi+W3vfGsTEx0nY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gxvq81XBV4Yr5tyBP12Aekpq8rPAHuBo9JLuJk724Hf4lg6IAm1mUvBeA5qGaK9mnnrFs9nQY0XzbjdzjO6TDB2zYdBSTJsMEt0L3F+XDy5tzkwLNnHuI8zaq7Wly7ItkU7YdLwDu/0bjP0Nv2oi/C/KthYTDtuBvnX/m2fTBh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cj548110xz9sSL;
	Thu,  9 Oct 2025 12:01:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qOLNCcqM6pFr; Thu,  9 Oct 2025 12:01:12 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cj5476tjqz9sSC;
	Thu,  9 Oct 2025 12:01:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id D06108B76C;
	Thu,  9 Oct 2025 12:01:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id MfDghYtIuYkA; Thu,  9 Oct 2025 12:01:11 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 776CE8B767;
	Thu,  9 Oct 2025 12:01:09 +0200 (CEST)
Message-ID: <0c730c52-97ee-43ea-9697-ac11d2880ab7@csgroup.eu>
Date: Thu, 9 Oct 2025 12:01:08 +0200
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
 <faf62f20-8844-42a0-a7a7-846d8ead0622@csgroup.eu>
 <9361c75a-ab37-4d7f-8680-9833430d93d4@redhat.com>
 <03671aa8-4276-4707-9c75-83c96968cbb2@csgroup.eu>
 <1db15a30-72d6-4045-8aa1-68bd8411b0ba@redhat.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <1db15a30-72d6-4045-8aa1-68bd8411b0ba@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 09/10/2025 à 11:20, David Hildenbrand a écrit :
> On 09.10.25 11:16, Christophe Leroy wrote:
>>
>>
>> Le 09/10/2025 à 10:14, David Hildenbrand a écrit :
>>> On 09.10.25 10:04, Christophe Leroy wrote:
>>>>
>>>>
>>>> Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
>>>>> On 09.10.25 09:14, Christophe Leroy wrote:
>>>>>> Hi David,
>>>>>>
>>>>>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>>>> index 1e777cc51ad04..d3542e92a712e 100644
>>>>>>> --- a/mm/hugetlb.c
>>>>>>> +++ b/mm/hugetlb.c
>>>>>>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>>>>>>          BUILD_BUG_ON(sizeof_field(struct page, private) *
>>>>>>> BITS_PER_BYTE <
>>>>>>>                  __NR_HPAGEFLAGS);
>>>>>>> +    BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>>>>>>          if (!hugepages_supported()) {
>>>>>>>              if (hugetlb_max_hstate || 
>>>>>>> default_hstate_max_huge_pages)
>>>>>>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int
>>>>>>> order)
>>>>>>>          }
>>>>>>>          BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>>>>>>          BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>>>>>>> +    WARN_ON(order > MAX_FOLIO_ORDER);
>>>>>>>          h = &hstates[hugetlb_max_hstate++];
>>>>>>>          __mutex_init(&h->resize_lock, "resize mutex", &h- 
>>>>>>> >resize_key);
>>>>>>>          h->order = order;
>>>>>
>>>>> We end up registering hugetlb folios that are bigger than
>>>>> MAX_FOLIO_ORDER. So we have to figure out how a config can trigger 
>>>>> that
>>>>> (and if we have to support that).
>>>>>
>>>>
>>>> MAX_FOLIO_ORDER is defined as:
>>>>
>>>> #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>>> #define MAX_FOLIO_ORDER        PUD_ORDER
>>>> #else
>>>> #define MAX_FOLIO_ORDER        MAX_PAGE_ORDER
>>>> #endif
>>>>
>>>> MAX_PAGE_ORDER is the limit for dynamic creation of hugepages via
>>>> /sys/kernel/mm/hugepages/ but bigger pages can be created at boottime
>>>> with kernel boot parameters without CONFIG_ARCH_HAS_GIGANTIC_PAGE:
>>>>
>>>>      hugepagesz=64m hugepages=1 hugepagesz=256m hugepages=1
>>>>
>>>> Gives:
>>>>
>>>> HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
>>>> HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
>>>> HugeTLB: registered 64.0 MiB page size, pre-allocated 1 pages
>>>> HugeTLB: 0 KiB vmemmap can be freed for a 64.0 MiB page
>>>> HugeTLB: registered 256 MiB page size, pre-allocated 1 pages
>>>> HugeTLB: 0 KiB vmemmap can be freed for a 256 MiB page
>>>> HugeTLB: registered 4.00 MiB page size, pre-allocated 0 pages
>>>> HugeTLB: 0 KiB vmemmap can be freed for a 4.00 MiB page
>>>> HugeTLB: registered 16.0 MiB page size, pre-allocated 0 pages
>>>> HugeTLB: 0 KiB vmemmap can be freed for a 16.0 MiB page
>>>
>>> I think it's a violation of CONFIG_ARCH_HAS_GIGANTIC_PAGE. The existing
>>> folio_dump() code would not handle it correctly as well.
>>
>> I'm trying to dig into history and when looking at commit 4eb0716e868e
>> ("hugetlb: allow to free gigantic pages regardless of the
>> configuration") I understand that CONFIG_ARCH_HAS_GIGANTIC_PAGE is
>> needed to be able to allocate gigantic pages at runtime. It is not
>> needed to reserve gigantic pages at boottime.
>>
>> What am I missing ?
> 
> That CONFIG_ARCH_HAS_GIGANTIC_PAGE has nothing runtime-specific in its 
> name.

In its name for sure, but the commit I mention says:

     On systems without CONTIG_ALLOC activated but that support gigantic 
pages,
     boottime reserved gigantic pages can not be freed at all.  This patch
     simply enables the possibility to hand back those pages to memory
     allocator.

And one of the hunks is:

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7f7fbd8bd9d5b..7a1aa53d188d3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -19,7 +19,7 @@ config ARM64
         select ARCH_HAS_FAST_MULTIPLIER
         select ARCH_HAS_FORTIFY_SOURCE
         select ARCH_HAS_GCOV_PROFILE_ALL
-       select ARCH_HAS_GIGANTIC_PAGE if CONTIG_ALLOC
+       select ARCH_HAS_GIGANTIC_PAGE
         select ARCH_HAS_KCOV
         select ARCH_HAS_KEEPINITRD
         select ARCH_HAS_MEMBARRIER_SYNC_CORE

So I understand from the commit message that it was possible at that 
time to have gigantic pages without ARCH_HAS_GIGANTIC_PAGE as long as 
you didn't have to be able to free them during runtime.

> 
> Can't we just select CONFIG_ARCH_HAS_GIGANTIC_PAGE for the relevant 
> hugetlb config that allows for *gigantic pages*.
> 

We probably can, but I'd really like to understand history and how we 
ended up in the situation we are now.
Because blind fixes often lead to more problems.

If I follow things correctly I see a helper gigantic_page_supported() 
added by commit 944d9fec8d7a ("hugetlb: add support for gigantic page 
allocation at runtime").

And then commit 461a7184320a ("mm/hugetlb: introduce 
ARCH_HAS_GIGANTIC_PAGE") is added to wrap gigantic_page_supported()

Then commit 4eb0716e868e ("hugetlb: allow to free gigantic pages 
regardless of the configuration") changed gigantic_page_supported() to 
gigantic_page_runtime_supported()

So where are we now ?

Christophe

