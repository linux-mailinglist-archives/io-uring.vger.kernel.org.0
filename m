Return-Path: <io-uring+bounces-9264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4BF0B31DEF
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 17:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51EE61C24DE2
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D281FAC42;
	Fri, 22 Aug 2025 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gi25p9sE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F4F1F5821;
	Fri, 22 Aug 2025 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755875524; cv=none; b=Tin+DyGwGF0DDkn7uneuqiOivQUJlF/zTzh46j16oRGqW83ZWlc1ADD3+7q4QEHNvU69rXgMy+1lQrlz5wUj5jlaMwGAZpMGE1ZWneto5mPgmwr1OtmvQkplQpP2xXpzc3ZoNYRsPPBBLdqHqRj3RJuzgldujfaVnSsK3Df1BDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755875524; c=relaxed/simple;
	bh=HRRQbT257R2q2AEfvEk1n3oH5/MZBF2WDP7W6waprfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAf425xhf/hyPZLblU7UdIZdqLDOPayCqHznJu6DnEwKHgZ8OCb1oDPDFfCJBwTcAym4Acn/ALZ8r+Y5BncCcD41IIVSLxqsNqNFSCQ5/vHw+JT0DnmDeaqMKzeFkKpDcVy80sArBEFQE/9TKvMOYxcIMnM0YlU3M6REXc/1rsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gi25p9sE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164C3C113CF;
	Fri, 22 Aug 2025 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755875523;
	bh=HRRQbT257R2q2AEfvEk1n3oH5/MZBF2WDP7W6waprfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gi25p9sE7/lhCMi1fpxXS8fHF0WuseavqUdHcmBb8R6Y5VmKdKZVf1NnefLXt7kJ7
	 URm4lN5NGS/MzTvr5vAw98Gq9CNFGqAh8ylmDv22+DClMuw6uQoLRDzkVyRGmBlOl5
	 pRDjccH/6i79s/pMSSAEfP5hs73RRhp+GS4gTAO//P13gtHF9XponRl0O3F6GIHolA
	 6zgBDUxATcZf2srHifss8fRY80pD0AOMPWUP3XezWzz82yxkmlYx2QZZ7J5OBL3NEv
	 BrAn9osE1Lz4iRcmF7gBSFbdr0TGaiCiIGNk8hDPs3BG24FCO8bHkl52zypr7/T0mK
	 AjOJKgqMIIPCA==
Date: Fri, 22 Aug 2025 18:11:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: Re: [PATCH RFC 04/35] x86/Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <aKiIsF8mpeUy-8zt@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-5-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-5-david@redhat.com>

On Thu, Aug 21, 2025 at 10:06:30PM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58d890fe2100e..e431d1c06fecd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1552,7 +1552,6 @@ config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_STATIC if X86_32
>  	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
> -	select SPARSEMEM_VMEMMAP if X86_64
>  
>  config ARCH_SPARSEMEM_DEFAULT
>  	def_bool X86_64 || (NUMA && X86_32)
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

