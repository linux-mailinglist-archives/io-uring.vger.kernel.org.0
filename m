Return-Path: <io-uring+bounces-9369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA2EB39287
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 06:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C1251BA7FEF
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 04:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D5D209F5A;
	Thu, 28 Aug 2025 04:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDOpy7Q7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A6830CD97;
	Thu, 28 Aug 2025 04:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756355265; cv=none; b=r2UIBl3fzj8XOTo2LGZrcrtlQ5xoTTX7n40oXyt42m/Zre12gLcN2OxXDNg11r+Y0obdizIwa7c9u9+4SQ9FXexUpr9XRdZGx6WpdXThBMzhcHJv4LFnIDAfueEeW2sR3hJT+KYvNGuP4KzVUqnWV0n2HJtFT86pabw6Aq8El+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756355265; c=relaxed/simple;
	bh=hUnNfjGCPEWmiNNGGLZKDOsScYWj511icwVWbnrMbSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gE86G8YGZBmkIG9k7GPXf1bScrcjGn4WEPmcPw/M1D9uGUWwf3Ghr3OEmcgTmCtyC0BhnkTHq05Wiou0SvFFyZLlbkdajwARCMNLB9eqW+I76kO7xduMb1y64kHuctDWVi/bnJ63PN+jjUz85QjUFYtwE37hqwKAmHR8nU0AS4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDOpy7Q7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33984C4CEEB;
	Thu, 28 Aug 2025 04:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756355264;
	bh=hUnNfjGCPEWmiNNGGLZKDOsScYWj511icwVWbnrMbSE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MDOpy7Q7+PtjV9ZnI/+71mkZCJrWQwTtFvdW0afXONz8h7wR9ImGTrV4WCC7mXn2B
	 7EbOn3HGpIWLqjjSjwF8rGcKZhPtc4Gfky+zbxOUAt8Kl+cAXdXSfuUaya8Zvy1ya1
	 F1mYHsgG9WcnDg0zKq2bACZzcl/UPORrd7FsCsy3qdsnuRy8wAbqlzxL98joSNwLF6
	 w9WMn87Hpnp8f8IF6pk5vnsO7wQiX+Ib8XV+pManWrp62VQ4CdQPenZjvMUQSDERoQ
	 eOJ33fQuGDSZ49Qcix6/vKNOIhOhF/f6epJTEq5OJkbiyKYIE1xM/FteX3oGbk+Ymp
	 Up7jZQPpsB0CA==
Message-ID: <c39104cf-f066-45d8-a13c-cad558312b6e@kernel.org>
Date: Thu, 28 Aug 2025 13:24:45 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 24/36] ata: libata-eh: drop nth_page() usage within SG
 entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>, Alexander Potapenko
 <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>,
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
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-25-david@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250827220141.262669-25-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/28/25 7:01 AM, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Niklas Cassel <cassel@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

