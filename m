Return-Path: <io-uring+bounces-9933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26183BC713C
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 03:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 515D23E5267
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 01:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67AE1F151C;
	Thu,  9 Oct 2025 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rIX5UnrQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD2D155C82;
	Thu,  9 Oct 2025 01:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759972042; cv=none; b=LNZAwBhNqjUC2gcQFKkdHAG2AGPMGiW1IaIIhcOZOJNC5FVFpxn1wKQocITFfucHzBFDTzLmxA0QHQwjQdXWeenoOpN1doDMNrqH0JYdkJTpr/6cW9K223PDXHImlEh0Zx579kUs5sU4E2gEMyu6f4k5nQxuDqZyNCucZfN/fW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759972042; c=relaxed/simple;
	bh=gOZMzGofq4mPMi4a6FfMrSXrrYqWnEJSEe2U4H+HIxI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VNRVrwE8YDMhefRAzP72LLs9XrHatPRPhbae+zcBfVI1fXzjEkhr99sZpyHVwOIKOZCbN33K9xaeJwFDLu5bA9QsWxQQrnS9JdfHZvdUlZhFCznwgLQTIEtgdV7KBokaCrY71szTQKfcmCy8aAMGyIrySdBz7Bu6Ljn+GWqDVDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rIX5UnrQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFE9C4CEE7;
	Thu,  9 Oct 2025 01:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759972041;
	bh=gOZMzGofq4mPMi4a6FfMrSXrrYqWnEJSEe2U4H+HIxI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rIX5UnrQuVtPUja4Kq/zNxiwyTbf5s+hCzHT8aH9/VUdnNlKWh8D4mSKFL/eXwlaD
	 7z8+SEmVkcAfo9fmiSSyJ11EAUKKRJcwMVTb9iuWDWBwheam1F4EfrpnDWIzUjmitV
	 mpUbtUtSbqOH/UnhpYe9i14SkLmyq3I1gfKlnnkK+sqgEdkc4pLZ6mWhV/a0ryPI+M
	 cnqFIsiLX5CDpbNJvCwTuxPNZCjZR+B1mOV2TKr1ssRJwK/PuLD12JWWzuO1dLp+oX
	 6de792lhNHw6SaLSFK1kZpeE0QJJFPFLV/HILKfJuySwcXVffLr7XVkoyczsYsHHIo
	 /dSAJt7cVsj/Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADDA93A41017;
	Thu,  9 Oct 2025 01:07:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: update kernel-doc for MEMBLOCK_RSRV_NOINIT (was: Re: [PATCH RFC
 10/35] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap())
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175997202925.3661959.5694356441030280085.git-patchwork-notify@kernel.org>
Date: Thu, 09 Oct 2025 01:07:09 +0000
References: <aKyWIriZ1bmnIrBW@kernel.org>
In-Reply-To: <aKyWIriZ1bmnIrBW@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-riscv@lists.infradead.org, david@redhat.com, mpenttil@redhat.com,
 linux-kernel@vger.kernel.org, glider@google.com, akpm@linux-foundation.org,
 jackmanb@google.com, cl@gentwo.org, dennis@kernel.org, dvyukov@google.com,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org, jgg@nvidia.com,
 axboe@kernel.dk, hannes@cmpxchg.org, jhubbard@nvidia.com,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org, Liam.Howlett@oracle.com,
 torvalds@linux-foundation.org, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
 lorenzo.stoakes@oracle.com, elver@google.com, m.szyprowski@samsung.com,
 mhocko@suse.com, muchun.song@linux.dev, netdev@vger.kernel.org,
 osalvador@suse.de, peterx@redhat.com, robin.murphy@arm.com,
 surenb@google.com, tj@kernel.org, virtualization@lists.linux.dev,
 vbabka@suse.cz, wireguard@lists.zx2c4.com, x86@kernel.org, ziy@nvidia.com

Hello:

This patch was applied to riscv/linux.git (for-next)
by Mike Rapoport (Microsoft) <rppt@kernel.org>:

On Mon, 25 Aug 2025 19:58:10 +0300 you wrote:
> On Mon, Aug 25, 2025 at 06:23:48PM +0200, David Hildenbrand wrote:
> >
> > I don't quite understand the interaction with PG_Reserved and why anybody
> > using this function should care.
> >
> > So maybe you can rephrase in a way that is easier to digest, and rather
> > focuses on what callers of this function are supposed to do vs. have the
> > liberty of not doing?
> 
> [...]

Here is the summary with links:
  - update kernel-doc for MEMBLOCK_RSRV_NOINIT (was: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap())
    https://git.kernel.org/riscv/c/b3dcc9d1d806

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



