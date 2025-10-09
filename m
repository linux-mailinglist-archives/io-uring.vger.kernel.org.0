Return-Path: <io-uring+bounces-9937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 871D6BC7AAA
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 09:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A35C19E6FAB
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 07:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C972D063D;
	Thu,  9 Oct 2025 07:20:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685D6298CA4;
	Thu,  9 Oct 2025 07:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759994436; cv=none; b=ozYhkuaNZZIOikcvqrcgDeoXTxpRYWCZzu7bQ6kLZ51SCZbkblTXwsHczAoo5VM4utDOoeyY9ajZVVa4WwQYOcSIUpam/hcsP5uCp+DC5TePIj6xIIAeCP7A+uwi03JhZTRO0ZKDf87KyTK+/edBI2cWj+8wVDtjtGamU/g+uII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759994436; c=relaxed/simple;
	bh=qiRw4QuoIHdxgOMBw5rOBwaXySx4YLDEZtVJzzfIsuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1iMZdIQ2LfY98Zq9sJDWmqOVQg3nEREc9g5XGqwJ+oyo6Bf/a4s+ziwP2nXVp5lKb2iAnO3cryLV/X91lomZF6sezxjUTlw9LgXwYdcPUeFcDySq2Bh2WY4wtA8Lu1gw0Y+GajJdjDO4RBUxunfgRyWOERuZ0+qZ359hv9oPVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cj1Mm20R5z9sSd;
	Thu,  9 Oct 2025 09:14:28 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IrXIuvb4y-IU; Thu,  9 Oct 2025 09:14:28 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cj1Mm0p1dz9sSb;
	Thu,  9 Oct 2025 09:14:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id F24048B76C;
	Thu,  9 Oct 2025 09:14:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id wHEaqnf6dd0R; Thu,  9 Oct 2025 09:14:27 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id D85288B768;
	Thu,  9 Oct 2025 09:14:25 +0200 (CEST)
Message-ID: <3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu>
Date: Thu, 9 Oct 2025 09:14:24 +0200
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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250901150359.867252-9-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi David,

Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
> Let's check that no hstate that corresponds to an unreasonable folio size
> is registered by an architecture. If we were to succeed registering, we
> could later try allocating an unsupported gigantic folio size.
> 
> Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
> is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
> to use a BUILD_BUG_ON_INVALID() to make it compile.
> 
> No existing kernel configuration should be able to trigger this check:
> either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
> gigantic folios will not exceed a memory section (the case on sparse).
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

I get following warning on powerpc with linus tree, bisected to commit 
7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when 
registering hstate")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at mm/hugetlb.c:4744 hugetlb_add_hstate+0xc0/0x180
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 
6.17.0-rc4-00275-g7b4f21f5e038 #1683 NONE
Hardware name: QEMU ppce500 e5500 0x80240020 QEMU e500
NIP:  c000000001357408 LR: c000000001357c90 CTR: 0000000000000003
REGS: c00000000152bad0 TRAP: 0700   Not tainted 
(6.17.0-rc4-00275-g7b4f21f5e038)
MSR:  0000000080021002 <CE,ME>  CR: 44000448  XER: 20000000
IRQMASK: 1
GPR00: c000000001357c90 c00000000152bd70 c000000001339000 0000000000000012
GPR04: 000000000000000a 0000000000001000 000000000000001e 0000000000000000
GPR08: 0000000000000000 0000000000000000 0000000000000001 000000000000000a
GPR12: c000000001357b68 c000000001590000 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: c0000000011adb40 c00000000156b528 0000000000000000 c00000000156b4b0
GPR28: c00000000156b528 0000000000000012 0000000040000000 0000000000000000
NIP [c000000001357408] hugetlb_add_hstate+0xc0/0x180
LR [c000000001357c90] hugepagesz_setup+0x128/0x150
Call Trace:
[c00000000152bd70] [c00000000152bda0] init_stack+0x3da0/0x4000 (unreliable)
[c00000000152be10] [c000000001357c90] hugepagesz_setup+0x128/0x150
[c00000000152be80] [c00000000135841c] hugetlb_bootmem_alloc+0x84/0x104
[c00000000152bec0] [c00000000135143c] mm_core_init+0x30/0x174
[c00000000152bf30] [c000000001332ed4] start_kernel+0x540/0x880
[c00000000152bfe0] [c000000000000a50] start_here_common+0x1c/0x20
Code: 2c09000f 39000001 38e00000 39400001 7d00401e 0b080000 281d0001 
7d00505e 79080020 0b080000 281d000c 7d4a385e <0b0a0000> 1f5a00b8 
38bf0020 3c82ffe8
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at mm/hugetlb.c:4744 hugetlb_add_hstate+0xc0/0x180
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G        W 
6.17.0-rc4-00275-g7b4f21f5e038 #1683 NONE
Tainted: [W]=WARN
Hardware name: QEMU ppce500 e5500 0x80240020 QEMU e500
NIP:  c000000001357408 LR: c000000001357c90 CTR: 0000000000000005
REGS: c00000000152bad0 TRAP: 0700   Tainted: G        W 
(6.17.0-rc4-00275-g7b4f21f5e038)
MSR:  0000000080021002 <CE,ME>  CR: 48000448  XER: 20000000
IRQMASK: 1
GPR00: c000000001357c90 c00000000152bd70 c000000001339000 000000000000000e
GPR04: 000000000000000a 0000000000001000 0000000040000000 0000000000000000
GPR08: 0000000000000000 0000000000000001 0000000000000001 0000000000000280
GPR12: c000000001357b68 c000000001590000 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: c0000000011adb40 c00000000156b5e0 0000000000000001 c00000000156b4b0
GPR28: c00000000156b528 000000000000000e 0000000004000000 00000000000000b8
NIP [c000000001357408] hugetlb_add_hstate+0xc0/0x180
LR [c000000001357c90] hugepagesz_setup+0x128/0x150
Call Trace:
[c00000000152bd70] [c000000000f27048] __func__.0+0x0/0x18 (unreliable)
[c00000000152be10] [c000000001357c90] hugepagesz_setup+0x128/0x150
[c00000000152be80] [c00000000135841c] hugetlb_bootmem_alloc+0x84/0x104
[c00000000152bec0] [c00000000135143c] mm_core_init+0x30/0x174
[c00000000152bf30] [c000000001332ed4] start_kernel+0x540/0x880
[c00000000152bfe0] [c000000000000a50] start_here_common+0x1c/0x20
Code: 2c09000f 39000001 38e00000 39400001 7d00401e 0b080000 281d0001 
7d00505e 79080020 0b080000 281d000c 7d4a385e <0b0a0000> 1f5a00b8 
38bf0020 3c82ffe8
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at mm/hugetlb.c:4744 hugetlb_add_hstate+0xc0/0x180
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G        W 
6.17.0-rc4-00275-g7b4f21f5e038 #1683 NONE
Tainted: [W]=WARN
Hardware name: QEMU ppce500 e5500 0x80240020 QEMU e500
NIP:  c000000001357408 LR: c000000001357c90 CTR: 0000000000000004
REGS: c00000000152bad0 TRAP: 0700   Tainted: G        W 
(6.17.0-rc4-00275-g7b4f21f5e038)
MSR:  0000000080021002 <CE,ME>  CR: 48000448  XER: 20000000
IRQMASK: 1
GPR00: c000000001357c90 c00000000152bd70 c000000001339000 0000000000000010
GPR04: 000000000000000a 0000000000001000 0000000004000000 0000000000000000
GPR08: 0000000000000000 0000000000000002 0000000000000001 0000000000000a00
GPR12: c000000001357b68 c000000001590000 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: c0000000011adb40 c00000000156b698 0000000000000002 c00000000156b4b0
GPR28: c00000000156b528 0000000000000010 0000000010000000 0000000000000170
NIP [c000000001357408] hugetlb_add_hstate+0xc0/0x180
LR [c000000001357c90] hugepagesz_setup+0x128/0x150
Call Trace:
[c00000000152bd70] [c000000000f27048] __func__.0+0x0/0x18 (unreliable)
[c00000000152be10] [c000000001357c90] hugepagesz_setup+0x128/0x150
[c00000000152be80] [c00000000135841c] hugetlb_bootmem_alloc+0x84/0x104
[c00000000152bec0] [c00000000135143c] mm_core_init+0x30/0x174
[c00000000152bf30] [c000000001332ed4] start_kernel+0x540/0x880
[c00000000152bfe0] [c000000000000a50] start_here_common+0x1c/0x20
Code: 2c09000f 39000001 38e00000 39400001 7d00401e 0b080000 281d0001 
7d00505e 79080020 0b080000 281d000c 7d4a385e <0b0a0000> 1f5a00b8 
38bf0020 3c82ffe8
---[ end trace 0000000000000000 ]---


> ---
>   mm/hugetlb.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1e777cc51ad04..d3542e92a712e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>   
>   	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>   			__NR_HPAGEFLAGS);
> +	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>   
>   	if (!hugepages_supported()) {
>   		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>   	}
>   	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>   	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
> +	WARN_ON(order > MAX_FOLIO_ORDER);
>   	h = &hstates[hugetlb_max_hstate++];
>   	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>   	h->order = order;


