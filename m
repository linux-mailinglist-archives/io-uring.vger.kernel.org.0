Return-Path: <io-uring+bounces-9265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A02A4B31DCB
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 17:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 628D54E117A
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80B6214A78;
	Fri, 22 Aug 2025 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oq+YiBtz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47674212568;
	Fri, 22 Aug 2025 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755875638; cv=none; b=ayDC3qL1H25nUS22pWAuvNWgo0vpB0xilmQtMMu8IjRescnVHLI98sp4jVR+DtEbmScJmR+GRokY8zo4Tn1gMqCYWpr+n+P+kXZZlA+f+CMqHC/ZBS3JtCn2SHFYOMxrYKLPTMwlO7UE35aEr/STrZab2g6nzvfuWUSYHexhQoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755875638; c=relaxed/simple;
	bh=p0iPLyXnfNJdu+YoCuoUVSR7eRuOWUAmkwSHtZmbswo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJgXqiv5qFfyKIvl4tSf001KaaDUyhOEWVxb5YcAhYfqpDcMo9bCE9hVtSWczn4ir0PX8o2ocBa3YMBa8vpyvbTQquBuzgBWGPbRAIZdcy1JqDI7kFBsUiZHdsP0euXaaFW77FWErs31rPX/soKsD4iahnGsqpOgu4e0GZIggUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oq+YiBtz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A19C4CEED;
	Fri, 22 Aug 2025 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755875637;
	bh=p0iPLyXnfNJdu+YoCuoUVSR7eRuOWUAmkwSHtZmbswo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oq+YiBtzNwt4g95Bu7PV0Fl9ib86q+ONSg37ZzPXpeT67l668lZdZKcDZ17zCgq/+
	 NUr9Cggu/NQsNbAf8J5LWQZhrBwU1g/MF3aj/PVZNB0J8PVxbWJVmp+W/+1x83AUZi
	 Ksafl3fKhK5d4QzvSbcncq8HLEoFlkjFsSlSh1hzeqF0bChtCL26UZCq78qNfMb29E
	 EBeBkg4phSCnNI6fLlpTsGgIlXQA3OAyRkh7ArJn5n6ii54fXevJBkxPUnY9AstAPY
	 LmiLofHFtmfQUlmw4ITl2sEhNM7ay49imRJJkphBZ9EWVC8vpCEY5+m+WLFICOjhFU
	 VsNUYbhaEIPrw==
Date: Fri, 22 Aug 2025 18:13:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <shuah@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 05/35] wireguard: selftests: remove
 CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Message-ID: <aKiJI0jiFEjtLE3l@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-6-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-6-david@redhat.com>

On Thu, Aug 21, 2025 at 10:06:31PM +0200, David Hildenbrand wrote:
> It's no longer user-selectable (and the default was already "y"), so
> let's just drop it.

and it should not matter for wireguard selftest anyway
> 
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
> index 0a5381717e9f4..1149289f4b30f 100644
> --- a/tools/testing/selftests/wireguard/qemu/kernel.config
> +++ b/tools/testing/selftests/wireguard/qemu/kernel.config
> @@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
>  CONFIG_FUTEX=y
>  CONFIG_SHMEM=y
>  CONFIG_SLUB=y
> -CONFIG_SPARSEMEM_VMEMMAP=y
>  CONFIG_SMP=y
>  CONFIG_SCHED_SMT=y
>  CONFIG_SCHED_MC=y
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

