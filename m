Return-Path: <io-uring+bounces-9262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7ACEB31E3E
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 17:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46D9EB40D8F
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CFB1DF99C;
	Fri, 22 Aug 2025 15:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfKWAMlW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83861DEFE6;
	Fri, 22 Aug 2025 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755875443; cv=none; b=eYzWTXRpgeqbfKLfOguIE0YzRbCgjW7rXJhAa/6AED2wUe0lZnXmDBGEIhNdDWRNfys8QVQaJdUhzDTh86Uhew6hYlMZraPmMcKbRstxjRSmdwGt/B5w5muVABCHG+sr0fM/zYAuUfxkBmImDSuNAiXDGwLeZm045uAQVDvqaE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755875443; c=relaxed/simple;
	bh=CAY5DlsOHyGeAuJSXFXVAByj59QIAOw2AekVjj0R+b4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igpl4qwFxCCvB9JAWu67+HRh2kHPLpmIEQs1M+WvcoC9phHOVSYipMqQ8vD0SSPXF64hYeH2NYcumn+mphsL4Yp3njjQ6fl/QbIoWZwEq+wREopxUtXQfpZqzjrBy/Y50ReJPQFsXbA5tFeLLf+92Ljs7M+dt5iiBNZIJBvNaiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfKWAMlW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA78EC4CEED;
	Fri, 22 Aug 2025 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755875442;
	bh=CAY5DlsOHyGeAuJSXFXVAByj59QIAOw2AekVjj0R+b4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MfKWAMlWZSLolf5Er8IdYEE5zQV86o5SRIWNfuGwAevHaro0KNr+O0AUudzUFXmc3
	 fsRmTkuzMKyOWmo+8Ib/4pg6uAO607N85i/ZR6XdaP13USRH/bc4QgbG247YDVGntr
	 dIuimCsUgCJa1CldCgolX2CMa2bqt+CMes53Pgq69q6mqbsJBHuaoP74dMUUlUNsww
	 SqsEK32SbicopH2MuZVGLxcSstv41b7vIfL/1490jZeCkzm9ukqxF1GXRENu39XO4p
	 GF/7+asbsxkyC7LQAOGokPKRMO8cxy0hNc1JtEMo2NFHS86o6qSj3ySEtrOWX+tEVg
	 yHfXvZ0oyq//A==
Date: Fri, 22 Aug 2025 18:10:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH RFC 02/35] arm64: Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <aKiIYJoshnWwrJQ3@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-3-david@redhat.com>

On Thu, Aug 21, 2025 at 10:06:28PM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/arm64/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e9bbfacc35a64..b1d1f2ff2493b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1570,7 +1570,6 @@ source "kernel/Kconfig.hz"
>  config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_VMEMMAP_ENABLE
> -	select SPARSEMEM_VMEMMAP
>  
>  config HW_PERF_EVENTS
>  	def_bool y
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

